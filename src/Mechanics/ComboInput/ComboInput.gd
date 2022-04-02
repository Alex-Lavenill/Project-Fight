extends Node2D

# Objects
onready var parent := get_parent()
onready var hitbox := parent.get_node("Hitbox")

# Integers
var light_combo_length := 2

# Floats
var input_max_time := .2
var input_time := input_max_time

# Arrays
var input_sequence := []

# Dictionarys
var light_combos := {
	['u', 'l'] : "UpLight",
	['s', 'l'] : "SideLight",
	['d', 'l'] : "DownLight"
}
var directional_pressed := {
	'Up' : false,
	'Side' : false,
	'Down' : false
} 

# Functions
func _input(event: InputEvent) -> void:
	var dir :=  Vector2.ZERO
	
	# Directional press
	if event.is_action_pressed("down", true):
		directional_pressed.Down = true
	elif event.is_action_pressed("up", true):
		directional_pressed.Up = true
	elif event.is_action_pressed("left", true):
		directional_pressed.Side = true
	elif event.is_action_pressed("right", true):
		directional_pressed.Side = true
	
	# Directional release
	if event.is_action_released("down"):
		print("DOWN RELEASED")
		directional_pressed.Down = false
	if event.is_action_released("up"):
		print("UP RELEASED")
		directional_pressed.Up = false
	if event.is_action_released("left"):
		print("SIDE RELEASED")
		directional_pressed.Side = false
	if event.is_action_released("right"):
		print("Side RELEASED")
		directional_pressed.Side = false
	
	# Register Directionals
	if directional_pressed.Down:
		add_input('d')
		dir
	elif directional_pressed.Up:
		add_input('u')
	elif directional_pressed.Side:
		add_input('s')
	
	# Register Action
	if event.is_action_pressed("light"):
		add_input('l')
	print(input_sequence)

func add_input(input: String) -> void:
	print('input')
	if input_sequence.size() == light_combo_length:
		print('1')
		if input_sequence[0] == input_sequence[1]:
			print('2')
			input_sequence.pop_front()
		else:
			return
	input_sequence.push_back(input)
	print('final ', input_sequence)

func do_combo(inputs: Array) -> void:
	var combo : String = light_combos.get(inputs, "")
	if not combo == "":
		match combo:
			"UpLight":
				hitbox.up_light(parent.strength)
				print("UpLight")
			"SideLight":
#				side_light(strength)
				print("SideLight")
			"DownLight":
				hitbox.down_light(parent.strength)
				print("DownLight")

func _physics_process(delta: float) -> void:
	if not input_sequence.empty():
		input_time -= delta
		
		if input_time < 0:
			do_combo(input_sequence)
			input_time = input_max_time
			input_sequence.clear()




