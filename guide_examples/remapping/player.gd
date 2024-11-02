extends Node2D

@export var speed:float = 150
@export var move_action:GUIDEAction


func _process(delta:float) -> void:
	position += move_action.get_value_axis_2d().normalized() * speed * delta

	
