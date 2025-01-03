extends CharacterBody2D

const MAX_HP = 10

var speed = 20
var rotation_speed = 1.5
var direction = Vector2.ZERO
var player_detected = false
var angle

@export var hp = 10
@export var damage = 1

@onready var player = get_tree().get_nodes_in_group("Player")[0]

func _physics_process(delta: float) -> void:
	if player_detected:
		velocity =  player.global_position - global_position
		velocity = velocity.normalized()
	else:
		direction.y = -1
		velocity = direction.rotated(deg_to_rad(rotation_degrees))
		velocity = velocity.normalized()
	angle = -rad_to_deg(velocity.angle_to(Vector2(0,-1)))
	if abs(rotation_degrees - angle) >= 180:
		rotation_degrees = angle 
	rotation_degrees = move_toward(rotation_degrees, angle, rotation_speed)
	set_velocity(velocity * speed)
	move_and_slide()
	velocity = velocity
	
	
	move_and_slide()


func _on_detection_area_body_entered(body: Node2D) -> void:
	player_detected = true


func _on_detection_area_body_exited(body: Node2D) -> void:
	player_detected = false
