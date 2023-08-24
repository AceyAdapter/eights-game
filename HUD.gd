extends CanvasLayer

signal start_game
signal home_pressed
signal play_again
signal toggle_volume
signal toggle_menu
signal close_menu
signal quit_game
signal time_trial
signal close_welcome(new_name)
signal show_stats
signal close_stats

# Called when the node enters the scene tree for the first time.
func _ready():
	$ScoreLabel.hide()
	$PreviewBlock.hide()
	$GameOver.hide()
	$Blocks.show()
	
	var generatedName = generateName()
	$WelcomePopup/FirstPage/NameLabel.text = generatedName
	
	for block in $Blocks.get_children():
		await get_tree().create_timer(0.2).timeout
		block.show()
		block.play_fall_in()
	
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
	$MusicToggle.hide()
	
	$PreviewBlock.show()
	
	start_game.emit()



func _on_volume_button_pressed():
	var current_img = $Menu/Volume.icon.get_path()
	
	if current_img == "res://mute.png":
		var image = preload("res://volume.png")
		$Menu/Volume.icon = image
		$MusicToggle.text = "Music: On"
	else:
		var image = preload("res://mute.png")
		$Menu/Volume.icon = image
		$MusicToggle.text = "Music: Off"
	toggle_volume.emit()


func _on_go_home_button_pressed():
	home_pressed.emit()


func _on_play_again_button_pressed():
	play_again.emit()


func _on_menu_pressed():
	toggle_menu.emit()


func _on_close_button_pressed():
	close_menu.emit()


func _on_quit_game_button_pressed():
	quit_game.emit()


func _on_start_time_button_pressed():
	time_trial.emit()


func _on_show_stats_pressed():
	show_stats.emit()


func _on_close_stats_pressed():
	close_stats.emit()


func _on_music_toggle_pressed():
	_on_volume_button_pressed()


func _on_close_welcome_pressed():
	print($WelcomePopup/FirstPage/NameLabel.get_text())
	close_welcome.emit($WelcomePopup/FirstPage/NameLabel.get_text())
	
var prefixes := [
	"Mystic",
	"Cryptic",
	"Ethereal",
	"Enigmatic",
	"Puzzling",
	"Intricate",
	"Curious",
	"Arcane",
	"Clever",
	"Surreal",
	"Quizzical",
	"Perplexing",
	"Complex",
	"Mindful",
	"Unusual",
	"Challenging",
	"Baffling",
	"Amusing",
	"Astute",
	"Tricky",
	"Abstract",
	"Cognitive",
	"Confounding",
	"Cunning",
	"Cerebral",
	"Crafty",
	"Delicate",
	"Devious",
	"Elusive",
	"Eccentric",
	"Esoteric",
	"Fascinating",
	"Ingenious",
	"Insightful",
	"Intellectual",
	"Mysterious",
	"Paradoxical",
	"Pensive",
	"Peculiar",
	"Pensive",
	"Thoughtful",
	"Unconventional",
	"Unfathomable",
	"Unpredictable",
	"Whimsical",
	"Witty",
	"Cryptical",
	"Riddling",
]
var suffixes := [
	"Kangaroo",
	"Sloth",
	"Penguin",
	"Giraffe",
	"Cheetah",
	"Llama",
	"Panda",
	"Hedgehog",
	"Ostrich",
	"Octopus",
	"Squirrel",
	"Raccoon",
	"Koala",
	"Flamingo",
	"Platypus",
	"Narwhal",
	"Walrus",
	"Seagull",
	"Parrot",
	"Hippo",
	"Gorilla",
	"Hamster",
	"Chameleon",
	"Kitten",
	"Puppy",
	"Robot",
	"Spaceship",
	"Banana",
	"Taco",
	"Pineapple",
	"Gummybear",
	"Bubble",
	"Unicorn",
	"Dragon",
	"Wizard",
	"Ninja",
	"Superhero",
	"Rainbow",
	"Marshmallow",
	"Sneaker",
	"Slinky",
	"SillyPutty",
	"Noodle",
	"Slinky",
	"Kazoo",
	"Pajamas",
	"Banjo",
	"Pirate"
]


# Function to generate a name
func generateName():
	var randomPrefix = prefixes[randi() % prefixes.size()]
	var randomSuffix = suffixes[randi() % suffixes.size()]
	
	var generatedName = randomPrefix + " " + randomSuffix
	
	return generatedName

func _on_generate_name_pressed():
	var generatedName = generateName()
	$WelcomePopup/FirstPage/NameLabel.text = generatedName
