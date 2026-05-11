extends AnimatedSprite2D

@onready var _animated_sprite = $"."

func _ready() -> void:
	#var overlapping_bodies = explosion_area.find_overlapping_bodies()	
	#print("overlapping_bodies", overlapping_bodies)
	pass


#func start_explosion():
	#print("playing animation")
	#_animated_sprite.play("explode")
	#_animated_sprite.animation_finished.connect(_on_finished)
#
#func _on_finished():
	#queue_free()
