extends CharacterBody2D

#-------Initialize Key Parameters--------
var SPEED: int
var direction : Vector2
var waiting_for_launch: bool
var game_start: bool
var ball_position: Vector2
var max_length = 800
var increment = 1
var aim_angle = 3.142
var rotation_speed = 1.0
var aim_direction: Vector2
@onready var launch_line: RayCast2D = $LaunchLine
@onready var line: Line2D =  $LaunchLine/Line2D

#===================================================================================================
#LIFECYCLE FUNCTIONS
#===================================================================================================
#------Called when the node enters the scene tree for the first time---------
func _ready() -> void:
	waiting_for_launch = true
	
	SignalBus.game_start.connect(_on_game_start)
	SignalBus.game_over.connect(_on_game_over)
	SignalBus.ball_launched.connect(_on_launch)
	
#-----Called every frame. 'delta' is the elapsed time since the previous frame----------------------
func _physics_process(delta: float) -> void:
	if game_start and waiting_for_launch: 
		if Input.is_action_pressed("ui_left"):
			aim_angle -= increment * delta
		elif Input.is_action_pressed("ui_right"):
			aim_angle += increment * delta
		
		aim_angle = clamp(aim_angle, 3.3, 6.1)
		
		aim_direction = Vector2.from_angle(aim_angle)
		launch_line.target_position = aim_direction*max_length
		
		launch_line.force_raycast_update()
		
		var local_start = ball_position
		var local_end: Vector2
		
		#set start point for first line segment
		line.set_point_position(0, local_start)
		
		#check if there is a collision
		if launch_line.is_colliding():
			#fetch global collision data
			var collision_point = launch_line.get_collision_point()
			var normal = launch_line.get_collision_normal()
			
			#Set the first line segment's end point 
			local_end = line.to_local(collision_point)
			line.set_point_position(1, local_end)
			
			#get remaining distance
			var distance_travelled = ball_position.distance_to(local_end)
			var remaining_distance = max_length - distance_travelled
			
			#calculate the reflection direction vector
			var bounce_direction = aim_direction.bounce(normal)
			
			#get the global target for the bounce
			var global_bounce_end = collision_point + (bounce_direction*remaining_distance)
			var local_bounce_end = line.to_local(global_bounce_end)
			if line.get_point_count() < 3:
				line.add_point(local_bounce_end)
			else:
				line.set_point_position(2, local_bounce_end)
			
		else:
			local_end = line.to_local(launch_line.global_position + launch_line.target_position)

		line.set_point_position(1, local_end)
	
	
	if not waiting_for_launch and game_start:
		var displacement = move_ball(direction, delta)
		var collision = move_and_collide(displacement)
		if collision:
			collision_handler(collision)
		
#===================================================================================================
#DIRECTION AND MOVEMENT HANDLERS
#===================================================================================================	
func launch_ball(launch_direction):
	waiting_for_launch = false
	SignalBus.ball_launched.emit()
	var new_direction = Vector2()
	new_direction.x = launch_direction.x
	new_direction.y = launch_direction.y
	direction = new_direction
	
func _input(event):
	if waiting_for_launch and game_start:
		if event.is_action_pressed("launch"):
			print("enter pressed, ball launched", "aim_direction", aim_direction)
			var launch_direction = aim_direction
			launch_ball(launch_direction)


func move_ball(direction, delta):
	return direction * SPEED * delta


func collision_handler(collision):
	var collision_normal = collision.get_normal()
	direction = direction.bounce(collision_normal).normalized()
	var remainder = collision.get_remainder()
	var remainder_distance = remainder.length()
	move_and_collide(direction*remainder_distance)
	var collider = collision.get_collider()
	if collider.has_method("take_damage"):
		collider.take_damage(self)


func _on_launch():		
	$LaunchLine.visible = false

func _on_game_start():
	game_start = true 

func _on_game_over():
	#reset_ball()
	game_start = false
