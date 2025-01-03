extends CharacterBody2D

var speed = 100
var rotation_speed = 1.5
var direction = Vector2.ZERO
const MAX_HP = 10
var hp = 10
var damage = 1

@onready var sprite = $Sprite

func _physics_process(delta: float) -> void:
	#sprite.play("run")
	direction.y = (int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up")))
	if (Input.is_action_pressed("ui_up")):
		sprite.play("run")
	elif (Input.is_action_pressed("ui_down")):
		sprite.play("run_back")
	else :
		sprite.stop()
	velocity = direction.rotated(deg_to_rad(self.rotation_degrees))
	velocity = velocity.normalized() * speed
	
	if Input.is_action_pressed("ui_right"):
		self.rotation_degrees+=rotation_speed
	elif Input.is_action_pressed("ui_left"):
		self.rotation_degrees-=rotation_speed
	
	$Lufa.look_at(get_global_mouse_position())
	$Lufa.rotation_degrees += 90
	
	
	move_and_slide()
