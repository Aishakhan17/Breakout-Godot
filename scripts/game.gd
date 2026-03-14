extends Node2D

var window_size: Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var window_size = get_viewport_rect().size
	if $Ball.position.y > (window_size.y/2):
		get_tree().reload_current_scene()
	#pass


func _on_ball_spawn_timer_timeout() -> void:
	$Ball.spawn_ball()
