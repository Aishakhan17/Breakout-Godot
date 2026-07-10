extends Node2D
class_name MenuGenerator

@export var start_button = preload("res://resources/start_button.tres")
@export var settings_button = preload("res://resources/settings_button.tres")
@export var quit_button = preload("res://resources/quit_button.tres")
@export var resume_button = preload("res://resources/resume_button.tres")

@export var button_textures: Dictionary

	
signal menu_option_selected(option_name)
	
func _ready() -> void:
	print("menu generator instantiated", position)

func generate_menus(options):
	var button_textures = assemble_textures()

	var vboxcontainer = VBoxContainer.new()
	vboxcontainer.alignment = BoxContainer.ALIGNMENT_CENTER
	
	var menu_button_scene = preload("res://ui/menus/menu_button.tscn")
	
	for option in options: 
		var panel_container = PanelContainer.new()
		panel_container.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
		
		var menu_button = menu_button_scene.instantiate()
		menu_button.setup(option, button_textures[option])
		menu_button.option_pressed.connect(_on_option_pressed)
		
		panel_container.add_child(menu_button)
		vboxcontainer.add_child(panel_container)
	return vboxcontainer


#<========================================Helpers==================================================>
func assemble_textures():
	print("assemble textures called")
	return {
		"start": start_button,
		"settings": settings_button,
		"quit": quit_button,
		"resume": resume_button
	}
	

func _on_option_pressed(option_name: String) -> void:
	print("option_name", option_name)
	menu_option_selected.emit(option_name)	

func hide_menu():
	print("hiding menu")
	queue_free()
		
