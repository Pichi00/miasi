class_name PlayerBullet
extends CharacterBody2D

var vel
var direction = Vector2(0,-1)
var speed = 400

var damage = 1

func _ready():
	damage = get_parent().damage
	set_as_top_level(true)

func _physics_process(_delta):
	set_velocity(velocity.normalized() * speed)
	move_and_slide()


func hit():
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
