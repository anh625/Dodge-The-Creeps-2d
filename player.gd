extends Area2D

signal hit

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var health_point_current
var max_health_point = 200
var current_color_health_point = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
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
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about the following boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0	


func _on_body_entered(body):
	#hide() # Player disappears after being hit.
	#hit.emit()
#	set_health_point(health_point_current - 25)
	# Must be deferred as we can't change physics properties on a physics callback.
	#$CollisionShape2D.set_deferred("disabled", true)
	#body.queue_free()
	pass
	
func start(pos):
	position = pos
	show()
#	queue_redraw()
	$CollisionShape2D.disabled = false
	
func set_health_point(health_point):
	health_point_current = health_point #if health_point >= 0 else 0
	if (health_point_current <= 0):
#		queue_free()
		hide()
		hit.emit()
		
	$Label.text = str(health_point_current)
		
	var percent_health_point = health_point_current * 100 / max_health_point	
	var target_color_health_point: String
	if percent_health_point > 66:
		target_color_health_point = "green"
	elif percent_health_point > 33:
		target_color_health_point = "yellow"
	else:
		target_color_health_point = "red"
	
	if current_color_health_point != target_color_health_point:
		current_color_health_point = target_color_health_point
		$Label.add_theme_color_override("font_color", current_color_health_point)
	
func set_max_health_point(health_point):
	max_health_point = health_point
	
func take_damage(damage):
	set_health_point(health_point_current - damage)
	

