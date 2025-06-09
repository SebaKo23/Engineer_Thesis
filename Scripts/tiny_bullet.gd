extends Area2D

var direction = 1
var tiny_bullet_speed = 200.0

func _ready():
	add_to_group("TinyBullet")
	
func _physics_process(delta):
	move_local_x(direction * tiny_bullet_speed * delta)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	
func destroy_bullet():
	queue_free()
