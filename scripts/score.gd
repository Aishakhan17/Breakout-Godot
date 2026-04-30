extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_score(destroyed):
	if destroyed: 
		DataConfig.score += 10
	print("update_score called", DataConfig.score)
	text = "Score: %s" % DataConfig.score
	
	
