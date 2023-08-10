extends CanvasLayer

signal start_game
signal home_pressed
signal play_again
signal toggle_volume

# Called when the node enters the scene tree for the first time.
func _ready():
	$ScoreLabel.hide()
	$PreviewBlock.hide()
	$GridBackground.hide()
	$Blocks.show()
	$GameOver.hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func set_preview_block(number):
	$PreviewBlock.set_number(number);
	
func update_score(score):
	$ScoreLabel.text = str(score)
	$GameOver/ScoreLabel.text = str(score)

func _on_start_button_pressed():
	$StartButton.hide()
	$StartTimeButton.hide()
	$MainTitle.hide()
	$ScoreLabel.show()
	
	$PreviewBlock.show()
	
	start_game.emit()



func _on_volume_button_pressed():
	toggle_volume.emit()


func _on_go_home_button_pressed():
	home_pressed.emit()


func _on_play_again_button_pressed():
	play_again.emit()
