extends Node

signal player_leave_area

var can_leave = false

func enable_next_area() -> void:
	$NextArea/NextAreaLight.show()
	can_leave = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player: Player = get_tree().get_first_node_in_group("Player")
	if player == null:
		return
	player.global_position = $PlayerStart.global_position
	
	$NextArea/NextAreaLight.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_next_area_body_entered(body: Node2D) -> void:
	player_leave_area.emit()
