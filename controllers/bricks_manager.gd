extends Node

var pattern_library = preload("res://autoloads/patternlibrary.gd")

func _ready() -> void:
	print("bricks manager instantiated")
	pass
		
func initialize_bricks_grid():
	var game_level = 1  ##################FIX THIS LATER
	var spawn_manager = pattern_library.new()
	spawn_manager.set_levels()
	spawn_manager.generate_pattern_library()
	var spawn_pattern = spawn_manager.fetch_spawn_pattern(game_level)
	print("spawn_pattern", spawn_pattern)
	
	var bricks = $"../../GameWorld/Bricks"
	bricks.instantiate_brick_grid(spawn_pattern)
