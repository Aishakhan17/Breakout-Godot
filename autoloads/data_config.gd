extends Node


#---------------- Initialize game data parameters ------------------------------
var current_level = 7
var player_health: int = 3
var score: int = 0
var menu_options: Array
var levels:  Dictionary


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.brick_destroyed.connect(func(value, collider): _on_brick_destroyed(value))
	SignalBus.level_complete.connect(_on_level_complete)
	SignalBus.ball_off_screen.connect(reduce_player_health) 
	SignalBus.game_over.connect(_on_game_over)

func _on_brick_destroyed(value):
	update_score(value)
	
func update_score(value):
	score += value
	
func reduce_player_health():
	player_health -= 1

func _on_level_complete():
	reset_values()
	
func _on_game_over():
	reset_values()
	
func reset_values():
	score = 0
	player_health = 3
