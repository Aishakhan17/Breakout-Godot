extends HBoxContainer

@export var heart_list: Dictionary
@export var heart_full = load("res://resources/heart_full.tres")
@export var heart_empty = load("res://resources/heart_empty.tres")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_heart_list()
	$Health.text = "Health:" 
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	manage_health()
	
func init_heart_list():
	heart_list = {
		$heart_1: 1,
		$heart_2: 2,
		$heart_3: 3
	}
func manage_health():
	var health = DataConfig.player_health
	
	for key in heart_list:
		if health >= heart_list[key]:
			key.texture = heart_full
		elif health < heart_list[key]:
			key.texture = heart_empty
	

	
