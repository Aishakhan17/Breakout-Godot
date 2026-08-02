extends Node2D
var launch_game: bool 
var game_in_progress: bool = false
var load_menu: bool = false

var game_world
var menu_manager
var game_manager 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Instantiate all relevant managers
	SignalBus.game_start.connect(start_game)
	SignalBus.level_complete.connect(_on_level_complete)
	SignalBus.game_over.connect(_on_game_over)
	menu_manager = $GameManager/MenuManager
	game_world = $GameWorld
	game_manager = $GameManager
	game_world.visible = false
	
	set_load_menu_parameters(true)
	if launch_game and load_menu: 
		$GameManager/MenuManager.load_menu(game_in_progress)
	
func start_game():
	set_load_menu_parameters(false)
	set_game_params(true)
	game_manager.initialize_game_setup(game_in_progress)
	
func _on_level_complete():
	pass

func _on_game_over():
	set_game_params(false)
	$GameManager/MenuManager.load_menu(game_in_progress)

func set_game_params(bool_value):
	game_in_progress = bool_value
	game_world.visible = bool_value
	
func set_load_menu_parameters(bool_value):
	launch_game = bool_value
	load_menu = bool_value
	
