extends Node2D

#---------------- Initialize brick parameters ----------------------------------
@export var sample_brick = preload("res://scenes/green_brick.tscn")
@export var brick_width: float
@export var brick_height: float

#---------------- Initialize viewport parameters ------------------------------
@export var viewport_size: Vector2
@export var usable_screen_width: float
@export var usable_screen_height: float
@export var num_cols: int
@export var num_rows: int

#-------Set UI Parameters for rendering--------
@export var left_padding = 10
@export var right_padding = 10
@export var top_bar_height = 80
@export var bottom_bar_height = 300
@export var horizontal_spacing = 20
@export var vertical_spacing = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_viewport_params()
	get_prototype_brick()
	set_nums_cols()
	

	
func set_viewport_params():
	viewport_size = get_viewport_rect().size
	usable_screen_width = viewport_size.x - (left_padding + right_padding)
	usable_screen_height = (viewport_size.y - top_bar_height - bottom_bar_height)
	print("viewport_size", viewport_size, "usable_screen_width", usable_screen_width, "usable_screen_height", usable_screen_height, "left_padding", left_padding, "right_padding", right_padding)

func set_nums_cols():
	num_cols = usable_screen_width/(brick_width+horizontal_spacing)
	num_rows = (usable_screen_height/(brick_height+vertical_spacing))
	if num_cols%2 == 0:
		num_cols -= 1
	if num_rows%2 == 0:
		num_rows -= 1
	print("num_cols", num_cols, "num_rows", num_rows)
	

func get_prototype_brick():
	var prototype_brick = instantiate_brick()
	var prototype_sprite = get_child_node(prototype_brick, "Sprite2D")
	#get brick dimensions 
	brick_width = prototype_sprite.region_rect.size.x
	brick_height = prototype_sprite.region_rect.size.y
	print("brick_width", brick_width, "brick_height", brick_height)
	prototype_brick.queue_free()  #delete the sample brick 

#function to instantiate a brick
func instantiate_brick():
	return sample_brick.instantiate()

#im not sure why I felt the need to make a function for this
func get_child_node(parent_node, child_node):
	var node_to_return = parent_node.get_node(child_node)
	return node_to_return
