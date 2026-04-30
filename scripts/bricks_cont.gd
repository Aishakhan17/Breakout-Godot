extends Node2D

#-------export individual bricks as packed scenes--------

@export var yellow_brick: PackedScene
@export var red_brick: PackedScene
@export var orange_brick: PackedScene
@export var green_brick: PackedScene
@export var explosive_brick: PackedScene

#-------Set UI Parameters for rendering--------
@export var usable_screen_width: float = ViewportConfig.usable_screen_width
@export var usable_screen_height: float = ViewportConfig.usable_screen_height
@export var horizontal_spacing = ViewportConfig.horizontal_spacing
@export var vertical_spacing = ViewportConfig.vertical_spacing


@export var brick_width = ViewportConfig.brick_width
@export var brick_height = ViewportConfig.brick_height
@export var num_cols = ViewportConfig.num_cols
@export var num_rows = ViewportConfig.num_rows

@export var bricks_dict: Dictionary
@export var bricks_pos_dict: Dictionary
@export var new_brick: Node2D


#------Called when the node enters the scene tree for the first time---------
func _ready() -> void:
	#generate bricks dict once Packed Scenes have been instantiated
	bricks_dict = {
	0: yellow_brick,
	1: red_brick,
	2: orange_brick,
	3: green_brick,
}	


#----------------------add brick grid to the layout-----------------------------				

func instantiate_brick_grid(pattern):
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
				new_brick = instantiate_brick()
				add_child(new_brick)
				DataConfig.brick_count += 1
				#print("brick_width", brick_width, "brick_height", brick_height)
				var new_brick_position = Vector2(
					start_x + (j * cell_width), 
					start_y + (i * cell_height)
				)
				bricks_pos_dict[new_brick] = new_brick_position	
	print("grid_width",grid_width, "bricks_pos_dict", bricks_pos_dict)
	display_bricks()	


func display_bricks():
	#print("displaying bricks", bricks_pos_dict)
	for brick in bricks_pos_dict:
		brick.position = bricks_pos_dict[brick]
	


#-------------------------------------------------------------------------------



#------------------_Helper Functions for bricks---------------------------------

#function to instantiate a brick
func instantiate_brick():
	var brick_index = generate_random_number()
	var new_brick = bricks_dict[brick_index]
	return new_brick.instantiate()

	
#function deletes a brick from the brick dictionary
func delete_brick(brick_pos, collider):
	bricks_pos_dict.erase(collider)
		
#function to delete brick grid instance when needed. Eg end of a game
func destroy_bricks_grid():
	for brick in bricks_pos_dict:
		print("deleting")
		bricks_pos_dict.erase(brick)
	print("desptroying grid", bricks_pos_dict.size()) 
	

		
		
#-------------------------------------------------------------------------------		


#--------------------Misc Helper Functions--------------------------------------
func generate_random_number() -> int:
	var rng = RandomNumberGenerator.new()
	var random_number = rng.randi_range(0,3)
	return random_number
	
