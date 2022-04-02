extends Area2D

# Objects
onready var parent := get_parent()
onready var lbDamage := $LbDamage
onready var lbLifes := $LbLifes
onready var stun := $Stun

# Constants
const MAX_DAMAGE := 200

# Booleans
var is_stunned := false

# Integers
var max_lifes := 3
var curr_lifes := max_lifes

# Floats
var damage_taken : float = 0.0

# Functions

func _ready() -> void:
	lbDamage.text = damage_taken as String
	lbLifes.text = curr_lifes as String

func reduce_life() -> int:
	if curr_lifes > 1:
		curr_lifes -= 1
		lbLifes.text = curr_lifes as String
		return 0
	else:
		return -1

func apply_damage(damage: float) -> void:
	if damage_taken == 200:
		return
	damage_taken += stepify(damage * ( 100 / ( 100 + parent.defense )), 0.01)
	if damage_taken > 200:
		damage_taken = 200 
	lbDamage.text = damage_taken as String

func reset_damage() -> void:
	damage_taken = 0
	lbDamage.text = 0 as String

func reset_lifes() -> void:
	reset_damage()
	curr_lifes = max_lifes
	lbLifes.text = curr_lifes as String
	is_stunned = false

func apply_stun(time: float) -> void:
	is_stunned = true
	parent.is_stunned = true
	print("stun ", time)
	stun.wait_time = time
	stun.start()

# Signals

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













