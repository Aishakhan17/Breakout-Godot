extends StaticBody2D
class_name MasterBrick 

@export var hit_points: int
@export var type: int 
@export var value: int


func _ready() -> void:
	hit_points = 1
	pass
	
func set_texture(texture):
	$Sprite2D.texture = texture

func take_damage(collider):
	hit_points -= 1
	if hit_points <= 0:
		if type == 1:
			instantiate_explosion()
		SoundManager.brick_destroyed()
		delete_brick(collider)
	return 	hit_points <= 0

func instantiate_explosion():
	var explosion_scene = load("res://gameworld/entities/explosion/explosion.tscn")
	var explosion = explosion_scene.instantiate()
	get_tree().current_scene.add_child(explosion)
	explosion.global_position = get_global_transform().origin
	explosion.start_explosion()
	SoundManager.play_explosion()

func on_brick_destroyed(collider):
	SoundManager.brick_destroyed()
	
func delete_brick(collider):
	var bricks_grid = get_parent()
	bricks_grid.delete_brick(collider)
	DataConfig.score += value
	DataConfig.brick_count -= 1
	#DataConfig.bricks_destroyed += 1
	queue_free()
