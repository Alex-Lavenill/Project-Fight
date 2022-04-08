# Run.gd
extends State


func enter(msg := {}) -> void:
	print('RUN')
	pass


func physics_update(delta: float) -> void:
	
	
	# Checks if we need to change the state
	if not owner.is_on_floor():
		state_machine.transition_to("Fall")
		return
	
	
	# Capture the direcion of the input
	var dir : Vector2 = owner.directional_input()
	
	
	# Checks if the owner is accelerating or decelerating
	if dir.x == 0:
		state_machine.transition_to("Idle")
		return
	
	# Moves the owner in the velocity
	owner.velocity.x = lerp(owner.velocity.x, dir.x * owner.speed, owner.acceleration)
	owner._move_and_slide(delta)
	
	
	# Capture the movement
	var movement : String = owner.movement_input()
	if not movement == '':
		var msg := {}
		
		match (movement):
			'Dash':
				msg['direction'] = dir
			'Fall-Through':
				 msg['from_the_air'] = false
		state_machine.transition_to(movement, msg)
		return

















