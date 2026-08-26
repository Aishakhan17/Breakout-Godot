extends Node2D

var game_start: bool
var launch_game: bool 
var game_paused: bool = false
var load_menu: bool = false
var game_over: bool = false

var blur_layer 
var game_world
var menu_manager
var game_manager 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.launch_game.emit()
	
	#Instantiate all relevant managers
	SignalBus.game_start.connect(start_game)
	SignalBus.level_complete.connect(_on_level_complete)
	SignalBus.game_over.connect(_on_game_over)
	#SignalBus.game_resumed.connect(_on_game_resumed)
	
	blur_layer = $BlurLayer/Blur
	menu_manager = $MenuLayout/MenuManager
	game_world = $GameWorld
	game_manager = $GameManager
	
	blur_layer.visible = not blur_layer.visible
	game_world.visible = not game_world.visible
	
	menu_manager.load_menu()
	
func start_game():
	set_game_params(true)
	game_manager.initialize_game_setup()

func _input(event):
	if game_start:
		if event.is_action_pressed("ui_cancel"):
			game_paused = not get_tree().paused
			get_tree().paused = game_paused
			
			SignalBus.game_paused.emit(game_paused)
			if game_paused:
				_on_game_paused()
			else :
				_on_game_resumed()
				
func _on_game_resumed():
	game_world.process_mode = PROCESS_MODE_INHERIT
	blur_layer.visible = game_paused
	menu_manager.delete_scene()
	
func _on_game_paused(): 
	#get_tree().paused = game_paused
	game_world.process_mode = PROCESS_MODE_DISABLED
	blur_layer.visible = game_paused
	$BlurLayer/AnimationPlayer.play("fade_pause")
	menu_manager.load_menu()
	
func _on_level_complete():
	set_game_params(false)
	menu_manager.load_menu()

func _on_game_over():
	game_over = not game_over
	set_game_params(not game_over)
	menu_manager.load_menu()

func set_game_params(bool_value):
	game_start = bool_value
	game_world.visible = bool_value
	
	
func set_load_menu_parameters(bool_value):
	launch_game = bool_value
	load_menu = bool_value
	
