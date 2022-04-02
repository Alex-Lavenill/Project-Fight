extends Node2D

# Objects
onready var leftPos := $LeftPos
onready var rightPos := $RightPos
onready var parent := get_parent()

# Signals
signal win(name)

# Functions

func revive(Char: Node) -> void:
	if Char.is_in_group("PLAYER"):
		Char.global_position = leftPos.global_position
	else:
		Char.global_position = rightPos.global_position

func match_end(Char: Node) -> void:
	var winner : String
	if Char.is_in_group("PLAYER"):
		winner = "Player2"
	else:
		winner = "Player1"
	emit_signal("win", winner)

func kill_character(Char: Node) -> void:
	if Char.is_in_group("CHARACTER"):
		var lifes : int = Char.hurtbox.reduce_life()
		if lifes >= 0:
			Char.hurtbox.reset_damage()
			revive(Char)
		else:
			match_end(Char)

# Signals

func _UpKillbox_body_entered(body: Node) -> void:
	if body.is_stunned:
		kill_character(body)

func _DownKillbox_body_entered(body: Node) -> void:
	print("ISSO MATOU")
	kill_character(body)

func _LeftKillbox_body_entered(body: Node) -> void:
	kill_character(body)

func _RightKillbox_body_entered(body: Node) -> void:
	kill_character(body)








