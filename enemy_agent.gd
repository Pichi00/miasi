class_name Enemy
extends CharacterBody2D

signal player_detected

const MAX_HP = 10

var speed = 70
var rotation_speed = 1.5
var direction = Vector2.ZERO
#var player_detected = false
var angle
var destroy_lock = false
var player_in_dmg_range = false

enum STATES {DEFAULT, PLAYER_DETECTED}
var state = STATES.DEFAULT

@export var hp = 2
@export var damage = 1

@onready var player = get_tree().get_nodes_in_group("Player")[0]
@onready var sprite = $Sprite
@onready var change_direction_timer = $ChangeDirectionTimer
@onready var animation_player = $AnimationPlayer
@onready var destruction_range = $DestructionRange
@onready var parent:EnemyBase = get_parent()

func _ready():
	sprite.play("run")
	angle = -rad_to_deg(velocity.angle_to(Vector2(0,-1)))
	connect("player_detected",parent.detect_player_alert)

func _physics_process(delta: float) -> void:
	match(state):
		STATES.PLAYER_DETECTED:
			velocity =  player.global_position - global_position
			velocity = velocity.normalized()
			angle = -rad_to_deg(velocity.angle_to(Vector2(0,-1)))
		STATES.DEFAULT:
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
	set_player_detection(true)


func _on_detection_area_body_exited(body: Node2D) -> void:
	pass
	#set_player_detection(false)


func _on_hitbox_body_entered(body: PlayerBullet):
	if !destroy_lock:
		animation_player.play("get_hit")
		lose_hp(body.damage)
		emit_signal("player_detected")
		body.queue_free()

func lose_hp(damage: int):
	hp -= damage
	if hp <= 0:
		selfdestroy()

func change_direction():
	if state == STATES.DEFAULT:
		angle = randi_range(30, 180)
		change_direction_timer.wait_time = randf_range(2, 6)

func set_player_detection(value:bool):
	if value:
		state = STATES.PLAYER_DETECTED
	else:
		state = STATES.DEFAULT

func _on_change_direction_timer_timeout():
	change_direction()

func selfdestroy():
	animation_player.play("destroy")
	destroy_lock = true
	

func damage_player():
	if player_in_dmg_range:
		player.take_damage(damage)
		print("player damaged")

func _on_destruction_range_body_entered(body:Player):
	player_in_dmg_range = true
	selfdestroy()

func _on_destruction_range_body_exited(body:Player):
	player_in_dmg_range = false
