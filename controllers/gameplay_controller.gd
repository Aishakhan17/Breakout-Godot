extends Node

var game_start: bool = false
var ball: CharacterBody2D
var paddle: CharacterBody2D
var game_manager: Node2D
var elapsed_seconds = 0
var max_seconds = 5
var bricks_manager



#===================================================================================================
#LIFECYCLE FUNCTIONS
#===================================================================================================
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = $".."
	bricks_manager = $"../BricksManager"
	ball = $"../../GameWorld/Ball"
	paddle = $"../../GameWorld/Paddle"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if game_start and bricks_manager.grid_ready:
		var is_ball_off_screen = is_ball_off_screen() 
		var level_complete = check_if_level_complete()
		
		#--- Check if Ball Falls Off Screen ---
		if is_ball_off_screen:
				#--- Update Player Health ---
			SignalBus.ball_off_screen.emit()
			ball.waiting_for_launch = true
				#--- Check if Game Over ---
			var is_game_over = check_game_over()
			if is_game_over:
				print("you lose", bricks_manager.total_bricks)
				SignalBus.game_over.emit()
			elif not is_game_over:
				game_manager.reset_level()
		#--- Check if Player has Won ---
		elif level_complete:
			print("player wins", bricks_manager.total_bricks)
			elapsed_seconds += _delta
			if elapsed_seconds > max_seconds:
				SignalBus.level_complete.emit()

#===================================================================================================	
func start_game():
	ball.game_start = game_start
	paddle.game_start = game_start
		
func check_game_over():
	#game over if ball falls off screen and player health is 0
	return DataConfig.player_health < 1 and bricks_manager.total_bricks >= 0

func is_ball_off_screen():
	return ball.position.y > ViewportConfig.viewport_size.y

func check_if_level_complete():
	#level is complete if all bricks are destroyed	
	return bricks_manager.total_bricks <= 0

func update_params(param, method, value):
	DataConfig.player_health -= 1
	pass
	
