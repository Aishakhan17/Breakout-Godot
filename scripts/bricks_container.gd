extends Node2D

#export individual bricks
@export var yellow_brick = PackedScene
@export var red_brick = PackedScene
@export var orange_brick = PackedScene
@export var green_brick = PackedScene

@export var horizontal_spacing = 20
@export var vertical_spacing = 5
@export var left_padding = 10
@export var right_padding = 10
@export var top_bar_height = 40

var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#get screen width and height
	var screen_width = get_viewport_rect().size.x - (left_padding + right_padding)
	var screen_height = ((get_viewport_rect().size.y)/2 - top_bar_height)
	print("screen_width", screen_width, "screen_height", screen_height) 
	

	#generate bricks dict
	var bricks_dict = {
	0: yellow_brick,
	1: red_brick,
	2: orange_brick,
	3: green_brick,
}
	#instantiate a brick to get brick dimensions
	var prototype_brick = instantiate_brick(bricks_dict)
	print("prototype_brick", prototype_brick)
	var prototype_sprite = get_child_node(prototype_brick, "Sprite2D")
	print("prototype_sprite", prototype_sprite)
	var brick_width = prototype_sprite.region_rect.size.x
	var brick_height = prototype_sprite.region_rect.size.y
	print("brick_width", brick_width, "brick_height", brick_height)
	prototype_brick.queue_free()
	add_bricks(screen_width, screen_height, bricks_dict, brick_width, brick_height)
	
func add_bricks(screen_width: int, screen_height: int, bricks_dict, brick_width, brick_height): 
	#print("brick_width",brick_width)
	var num_bricks_in_row = floor((screen_width)/(brick_width+horizontal_spacing))
	var num_bricks_in_column = floor((screen_height)/(brick_height+vertical_spacing))
	print("num_bricks_in_row", num_bricks_in_row, "num_bricks_in_column", num_bricks_in_column)
	
	var start_x = -screen_width/2 + brick_width/2 + 2*left_padding
	var start_y = -screen_height + brick_height/2 + top_bar_height
	for i in range(num_bricks_in_row):
		for j in range(num_bricks_in_column):
			var new_brick = instantiate_brick(bricks_dict)
			add_child(new_brick)
			new_brick.position = Vector2(
				start_x + (i * (brick_width + horizontal_spacing)), 
				start_y + j * (brick_height + vertical_spacing)
			)
			
#random number generator function to spawn bricks randomly
func generate_random_number() -> int:
	var random_number = rng.randi_range(0,3)
	return random_number
	

func instantiate_brick(bricks_dict):
	var brick_index = generate_random_number()
	var brick_to_add = bricks_dict[brick_index]
	var new_brick = brick_to_add.instantiate()
	return new_brick
	
	
func get_child_node(parent_node, child_node):
	var node_to_return = parent_node.get_node(child_node)
	return node_to_return
# Called every frame. 'delta' is the elapsed time since the previous frame.


func _process(delta: float) -> void:
	pass
