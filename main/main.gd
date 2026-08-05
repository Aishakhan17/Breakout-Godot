extends Node2D

var launch_game: bool 
var load_menu: bool = false
var game_over: bool = false

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
	
	menu_manager = $MenuManager
	game_world = $GameWorld
	game_manager = $GameManager
	game_world.visible = false
	
	menu_manager.load_menu()
	
func start_game():
	#set_load_menu_parameters(false)
	print("DataConfirg current level", DataConfig.current_level)
	set_game_params(true)
	game_manager.initialize_game_setup()
	
func _on_level_complete():
	set_game_params(false)
	menu_manager.load_menu()

func _on_game_over():
	game_over = true
	set_game_params(false)
	menu_manager.load_menu()

func set_game_params(bool_value):
	game_world.visible = bool_value
	
	
func set_load_menu_parameters(bool_value):
	launch_game = bool_value
	load_menu = bool_value
	
