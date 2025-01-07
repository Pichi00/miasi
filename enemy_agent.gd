class_name Enemy
extends CharacterBody2D

const MAX_HP = 10

var speed = 70
var rotation_speed = 1.5
var direction = Vector2.ZERO
var player_detected = false
var angle

@export var hp = 10
@export var damage = 1

@onready var player = get_tree().get_nodes_in_group("Player")[0]
@onready var sprite = $Sprite
@onready var change_direction_timer = $ChangeDirectionTimer
@onready var animation_player = $AnimationPlayer

func _ready():
	sprite.play("run")
	angle = -rad_to_deg(velocity.angle_to(Vector2(0,-1)))

func _physics_process(delta: float) -> void:
	if player_detected:
		velocity =  player.global_position - global_position
		velocity = velocity.normalized()
		angle = -rad_to_deg(velocity.angle_to(Vector2(0,-1)))
	else:
		direction.y = -1
		velocity = direction.rotated(deg_to_rad(rotation_degrees))
		velocity = velocity.normalized()
	
	if abs(rotation_degrees - angle) >= 180:
		rotation_degrees = angle 
	rotation_degrees = move_toward(rotation_degrees, angle, rotation_speed)
	set_velocity(velocity * speed)
	#move_and_slide()
	velocity = velocity
	
	move_and_slide()


func _on_detection_area_body_entered(body: Node2D) -> void:
	pass
	#player_detected = true


func _on_detection_area_body_exited(body: Node2D) -> void:
	pass
	#player_detected = false


func _on_hitbox_body_entered(body: PlayerBullet):
	animation_player.play("get_hit")
	lose_hp(body.damage)
	body.queue_free()

func lose_hp(damage: int):
	hp -= damage
	if hp <= 0:
		queue_free()

func change_direction():
	if !player_detected:
		angle = randi_range(30, 180)
		change_direction_timer.wait_time = randf_range(2, 6)

func _on_change_direction_timer_timeout():
	change_direction()
