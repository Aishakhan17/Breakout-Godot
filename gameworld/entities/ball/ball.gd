extends CharacterBody2D

#-------Initialize Key Parameters--------
var SPEED: int
var direction : Vector2
var waiting_for_launch: bool
var game_start: bool
var ball_position: Vector2
var aim_angle = 3.142
var rotation_speed = 3.0
var aim_direction: Vector2
@onready var launch_line: RayCast2D = $LaunchLine
@onready var line: Line2D =  $LaunchLine/Line2D
var left_wall: StaticBody2D
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
			aim_angle -= 2 * delta
		elif Input.is_action_pressed("ui_right"):
			aim_angle += 2 * delta
		print("aim_angle", aim_angle)
		aim_angle = clamp(aim_angle, 3.3, 6.1)
		
		var max_length = 600
		aim_direction = Vector2.from_angle(aim_angle)
		print("aim direction", aim_direction)
		launch_line.target_position = aim_direction*max_length
		
		launch_line.force_raycast_update()
		var local_start = ball_position
		var local_end: Vector2
		
		if launch_line.is_colliding():
			local_end = line.to_local(launch_line.get_collision_point())
		else:
			local_end = line.to_local(launch_line.global_position + launch_line.target_position)
		line.set_point_position(0, local_start)
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
	direction = direction.bounce(collision.get_normal()).normalized()
	var remainder = collision.get_remainder()
	move_and_collide(remainder.bounce(collision.get_normal()))
	var collider = collision.get_collider()
	if collider.has_method("take_damage"):
		collider.take_damage(collider)


func _on_launch():		
	$LaunchLine.visible = false

func _on_game_start():
	game_start = true 

func _on_game_over():
	#reset_ball()
	game_start = false
