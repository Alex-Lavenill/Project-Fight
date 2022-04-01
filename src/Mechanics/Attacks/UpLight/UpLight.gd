extends Area2D

export (int) var recovery = 7
export (int) var cooldown = 3
export (int) var stun = 5
export (float) var damage = 6.0
export (float) var var_force = 5.0
export (float) var fix_force = 15.0

onready var parent := get_parent()
onready var target := $Target
onready var coll := $Coll
onready var anim_player := $AnimPlayer

var missed := true
var extra_frames := 0
var on_animation := false
var attacker_strength : float
var knockback_direction : Vector2

func _ready() -> void:
	knockback_direction = (target.global_position - global_position).normalized()

func _process(delta: float) -> void:
	if extra_frames > 0:
		print(extra_frames)
		extra_frames -= 1
		if extra_frames == 0:
			missed = false
			_AnimPlayer_animation_finished("hit")

func hit(strength: float) -> void:
	attacker_strength = strength
	anim_player.play("hit")
	on_animation = true

func _AnimPlayer_animation_finished(anim_name: String) -> void:
	if missed:
		print('missou')
		extra_frames = cooldown
		return
	print('acertou')
	parent.is_hitting = false
	parent.put_on_cooldown(cooldown)
	queue_free()

func _UpLight_body_entered() -> void:
	missed = false

func _UpLight_body_exited(body: Node) -> void:
	missed = true
