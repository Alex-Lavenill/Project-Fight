extends Node2D

onready var parent := get_parent()
onready var cooldown := $Cooldown
onready var pre_up_light := preload("res://src/Mechanics/Attacks/UpLight/UpLight.tscn")
onready var pre_down_light := preload("res://src/Mechanics/Attacks/DownLight/DownLight.tscn")

var atk_layer := 1
var is_hitting := false
var in_cooldown := false
var curr_attack : PackedScene
var curr_cooldown : PackedScene

func _ready() -> void:
	if parent.name == "Player":
		atk_layer = 2

func put_on_cooldown(value: float) -> void:
	cooldown.wait_time = value
	cooldown.start()
	curr_cooldown = curr_attack
	curr_attack = null
	in_cooldown = true
	is_hitting = false

func up_light(strength: float) -> void:
	if curr_cooldown != pre_up_light:
		var upLight := pre_up_light.instance()
		add_child(upLight)
		upLight.collision_layer = atk_layer
		upLight.collision_mask = atk_layer
		upLight.add_to_group("ATTACK")
		upLight.hit(strength)
		curr_attack = pre_up_light
		is_hitting = true

func down_light(strength: float) -> void:
	if curr_cooldown != pre_down_light:
		var downLight := pre_down_light.instance()
		add_child(downLight)
		downLight.collision_layer = atk_layer
		downLight.collision_mask = atk_layer
		downLight.add_to_group("ATTACK")
		downLight.hit(strength)
		curr_attack = pre_down_light
		is_hitting = true

func _Cooldown_timeout() -> void:
	curr_cooldown = null
	in_cooldown = false
