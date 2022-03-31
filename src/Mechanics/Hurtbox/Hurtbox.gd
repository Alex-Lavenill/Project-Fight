extends Area2D

onready var parent := get_parent()
onready var lab := $Label

const MAX_DAMAGE := 200

var damage_taken : float = 0.0

func _ready() -> void:
	lab.text = damage_taken as String

func apply_damage(damage: float) -> void:
	damage_taken += stepify(damage * ( 100 / ( 100 + parent.defense )), 0.01) 
	lab.text = damage_taken as String

func _Hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("ATTACK"):
		apply_damage(area.damage) 
		parent.movement.knockback(
			pow(area.fix_force, 2) + ((damage_taken + area.attacker_strength) * area.var_force), 
			area.knockback_direction
		)
