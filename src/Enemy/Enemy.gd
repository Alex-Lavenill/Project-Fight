extends KinematicBody2D

# FIGHTER STATUS
export (float) var strenght := 50
export (float) var defense := 10

onready var hurtbox := $Hurtbox
onready var hitbox := $Hitbox
onready var movement := $Movement

var is_stunned := false
var stun_time := 0

func _physics_process(delta: float) -> void:
	if !hitbox.is_hitting:
		hitbox.up_light(strenght)
	if !is_stunned:
		$ColorRect.visible = false
		movement.move(Vector2.ZERO)
	else:
		$ColorRect.visible = true
