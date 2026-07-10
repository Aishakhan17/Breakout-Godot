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
	menu_manager = $GameManager/MenuManager
	game_world = $GameWorld
	game_manager = $GameManager
	game_world.visible = false
	
	launch_game = true
	load_menu = true
	if launch_game and load_menu: 
		$GameManager/MenuManager.load_menu(game_in_progress)
		
	
func start_game():
	load_menu = false
	game_in_progress = true
	
	game_manager.initialize_game_setup(game_in_progress)
	game_world.visible = true
	
	
	
