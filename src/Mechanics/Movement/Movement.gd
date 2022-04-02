extends Node2D

export (int) var speed = 300
export (int) var dash_speed = 450
export (int) var jump_speed = -600
export (int) var gravity = 1800
export (float, 0, 1.0) var air_friction = 0.04
export (float, 0, 1.0) var ground_friction = 0.2
export (float, 0, 1.0) var momentum_friction = 0.5
export (float, 0, 1.0) var acceleration = 0.15
export (float) var force_modifier = 1

onready var parent := get_parent()
onready var dash_timer := $DashTimer

var can_dash := true
var can_jump := true
var can_fall := false
var velocity = Vector2.ZERO
var curr_dir := 1 setget set_curr_direction
var last_dir := 1

func _physics_process(delta: float) -> void:
	if parent.grounded:
		can_jump = true
		can_dash = true
	if velocity.x > 0 and !curr_dir == 1:
		set_curr_direction(1)
	elif velocity.x < 0 and !curr_dir == -1:
		set_curr_direction(-1)
	velocity.y += gravity * delta
	velocity = parent.move_and_slide(velocity, Vector2.UP)

func move(direction: Vector2) -> void:
	curr_dir != last_dir
	if direction.x != 0:
		print("alo")
		velocity.x = lerp(velocity.x, direction.x * speed, acceleration)
	else:
		if parent.grounded:
			velocity.x = lerp(velocity.x, 0, ground_friction)
		else:
			velocity.x = lerp(velocity.x, 0, air_friction)

func set_curr_direction(new_dir: int) -> void:
	last_dir = curr_dir
	curr_dir = new_dir
	parent.scale.x = -1

func fall_through() -> void:
	if can_fall:
		parent.position.y += 5

func jump() -> void:
	if can_jump:
		if !parent.grounded:
			can_jump = false
		velocity.y = jump_speed

func dash(dir: Vector2) -> void:
	if can_dash:
		velocity = dir * dash_speed
		if !parent.grounded:
			can_dash = false
			dash_timer.start()

func knockback(final_force: float, dir: Vector2) -> void:
	velocity = Vector2.ZERO
	var knockback_strength : float = final_force * force_modifier
	velocity = dir * knockback_strength

func _DashTimer_timeout() -> void:
	can_dash = true

func _Detecter_body_entered(body: Node) -> void:
	if body.is_in_group("PLATFORM"):
		can_fall = true
	else:
		can_fall = false

