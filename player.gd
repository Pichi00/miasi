class_name Player
extends CharacterBody2D

var speed = 100
var rotation_speed = 1.5
var direction = Vector2.ZERO
const MAX_HP = 10
var hp = 10
var damage = 1
var can_attack = true
var detected = false

@onready var sprite = $Sprite
@onready var collision = $CollisionShape2D
@onready var attack_cooldown_timer = $AttackCooldownTimer
@export var bullet: PackedScene
@export var bullet_speed = 100

func _physics_process(delta: float) -> void:
	direction.y = (int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up")))
	velocity = direction.rotated(deg_to_rad(sprite.rotation_degrees))
	velocity = velocity.normalized() * speed
	if (Input.is_action_pressed("ui_up")):
		sprite.play("run")
	elif (Input.is_action_pressed("ui_down")):
		sprite.play("run_back")
	else :
		sprite.stop()

	
	if Input.is_action_pressed("ui_right"):
		sprite.rotation_degrees+=rotation_speed
		collision.rotation_degrees+=rotation_speed
	elif Input.is_action_pressed("ui_left"):
		sprite.rotation_degrees-=rotation_speed
		collision.rotation_degrees-=rotation_speed
	
	if Input.is_action_pressed("shot"):
		shot_one()
	
	$Lufa.look_at(get_global_mouse_position())
	$Lufa.rotation_degrees += 90
	
	move_and_slide()


func shot_one():
	if can_attack:
		var new_bullet = bullet.instantiate()
		add_child(new_bullet)
		new_bullet.global_position = $Lufa/BulletSpawner.global_position
		new_bullet.rotation_degrees = $Lufa.rotation_degrees 
		new_bullet.velocity = new_bullet.direction.rotated(deg_to_rad(new_bullet.rotation_degrees))
		can_attack = false
		attack_cooldown_timer.start()

func _on_attack_cooldown_timer_timeout():
	attack_cooldown_timer.stop()
	can_attack = true

func detect():
	detected = true
	$DetectionWarning.visible = true

func undetect():
	detected = false
	$DetectionWarning.visible = false
