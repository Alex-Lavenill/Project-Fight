extends State


func enter(msg := {}) -> void:
	print('IDLE')
	owner.can_attack = true


func physics_update(delta: float) -> void:	
	
	# checks if we need to change the state
	if not owner.is_on_floor():
		state_machine.transition_to("Fall")
		return
	
	
	# decelerating the owner
	if not owner.velocity.x == 0:
		
		if abs(owner.velocity.x) < 0.01:
			owner.velocity.x = 0
		
		owner.velocity.x = lerp(owner.velocity.x, 0, owner.friction)
		owner._move_and_slide(delta)
	
	
	# Capture the direcion of the input
	var dir : Vector2 = owner.directional_input()
	
	
	# check directions
	if not dir.x == 0:
		state_machine.transition_to('Run')
	
	
	# Capture the movement
	var movement : String = owner.movement_input()
	
	# Checks if the movement recieved is prohibited
	if not movement == '' and not prohibited.has(movement):
		var msg := {}
		if movement == 'Dash':
			msg['direction'] = dir
		state_machine.transition_to(movement, msg)













