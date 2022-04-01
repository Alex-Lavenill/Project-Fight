extends Node2D

export (int) var speed = 200
export (Vector2) var dash_speed = Vector2(1200, 700)
export (int) var jump_speed = -900
export (int) var gravity = 3000
export (float, 0, 1.0) var friction = 0.3
export (float, 0, 1.0) var acceleration = 0.5
export (float) var force_modifier = 1

onready var parent := get_parent()
onready var dash_timer := $DashTimer

var can_dash := true
var can_jump := true
var can_fall := false
var velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if parent.is_on_floor():
		can_jump = true
		can_dash = true
	velocity.y += gravity * delta
	velocity = parent.move_and_slide(velocity, Vector2.UP)

func move(direction: Vector2) -> void:
	if direction.x != 0:
		velocity.x = direction.x * speed
	else:
		if parent.is_on_floor():
			velocity.x = lerp(velocity.x, 0, friction)
		else:
			velocity.x = lerp(velocity.x, 0, friction/2)

func fall_through() -> void:
	if can_fall:
		parent.position.y += 6

func jump() -> void:
	if can_jump:
		if !parent.is_on_floor():
			can_jump = false
		velocity.y = jump_speed

func dash(dir: Vector2) -> void:
	if can_dash:
		velocity = Vector2(dir.x * dash_speed.x, dir.y * dash_speed.y)
		if !parent.is_on_floor():
			can_dash = false
			dash_timer.start()

func knockback(final_force: float, dir: Vector2) -> void:
	velocity = Vector2.ZERO
	var knockback_strength : float = final_force * force_modifier
	print('Final KO force: ', knockback_strength)
	velocity = dir * knockback_strength
	print('Vel: ', velocity)

func _DashTimer_timeout() -> void:
	can_dash = true

func _Detecter_body_entered(body: Node) -> void:
	if body.is_in_group("PLATFORM"):
		can_fall = true
	else:
		can_fall = false

