extends Node

func _ready():
	pass

func _on_hud_start_game():
	$Grid.new_number.connect(on_new_number)
	$Grid.initialize_grid()
	
func on_new_number(number):
	$HUD.set_preview_block(number)

func _on_hud_shuffle_blocks():
	$Grid.shuffle_grid()
