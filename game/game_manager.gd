extends Node2D

var level_manager 
var bricks_manager
var gameplay_controller 

#------- Set Game State Data --------
var game_level: int
var level_data: Dictionary

var game_over: bool = false
var level_complete: bool = false
var game_start: bool 
var bricks_grid: Node2D
var elapsed_seconds = 0
var max_seconds = 5
	
var ball_scene = preload("res://gameworld/entities/ball/ball.tscn")
var paddle_scene = preload("res://gameworld/entities/paddle/paddle.tscn")
var ball: CharacterBody2D
var paddle: CharacterBody2D
var ball_position: Vector2 = Vector2(576, 583)
var paddle_position: Vector2 = Vector2(576, 600)


#===================================================================================================
#LIFECYCLE FUNCTIONS
#===================================================================================================
	
func _ready():
	SignalBus.game_start.connect(_on_game_start)
	SignalBus.reset_level.connect(set_assets_pos)
	SignalBus.level_complete.connect(_on_level_complete)
	SignalBus.game_over.connect(_on_game_over)
	

func initialize_game_setup():	
	##--- Instantiate and Set Up Brick Grid ---
	bricks_manager = $BricksManager
	level_manager = $LevelManager
	gameplay_controller = $GamePlayController
	gameplay_controller = $GamePlayController
	
	print("game_start from manager", game_start)
	fetch_game_data()
	initialize_assets()
	gameplay_controller.assign_ball_paddle()
	set_assets_pos()
	

func fetch_game_data():
	#--- Load Level Configuration ---
	game_level = DataConfig.current_level
	level_data = level_manager.fetch_level_data(game_level)

func initialize_assets():
	ball = ball_scene.instantiate()
	paddle = paddle_scene.instantiate()
	bricks_manager.initialize_bricks_generator(game_level)
	add_child(ball)
	add_child(paddle)
	ball.game_start = game_start
	paddle.game_start = game_start

func _on_game_start():
	game_start = true
	
func _on_level_complete():
	end_game()

func _on_game_over():
	game_start = false
	end_game()
#===================================================================================================
#GAME RESET INITIALIZATION
#===================================================================================================
	
func end_game():
	ball.queue_free()
	paddle.queue_free()
	bricks_manager.destroy_bricks_grid()	
	
		

#===================================================================================================
#GAME STATE CHECK
#===================================================================================================
	
	
func set_assets_pos():
	fetch_game_data()
	print("signal fired resetting")
	#--- Set Ball Position and Speed ---
	ball.SPEED = level_data["ball_speed"]
	ball.position = ball_position
	#--- Set Paddle Position and Speed --- 
	paddle.SPEED = level_data["paddle_speed"]
	paddle.position = paddle_position
	
#===================================================================================================
#SIGNAL HANDLERS
#===================================================================================================
