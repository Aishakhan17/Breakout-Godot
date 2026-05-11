extends StaticBody2D

@export var hit_points: int
@export var type: int 
#@export var explosion = load("res://scenes/explosion.tscn")

func _ready() -> void:
	hit_points = 1
	pass
	
func take_damage():
	hit_points -= 1
	if hit_points <= 0:
		DataConfig.brick_count -= 1
		if type == 1:
			print("position", position)
			var explosion_scene = load("res://scenes/explosion.tscn")
			var explosion = explosion_scene.instantiate()
			get_tree().current_scene.add_child(explosion)
			explosion.global_position = get_global_transform().origin
			explosion.start_explosion()
		delete_brick()
	return 	hit_points <= 0

func delete_brick():
	queue_free()
	
