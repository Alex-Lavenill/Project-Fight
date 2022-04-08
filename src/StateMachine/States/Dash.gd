extends State


# Exports
export (float) var dash_speed := 600

# Objects
onready var duration := $Duration
onready var cooldown := $Cooldown

# Floats
var duration_time := 0.1
var cooldown_time := 0.35


# Functions
func enter(msg := {}) -> void:
	
	
	# Setting control variables
	if not owner.is_on_floor():
		owner.can_dash = false
	owner.is_dashing = true
	
	
	# Capture the direction and set a default direction if is empty
	var dir := Vector2(owner.curr_direction, 0)
	
	
	if not msg['direction'] == Vector2.ZERO:
		if not owner.is_on_floor():
			
			if not msg['direction'].x == 0 and not msg['direction'].x == owner.curr_direction:
				
				state_machine.transition_to('Fall')
				return
			
		dir = msg['direction'].normalized()
	
	
	# Sets and starts the duration timer
	duration.wait_time = duration_time
	duration.start()
	
	
	# Sets the dash velocity
	owner.velocity = dir * dash_speed


# Process the movement
func physics_update(delta: float) -> void:
	
	
	# Capture the direcion of the input
	var dir : Vector2 = owner.directional_input()
	owner._move_and_slide(delta)
	
	
	# Capture the movement
	var movement : String = owner.movement_input()
	
	
	# Checks if the movement recieved is prohibited
	if not movement == '' and not prohibited.has(movement):
		var msg := {}
		if movement == 'Dash':
			msg['direction'] = dir
		state_machine.transition_to(movement, msg)


# When duration timer finish
func _on_Duration_timeout() -> void:
	
	owner.is_dashing = false
	
	# Restore the dash and idle state is owner is grounded
	if owner.is_on_floor():
		owner.can_dash = true
		state_machine.transition_to('Idle')
		return
	
	
	# If owner is on the air, apply cooldown and set the state to falling
	state_machine.transition_to('Fall')
	cooldown.wait_time = cooldown_time
	cooldown.start()


# When the dash cooldown timer finish
func _on_Cooldown_timeout() -> void:
	print('Can dash')
	owner.can_dash = true
























