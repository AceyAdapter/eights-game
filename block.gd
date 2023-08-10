extends Node2D

@export var number = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	$Number.text = str(number)
	
	if (number == 2):
		$ColorRect.color = "#ff4d4d"
	elif (number == 3):
		$ColorRect.color = "#FF7F00"
	elif (number == 4):
		$ColorRect.color = "#FFFF00"
	elif (number == 5):
		$ColorRect.color = "#32cd32"
	elif (number == 6):
		$ColorRect.color = "#87ceeb"
	elif (number == 7):
		$ColorRect.color = "#FFC0CB"
	elif (number == 8):
		$ColorRect.color = "#a083c4"
	elif (number == 0):
		$ColorRect.color = "#333"
		$Number.text = ""
	else:
		$ColorRect.color = "#ccc"
		$Number.text = ""

func set_number(num):
	number = num
	$Number.text = str(number)
		
	if (number == 2):
		$ColorRect.color = "#ff4d4d"
	elif (number == 3):
		$ColorRect.color = "#FF7F00"
	elif (number == 4):
		$ColorRect.color = "#FFFF00"
	elif (number == 5):
		$ColorRect.color = "#32cd32"
	elif (number == 6):
		$ColorRect.color = "#87ceeb"
	elif (number == 7):
		$ColorRect.color = "#FFC0CB"
	elif (number == 8):
		$ColorRect.color = "#a083c4"
	elif (number == 0):
		$ColorRect.color = "#333"
		$Number.text = ""
	else:
		$ColorRect.color = "#ccc"
		$Number.text = ""
		
func play_fall_in():
	pass
	#var animation = $FallingAnimationPlayer.get_animation("fall_in")
	#var animation_track = animation.track_get_path(0)
	
	#animation.track_insert_key(0, 0, Vector2(0,0))
	#animation.track_insert_key(0, 0.5, self.position)
	
	#$FallingAnimationPlayer.play("fall_in")
	

func get_number():
	return number

	#if (number == 2):
	#	$ColorRect.color = "#ff0000"
	#elif (number == 3):
	#	$ColorRect.color = "#FFA500"
	#elif (number == 4):
	#	$ColorRect.color = "#FFC0CB"
	#elif (number == 5):
	#	$ColorRect.color = "#800080"
	#elif (number == 6):
	#	$ColorRect.color = "#00FF00"
	#elif (number == 7):
	#	$ColorRect.color = "#FFFF00"
	#elif (number == 8):
	#	$ColorRect.color = "#21acc5"
