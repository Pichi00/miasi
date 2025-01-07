extends StaticBody2D

signal detect_player
signal undetect_player

@export var enemy: PackedScene

@onready var detection_timer = $DetectionTimer

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_enemy():
	var new_enemy = enemy.instantiate()
	new_enemy.position = Vector2(0,0)
	add_child(new_enemy)

func _on_spawn_cooldown_timeout():
	spawn_enemy()

func _on_detection_timer_timeout():
	emit_signal("undetect_player")


func _on_base_hitbox_body_entered(body):
	emit_signal("detect_player")
	detection_timer.start()
