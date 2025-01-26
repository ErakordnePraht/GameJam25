extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed('restart'):
		get_tree().reload_current_scene()
	pass


func _on_player_hit() -> void:
	$BoboDamagePlayer.play()


func _on_player_game_over() -> void:
	get_tree().reload_current_scene()
	#get_tree().paused = true
