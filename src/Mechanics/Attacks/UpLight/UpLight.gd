extends Area2D

export (int) var recovery = 7
export (int) var cooldown = 3
export (int) var stun = 5
export (float) var damage = 6.0
export (float) var var_force = 10.0
export (float) var fix_force = 15.0

onready var parent := get_parent()
onready var target := $Target
onready var coll := $Coll
onready var anim_player := $AnimPlayer

var attacker_strength : float
var on_animation := false
var knockback_direction : Vector2

func _ready() -> void:
	knockback_direction = (target.global_position - global_position).normalized()

func hit(strength: float) -> void:
	attacker_strength = strength
	anim_player.play("hit")
	on_animation = true

func n_AnimPlayer_animation_finished(anim_name: String) -> void:
	parent.is_hitting = false
	parent.put_on_cooldown(cooldown)
	queue_free()
