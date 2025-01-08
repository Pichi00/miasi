extends StaticBody2D

signal detect_player
signal undetect_player

var player_detected = false
var hp = 12

@export var enemy: PackedScene

@onready var enemy_coordinator = get_parent()
@onready var hp_bar = $HpBar

func _ready():
	hp_bar.value = hp

func _process(delta):
	pass

func spawn_enemy():
	var new_enemy:Enemy = enemy.instantiate()
	new_enemy.position = Vector2(0,0)
	new_enemy.set_player_detection(player_detected)
	add_child(new_enemy)

func _on_spawn_cooldown_timeout():
	spawn_enemy()

func take_damage(value:int):
	$AnimationPlayer.play("take_damage")
	hp -= value
	if hp <= 0:
		queue_free()
	hp_bar.value = hp

func _on_detection_timer_timeout():
	emit_signal("undetect_player")

func _on_base_hitbox_body_entered(body:PlayerBullet):
	emit_signal("detect_player")
	take_damage(body.damage)
	body.queue_free()

func set_player_detection(value:bool):
	player_detected = value
