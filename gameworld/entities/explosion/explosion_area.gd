extends Area2D

@onready var area = $"."
@onready var animated_sprite = $AnimatedSprite2D
var playing: bool = false
var body_count: int = 0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body:
		body_count += 1
		if body.has_method("take_damage"):
			body.take_damage(body)



func start_explosion():
	playing = true
	animated_sprite.play("explode")
	SignalBus.brick_exploded.emit()
	animated_sprite.animation_finished.connect(_on_finished)

func _on_finished():
	playing = false
	print("body count", body_count)
	queue_free()


	
