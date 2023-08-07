extends Node2D

signal new_number(number)

@export var column_scene: PackedScene

const GRID_SIZE_X = 7
const GRID_SIZE_Y = 10

var rows = []
var columns_parent
var block_size
var next_number

func _ready():
	block_size = Vector2(80, 80)
	
func get_new_number():
	next_number = randi() % 7 + 2
	new_number.emit(next_number)

func initialize_grid():
	get_new_number()
	
	for x in range(GRID_SIZE_X):
		var column = column_scene.instantiate()
		$Columns.add_child(column)
		column.position = Vector2(x * block_size.x, block_size.y)
		column.index = x + 1
		
		column.column_clicked.connect(on_column_clicked)
		
# Place next block on column click
func on_column_clicked(index, column_node):
	# Get the lowest empty cell in the clicked column
	if $Columns.get_child(index - 1).find_highest_empty_cell() >= 0:
		column_node.place_block(next_number)
		
		check_grid_for_matches()
		
		get_new_number()

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
		
		if temp_lowest_cell < GRID_SIZE_Y - 1:
			for row in range(GRID_SIZE_Y - 1, temp_lowest_cell, -1):
				visited[col].append(false)
	
	var column = $Columns.get_child(x)
	
	var block_val = column.get_number_at_index(y)
	
	var adj_count = count_adjacent_blocks(x, GRID_SIZE_Y - 1 - y, block_val, visited)
		
	if adj_count >= block_val:
		return true
	
func remove_matching_blocks():
	var blocks_to_remove = []
	
	for x in range(GRID_SIZE_X):
		var column = $Columns.get_child(x)
		var lowest_cell = column.find_highest_empty_cell()
		
		if (lowest_cell < GRID_SIZE_Y - 1):
			for y in range(GRID_SIZE_Y - 1, lowest_cell, -1):
				if should_block_be_removed(x, y):
					blocks_to_remove.append([x, y])
					
	for block in blocks_to_remove:
		var column = $Columns.get_child(block[0])
		column.clear_block_at_index(block[1])
	
	return len(blocks_to_remove)

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
	
	#print_grid()
	
