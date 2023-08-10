extends Node2D

signal new_number(number)
signal new_score(score)
signal turns_till_stone(turns)
signal game_over
signal reset_score

@export var column_scene: PackedScene

const GRID_SIZE_X = 7
const GRID_SIZE_Y = 10

var stone_freq = 16
var blocks_till_stone

var rows = []
var columns_parent
var block_size
var next_number

var game_ended = false

func _ready():
	block_size = Vector2(60, 60)
	blocks_till_stone = 16
	
	turns_till_stone.emit(blocks_till_stone)
	
func get_new_number():
	next_number = randi() % 7 + 2
	new_number.emit(next_number)

func initialize_grid():
	for old_col in $Columns.get_children():
		old_col.queue_free()
	
	game_ended = false
	
	reset_score.emit()
	
	blocks_till_stone = 16
	
	turns_till_stone.emit(blocks_till_stone)
	
	get_new_number()
	
	for x in range(GRID_SIZE_X):
		print(x)
		var column = column_scene.instantiate()
		$Columns.add_child(column)
		column.position = Vector2((x * block_size.x) - 45, block_size.y + 30)
		column.index = x + 1
		
		print(column.position)
		
		column.column_clicked.connect(on_column_clicked)
		
		
# Place next block on column click
func on_column_clicked(index, column_node):
	# Get the lowest empty cell in the clicked column
	if !game_ended:
		if $Columns.get_child(index - 1).find_highest_empty_cell() > 0:
			column_node.place_block(next_number)
			$HitSound.play()
		
			
			check_grid_for_matches()
			
			get_new_number()
		else:
			column_node.place_block(next_number)
			$HitSound.play()
			
			await check_grid_for_matches()
			get_new_number()
			
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
	if x >= 0 and y >= 0 and x < GRID_SIZE_X and y < GRID_SIZE_Y and get_number_at_index(x,y) > 0:		
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
		
		if temp_lowest_cell < GRID_SIZE_Y - 1:
			for row in range(GRID_SIZE_Y - 1, temp_lowest_cell, -1):
				visited[col].append(false)
	
	var column = $Columns.get_child(x)
	
	var block_val = column.get_number_at_index(y)
	
	if block_val > 0:
		var adj_count = count_adjacent_blocks(x, GRID_SIZE_Y - 1 - y, block_val, visited)
			
		if adj_count >= block_val:
			return true
	
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
		var column = $Columns.get_child(block[0])
		score += column.clear_block_at_index(block[1])
		$BlipSound.play()
	# Return score
	# Blocks are worth their face value
	new_score.emit(score)
	return score

func shift_remaining_blocks():
	await get_tree().create_timer(0.25).timeout
	# Look through each column and look for 0 below a number,
	# if so shift everything down by 1.
	# Repeat recursively then run remove_matching_blocks()
	for x in range(GRID_SIZE_X):
		var column = $Columns.get_child(x)
		column.shift_blocks_down()
	
	await get_tree().create_timer(0.25).timeout
	
	if remove_matching_blocks() == 0:
		return -1
	else:
		shift_remaining_blocks()
		
func print_grid():
	print("============")
	for x in range(GRID_SIZE_X):
		var column = $Columns.get_child(x)

func check_grid_for_matches():
	await get_tree().create_timer(0.25).timeout
	# Check through all placed blocks and look for matches
	remove_matching_blocks()
	
	# Shift all blocks down to account for space
	shift_remaining_blocks()
	
	blocks_till_stone -= 1
	
	if blocks_till_stone <= 0:
		print(randi() % 8)
		var rand_column = $Columns.get_child(randi() % 7)
		if rand_column.find_highest_empty_cell() >= 0:
			rand_column.place_block(0)
			$HitSound.play()
			
			blocks_till_stone += stone_freq
		else:
			print("Game Over!")
	
	turns_till_stone.emit(blocks_till_stone)
	
	
