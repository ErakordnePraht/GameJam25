extends RigidBody2D

signal bubble_pop

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
