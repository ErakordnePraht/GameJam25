extends Node

func pause_game() -> void:
	get_tree().paused = true
	var pause_screen = preload("res://pause_screen.tscn").instantiate()
	pause_screen.unpause.connect(unpause_game)
	pause_screen.restart.connect(restart)
	add_child(pause_screen)

func unpause_game() -> void:
	var pause_screen = get_node("PauseScreen")
	remove_child(pause_screen)
	get_tree().paused = false

func restart() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_released("restart"):
		if !get_node_or_null("PauseScreen"):
			pause_game()
		else:
			unpause_game()
	pass


func _on_player_hit() -> void:
	$BoboDamagePlayer.play()

func _on_player_game_over() -> void:
	get_tree().paused = true
	var game_over_screen = preload("res://game_over_screen.tscn").instantiate()
	game_over_screen.restart.connect(_on_player_game_over_restart)
	add_child(game_over_screen)

func _on_player_game_over_restart() -> void:
	var game_over_screen = get_node("GameOverScreen")
	remove_child(game_over_screen)
	#get_tree().paused = false
	restart()
