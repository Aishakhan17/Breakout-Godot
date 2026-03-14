extends CharacterBody2D


const SPEED = 500.0


func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("ui_right"):
		position.x += SPEED * delta
		#move_and_slide()
		
	if  Input.is_action_pressed("ui_left"):
		position.x -= SPEED * delta
	#move_and_slide()
		
