extends Node

var game_start: bool = false
var ball: CharacterBody2D
var game_manager: Node2D
var elapsed_seconds = 0
var max_seconds = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = $".."
	ball = $"../../GameWorld/Ball"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	if game_start:
		var is_ball_off_screen = is_ball_off_screen() 
		var level_complete = check_if_level_complete()
		
		#--- Check if Ball Falls Off Screen ---
		if is_ball_off_screen:
				#--- Update Player Health ---
			DataConfig.reduce_player_health()
			ball.waiting_for_launch = true
				#--- Check if Game Over ---
			var is_game_over = check_game_over()
			if is_game_over and DataConfig.brick_count >= 0:
				game_manager.is_game_over = is_game_over
			elif not is_game_over and DataConfig.brick_count >= 0:
				game_manager.reset_level()
		#--- Check if Player has Won ---
		elif level_complete:
			print("player wins")
			elapsed_seconds += _delta
			if elapsed_seconds > max_seconds:
				game_manager.level_complete = level_complete
				
func check_game_over():
	#game over if ball falls off screen and player health is 0
	return DataConfig.player_health < 1

func is_ball_off_screen():
	return ball.position.y > ViewportConfig.viewport_size.y

func check_if_level_complete():
	#level is complete if all bricks are destroyed	
	return DataConfig.brick_count <= 0

func update_params(param, method, value):
	DataConfig.player_health -= 1
	pass
	
