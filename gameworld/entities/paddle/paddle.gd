extends CharacterBody2D

var game_start: bool
var window_size: Vector2
var paddle_size: Vector2
var paddle_position: Vector2
var SPEED: int

func _ready():
	window_size = get_viewport_rect().size
	paddle_size = $AnimatedSprite2D.sprite_frames.get_frame_texture($AnimatedSprite2D.animation, $AnimatedSprite2D.frame).get_size()*$AnimatedSprite2D.scale
	#paddle_position = Vector2(576, 600)
	
	SignalBus.game_over.connect(_on_game_over)

func _physics_process(delta: float) -> void:
	if game_start:
		velocity.x = 0
		velocity.y = 0
		if Input.is_action_pressed("ui_right"):
			velocity.x = SPEED
		if  Input.is_action_pressed("ui_left"):
			velocity.x = -SPEED
		move_and_slide()
		
		var half = paddle_size.x/2 + 12
		position.x = clamp(position.x, half, window_size.x-half)

func reset_paddle():
	position = Vector2(576, 600)

func _on_game_over():
	game_start = false
	reset_paddle()
