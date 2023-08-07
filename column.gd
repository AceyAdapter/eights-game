extends Node2D

@export var block_scene: PackedScene

signal column_clicked(index, node)

const COLUMN_SIZE = 10

var block_size
var blocks_parent
var column_vals
var index = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	block_size = Vector2(80, 80)  # Adjust the size as needed
	blocks_parent = Node2D.new()
	self.add_child(blocks_parent)
	initialize_column()

func find_lowest_empty_cell():
	for x in range(COLUMN_SIZE):
		if column_vals[x] == 0:
			return x
	return -1
	
func find_highest_empty_cell():
	for x in range(COLUMN_SIZE - 1, -1, -1):
		if column_vals[x] == 0:
			return x

	return -1
		
func get_number_at_index(index):
	if index < COLUMN_SIZE:
		return column_vals[index]

func clear_block_at_index(index):
	var block = blocks_parent.get_child(index)
	block.set_number(0)
	column_vals[index] = 0

func get_block_at_index(index):
	return blocks_parent.get_child(index)
	
func initialize_column():
	column_vals = []
	
	for x in range(COLUMN_SIZE):
		column_vals.append(0)
		var block = create_block(0)
		blocks_parent.add_child(block)
		block.position = Vector2(0, x * block_size.y)
		
func create_block(number):
	var block = block_scene.instantiate()
	block.number = number
	return block
	
func place_block(number):
	var lowest_cell = find_highest_empty_cell()
	
	if lowest_cell >= 0:
		var block = blocks_parent.get_child(lowest_cell)
		block.set_number(number)
		column_vals[lowest_cell] = number

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			# Check if the click is within the column's bounds
			if event.position.x >= index * block_size.x and event.position.x < (index + 1) * block_size.x:
			# Emit the 'column_clicked' signal when the column is clicked
				column_clicked.emit(index, self)

func is_empty_space():
	var lowest_cell = find_highest_empty_cell()
	
	for y in range(COLUMN_SIZE - 1, -1, -1):
		if y < lowest_cell and column_vals[y] != 0:
			return true

	return false

func shift_blocks_down():
	for y in range(COLUMN_SIZE - 1, -1, -1):
		var block = get_block_at_index(y)
		if block.number == 0 and y > 0:
			# Found a non-empty block above the empty cell, move it down
			var block_above = get_block_at_index(y-1)
			
			if block_above.number != 0:
				column_vals[y] = block_above.number
				column_vals[y-1] = 0
				
				block.set_number(block_above.number)
				block_above.set_number(0)

	if is_empty_space():
		shift_blocks_down()
