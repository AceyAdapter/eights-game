extends Node2D

@export var number = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	$Number.text = str(number)
	
	if (number == 2):
		$ColorRect.color = "#ff0000"
	elif (number == 3):
		$ColorRect.color = "#FFA500"
	elif (number == 4):
		$ColorRect.color = "#FFC0CB"
	elif (number == 5):
		$ColorRect.color = "#800080"
	elif (number == 6):
		$ColorRect.color = "#00FF00"
	elif (number == 7):
		$ColorRect.color = "#FFFF00"
	elif (number == 8):
		$ColorRect.color = "#21acc5"
	else:
		$ColorRect.color = "#ccc"
		$Number.text = ""

func set_number(num):
	number = num
	$Number.text = str(number)
		
	if (number == 2):
		$ColorRect.color = "#ff0000"
	elif (number == 3):
		$ColorRect.color = "#FFA500"
	elif (number == 4):
		$ColorRect.color = "#FFC0CB"
	elif (number == 5):
		$ColorRect.color = "#800080"
	elif (number == 6):
		$ColorRect.color = "#00FF00"
	elif (number == 7):
		$ColorRect.color = "#FFFF00"
	elif (number == 8):
		$ColorRect.color = "#21acc5"
	else:
		$ColorRect.color = "#ccc"
		$Number.text = ""

func get_number():
	return number
