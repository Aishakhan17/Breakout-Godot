extends Node


#---------------- Initialize game data parameters ------------------------------
var current_level: int = 1
var player_health: int = 3
var score: int = 0
var brick_count: int = 0
var menu_options: Array
var levels:  Dictionary


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#set_positions()
	pass

	

func reduce_player_health():
	player_health -= 1


func reset_values():
	score = 0
	brick_count = 0
	player_health = 3
