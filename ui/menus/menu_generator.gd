extends Node2D
class_name MenuGenerator

#var background_imagee = 
var start_button = preload("res://resources/start_button.tres")
var settings_button = preload("res://resources/settings_button.tres")
var quit_button = preload("res://resources/quit_button.tres")
var resume_button = preload("res://resources/resume_button.tres")
var reset_button = preload("res://resources/restart.tres")
var back_button = preload("res://resources/back.tres")
var next_button = preload("res://resources/next.tres")
var mute_button = preload("res://resources/mute.tres")



@export var button_textures: Dictionary

	
signal menu_option_selected(option_name)
	
func _ready() -> void:
	pass
	
func generate_menus(options, label):
	var button_textures = assemble_textures()
		
	var vboxcontainer = VBoxContainer.new()
	vboxcontainer.alignment = BoxContainer.ALIGNMENT_CENTER
	
	
	var menu_label = Label.new()
	menu_label.text = label
	menu_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	menu_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	var font = load("res://fonts/my_font.ttf")
	menu_label.add_theme_font_override("font", font)
	menu_label.add_theme_constant_override("outline_size", 15)
	menu_label.add_theme_constant_override("size", 30)
	menu_label.add_theme_color_override("font_outline_color", Color.BLACK)
	
	vboxcontainer.add_child(menu_label)

	var menu_button_scene = preload("res://ui/menus/menu_button.tscn")
	
	for option in options: 
		var panel_container = PanelContainer.new()
		panel_container.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
		
		var hboxcontainer = HBoxContainer.new()
		hboxcontainer.alignment = BoxContainer.ALIGNMENT_CENTER
		
		var menu_button = menu_button_scene.instantiate()
		menu_button.setup(option, button_textures[option])
		menu_button.option_pressed.connect(_on_option_pressed)
		
		
		hboxcontainer.add_child(menu_button)
		panel_container.add_child(hboxcontainer)
		vboxcontainer.add_child(panel_container)
	return vboxcontainer


#<========================================Helpers==================================================>
func assemble_textures():
	return {
		"start": start_button,
		"settings": settings_button,
		"quit": quit_button,
		"resume": resume_button,
		"reset": reset_button,
		"back": back_button,
		"next": next_button,
		"mute": mute_button,
	}
	

func _on_option_pressed(option_name: String) -> void:
	#print("option_name", option_name)
	menu_option_selected.emit(option_name)	

func hide_menu():
	queue_free()
		
