class_name Player
extends CharacterBody2D

var speed = 110
var rotation_speed = 1.6
var direction = Vector2.ZERO
var hp = 10
var damage = 1
var can_attack = true
var detected = false
var enemy_bases_amount = 4

@onready var sprite = $Sprite
@onready var collision = $CollisionShape2D
@onready var attack_cooldown_timer = $AttackCooldownTimer
@onready var animation_player = $AnimationPlayer
@onready var hp_label = $UI/HpLabel
@onready var bases_label = $UI/BasesLabel

@export var bullet: PackedScene
@export var bullet_speed = 100

# Metoda wywoływana po stworzeniu obiektu
func _ready():
	hp_label.text = str(hp)

# Metoda wywoływana automatycznie przez silnik Godot w stałych odstępach czasu,
# synchronizowanych z zegarem fizyki
func _physics_process(delta: float) -> void:
	# Obliczenie wektora ruchu gracza
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
	
	# Wykrycie akcji strzału gracza
	if Input.is_action_pressed("shot"):
		shot_one()
	
	# Obrót lufy czołgu by podążała za kursorem myszy
	$Lufa.look_at(get_global_mouse_position())
	$Lufa.rotation_degrees += 90
	
	# Wbudowana metoda odpowiedzialna za ruch gracza
	move_and_slide()

# Metoda odpowiedzialna za wystrzelenie pocisku przez gracza
func shot_one():
	if can_attack:
		var new_bullet = bullet.instantiate()
		add_child(new_bullet)
		new_bullet.global_position = $Lufa/BulletSpawner.global_position
		new_bullet.rotation_degrees = $Lufa.rotation_degrees 
		new_bullet.velocity = new_bullet.direction.rotated(deg_to_rad(new_bullet.rotation_degrees))
		# Ustawienie przerwy w atakach gracza
		can_attack = false
		attack_cooldown_timer.start()

# Metoda przywracająca możliwość strzału graczowi
func _on_attack_cooldown_timer_timeout():
	attack_cooldown_timer.stop()
	can_attack = true

# Metoda ustawiająca stanu wykrycia gracza przez przeciwników
func detection(value:bool):
	detected = value
	$DetectionWarning.visible = value

# Metoda wywoływana po otrzymaniu obrażeń przez gracza
func take_damage(value:int):
	animation_player.play("take_damage")
	hp -= value
	hp_label.text = str(hp)
	if hp <= 0:
		print("YOU LOST")

# Metoda ustawiająca ilość pozostałych baz przeciwników
func set_enemy_bases_amount(value:int):
	enemy_bases_amount = value
	$UI/BasesLabel.text = str(enemy_bases_amount)
