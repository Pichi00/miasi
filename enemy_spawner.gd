class_name EnemyBase
extends StaticBody2D

signal detect_player
signal undetect_player
signal base_destroyed

var player_detected = false
var hp = 10
var enemies_limit = 20

@export var enemy: PackedScene

@onready var enemy_coordinator = get_parent()
@onready var hp_bar = $HpBar

func _ready():
	hp_bar.value = hp

func spawn_enemy():
	var enemies_amount = len(get_tree().get_nodes_in_group("Enemy"))
	if enemies_amount < enemies_limit:
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
		emit_signal("base_destroyed")
		queue_free()
	hp_bar.value = hp

func _on_detection_timer_timeout():
	emit_signal("undetect_player")

func _on_base_hitbox_body_entered(body:PlayerBullet):
	detect_player_alert()
	take_damage(body.damage)
	body.queue_free()

func detect_player_alert():
	emit_signal("detect_player")

func set_player_detection(value:bool):
	player_detected = value
