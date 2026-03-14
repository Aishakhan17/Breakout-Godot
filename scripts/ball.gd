extends CharacterBody2D

var window_size: Vector2
const START_SPEED : int = 600
#var initial_position: Vector2

#const ACCELERATION : int = 50

var speed : int 
var direction : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#initial_position = global_position
	window_size = get_viewport_rect().size
	
func spawn_ball():
	direction = set_direction()
	return direction
	
func set_direction():
	var new_direction = Vector2()
	var possible_x_direction = [1.0, -1.0]
	var y_direction = -1.0
	new_direction.x = possible_x_direction.pick_random()
	new_direction.y = y_direction
	#print("new_direction", new_direction.normalized())
	return new_direction.normalized()
	

func move_ball(direction, delta):
	var velocity = direction * START_SPEED * delta
	return velocity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity = move_ball(direction, delta)
	var collision = move_and_collide(velocity)
	if collision:
		print("collision_info", collision)
		direction = direction.bounce(collision.get_normal())
		var collider = collision.get_collider()
		print("collider name", collider.name)
		if collider.has_method("take_damage"):
			collider.take_damage()
			
