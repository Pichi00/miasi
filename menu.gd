extends Control

var gameScene = "res://world.tscn"
var authorsScene = "res://authors.tscn"

func _on_button_pressed():
	get_tree().change_scene_to_file(gameScene)

func _on_authors_button_pressed():
	get_tree().change_scene_to_file(authorsScene)


func _on_exit_button_pressed():
	get_tree().quit()
