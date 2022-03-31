extends Area2D

export (int) var recovery = 7
export (int) var cooldown = 3
export (float) var damage = 6.5
export (float) var force = 10

onready var anim_player := $AnimPlayer
onready var parent := get_parent()

var on_animation := false

func hit() -> void:
	anim_player.play("hit")
	on_animation = true

func n_AnimPlayer_animation_finished(anim_name: String) -> void:
	parent.is_hitting = false
	parent.put_on_cooldown(cooldown)
	queue_free()
