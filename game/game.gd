extends Node2D

var level_manager 
var bricks_manager
var gameplay_controller 

#------- Set Game State Data --------
var game_level: int
var level_data: Dictionary

var is_game_over: bool = false
var level_complete: bool = false
var game_start: bool = false
var bricks_grid: Node2D
var elapsed_seconds = 0
var max_seconds = 5
	
var ball: CharacterBody2D
var paddle: CharacterBody2D

#===================================================================================================
#LIFECYCLE FUNCTIONS
#===================================================================================================
	

func initialize_game_setup(game_in_progress):	
	##--- Instantiate and Set Up Brick Grid ---
	bricks_manager = $BricksManager
	level_manager = $LevelManager
	gameplay_controller = $GamePlayController
	ball = $"../GameWorld/Ball"
	paddle = $"../GameWorld/Paddle"
	
	bricks_manager.initialize_bricks_grid()
	fetch_game_data()
	
	#--- Initialize Sound Manager  ---
	SoundManager.initialize_music_players()
	SoundManager.play_background_music(game_level)
	
	game_start = true
	ball.game_start = game_start
	gameplay_controller.game_start = game_start
	
	set_assets_pos()
	gameplay_controller = $GamePlayController
	#gameplay_controller.start_game()	

func fetch_game_data():
	#--- Load Level Configuration ---
	game_level = level_manager.current_level
	level_data = level_manager.fetch_level_data(game_level)
	
#===================================================================================================
#GAME RESET INITIALIZATION
#===================================================================================================



func reset_level():
	fetch_game_data()
	#--- Reset Ball ---
	ball.position = ball.ball_position
	print("ball.position", ball.ball_position)
	ball.SPEED = level_data["ball_speed"]
	
	#--- Reset Paddle --- 
	paddle.position = paddle.paddle_position
	paddle.SPEED = level_data["paddle_speed"]
	print("paddle.paddle_position", paddle.paddle_position)
	
	
	


	
		

#===================================================================================================
#GAME STATE CHECK
#===================================================================================================
	
	
func reset_params():
	$HUD/PanelContainer/ScoreLabelContainer/Score.update_score()
	DataConfig.reset_values()
	bricks_grid.queue_free() 
	SoundManager.stop_playing()

func set_assets_pos():
	#--- Set Ball Speed ---
	ball.SPEED = level_data["ball_speed"]
	
	#--- Set Paddle Speed --- 
	paddle.SPEED = level_data["paddle_speed"]
	
#===================================================================================================
#SIGNAL HANDLERS
#===================================================================================================
