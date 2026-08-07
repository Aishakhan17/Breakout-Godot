extends Node
class_name MenuManager

var menu: Node
var menu_generator: Node
var menu_generator_scene = preload("res://ui/menus/menu_generator.tscn")
var game_over: bool
var level_complete: bool 
var game_start: bool = false
var settings_selected: bool

func _ready() -> void:
	SignalBus.game_over.connect(_on_game_over)
	SignalBus.level_complete.connect(_on_level_complete)
	SignalBus.game_start.connect(_on_game_start)

	
func load_menu():
	var menu_data = fetch_menu_options()
	var menu_options = menu_data[0]
	var label = menu_data[-1]
	print("menu_options", menu_options, "label", back_to_main)
	menu_generator = menu_generator_scene.instantiate()
	add_child(menu_generator)
	menu = menu_generator.generate_menus(menu_options, label)
	print("new menu and menu generator", menu, menu_generator)
	display_menu(menu)
	menu_generator.menu_option_selected.connect(_on_menu_option_selected)
	
func fetch_menu_options():
	print("level_complete", level_complete)
	if game_start:
		return [["resume", "settings", "quit"], "Game Paused"]
	elif game_over:
		return [["reset", "back"], "Game Over. Press reset to start again or back to go to the main menu"]
	elif level_complete:
		print("menu manager level complete statement working")
		level_complete = false
		return [["next", "back"], "Level Complete. Press next to go to the next level or back to go to main menu"]
	else:
		return [["start", "settings", "quit"], "Main Menu"]

func display_menu(menu):
	var canvas_layer = CanvasLayer.new()
	add_child(canvas_layer)
	
	var ui_control_root = Control.new()	
	ui_control_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	canvas_layer.add_child(ui_control_root)
	
	
	var center_container = CenterContainer.new()
	center_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	center_container.add_child(menu)
	ui_control_root.add_child(center_container)
	

func _on_menu_option_selected(option_name: String):
	match option_name:
		"start": 
			SignalBus.game_start.emit()
			delete_scene()
		"settings": 
			settings_selected = true
			delete_scene()
			#menu_generator_scene.show_settings_menu() ########this needs to be sorted
		"reset":
			##do something here
			SignalBus.game_start.emit()
			SignalBus.launch_game.emit()
			delete_scene()
		"next":
			SignalBus.game_start.emit()
			delete_scene()
		"quit": 
			delete_scene()
			get_tree().quit()
		"back":
			SoundManager.play_background_music(DataConfig.current_level)
			delete_scene()
			back_to_main()

func back_to_main():
	game_over = false
	load_menu()
	
func delete_scene():
	menu_generator.queue_free()
	menu.queue_free()
	
func _on_game_over():
	game_over = true
	game_start = false

func _on_level_complete():
	game_start = false
	level_complete = true
	
func _on_game_start():
	game_start = true
	level_complete = false 
	game_over = false
