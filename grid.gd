extends Node2D

signal new_number(number)
signal new_score(score)
signal turns_till_stone(turns)
signal game_over
signal reset_score

@export var column_scene: PackedScene

const GRID_SIZE_X = 7
const GRID_SIZE_Y = 10

var stone_freq = 10
var blocks_till_stone

var rows = []
var columns_parent
var block_size
var next_number

var in_menu = false

var game_ended = false

var in_animation = false
var block_animation = false

func toggle_animation():
	in_animation = !in_animation

func _ready():
	block_size = Vector2(60, 60)
	blocks_till_stone = stone_freq
	
	turns_till_stone.emit(blocks_till_stone)
	
func get_new_number():
	next_number = randi() % 7 + 2
	new_number.emit(next_number)

func initialize_grid():
	$GridBackground.show()
	
	in_animation = false
	block_animation = false
	
	for old_col in $Columns.get_children():
		old_col.queue_free()
	
	game_ended = false
	
	reset_score.emit()
	
	blocks_till_stone = stone_freq
	
	turns_till_stone.emit(blocks_till_stone)
	
	get_new_number()
	
	for x in range(GRID_SIZE_X):
		var column = column_scene.instantiate()
		$Columns.add_child(column)
		column.position = Vector2((x * block_size.x) + 15, block_size.y + 90)
		column.index = x + 1
		
		column.column_clicked.connect(on_column_clicked)
		column.animation_start.connect(on_animation_start)
		column.animation_end.connect(on_animation_end)

func on_animation_start():
	block_animation = true
	pass
	
func on_animation_end():
	block_animation = false
	pass
		
# Place next block on column click
func on_column_clicked(index, column_node):
	# Get the lowest empty cell in the clicked column
	if !game_ended and !in_animation and !block_animation and !in_menu:
		if $Columns.get_child(index - 1).find_highest_empty_cell() > 0:
			var block_no = next_number
			
			get_new_number()
			
			blocks_till_stone -= 1
			turns_till_stone.emit(blocks_till_stone)
			await column_node.place_block(block_no)
			
			check_grid_for_matches()
			
			
		else:
			var block_no = next_number
			get_new_number()
			
			blocks_till_stone -= 1
			turns_till_stone.emit(blocks_till_stone)
			await column_node.place_block(block_no)
		
			check_grid_for_matches()
			
			
			if check_grid_for_full_columns():
				game_ended = true
				game_over.emit()
				

func check_grid_for_full_columns():
	for x in range(GRID_SIZE_X):
		var full_column = $Columns.get_child(x).check_full_column()
		
		if full_column:
			return true
			break
	return false

func get_number_at_index(x, y):
		y = GRID_SIZE_Y - 1 - y
	
		return $Columns.get_child(x).get_number_at_index(y)

func is_valid_block(x, y):
	if x >= 0 and y >= 0 and x < GRID_SIZE_X and y < GRID_SIZE_Y:		
		return true
	
func count_adjacent_blocks(x, y, value, visited):	
	if !is_valid_block(x, y) or get_number_at_index(x,y) != value:
		return 0
	
	if visited[x][y]:
		return 0
	
	visited[x][y] = true
	var count = 1

	count += count_adjacent_blocks(x - 1, y, value, visited)  # Left
	count += count_adjacent_blocks(x + 1, y, value, visited)  # Right
	count += count_adjacent_blocks(x, y - 1, value, visited)  # Up
	count += count_adjacent_blocks(x, y + 1, value, visited)  # Down
		
	return count
	
func should_block_be_removed(x, y):
	# Create a grid to track visited blocks
	var visited = []
	for col in range(GRID_SIZE_X):
		visited.append([])
		
		var temp_column = $Columns.get_child(col)
		var temp_lowest_cell = temp_column.find_highest_empty_cell()
		
		if temp_lowest_cell < GRID_SIZE_Y:
			for row in range(GRID_SIZE_Y - 1, temp_lowest_cell, -1):
				visited[col].append(false)
	
	var column = $Columns.get_child(x)
	
	var block_val = column.get_number_at_index(y)
	
	if block_val > 0:
		var adj_count = count_adjacent_blocks(x, GRID_SIZE_Y - 1 - y, block_val, visited)
			
		if adj_count >= block_val:
			return true

func remove_adjacent_stone(x, y):
	var left = [x - 1, y]
	var right = [x + 1, y]
	var up = [x, y + 1]
	var down = [x, y - 1]
	
	var directions = [left, right, up, down]
	
	for direction in directions:
		if is_valid_block(direction[0], direction[1]) and $Columns.get_child(direction[0]).get_number_at_index(direction[1]) == 0:
			print(direction)
			
			var column = $Columns.get_child(direction[0])
			column.clear_block_at_index(direction[1])
			
			print("removed stone")
			
			$BlipSound.play()
			new_score.emit(10)
		
	
func remove_matching_blocks():
	var blocks_to_remove = []
	var score = 0
	
	for x in range(GRID_SIZE_X):
		var column = $Columns.get_child(x)
		var lowest_cell = column.find_highest_empty_cell()
		
		if (lowest_cell < GRID_SIZE_Y - 1):
			for y in range(GRID_SIZE_Y - 1, lowest_cell, -1):
				if should_block_be_removed(x, y):
					blocks_to_remove.append([x, y])
					
	for block in blocks_to_remove:
		await get_tree().create_timer(0.1).timeout
		var column = $Columns.get_child(block[0])
		new_score.emit(column.clear_block_at_index(block[1]))
		$BlipSound.play()
		
		await remove_adjacent_stone(block[0], block[1])
		
	# Return score
	# Blocks are worth their face value
	return len(blocks_to_remove)

func shift_remaining_blocks():
	# Look through each column and look for 0 below a number,
	# if so shift everything down by 1.
	# Repeat recursively then run remove_matching_blocks()
	for x in range(GRID_SIZE_X):
		var column = $Columns.get_child(x)
		column.shift_blocks_down()
	
	var removed_blocks = await remove_matching_blocks()
	
	if removed_blocks == 0:
		return -1
	else:
		shift_remaining_blocks()
		
func print_grid():
	print("============")
	for x in range(GRID_SIZE_X):
		var column = $Columns.get_child(x)

func check_grid_for_matches():
	toggle_animation()
	
	# Check through all placed blocks and look for matches
	remove_matching_blocks()
	
	# Shift all blocks down to account for space
	await shift_remaining_blocks()
	
	if blocks_till_stone <= 0:
		var rand_column = $Columns.get_child(randi() % 7)
		if rand_column.find_highest_empty_cell() > 0:
			await rand_column.place_block(0)
			
			blocks_till_stone += stone_freq
			turns_till_stone.emit(blocks_till_stone)
		else:
			await rand_column.place_block(0)
			
			game_ended = true
			game_over.emit()
	
	toggle_animation()
	
	
