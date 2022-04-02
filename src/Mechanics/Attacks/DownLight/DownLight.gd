extends Area2D

export (float) var recovery = 0.05
export (float) var cooldown = 0.04
export (float) var stun = 0.15
export (float) var damage = 6.0
export (float) var var_force = 0.5
export (float) var fix_force = 15.0

onready var parent := get_parent()
onready var coll := $Coll
onready var timer := $Timer
onready var target := $Target
onready var anim_player := $AnimPlayer

var missed := true
var extra_frames := 0.0
var on_animation := false
var attacker_strength : float
var knockback_direction : Vector2

func _ready() -> void:
	knockback_direction = (target.global_position - global_position).normalized()

func hit(strength: float) -> void:
	attacker_strength = strength
	anim_player.play("hit")
	on_animation = true

func _AnimPlayer_animation_finished(anim_name: String) -> void:
	if missed:
		timer.wait_time = cooldown
		timer.start()
		return
	parent.is_hitting = false
	parent.put_on_cooldown(cooldown)
	queue_free()

func _UpLight_body_entered() -> void:
	missed = false

func _UpLight_body_exited(body: Node) -> void:
	missed = true

func _Timer_timeout() -> void:
	missed = false
	_AnimPlayer_animation_finished("hit")
