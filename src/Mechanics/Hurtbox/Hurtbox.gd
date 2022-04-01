extends Area2D

onready var parent := get_parent()
onready var lab := $Label

const MAX_DAMAGE := 200

var stun_time := 0
var is_stunned := false
var damage_taken : float = 0.0

func _ready() -> void:
	lab.text = damage_taken as String

func _process(delta: float) -> void:
	if is_stunned:
		stun_time -= 1
		if stun_time == 0:
			parent.is_stunned = false
			is_stunned = false

func apply_damage(damage: float) -> void:
	if damage_taken == 200:
		return
	damage_taken += stepify(damage * ( 100 / ( 100 + parent.defense )), 0.01)
	if damage_taken > 200:
		damage_taken = 200 
	lab.text = damage_taken as String

func apply_stun(time: int) -> void:
	parent.is_stunned = true
	is_stunned = true
	stun_time = time

func _Hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("ATTACK"):
		apply_damage(area.damage) 
		parent.movement.knockback(
			pow(area.fix_force, 2) + ((damage_taken + area.attacker_strength) * area.var_force), 
			area.knockback_direction
		)
		var extra_stun : int = floor(((damage_taken * area.var_force)/area.stun)/100) 
		apply_stun(area.stun + extra_stun)






















