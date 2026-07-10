extends Area2D
@onready var area = $"."
@onready var animated_sprite = $AnimatedSprite2D
@export var playing: bool = false
@export var bricks_destroyed: int

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body:
		if body.has_method("take_damage"):
			print("has method take damage")
			body.take_damage(body)
	
func start_explosion():
	playing = true
	animated_sprite.play("explode")
	animated_sprite.animation_finished.connect(_on_finished)

func _on_finished():
	playing = false
	queue_free()


	
