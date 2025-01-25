class_name Bubble
extends Projectile

signal bubble_pop
const current_scene: PackedScene = preload("res://bubble.tscn")

@export var damage = 1

static func new_bubble(starting_position: Vector2, damage := 1, speed := 15) -> Bubble:
	var new_bubble: Bubble = current_scene.instantiate()
	new_bubble.global_position = starting_position
	new_bubble.damage = damage
	new_bubble.speed = speed
	
	return new_bubble

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node) -> void:
	bubble_pop.emit()
	#if body is Player:
		#body.on_hit()
	if body is Mob:
		body.on_hit()
	
	$BubblePop.play()
	hide()


func _on_bubble_pop_finished() -> void:
	queue_free()
