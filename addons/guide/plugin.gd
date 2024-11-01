@tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("GUIDE", "res://addons/guide/guide.gd")


func _exit_tree():
	remove_autoload_singleton("GUIDE")
