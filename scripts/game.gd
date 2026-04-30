extends Node2D

#------- preload scenes --------
@export var bricks_scene = preload("res://scenes/bricks_cont.tscn")
@export var pattern_library = preload("res://scripts/patternlibrary.gd")


#-------export individual bricks as packed scenes--------
@export var is_game_over: bool = false
@export var bricks_grid: Node2D



#===================================================================================================
#LIFECYCLE FUNCTIONS
#===================================================================================================
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialize_game()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	#check if game's over or if the use has won
	var is_game_over = check_game_over() 
	var level_complete = check_if_level_complete()
	
	
	if is_game_over and DataConfig.brick_count >= 0:
		print("ball off screen", is_game_over, DataConfig.brick_count) 
		initialize_game()
	elif level_complete:
		print("player wins")
		DataConfig.current_level += 1
		initialize_game()

#===================================================================================================
#GAME INITIALIZATION
#===================================================================================================
func initialize_game():
	#--- Load Level Configuration ---
	var game_level = DataConfig.current_level
	var level_data = DataConfig.fetch_level_data(game_level)
	
	var spawn_manager = pattern_library.new()
	spawn_manager.set_levels()
	spawn_manager.generate_pattern_library()
	var spawn_pattern = spawn_manager.fetch_spawn_pattern(game_level)
	
	#--- Initialize Sound Manager  ---
	SoundManager.initialize_music_players()
	SoundManager.play_background_music(game_level)
	
	#--- Instantiate and Set Up Brick Grid ---
	bricks_grid = bricks_scene.instantiate()
	add_child(bricks_grid)
	bricks_grid.instantiate_brick_grid(spawn_pattern)
	
	#--- Reset Score State ---
	var destroyed: bool = false
	DataConfig.score = 0
	$HUD/PanelContainer/HBoxContainer/Score.update_score(destroyed)
	
	#--- Reset Ball ---
	$Ball.position = DataConfig.ball_position
	$Ball.SPEED = level_data["ball_speed"]
	
	#--- Reset Paddle --- 
	$Paddle.position = DataConfig.paddle_position
	$Paddle.SPEED = level_data["paddle_speed"]
	
	$Ball.spawn_ball()


#===================================================================================================
#GAME STATE CHECK
#===================================================================================================
func check_game_over():
	#trigger game over if ball falls below viewport
	if $Ball.position.y > ViewportConfig.viewport_size.y:
		DataConfig.brick_count = 0
		bricks_grid.queue_free()
		SoundManager.stop_playing()
		return $Ball.position.y > ViewportConfig.viewport_size.y


func check_if_level_complete():
	#level is complete if all calls are destroyed	
	return DataConfig.brick_count <= 0
	

#===================================================================================================
#SIGNAL HANDLERS
#===================================================================================================


func on_brick_destroyed(destroyed, brick_pos, collider):
	SoundManager.brick_destroyed()
	$HUD/PanelContainer/HBoxContainer/Score.update_score(destroyed)
	bricks_grid.delete_brick(brick_pos, collider)
	destroyed = false
