extends Node2D

@export var number = 2
signal animation_start
signal animation_end


# Called when the node enters the scene tree for the first time.
func _ready():	
	set_number(number)


func set_number(num):
	number = num
	$Number.text = str(number)
	
	var gradient_data := {
		0.0: "#A6CCF5",
		1.0: "#A6CCF5",
	}
		
	if (number == 2):
		gradient_data = {
			0.0: "#ffada6",
			0.4: "#FE1E3C"
		}
	elif (number == 3):
		gradient_data = {
			0.0: "#FFD0A1",
			0.4: "#FF7F00"
		}
	elif (number == 4):
		gradient_data = {
			0.0: "#fdffd7",
			0.4: "#FFFF00",
		}
	elif (number == 5):
		gradient_data = {
			0.0: "#B4E0B4",
			0.4: "#32cd32",
		}
	elif (number == 6):
		gradient_data = {
			0.0: "#87ceeb",
			0.4: "#36B7EB",
		}
	elif (number == 7):
		gradient_data = {
			0.0: "#FFC0CB",
			0.4: "#FF7D93",
		}
	elif (number == 8):
		gradient_data = {
			0.0: "#a083c4",
			0.4: "#8754C4",
		}
	elif (number == 0):
		gradient_data = {
			0.0: "#737373",
			0.4: "#333",
		}
		$Number.text = ""
	else:
		$ColorRect.color = "#A6CCF5"
		$Number.text = ""

	var gradient := Gradient.new()
	gradient.offsets = gradient_data.keys()
	gradient.colors = gradient_data.values()

	var gradient_texture := GradientTexture2D.new()
	gradient_texture.gradient = gradient
	gradient_texture.width = 60
	gradient_texture.height =60

	$TextureRect.texture = gradient_texture

func play_fall_in():
	animation_start.emit()
	print(self.position.y)
	
	var final_y = self.position.y
	
	self.position.y = 0
	
	while (self.position.y < final_y):
		self.position.y += 20
		await get_tree().create_timer(0.001).timeout
	
	animation_end.emit()

	

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
