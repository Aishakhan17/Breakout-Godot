extends Node2D

#-------export individual bricks as packed scenes--------
var master_brick_scene = preload("res://gameworld/entities/bricks/master_brick.tscn")
var yellow_brick = preload("res://resources/yellow_brick.tres")
var red_brick = preload("res://resources/red_brick.tres")
var orange_brick = preload("res://resources/orange_brick.tres")
var green_brick = preload("res://resources/green_brick.tres")
var explosive_brick = preload("res://resources/explosive_brick.tres")

#-------Set UI Parameters--------

var brick_width 
var brick_height 
var horizontal_spacing 
var vertical_spacing 
var usable_screen_width 

var bricks: Dictionary
var bricks_dict: Dictionary
var brick_count: int


#------Called when the node enters the scene tree for the first time---------
func _ready() -> void:
	#generate bricks dict once Packed Scenes have been instantiated
	print("bricks instantiated")
	bricks = {
	0: ["yellow_brick", yellow_brick],
	1: ["red_brick", red_brick],
	2: ["orange_brick", orange_brick],
	3: ["green_brick", green_brick],
	4: ["explosive_brick", explosive_brick],
}	


#----------------------add brick grid to the layout-----------------------------				

func instantiate_brick_grid(pattern):
	fetch_parameters()
	var rows = len(pattern)
	var cols = len(pattern[0])
	
	var cell_width = brick_width + horizontal_spacing
	var cell_height = brick_height + vertical_spacing
	
	var grid_width = cols * cell_width
	var start_x = ViewportConfig.left_padding + (usable_screen_width - grid_width)/2 
	var start_y = ViewportConfig.top_bar_height 

	
	for i in range(rows):
		for j in range(cols):
			if pattern[i][j] == 1:
				var new_brick = instantiate_brick()
				add_child(new_brick)
				brick_count += 1
				var new_brick_position = Vector2(
					start_x + (j * cell_width), 
					start_y + (i * cell_height)
				)
				bricks_dict[new_brick] = new_brick_position	
				new_brick.position = new_brick_position
				
	SignalBus.bricks_added.emit(brick_count)
		

		
#-------------------------------------------------------------------------------



#------------------_Helper Functions for bricks---------------------------------

##function to instantiate a brick
func instantiate_brick():
	var brick_type: int
	var brick_value: int
	var brick_index = generate_random_number()
	if brick_index == 4:
		brick_type = 1
		brick_value = 20
	else:
		brick_type = 0
		brick_value = 10
	var new_brick = master_brick_scene.instantiate()
	var new_brick_texture = bricks[brick_index][-1]
	new_brick.set_texture(new_brick_texture)
	new_brick.type = brick_type
	new_brick.value = brick_value
	new_brick.brick_name = bricks[brick_index][0]
	return new_brick


#function to delete brick grid instance when needed. Eg end of a game
func destroy_bricks():
	queue_free()

		
		
#-------------------------------------------------------------------------------		


#--------------------Misc Helper Functions--------------------------------------
func generate_random_number() -> int:
	var rng = RandomNumberGenerator.new()
	var random_number = rng.randi_range(0,4)
	return random_number
	
func fetch_parameters():
	brick_width = ViewportConfig.brick_width
	brick_height = ViewportConfig.brick_height
	horizontal_spacing = ViewportConfig.horizontal_spacing
	vertical_spacing = ViewportConfig.vertical_spacing
	usable_screen_width = ViewportConfig.usable_screen_width
