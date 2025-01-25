class_name Player
extends CharacterBody2D

@export var bubble_scene: PackedScene
@export var bubble_speed = 15

@export var speed = 200
@export var friction = 0
@export var acceleration = 0
# TODO: times per second?
@export var shooting_speed = 1

@export var health = 3

var is_shooting_cooldown = false
var screen_size

signal hit
signal game_over

func on_hit() -> void:
	hit.emit()
	health -= 1
	if health < 1:
		queue_free()

func check_collision_between(from: Vector2, to: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(from, to)
	query.collision_mask = 1
	var result = space_state.intersect_ray(query)
	
	if result.size() > 0:
		return true
	return false

func can_shoot() -> bool:
	# Current weapon? võta sealt shooting speed
	#	Delay shooting speed põhjal
	return !is_shooting_cooldown

func get_enemies() -> Array[Node]:
	return get_tree().get_nodes_in_group("Enemy")

func get_nearest_enemy(enemies: Array[Node]) -> Node:
	var nearest_enemy = null
	var shortest_distance = INF
	
	for enemy in enemies:
		var distance = global_position.distance_to(enemy.global_position)
		if enemy and distance < shortest_distance and !check_collision_between(global_position, enemy.global_position):
			shortest_distance = distance
			nearest_enemy = enemy
	return nearest_enemy

# Ei tohi collision obj taga olla, et sihtida?
func shoot_nearest_enemy():
	if !can_shoot():
		return

	# Loo bubble node-id, mis liiguvad otse vaenlase poole
	var nearest_enemy: Node = get_nearest_enemy(get_enemies())
	if nearest_enemy == null:
		return
	
	look_at(nearest_enemy.global_position)
	
	var bubble = bubble_scene.instantiate()
	bubble.position = $BubbleStartMarker.global_position
	var direction = (nearest_enemy.global_position - bubble.global_position).normalized()
	var force = direction * bubble_speed
	bubble.apply_central_force(force)
	
	# Kui player tulistas
	is_shooting_cooldown = true
	$ShootingCooldown.start()
	
	add_sibling(bubble)
	pass

func get_input():
	var input = Vector2()
	if Input.is_action_pressed('move_right'):
		input.x += 1
	if Input.is_action_pressed('move_left'):
		input.x -= 1
	if Input.is_action_pressed('move_down'):
		input.y += 1
	if Input.is_action_pressed('move_up'):
		input.y -= 1
	return input

func _physics_process(delta: float) -> void:
	var direction = get_input()
	if direction.length() > 0:
		velocity = direction.normalized() * speed
	else:
		velocity = Vector2.ZERO
		shoot_nearest_enemy()
	move_and_slide()


func _on_shooting_cooldown_timeout() -> void:
	is_shooting_cooldown = false
