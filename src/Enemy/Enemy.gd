extends KinematicBody2D

# FIGHTER STATUS
export (float) var strength := 50
export (float) var defense := 10

onready var hurtbox := $Hurtbox
onready var hitbox := $Hitbox
onready var movement := $Movement

var grounded := false
var is_stunned := false
var is_hitting := false
var stun_time := 0

func _ready() -> void:
	hurtbox.collision_layer = collision_layer
	hurtbox.collision_mask = collision_mask

func _physics_process(delta: float) -> void:
	grounded = is_on_floor()
	is_hitting = hitbox.is_hitting
	if !hitbox.is_hitting:
		hitbox.up_light(strength)
		pass
	else:
		is_hitting = true
	if !is_stunned:
		$ColorRect.visible = false
		movement.move(Vector2.ZERO)
	else:
		$ColorRect.visible = true
