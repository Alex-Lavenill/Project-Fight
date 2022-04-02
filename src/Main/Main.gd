extends Control

# Objects
onready var timer := $Timer
onready var map := $ProtoMap
onready var lbWinner := $LbWinner

# Booleans
var countdown := false
var pause_match := true

# Functions

func _ready() -> void:
	map.connect("win", self, "finalize_match")
	restart_match()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if pause_match:
			start_match()

func start_match() -> void:
	restart_match()
	timer.wait_time = 3.5
	timer.start()
	countdown = true

func finalize_match(winner: String) -> void:
	lbWinner.text = str(winner, " Wins!")
	lbWinner.visible = true
	switch_pause(true)

func restart_match() -> void:
	for c in get_children():
		if c.is_in_group("CHARACTER"):
			c.hurtbox.reset_lifes()
			map.revive(c)
	lbWinner.text = "Ready?"
	lbWinner.visible = true

func switch_pause(new_pause: bool) -> void:
	pause_match = new_pause

# process
func _process(delta: float) -> void:
	if pause_match:
		get_tree().paused = true
	else:
		get_tree().paused = false
		
	if countdown:
		lbWinner.text = floor(timer.time_left) as String
		lbWinner.visible = true

# Signal Func

func _Timer_timeout() -> void:
	countdown = false
	switch_pause(false)
	lbWinner.visible = false
