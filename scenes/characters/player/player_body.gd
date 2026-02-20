extends CharacterBody2D

@onready var player_sprite: AnimatedSprite2D = $PlayerSprite
@onready var player_collision: CollisionShape2D = $PlayerCollision

var speed = 150.0

var last_direction = "right"

func _physics_process(delta: float) -> void:
	var velocity = Vector2.ZERO # The player's movement vector.
	
	if Input.is_action_pressed("right"):
		last_direction = "right"
		velocity.x += 1
	if Input.is_action_pressed("left"):
		last_direction = "left"
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
		
	var moving = (velocity.x > 0 || velocity.x < 0 || velocity.y > 0 || velocity.y < 0)
	
	if velocity.length() > 0 :
		velocity = velocity.normalized() * speed
	
	# Animations
	if ((velocity.x > 1 || velocity.x < -1 || velocity.y > 1 || velocity.y < -1) and Input.is_action_pressed("shift") and speed > 200):
		player_sprite.animation = "running"
	elif (velocity.x > 1 || velocity.x < -1 || velocity.y > 1 || velocity.y < -1):
		player_sprite.animation = "walking"
	else:
		player_sprite.animation = "default"
	pass

	if last_direction == "left":
		player_sprite.flip_h = true
	else:
		player_sprite.flip_h = false
		
	position += velocity * delta
	
	move_and_slide()
	
func _ready():
	pass
