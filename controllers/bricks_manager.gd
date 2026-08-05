extends Node

var pattern_library = preload("res://autoloads/patternlibrary.gd")
var bricks_scene = preload("res://gameworld/entities/bricks/bricks.tscn")
var bricks
var total_bricks
var grid_ready
var master_brick 

func _ready() -> void:
	SignalBus.bricks_added.connect(_on_bricks_added)
	SignalBus.brick_destroyed.connect(func(value, collider): _on_brick_destroyed())
			
func initialize_bricks_generator(level):
	var game_level = level
	var spawn_manager = pattern_library.new()
	spawn_manager.set_levels()
	spawn_manager.generate_pattern_library()
	var spawn_pattern = spawn_manager.fetch_spawn_pattern(game_level)
	
	print("instantiating bricks")
	bricks = bricks_scene.instantiate()
	add_child(bricks)
	bricks.instantiate_brick_grid(spawn_pattern)
	print("total bricks", total_bricks)

func destroy_bricks_grid():
	bricks.destroy_bricks()

func _on_bricks_added(total):
	total_bricks = total
	grid_ready = true

func _on_brick_destroyed():
	total_bricks -= 1
	print("updated_bricks ", total_bricks, "score ", DataConfig.score)
