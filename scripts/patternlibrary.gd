extends Resource


@export var max_rows = ViewportConfig.num_rows
@export var max_cols = ViewportConfig.num_cols
@export var min_rows: int = 7
@export var min_cols: int = (max_cols*2/3)
@export var max_level = 12
@export var pattern_library: Dictionary


@export var l1_rows: int
@export var l1_cols: int
@export var l2_rows: int
@export var l2_cols: int
@export var l3_rows: int 
@export var l3_cols: int


# Called when the node enters the scene tree for the first time.
func _ready():
	set_levels()
	generate_pattern_library()

func set_levels():
	var levels = 2
	l1_rows = max(min_rows, round(max_rows/levels)) 
	l1_cols = max(min_cols, round(max_cols/levels)) 
	
	l2_rows = max(min_rows, round((max_rows*2)/levels)) 
	l2_cols = max(min_cols, round((max_cols*2)/levels)) 
	
	print("levels set", "l1_rows", l1_rows, "l1_cols", l1_cols, "l2_rows", l2_rows, "l2_cols", l2_cols)
	
	
func generate_pattern_library():
	pattern_library = {
		1: Callable(self, "spawn_maze").bind(l1_rows, l1_cols),
		2: Callable(self, "spawn_maze").bind(l2_rows, l2_cols),
		3: Callable(self, "spawn_pyramid").bind(l1_rows, l1_cols),
		4: Callable(self, "spawn_pyramid").bind(l2_rows, l2_cols),
		5: Callable(self, "spawn_tunnels").bind(l1_rows, l1_cols),
		6: Callable(self, "spawn_tunnels").bind(l2_rows, l2_cols),
		7: Callable(self, "spawn_nested_squares").bind(l1_rows, l1_cols),
		8: Callable(self, "spawn_nested_squares").bind(l2_rows, l2_cols),
	}
	print("generated")

func fetch_spawn_pattern(level):
	print("level", level, "pattern_library", pattern_library)
	if level <= pattern_library.size():
		var pattern = pattern_library[level].call()
		print("pattern", pattern)
		return pattern


func spawn_pyramid(n):
	var arr = []
	var idx: int
	for i in range(n, 0, -1):
		var sub_arr = [0] * (2*n-1)
		for k in range(2*i-1):
			idx = k + n-i
			sub_arr[idx] = 1	
		arr.append(sub_arr)
	return arr
		
func spawn_maze(rows, cols):
	print("rows", rows, "cols", cols)
	var arr = []
	for i in range(rows):
		var sub_arr: Array[int]
		sub_arr.resize(cols)	
		if i < 1:
			sub_arr.fill(1)
			arr.append(sub_arr)
		else:
			if i%2 != 0:
				sub_arr.fill(0)		
				sub_arr[0] = 1
				sub_arr[-1] = 1	
				arr.append(sub_arr)
			else:
				sub_arr.fill(1)
				arr.append(sub_arr) 
	for row in arr:
		print("row", row)
	return arr
	
func spawn_tunnels(rows, cols):
	pass

func spawn_nested_squares(rows, cols):
	pass 
				

	
