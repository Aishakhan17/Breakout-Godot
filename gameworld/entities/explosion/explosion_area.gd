extends Area2D
@onready var area = $"."
@onready var animated_sprite = $AnimatedSprite2D
@export var playing: bool = false
@export var bricks_destroyed: int

func _ready() -> void:
	SignalBus.brick_exploded.connect(_on_brick_exploded)
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body:
		if body.has_method("take_damage"):
			body.take_damage(body)

func _on_brick_exploded():
	print("explosion area signal working")
	start_explosion()

func start_explosion():
	playing = true
	animated_sprite.play("explode")
	animated_sprite.animation_finished.connect(_on_finished)

func _on_finished():
	playing = false
	queue_free()


	
