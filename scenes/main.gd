extends Node

var current_level = 1
#var levels = {
	#1: "Level1",
	#2: "Level2"
#}
@export var level1: PackedScene
@export var level2: PackedScene

var continue_screen: PackedScene = preload("res://continue_screen.tscn")

var levels = {}

var continue_screen_opened: int

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
	
func continue_game() -> void:
	if (Time.get_ticks_msec() - continue_screen_opened) < 500:
		return
	remove_child($ContinueScreen)
	get_tree().paused = false

func restart() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func move_to_next_level() -> void:
	var current_level_node = $Levels.get_node("Level%s" % current_level)
	if !current_level_node.can_leave:
		return
	$Levels.remove_child(current_level_node)
	
	# Add new level
	current_level += 1
	var current_level_text = "Level%s" % current_level
	var next_level = levels.get(current_level_text)
	if next_level == null:
		restart()
		return
	var next_level_instance = next_level.instantiate()
	
	$Levels.add_child(next_level_instance)
	
	# Pause level and add continuescreen
	var continue_screen_node = continue_screen.instantiate()
	add_child(continue_screen_node)
	get_tree().paused = true
	continue_screen_opened = Time.get_ticks_msec()
	
	connect_enemy_signals()

func connect_enemy_signals() -> void:
	var enemies = get_tree().get_nodes_in_group("Enemy")
	for enemy in enemies:
		enemy.death.connect(_on_enemy_death)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	levels["Level1"] = level1
	levels["Level2"] = level2
	$Hud.setup($Player.health)
	
	connect_enemy_signals()
	
	await $Levels/Level1.ready
	$Levels/Level1.player_leave_area.connect(move_to_next_level)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_anything_pressed() and $ContinueScreen:
		continue_game()
		return
	if Input.is_action_just_released("restart"):
		if !get_node_or_null("PauseScreen"):
			pause_game()
		else:
			unpause_game()
	pass


func _on_player_hit() -> void:
	$BoboDamagePlayer.play()
	$Hud.heart_remove()

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

func _on_enemy_death() -> void:
	var enemy_count = get_tree().get_node_count_in_group("Enemy")
	if enemy_count > 1:
		return
	
	var level = $Levels.get_child(0)
	level.enable_next_area()
	#move_to_next_level()


func _on_level_1_player_leave_area() -> void:
	move_to_next_level()
