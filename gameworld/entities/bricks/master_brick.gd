extends StaticBody2D
class_name MasterBrick 

var brick_name: String
var hit_points: int
var type: int 
var value: int
var destroyed: bool = false

func _ready() -> void:
	hit_points = 1 
	
func set_texture(texture):
	$Sprite2D.texture = texture

func take_damage(collider):
	if destroyed: 
		return
	
	hit_points -= 1
	if hit_points <= 0:
		destroyed = true
		SignalBus.brick_destroyed.emit(value, collider)	
		if type == 1:
			instantiate_explosion_scene()
		delete_brick()

func instantiate_explosion_scene():
	var explosion_scene = load("res://gameworld/entities/explosion/explosion.tscn")
	var explosion = explosion_scene.instantiate()
	get_tree().current_scene.add_child(explosion)
	explosion.global_position = get_global_transform().origin
	explosion.start_explosion()
	
func delete_brick():
	queue_free()
