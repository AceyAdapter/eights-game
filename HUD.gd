extends CanvasLayer

signal start_game
signal shuffle_blocks

# Called when the node enters the scene tree for the first time.
func _ready():
	$ScoreLabel.hide()
	$ShuffleButton.hide()
	$PreviewBlock.hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func set_preview_block(number):
	$PreviewBlock.set_number(number);

func _on_start_button_pressed():
	$StartButton.hide()
	$MainTitle.hide()
	$ScoreLabel.show()
	$ShuffleButton.show()
	
	$PreviewBlock.show()
	
	start_game.emit()


func _on_shuffle_button_pressed():
	shuffle_blocks.emit()

