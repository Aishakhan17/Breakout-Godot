extends TextureButton
class_name MenuOptionsButton

signal option_pressed(name: String)

var option_name: String

func setup(option: String, texture: Texture2D) -> void:
	option_name = option
	texture_normal = texture
	ignore_texture_size = true
	stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	custom_minimum_size = Vector2(400, 100)
	#pressed.connect(_on_option_pressed(name))
	pressed.connect(func(): option_pressed.emit(option_name))
	
