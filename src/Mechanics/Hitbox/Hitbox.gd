extends Node2D

onready var parent := get_parent()
onready var cooldown := $Cooldown
onready var pre_up_light := preload("res://src/Mechanics/Attacks/UpLight/UpLight.tscn")
onready var pre_side_light := preload("res://src/Mechanics/Attacks/SideLight/SideLight.tscn")
onready var pre_down_light := preload("res://src/Mechanics/Attacks/DownLight/DownLight.tscn")
onready var pre_recovery := preload("res://src/Mechanics/Attacks/Recovery/Recovery.tscn")

var atk_layer := 1
var spent_recoverys := 0
var is_hitting := false
var in_cooldown := false
var can_recovery := true
var curr_attack : PackedScene
var curr_cooldown : PackedScene

func _ready() -> void:
	if parent.is_in_group('PLAYER'):
		atk_layer = 2

func put_on_cooldown(value: float) -> void:
	cooldown.wait_time = value
	cooldown.start()
	curr_cooldown = curr_attack
	curr_attack = null
	in_cooldown = true
	is_hitting = false

func up_light(strength: float) -> void:
	if not curr_cooldown == pre_up_light:
		var upLight := pre_up_light.instance()
		add_child(upLight)
		upLight.collision_layer = atk_layer
		upLight.collision_mask = atk_layer
		upLight.add_to_group("ATTACK")
		upLight.hit(strength)
		curr_attack = pre_up_light
		is_hitting = true

func side_light(strength: float) -> void:
	if not curr_cooldown == pre_side_light:
		var sideLight := pre_side_light.instance()
		add_child(sideLight)
		sideLight.collision_layer = atk_layer
		sideLight.collision_mask = atk_layer
		sideLight.add_to_group("ATTACK")
		sideLight.hit(strength)
		curr_attack = pre_side_light
		is_hitting = true

func down_light(strength: float) -> void:
	if not curr_cooldown == pre_down_light:
		var downLight := pre_down_light.instance()
		add_child(downLight)
		downLight.collision_layer = atk_layer
		downLight.collision_mask = atk_layer
		downLight.add_to_group("ATTACK")
		downLight.hit(strength)
		curr_attack = pre_down_light
		is_hitting = true

func up_heavy(strength: float) -> void:
	if parent.grounded:
#		if not curr_cooldown == pre_up_heavy:
#			pass
		pass
	else:
		if can_recovery and not curr_cooldown == pre_recovery:
			var recovery := pre_recovery.instance()
			add_child(recovery)
			recovery.collision_layer = atk_layer
			recovery.collision_mask = atk_layer
			recovery.add_to_group("ATTACK")
			recovery.hit(strength)
			
			if spent_recoverys < 2:
				spent_recoverys += 1
			else:
				can_recovery = false
			
			curr_attack = pre_recovery
			is_hitting = true
			parent.movement.jump(true)

func _Cooldown_timeout() -> void:
	curr_cooldown = null
	in_cooldown = false










