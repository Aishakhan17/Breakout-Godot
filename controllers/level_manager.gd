extends Node

#---------------- Initialize game data parameters ------------------------------
var current_level: int = DataConfig.current_level #looks redundant - verify and remove if needed later
var levels

func _ready() -> void:
	initialize_level_data()

func initialize_level_data():
	levels = {
		"easy" : {
			ball_speed = 600,
			paddle_speed = 900,
		},
		"medium" : {
			ball_speed = 650,
			paddle_speed = 900,
		},
		"difficult" : {
			ball_speed = 700,
			paddle_speed = 900,
		},
	}
	
	
func fetch_level_data(game_level):
	var easy_threshold = 3
	var med_threshold = 6
	var diff_threshold = 9 
	if game_level <= easy_threshold:
		return levels["easy"]
	elif game_level <= med_threshold:
		return levels["medium"]
	elif game_level <= diff_threshold:
		return levels["difficult"]
	else:
		var text = "Level Configuration Undefined. Loading diff level data"
		push_error(text)
		return levels["difficult"]
