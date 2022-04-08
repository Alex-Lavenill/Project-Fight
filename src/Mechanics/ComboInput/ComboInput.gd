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
var heavy_combos := {
	['u', 'h'] : "UpHeavy",
	['s', 'h'] : "SideHeavy",
	['d', 'h'] : "DownHeavy",
}
var directional_pressed := {
	'Up' : false,
	'Side' : false,
	'Down' : false
} 


func _input(event: InputEvent) -> void:
	var num := parent.player_num as String
	
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
		directional_pressed.Down = false
	if event.is_action_released("up"):
		directional_pressed.Up = false
	if event.is_action_released("left"):
		directional_pressed.Side = false
	if event.is_action_released("right"):
		directional_pressed.Side = false
	
	
	# Register Directionals
	if directional_pressed.Down:
		add_input('d')
	elif directional_pressed.Up:
		add_input('u')
	elif directional_pressed.Side:
		add_input('s')
	
	
	# Register Action
	if event.is_action_pressed("light"):
		add_input('l')
	if event.is_action_pressed("heavy"):
		add_input('h')


func add_input(input: String) -> void:
	
	if input_sequence.size() == light_combo_length:
		if input_sequence[0] == input_sequence[1]:
			input_sequence.pop_front()
		else:
			return
	
	input_sequence.push_back(input)


func do_combo(inputs: Array) -> void:
	var lights : String = light_combos.get(inputs, "")
	var heavys : String = heavy_combos.get(inputs, "")
	
	if not lights == "":
		match lights:
			"UpLight":
				hitbox.up_light(parent.strength)
			"SideLight":
				hitbox.side_light(parent.strength)
			"DownLight":
				hitbox.down_light(parent.strength)
	
	
	if not heavys == "":
		match heavys:
			"UpHeavy":
				hitbox.up_heavy(parent.strength)
				pass
			"SideHeavy":
				print('sHeavy')
#				side_heavy(strength)
				pass
			"DownHeavy":
				print('dHeavy')
#				hitbox.down_heavy(parent.strength)
				pass


# Process
func _physics_process(delta: float) -> void:
	
	if not input_sequence.empty():
		input_time -= delta
		
		if input_time < 0 and parent.can_attack:
			do_combo(input_sequence)
			input_time = input_max_time
			input_sequence.clear()




