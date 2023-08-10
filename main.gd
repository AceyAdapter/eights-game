extends Node

@export var score = 0

func _ready():
	$Grid.hide()
	pass

func _on_hud_start_game():
	$HUD/Blocks.hide()
	$Grid.new_number.connect(on_new_number)
	$Grid.initialize_grid()
	$Grid.show()
	
func on_new_number(number):
	$HUD.set_preview_block(number)
	
func update_score(new_score):
	self.score += new_score
	
	$HUD.update_score(self.score)



func _on_grid_new_score(score):
	if score > 0:
		update_score(score)


func _on_hud_toggle_volume():
	if $BackgroundMusic.playing:
		$BackgroundMusic.stop()
	else:
		$BackgroundMusic.play()


func _on_grid_turns_till_stone(turns):
	$HUD/ScoreLabel/NextBlockLabel2/StoneBlock/StoneCounter.text = str(turns)


func _on_grid_game_over():
	$HUD/GameOver.show()


func _on_hud_home_pressed():
	$HUD/ScoreLabel.hide()
	$HUD/GameOver.hide()
	$HUD/Blocks.show()
	$HUD/PreviewBlock.hide()
	$Grid.hide()
	
	$HUD/StartButton.show()
	$HUD/MainTitle.show()
	$HUD/StartTimeButton.show()


func _on_hud_play_again():
	$HUD/GameOver.hide()
	$Grid.initialize_grid()


func _on_grid_reset_score():
	update_score(-score)


func _on_hud_toggle_menu():
	pass # Replace with function body.
