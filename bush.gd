extends Area2D

signal player_safe

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body:Player):
	print("player safe")
	emit_signal("player_safe")
