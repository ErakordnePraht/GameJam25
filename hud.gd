extends Node

func setup(heart_count: int) -> void:
	for i in range(heart_count - 1):
		var duplicate = $HeartContainer/Heart.duplicate()
		$HeartContainer.add_child(duplicate)
		
func heart_remove() -> void:
	var hearts = $HeartContainer.get_children()
	var heart = hearts.pop_back()
	$HeartContainer.remove_child(heart)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
