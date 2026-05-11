extends Area2D
@onready var area = $"."
@onready var animated_sprite = $AnimatedSprite2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	print("body", body)
	if body.has_method("take_damage"):
		body.call_deferred("take_damage")

func find_overlapping_bodies():
	var overlapping_bodies = get_overlapping_bodies()
	return overlapping_bodies
	
func start_explosion():
	print("playing animation")
	animated_sprite.play("explode")
	animated_sprite.animation_finished.connect(_on_finished)

func _on_finished():
	queue_free()


	
