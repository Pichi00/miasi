extends Node2D

var player_detected = false

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_player_detection(value: bool):
	player_detected = value
	var player:Player = get_tree().get_nodes_in_group("Player")[0]
	var enemies = get_tree().get_nodes_in_group("Enemy")
	var bases = get_tree().get_nodes_in_group("EnemyBase")
	player.detection(value)
	for enemy in enemies:
		enemy.set_player_detection(value)
	for enemyBase in bases:
		enemyBase.set_player_detection(value)

func _on_enemy_spawner_detect_player():
	update_player_detection(true)


func _on_enemy_spawner_undetect_player():
	pass
	#update_player_detection(false)


func _on_bush_player_safe():
	update_player_detection(false)
