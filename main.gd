extends Node

@export var score = 0

var survival_high_score = 0
var trial_high_score = 0
var first_time = 0
var username = ""

var save_path = "user://save_file.dat"
var name_path = "user://name_file.dat"

func save_data():
	var file = FileAccess.open(save_path, FileAccess.WRITE)

	if file:
		file.store_32(survival_high_score)
		file.store_32(trial_high_score)
		file.store_8(first_time)
		
		file.close()
		
		print("saved high score")
	else:
		print("Failed to save data.")

func load_data():
	var file = FileAccess.open(save_path, FileAccess.READ)

	if file:
		var stored_hi_score = file.get_32()
		var stored_trial_score = file.get_32()
		var stored_first_time = file.get_8()
		file.close()
		
		print(stored_hi_score)
		print(stored_trial_score)
		print(stored_first_time)

		survival_high_score = stored_hi_score
		trial_high_score = stored_trial_score
		first_time = stored_first_time
		
	else:
		print("No save file found.")
		
	var name_file = FileAccess.open(name_path, FileAccess.READ)
	
	if name_file:
		var stored_name = name_file.get_line()
		
		print(stored_name)
		
		username = stored_name
	else:
		print("No name found!")

# Save data before closing
func _exit_tree():
	pass
	# Save in-progress game

func _ready():
	await load_data()
	$HUD/ScoreLabel/HighScoreLabel.text = str(survival_high_score)
	$HUD/Stats/NameLabel.text = username
	$Grid.hide()
	$BackgroundMusic.play()
	
	if first_time == 0:
		first_time = 1
		save_data()
		
		$HUD/WelcomePopup.show()


func _on_hud_start_game():
	$HUD/Blocks.hide()
	$HUD/ShowStats.hide()
	$Grid.new_number.connect(on_new_number)
	$HUD/ScoreLabel/HighScoreLabel.text = str(survival_high_score)
	$HUD/ScoreLabel/NextBlockLabel2/TurnsTillNextLevel.show()
	$Grid.set_mode("survival")
	$Grid.initialize_grid()
	$Grid.show()
	$HUD/ScoreLabel/Clock.hide()
	$HUD/ScoreLabel/TimeLeft.hide()
	$HUD/MusicToggle.hide()
	
func on_new_number(number):
	$HUD.set_preview_block(number)
	
func update_score(new_score):
	self.score += new_score
	
	$HUD.update_score(self.score)
	
	if $Grid.mode == "survival" and score > survival_high_score:
		$HUD/ScoreLabel/HighScoreLabel.text = str(score)
	elif $Grid.mode == "time_trial" and score > trial_high_score:
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
	if $Grid.mode == "time_trial":
		$Grid/TrialTimer.stop()
	$HUD/GameOver.show()
	$HUD/GameOver/HighScoreText.hide()
	
	
	if $Grid.mode == "survival" and score > survival_high_score:
		survival_high_score = score
		
		$HUD/GameOver/HighScoreText.show()
		$HUD/ScoreLabel/HighScoreLabel.text = str(survival_high_score)
		save_data()
	elif $Grid.mode == "time_trial" and score > trial_high_score:
		trial_high_score = score
		
		$HUD/GameOver/HighScoreText.show()
		$HUD/ScoreLabel/HighScoreLabel.text = str(trial_high_score)
		save_data()


func _on_hud_home_pressed():
	$HUD/ScoreLabel.hide()
	$HUD/GameOver.hide()
	$HUD/Blocks.show()
	$HUD/PreviewBlock.hide()
	$Grid.hide()
	
	$HUD/StartButton.show()
	$HUD/MainTitle.show()
	$HUD/ShowStats.show()
	$HUD/StartTimeButton.show()
	$HUD/MusicToggle.show()


func _on_hud_play_again():
	$HUD/GameOver.hide()
	$Grid.initialize_grid()
	
	if $Grid.mode == "time_trial":
		$Grid.set_timer(30)
		$HUD/ScoreLabel/Clock.show()
		$HUD/ScoreLabel/TimeLeft.show()
	else:
		$HUD/ScoreLabel/Clock.hide()
		$HUD/ScoreLabel/TimeLeft.hide()


func _on_grid_reset_score():
	update_score(-score)


func _on_hud_toggle_menu():
	$HUD/Menu.show()
	$Grid.in_menu = true
	$Grid/TrialTimer.set_paused(true)


func _on_hud_close_menu():
	$HUD/Menu.hide()
	$Grid.in_menu = false
	$Grid/TrialTimer.set_paused(false)


func _on_hud_quit_game():
	$HUD/ScoreLabel.hide()
	$HUD/GameOver.hide()
	$HUD/Blocks.show()
	$HUD/PreviewBlock.hide()
	$Grid.hide()
	$Grid/TrialTimer.stop()
	
	$HUD/StartButton.show()
	$HUD/MainTitle.show()
	$HUD/ShowStats.show()
	$HUD/StartTimeButton.show()
	$HUD/MusicToggle.show()
	$HUD/Menu.hide()
	$Grid.in_menu = false
	$Grid.in_animation = true
	
	if $Grid.mode == "survival" and score > survival_high_score:
			survival_high_score = score
			
			$HUD/ScoreLabel/HighScoreLabel.text = str(survival_high_score)
			save_data()
	elif $Grid.mode == "time_trial" and score > trial_high_score:
		trial_high_score = score
		
		$HUD/GameOver/HighScoreText.show()
		$HUD/ScoreLabel/HighScoreLabel.text = str(trial_high_score)
		save_data()

func seconds_to_min_sec(total_seconds):
	var minutes = int(total_seconds) / 60
	var seconds = int(total_seconds) % 60
	return "%02d:%02d" % [minutes, seconds]


func _on_grid_time_left(time):
	$HUD/ScoreLabel/Clock.text = seconds_to_min_sec(time)


func _on_hud_time_trial():
	$HUD/Blocks.hide()
	$HUD/StartButton.hide()
	$HUD/MainTitle.hide()
	$HUD/StartTimeButton.hide()
	$HUD/ShowStats.hide()
	$HUD/ScoreLabel/HighScoreLabel.text = str(trial_high_score)
	$HUD/ScoreLabel/NextBlockLabel2/TurnsTillNextLevel.hide()
	
	$Grid.new_number.connect(on_new_number)
	$Grid.set_mode("time_trial")
	$Grid.initialize_grid()
	$Grid.show()
	$Grid.set_timer(300)
	$HUD/ScoreLabel.show()
	$HUD/PreviewBlock.show()
	$HUD/ScoreLabel/Clock.show()
	$HUD/ScoreLabel/TimeLeft.show()
	$HUD/MusicToggle.hide()


func _on_hud_show_stats():
	$HUD/Stats/SurvivalScore.text = str(survival_high_score)
	$HUD/Stats/TrialScore.text = str(trial_high_score)
	$HUD/Stats.show()


func _on_hud_close_stats():
	$HUD/Stats.hide()


func _on_grid_turns_till_next_level_signal(turns):
	var text = ""
	
	for turn in (4-turns):
		text += ". "
	
	$HUD/ScoreLabel/NextBlockLabel2/TurnsTillNextLevel/BackgroundText.text = text


func _on_hud_close_welcome(new_name):
	print(new_name)
	username = new_name

	var file = FileAccess.open(name_path, FileAccess.WRITE)

	if file:
		file.store_string(username)
		file.close()
		
		print("saved name: %s" % username)
	else:
		print("failed to save name")
	
	$HUD/Stats/NameLabel.text = username
		
	$HUD/WelcomePopup.hide()
