extends KinematicBody2D

# Exports
export (float) var strength := 50
export (float) var defense := 10

# Objects
onready var hitbox := $Hitbox
onready var hurtbox := $Hurtbox
onready var animSpr := $AnimSpr
onready var movement := $Movement

# Booleans
var grounded := false
var is_stunned := false
var is_hitting := false

# Functions

func input() -> void:
	var dir := Vector2.ZERO
	# Walk
	if Input.is_action_pressed("up"):
		dir.y -= 1
	if Input.is_action_pressed("down"):
		dir.y += 1
	if Input.is_action_pressed("right"):
		dir.x += 1
	if Input.is_action_pressed("left"):
		dir.x -= 1
	movement.move(dir)
	
	# ACTIONS
	if Input.is_action_pressed("down"):
		movement.fall_through()
	elif Input.is_action_just_pressed("jump"):
		movement.jump()
	elif Input.is_action_just_pressed("dash"):
		movement.dash(dir)

# Process
func _physics_process(delta: float) -> void:
	grounded = is_on_floor()
	is_hitting = hitbox.is_hitting
	if is_stunned:
		$ColorRect.visible = true
		
	else:
		$ColorRect.visible = false
		if is_hitting:
			movement.move(Vector2.ZERO)
			
		else:
			input()

