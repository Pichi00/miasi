extends Node2D

var player_detected = false

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_enemy_spawner_detect_player():
	player_detected = true
	var player:Player = get_tree().get_nodes_in_group("Player")[0]
	var enemies = get_tree().get_nodes_in_group("Enemy")
	player.detect()
	for enemy in enemies:
		enemy.player_detected = true
	$DetectionTimer.start()


func _on_enemy_spawner_undetect_player():
	player_detected = false
	var player:Player = get_tree().get_nodes_in_group("Player")[0]
	var enemies = get_tree().get_nodes_in_group("Enemy")
	player.undetect()
	for enemy in enemies:
		enemy.player_detected = false

