extends Node2D



var player : CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var velocity : Vector2 = Vector2.ZERO
var lifetime = 5.0

@onready var floor_ray_cast = $FloorRayCast

func _ready():
	$LifeTimeTimer.wait_time = lifetime
	$LifeTimeTimer.start()
	player = get_tree().get_nodes_in_group("Player")[0] as CharacterBody2D

func _physics_process(delta):
	if not floor_ray_cast.is_colliding():
		velocity.y += gravity * delta
		global_position += velocity * delta
	else:
		velocity.y = 0
		
func _on_life_time_timer_timeout():
	queue_free()


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player") and !player.is_invincible:
		body.collect_item()
		queue_free()
