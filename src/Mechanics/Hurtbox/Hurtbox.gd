extends Area2D

onready var parent := get_parent()
onready var lab := $Label
onready var stun := $Stun

const MAX_DAMAGE := 200

var is_stunned := false
var damage_taken : float = 0.0

func _ready() -> void:
	lab.text = damage_taken as String

func apply_damage(damage: float) -> void:
	if damage_taken == 200:
		return
	damage_taken += stepify(damage * ( 100 / ( 100 + parent.defense )), 0.01)
	if damage_taken > 200:
		damage_taken = 200 
	lab.text = damage_taken as String

func apply_stun(time: float) -> void:
	is_stunned = true
	parent.is_stunned = true
	print("stun ", time)
	stun.wait_time = time
	stun.start()

func _Hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("ATTACK"):
		apply_damage(area.damage) 
		parent.movement.knockback(
			pow(area.fix_force, 2) + ((damage_taken + area.attacker_strength) * area.var_force), 
			area.knockback_direction
		)
		var extra_stun : float = stepify(((damage_taken * area.var_force) / (area.stun*1000)) / 60, 0.01) 
		apply_stun(area.stun + extra_stun)

func _Stun_timeout() -> void:
	is_stunned = false
	parent.is_stunned = false













