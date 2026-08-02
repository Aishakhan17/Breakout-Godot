extends Node
class_name MenuManager

var menu: Node
var menu_generator: Node
var menu_generator_scene = preload("res://ui/menus/menu_generator.tscn")
 
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	pass
	
func load_menu(game_in_progress):
	var menu_options = fetch_menu_options(game_in_progress)
	menu_generator = menu_generator_scene.instantiate()
	add_child(menu_generator)
	menu = menu_generator.generate_menus(menu_options)
	display_menu(menu)
	print("menu.position", menu.position)
	menu_generator.menu_option_selected.connect(_on_menu_option_selected)

func fetch_menu_options(game_in_progress):
	if not game_in_progress:
		return ["start", "settings", "quit"]
	else:
		return ["resume", "settings", "quit"]

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
	return menu

func _on_menu_option_selected(option_name: String):
	match option_name:
		"start": 
			SignalBus.game_start.emit()
			delete_scene()
		"settings": 
			#menu_generator_scene.show_settings_menu() ########this needs to be sorted
			delete_scene()
		"quit": 
			delete_scene()
			get_tree().quit()

func delete_scene():
	menu_generator.queue_free()
	menu.queue_free()
