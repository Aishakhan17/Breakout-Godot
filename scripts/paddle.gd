extends CharacterBody2D

var window_size: Vector2
var paddle_size: Vector2
const SPEED = 432

func _ready():
	window_size = get_viewport_rect().size
	paddle_size = $AnimatedSprite2D.sprite_frames.get_frame_texture($AnimatedSprite2D.animation, $AnimatedSprite2D.frame).get_size()*$AnimatedSprite2D.scale
	print("paddle_size", paddle_size, window_size)
func _physics_process(delta: float) -> void:
	#print("new_position", new_position)
	if Input.is_action_pressed("ui_right"):
		var new_position = position.x + SPEED * delta
		if new_position <= (window_size.x)/2 - paddle_size.x/2:
			position.x += SPEED * delta
	if  Input.is_action_pressed("ui_left"):
		var new_position = position.x - SPEED * delta
		if new_position >= -(window_size.x)/2 + paddle_size.x/2:
			position.x -= SPEED * delta
		
