extends Area2D


# Objects
onready var parent := get_parent()
onready var stun := $Stun
onready var sprite := $Sprite
onready var lbLifes := $LbLifes
onready var cooldown := $Cooldown
onready var lbDamage := $LbDamage
onready var timePressed := $TimePressed

# Constants
const MAX_DAMAGE := 200
const SHIELD_AIR_CD := 2.0
const SHIELD_GROUND_CD := 1.0

# Booleans
var window := false
var shield_on := false
var is_stunned := false
var shield_spent := false
var grounded_shield := false
var shield_in_cooldown := false

# Integers
var max_lifes := 3
var curr_lifes := max_lifes

# Floats
var window_openned : float
var damage_taken : float = .0


# Functions

func _ready() -> void:
	lbDamage.text = damage_taken as String
	lbLifes.text = curr_lifes as String

func _process(delta: float) -> void:
	if window:
		if stepify((OS.get_ticks_msec() - window_openned)/1000, 0.01) > 1.00:
			window = false
			window_openned = .0

func shield_switch(mode: bool) -> void:
	
	shield_on = mode
	sprite.visible = mode
	
	if mode and not shield_in_cooldown:
		
		if parent.grounded:
			grounded_shield = true
		
		# Invulnerability
		
		timePressed.wait_time = 1.5
		timePressed.start()
		
	else:
		var cd_modifier := 1.0
		var final_cd : float
		
		if shield_spent:
			cd_modifier = 2.0
		
		if grounded_shield:
			final_cd = SHIELD_GROUND_CD * cd_modifier
		else:
			final_cd = SHIELD_AIR_CD * cd_modifier
		
		cooldown.wait_time = final_cd
		cooldown.start()
		
		shield_spent = false
		grounded_shield = false
		shield_in_cooldown = true

func apply_damage(damage: float) -> void:
	print("dano dano ", damage)
	print("shiel ", shield_on)
	if damage_taken == 200:
		return
	print(damage, ' ', parent.defense)
	print( damage * ( 100 / ( 100 + parent.defense )) )
	damage_taken += stepify(damage * ( 100 / ( 100 + parent.defense )), 0.01)
	print("dano taken ", damage_taken)
	if damage_taken > 200:
		damage_taken = 200 
	lbDamage.text = damage_taken as String

func reduce_life() -> int:
	parent.movement.stop_all()
	if curr_lifes > 1:
		curr_lifes -= 1
		lbLifes.text = curr_lifes as String
		return 0
	else:
		return -1

func reset_damage() -> void:
	damage_taken = 0
	lbDamage.text = 0 as String

func reset_lifes() -> void:
	reset_damage()
	curr_lifes = max_lifes
	lbLifes.text = curr_lifes as String
	is_stunned = false

func apply_stun(time: float) -> void:
	if window:
		print("Window: ", stepify((OS.get_ticks_msec() - window_openned)/1000, 0.01) as String )
		window = false
		window_openned = .0
	is_stunned = true
	print("stun ", time)
	stun.wait_time = time
	stun.start()

# Signals

func _Hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("ATTACK") and not shield_on:
		print('dano ', area.damage)
		apply_damage(area.damage) 
		parent.movement.knockback(
			pow(area.fix_force, 2) + ((damage_taken + area.attacker_strength) * area.var_force), 
			area.knockback_direction
		)
		var extra_stun : float = stepify(((damage_taken * area.var_force) / (area.stun*1000)) / 60, 0.01) 
		apply_stun(area.stun + extra_stun)

func _Stun_timeout() -> void:
	if is_stunned:
		window = true
		window_openned = OS.get_ticks_msec()
		is_stunned = false

func _Cooldown_timeout() -> void:
	shield_in_cooldown = false

func _TimePressed_timeout() -> void:
	shield_spent = true
	shield_switch(false)
