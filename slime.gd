class_name Slime
extends Projectile

const current_scene: PackedScene = preload("res://slime.tscn")

@export var damage = 1

static func new_slime(starting_position: Vector2, damage := 1, speed := 15) -> Slime:
	var new_slime: Slime = current_scene.instantiate()
	new_slime.global_position = starting_position
	new_slime.damage = damage
	new_slime.speed = speed
	
	return new_slime

func target_player() -> void:
	var player: Player = get_tree().get_first_node_in_group("Player")
	if !player:
		return
	move_towards(player.global_position)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SlimeAnimated.play()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node) -> void:
	if body is Player:
		body.on_hit()
	$SlimePop.play()
	hide()


func _on_slime_pop_finished() -> void:
	queue_free()
