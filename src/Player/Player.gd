extends KinematicBody2D

onready var movement := $Movement
onready var hitbox := $Hitbox

func get_input():
	var dir :=  Vector2.ZERO
	
	# MOVEMENT
	if Input.is_action_pressed("up"):
		dir.y -= 1
	if Input.is_action_pressed("down"):
		dir.y += 1
	if Input.is_action_pressed("right"):
		dir.x += 1
	if Input.is_action_pressed("left"):
		dir.x -= 1
	if Input.is_action_pressed("down"):
		movement.fall_through()
	if Input.is_action_just_pressed("jump"):
		movement.jump()
	if Input.is_action_just_pressed("dash"):
		movement.dash(dir)
	movement.move(dir)
	
	# ATTACKS
	if Input.is_action_pressed("light") and Input.is_action_pressed("up"):
#		print('hitting', hitbox.is_hitting)
		if !hitbox.is_hitting:
			hitbox.neutral_light()

func _physics_process(delta: float) -> void:
	if !hitbox.is_hitting:
		get_input()
	else:
		movement.move(Vector2.ZERO)


