extends CharacterBody2D

#-------Initialize Key Parameters--------
var window_size: Vector2
var SPEED: int
var destroyed: bool = false
var direction : Vector2
var waiting_for_launch: bool = true
var ball_launched: bool = true
var game_start: bool =  false
var ball_position: Vector2


#===================================================================================================
#LIFECYCLE FUNCTIONS
#===================================================================================================
#------Called when the node enters the scene tree for the first time---------
func _ready() -> void:
	#initial_position = global_position
	window_size = get_viewport_rect().size
	ball_position = Vector2(576, 583)

#-----Called every frame. 'delta' is the elapsed time since the previous frame----------------------
func _physics_process(delta: float) -> void:
	if not waiting_for_launch:
		var displacement = move_ball(direction, delta)
		var collision = move_and_collide(displacement)
		if collision:
			collision_handler(collision)
		
#===================================================================================================
#DIRECTION AND MOVEMENT HANDLERS
#===================================================================================================	
func launch_ball(launch_direction):
	waiting_for_launch = false
	var new_direction = Vector2()
	var direction_to_launch = position.direction_to(launch_direction) #similar to (b-a).normalized()
	new_direction.x = direction_to_launch.x
	new_direction.y = direction_to_launch.y
	direction = new_direction
	
func _input(event):
	if waiting_for_launch and game_start:
		if event.is_action_pressed("launch"):
			var launch_direction = event.position
			launch_ball(launch_direction)

	

func move_ball(direction, delta):
	return direction * SPEED * delta

func reset_ball():
	position = Vector2(576, 583)

func collision_handler(collision):
	direction = direction.bounce(collision.get_normal()).normalized()
	var remainder = collision.get_remainder()
	move_and_collide(remainder.bounce(collision.get_normal()))
	var collider = collision.get_collider()
	if collider.has_method("take_damage"):
		#destroyed = true
		collider.take_damage(collider)
		
