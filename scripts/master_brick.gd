extends StaticBody2D

@export var hit_points = 1
@export var brick_index: int
func take_damage():
	hit_points -= 1
	if hit_points <= 0:
		DataConfig.brick_count -= 1
		print("taking damage")
		queue_free()	
	print("remaining bricks", DataConfig.brick_count)	
	return 	hit_points <= 0

	
