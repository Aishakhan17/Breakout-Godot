extends Node2D
class_name MenuManager

var game_launch: bool
var game_paused: bool
var settings_options = ["mute", "back"]
var game_paused_options = ["settings", "quit"]
var game_over_options = ["reset", "back"]
var level_complete_options = ["next", "back"]
var game_launch_options = ["start", "settings", "quit"]
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
	SignalBus.game_paused.connect(_on_game_paused)
	SignalBus.launch_game.connect(_on_game_launch)
	
func load_menu():
	var menu_data = fetch_menu_options()
	print("menu_data", menu_data)
	var menu_options = menu_data[0]
	var label = menu_data[-1]
	menu_generator = menu_generator_scene.instantiate()
	add_child(menu_generator)
	menu = menu_generator.generate_menus(menu_options, label)
	display_menu(menu)
	menu_generator.menu_option_selected.connect(_on_menu_option_selected)
	
func fetch_menu_options():
	print("game_over", game_over, "game_paused", game_paused, "game_start", "level_complete", level_complete)
	if settings_selected:
		return [settings_options, "Settings"]
	if game_paused:
		return [game_paused_options, "Game Paused"]
	if game_over:
		return [game_over_options, "Game Over. Press reset to start again or back to go to the main menu"]
	if level_complete:
		level_complete = not level_complete
		return [level_complete_options, "Level Complete. Press next to go to the next level or back to go to main menu"]
	if game_launch:
		return [game_launch_options, "Main Menu"]

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
			launch_settings()
		"reset":
			SignalBus.game_start.emit()
			SignalBus.launch_game.emit()
			delete_scene()
		"next":
			SignalBus.game_start.emit()
			delete_scene()
		"mute":
			SignalBus.muted.emit()
		"quit": 
			delete_scene()
			get_tree().quit()
		"back":
			if settings_selected:
				settings_selected = not settings_selected
			SoundManager.play_background_music(DataConfig.current_level)
			delete_scene()
			back_to_main()	
			

func launch_settings():
	load_menu()

func back_to_main():
	if game_over:
		game_over = not game_over
	load_menu()
	
func delete_scene():
	menu_generator.queue_free()
	menu.queue_free()
	
func _on_game_launch():
	game_launch = true
	
func _on_game_paused(_game_paused):
	game_paused = _game_paused

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
