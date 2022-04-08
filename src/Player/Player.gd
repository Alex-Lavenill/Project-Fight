extends Character


# Objects
onready var hitbox := $Hitbox
onready var hurtbox := $Hurtbox
onready var animSpr := $AnimSpr
onready var movement := $Movement
onready var stateMachine := $StateMachine
onready var fallDuration := $FallDuration

# Booleans
var can_attack := true


var grounded := false

var is_stopped := false


# Functions
func _ready() -> void:
	curr_direction = 1 if scale.x == 1 else -1


func directional_input() -> Vector2:
	var direction := Vector2.ZERO
	
	if Input.is_action_pressed("up"):
		direction.y -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
		if not is_on_floor():
			set_collision_mask_bit(3, false)
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	
	
	if Input.is_action_just_released("down") and not stateMachine.curr_state.name == 'Fall-Through':
			set_collision_mask_bit(3, true)
	
	
	if not direction.x == 0 and not direction.x == curr_direction:
		scale.x *= -1
		curr_direction *= -1
		return Vector2.ZERO
	
	return direction


func movement_input() -> String:
	var state := ''
	
	# Press
	if Input.is_action_just_pressed("jump") and can_jump:
		state = 'Jump'
	elif Input.is_action_just_pressed("dash") and can_dash:
		state = 'Dash'
	elif Input.is_action_pressed("down") and can_fall:
		state = 'Fall-Through'


	# Release
	if Input.is_action_just_released("down") and stateMachine.curr_state.name == 'Fall-Through':
		get_node("StateMachine/Fall-Through").start_timer()
	
	
	return state


func combo_input() -> void:
	
	return


# Signals


func _on_Detector_body_entered(body: Node) -> void:
	if body.is_in_group('PLATFORM'):
		can_fall = true


func _on_Detector_body_exited(body: Node) -> void:
	if body.is_in_group('PLATFORM'):
		can_fall = false






















