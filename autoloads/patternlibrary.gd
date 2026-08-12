extends Resource


@export var max_rows = ViewportConfig.num_rows
@export var max_cols = ViewportConfig.num_cols
@export var min_rows: int = 5
@export var min_cols: int = (max_cols*2/3)
@export var max_level = 12
@export var pattern_library: Dictionary


@export var l1_rows: int
@export var l1_cols: int
@export var l2_rows: int
@export var l2_cols: int
@export var l3_rows: int 
@export var l3_cols: int
@export var brick_count: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_levels()
	generate_pattern_library()

func set_levels():
	var levels = 2
	l1_rows = max(min_rows, round(max_rows/levels)) 
	l1_cols = max(min_cols, round(max_cols/levels)) 
	
	l2_rows = max_rows
	l2_cols = max_cols 
	
func generate_pattern_library():
	pattern_library = {
		1: Callable(self, "spawn_maze").bind(l1_rows, l1_cols),
		2: Callable(self, "spawn_maze").bind(l2_rows, l2_cols),
		3: Callable(self, "spawn_pyramid").bind(l2_rows),
		4: Callable(self, "spawn_tunnels").bind(l2_rows, l2_cols),
		5: Callable(self, "spawn_nested_rectangles").bind(l2_rows, l2_cols),
		6: Callable(self, "level_seven_pattern").bind(l2_rows, l2_cols),
		
	}


func fetch_spawn_pattern(level):
	if level <= pattern_library.size():
		var pattern = pattern_library[level].call()
		return pattern


func spawn_pyramid(n):
	var level = DataConfig.current_level
	var arr = []
	var idx: int
	for i in range(n, 0, -1):
		var sub_arr: Array[int]
		sub_arr.resize(2*n-1)
		sub_arr.fill(0)	
		#var sub_arr = [0] * (2*n-1)
		for k in range(2*i-1):
			idx = k + n-i
			sub_arr[idx] = 1	
		arr.append(sub_arr)
	return arr
		
func spawn_maze(rows, cols):
	if DataConfig.current_level == 2:
		rows -= 2
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
	return arr
	
func spawn_tunnels(rows, cols):
	var arr: Array
	for i in range(rows):
		var sub_arr: Array[int]
		sub_arr.resize(cols)
	
		if i == 0 or i == 1 or i == rows -1 or i == rows -2:
			sub_arr.fill(1)
			arr.append(sub_arr)
		else:
			for j in range(cols):
				if j%2 == 0:
					sub_arr[j] = 1
				else:
					sub_arr[j] = 0
			arr.append(sub_arr)
			sub_arr = []
	return arr

func spawn_nested_rectangles(rows, cols):
	var arr = []
	for i in int(rows/2):
		var sub_arr = []
		sub_arr.resize(cols)
		if i%2==0:
			var start = i
			var end = cols -1-i
			for k in range(len(sub_arr)):
				if k>= start and k <= end:
					sub_arr[k] = 1
				else:
					if k %2 == 0:
						sub_arr[k] = 1
					else:
						sub_arr[k] = 0
		elif i%2 != 0:
			for j in range(len(sub_arr)):
				if j%2 == 0 and (j <= i or j >= len(sub_arr)-i):
					sub_arr[j] = 1
				else:
					sub_arr[j] = 0
		arr.append(sub_arr)
	var final_arr = []
	final_arr += arr
	var i = len(arr)-1
	while i >= 0:
		var element_to_add = arr[i]
		final_arr.append(arr[i])
		i -= 1
	return final_arr
		

func level_seven_pattern(rows, cols):
	var arr = []
	for i in range(rows):
		var sub_arr = []
		sub_arr.resize(cols)
		for j in range(cols):
			sub_arr.fill(0)
		arr.append(sub_arr)
	
	for i in range(len(arr)):
		var row = arr[i]
		for j in range(len(row)):
			if i == 0 or i == len(arr)-1 or j == 0 or j == len(row)-1:
				arr[i][j] = 1
			else:
				if arr[i-1][j-1] == 0:
					arr[i][j] = 1
	return arr
