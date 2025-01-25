class_name Mob
extends RigidBody2D

@export var health = 3
@export var slime_damage = 1

func on_hit() -> void:
	health -= 1
	if health < 1:
		queue_free()
		
func shoot_player() -> void:
	var player: Player = get_tree().get_first_node_in_group("Player")
	
	if !player:
		return
	look_at(player.global_position)
	
	# Create slime, start movement
	var slime: Slime = Slime.new_slime($SlimeStartMarker.global_position, slime_damage)
	add_sibling(slime)
	slime.target_player()
	
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node) -> void:
	pass


func _on_shooting_cooldown_timeout() -> void:
	shoot_player()
