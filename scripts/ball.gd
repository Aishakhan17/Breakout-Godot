extends CharacterBody2D

#-------Initialize Key Parameters--------
var window_size: Vector2
var SPEED: int
var destroyed: bool = false
var direction : Vector2

#------Called when the node enters the scene tree for the first time---------
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
	var velocity = direction * SPEED * delta
	return velocity

#-----Called every frame. 'delta' is the elapsed time since the previous frame----------------------
func _physics_process(delta: float) -> void:
	velocity = move_ball(direction, delta)
	var collision = move_and_collide(velocity)
	if collision:
		var brick_pos = collision.get_position()
		#print("collision_info", collision)
		direction = direction.bounce(collision.get_normal()).normalized()
		var remainder = collision.get_remainder()
		move_and_collide(remainder.bounce(collision.get_normal()).normalized())
		var collider = collision.get_collider()
		if collider.has_method("take_damage"):
			destroyed = collider.take_damage()
			if destroyed:
				$"..".on_brick_destroyed(destroyed, brick_pos, collider)
			
			
