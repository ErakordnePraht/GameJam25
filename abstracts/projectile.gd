class_name Projectile
extends RigidBody2D

@export var speed = 15

func move_towards(target: Vector2) -> void:
	var direction = (target - global_position).normalized()
	var force = direction * speed;
	look_at(target)
	
	apply_central_force(force)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
