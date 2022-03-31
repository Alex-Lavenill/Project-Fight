extends Node2D

onready var pre_up_light := preload("res://src/Mechanics/Attacks/UpLight/UpLight.tscn")
onready var parent := get_parent()

var is_hitting := false
var in_cooldown := false
var cooldown_frames := 0
var curr_attack : PackedScene
var curr_cooldown : PackedScene

func _process(delta: float) -> void:
	if in_cooldown:
		attack_cooldown()

func put_on_cooldown(value: int) -> void:
	curr_cooldown = curr_attack
	curr_attack = null
	cooldown_frames = value
	in_cooldown = true
	is_hitting = false

func attack_cooldown() -> void:
	cooldown_frames -= 1
	if cooldown_frames == 0:
		in_cooldown = false
		curr_cooldown = null

func up_light(strength: float) -> void:
	if curr_cooldown != pre_up_light:
		var upLight := pre_up_light.instance()
		add_child(upLight)
		upLight.add_to_group("ATTACK")
		upLight.hit(strength)
		curr_attack = pre_up_light
		is_hitting = true




