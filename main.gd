extends Node

@export var score = 0

var survival_high_score = 0

var save_path = "user://save_file.dat"

func save_data(score):
	var file = FileAccess.open(save_path, FileAccess.WRITE)

	if file:
		file.store_32(score)
		
		file.close()
		
		print("saved high score")
	else:
		print("Failed to save data.")

func load_data():
	var file = FileAccess.open(save_path, FileAccess.READ)

	if file:
		var stored_hi_score = file.get_32()
		file.close()
		
		print(stored_hi_score)

		survival_high_score = stored_hi_score
		
		return survival_high_score
	else:
		print("No save file found.")
		return null

# Save data before closing
func _exit_tree():
	pass
	# Save in-progress game

func _ready():
	await load_data()
	$HUD/ScoreLabel/HighScoreLabel.text = str(survival_high_score)
	$Grid.hide()
	$BackgroundMusic.play()
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
	
	if score > survival_high_score:
		$HUD/ScoreLabel/HighScoreLabel.text = str(score)
	



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
	$HUD/GameOver/HighScoreText.hide()
	
	if score > survival_high_score:
		survival_high_score = score
		
		$HUD/GameOver/HighScoreText.show()
		$HUD/ScoreLabel/HighScoreLabel.text = str(survival_high_score)
		save_data(score)


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
	$HUD/Menu.show()
	$Grid.in_menu = true


func _on_hud_close_menu():
	$HUD/Menu.hide()
	$Grid.in_menu = false


func _on_hud_quit_game():
	$HUD/ScoreLabel.hide()
	$HUD/GameOver.hide()
	$HUD/Blocks.show()
	$HUD/PreviewBlock.hide()
	$Grid.hide()
	
	$HUD/StartButton.show()
	$HUD/MainTitle.show()
	$HUD/StartTimeButton.show()
	$HUD/Menu.hide()
	$Grid.in_menu = false
	
	if score > survival_high_score:
		survival_high_score = score
		
		$HUD/ScoreLabel/HighScoreLabel.text = str(survival_high_score)
		save_data(score)
