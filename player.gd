extends Area2D

signal hit

@export var speed = 400
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
		velocity = velocity.normalized() * speed
		get_node("AnimatedSprite2D").play()
		
	else:
		get_node("AnimatedSprite2D").stop()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		get_node("AnimatedSprite2D").animation = "walk"
		get_node("AnimatedSprite2D").flip_v = false
		get_node("AnimatedSprite2D").flip_h = velocity.x < 0
	
	if velocity.y != 0:
		get_node("AnimatedSprite2D").animation = "up"
		get_node("AnimatedSprite2D").flip_v = velocity.y > 0


func _on_body_entered(body):
	hide()
	hit.emit()
	get_node("CollisionShape2D").set_deferred("disabled", true)


func start(pos):
	position = pos
	show()
	get_node("CollisionShape2D").disabled = false
