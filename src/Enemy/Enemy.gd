extends KinematicBody2D

# Exports
export (float) var strength := 50
export (float) var defense := 10

# Objects
onready var hitbox := $Hitbox
onready var hurtbox := $Hurtbox
onready var movement := $Movement

# Booleans
var grounded := false
var is_stopped := false

# Integers
var stun_time := 0

func _ready() -> void:
	hurtbox.collision_layer = collision_layer
	hurtbox.collision_mask = collision_mask

func _physics_process(delta: float) -> void:
	grounded = is_on_floor()
	movement.move(Vector2.ZERO)
	
	if hurtbox.is_stunned or hitbox.is_hitting or hurtbox.shield_on:
		is_stopped = true
	else:
		is_stopped = false
	
