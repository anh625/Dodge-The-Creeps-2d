extends RigidBody2D
@export var damage = 25

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_2d_area_entered(area):
	if area.has_method("take_damage"):
		area.take_damage(damage)
		hide() # Ẩn quái ngay lập tức
		$CollisionShape2D.set_deferred("disabled", true) # Tắt va chạm để tránh quái ẩn vẫn gây sát thương
		$DieSound.play()
		await $DieSound.finished # Đợi cho âm thanh phát xong hoàn toàn
		queue_free() # Xóa node sau khi âm thanh kết thúc
	
