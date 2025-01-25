extends CharacterBody2D

@export var speed = 400
# TODO: times per second?
@export var shooting_speed = 1
var is_shooting_cooldown = false
var screen_size

signal hit

func can_shoot():
	# Current weapon? võta sealt shooting speed
	#	Delay shooting speed põhjal
	pass

# Ei tohi collision obj taga olla, et sihtida?
func shoot_nearest_enemy():

	# Loo bubble node-id, mis liiguvad otse vaenlase poole
	
	# Kui laskmine käis
	is_shooting_cooldown = true
	$ShootingCooldown.start()
	pass

func start(pos):
	#position = pos
	show()
	$CollisionShape2D.disabled = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	if velocity.length() > 0:
		move_and_slide()
	else:
		$AnimatedSprite2D.stop()
		# Shoot at nearest enemy
	#position += velocity * delta
	#position = position.clamp(Vector2.ZERO, screen_size)


#func _on_body_entered(body: Node2D) -> void:
#	pass
	#hide()
	#hit.emit()
	#$CollisionShape2D.set_deferred("disabled", true)

# Timerit kasutades võib tekkida race condition?
func _on_shooting_cooldown_timeout() -> void:
	is_shooting_cooldown = false
