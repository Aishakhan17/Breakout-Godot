extends Node


var ball_off_screen: bool
var level_complete: bool
var game_over: bool
var game_start: bool 
var ball: CharacterBody2D
var paddle: CharacterBody2D
var game_manager: Node2D
var elapsed_seconds = 0
var max_seconds = 0.01
var bricks_manager



#===================================================================================================
#LIFECYCLE FUNCTIONS
#===================================================================================================
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = $".."
	bricks_manager = $"../BricksManager"
	SignalBus.game_start.connect(_on_game_start)
	SignalBus.game_over.connect(_on_game_over)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if game_start and is_instance_valid(ball):
		ball_off_screen = is_ball_off_screen() 
		level_complete = check_if_level_complete()
		
		#--- Check if Ball Falls Off Screen ---
		if ball_off_screen:
			#--- Update Player Health ---
			SignalBus.ball_off_screen.emit()
			#--- Check if Game Over ---
			game_over = check_game_over()
			if game_over:
				print("you lose", bricks_manager.total_bricks)
				SignalBus.game_over.emit()
			elif not game_over:
				SignalBus.reset_level.emit()
				ball.waiting_for_launch = true
				#game_manager.reset_level()
		#--- Check if Player has Won ---
		elif level_complete:
			DataConfig.current_level += 1
			#elapsed_seconds += _delta
			#if elapsed_seconds > max_seconds:
			SignalBus.level_complete.emit()	

#===================================================================================================			
func _on_game_start():
	game_start = true

func _on_game_over():
	game_over = true
	
func assign_ball_paddle():
	ball = game_manager.ball
	paddle = game_manager.paddle

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
	
