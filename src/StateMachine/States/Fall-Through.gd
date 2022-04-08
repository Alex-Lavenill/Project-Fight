extends State


# Objects
onready var duration := $Duration

func enter(msg := {}) -> void:
	print('FALL-THROUGH')
	
	owner.set_collision_mask_bit(3, false)


func physics_update(delta: float) -> void:
	
	
	# Capture the direcion of the input
	var dir : Vector2 = owner.directional_input()
	
	
	# Capture the movement
	var movement : String = owner.movement_input()
	
	# Checks if the movement recieved is prohibited
	if not movement == '' and not prohibited.has(movement):
		var msg := {}
		
		owner.set_collision_mask_bit(3, true)
		
		match (movement):
			'Dash':
				msg['direction'] = dir
			'Fall-Through':
				 msg['from_the_air'] = false
		
		state_machine.transition_to(movement, msg)
	
	
	owner._move_and_slide(delta)


func start_timer() -> void:
	duration.start()


func _on_Duration_timeout() -> void:
	owner.set_collision_mask_bit(3, true)
	if owner.is_on_floor():
		state_machine.transition_to('Idle')
	else:
		state_machine.transition_to('Fall')
