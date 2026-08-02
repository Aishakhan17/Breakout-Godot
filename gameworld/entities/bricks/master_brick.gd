extends StaticBody2D
class_name MasterBrick 

@export var hit_points: int
@export var type: int 
@export var value: int


func _ready() -> void:
	hit_points = 1 #use signal here
	
func set_texture(texture):
	$Sprite2D.texture = texture

func take_damage(collider):
	SignalBus.brick_destroyed.emit(value, collider)
	hit_points -= 1
	if hit_points <= 0:
		if type == 1:
			instantiate_explosion_scene()
			SignalBus.brick_exploded.emit()
		delete_brick()
	return 	hit_points <= 0

func instantiate_explosion_scene():
	var explosion_scene = load("res://gameworld/entities/explosion/explosion.tscn")
	var explosion = explosion_scene.instantiate()
	get_tree().current_scene.add_child(explosion)
	explosion.global_position = get_global_transform().origin
	
func delete_brick():
	queue_free()
