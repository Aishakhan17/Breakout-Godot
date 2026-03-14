extends StaticBody2D

@export var hit_points = 1

func take_damage():
	print("taking damage")
	hit_points -= 1
	if hit_points <= 0:
		queue_free()	
