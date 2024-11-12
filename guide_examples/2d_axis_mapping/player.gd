extends Node2D

@export var speed:float = 150

@export var mapping_context:GUIDEMappingContext
@export var move_action:GUIDEAction

func _ready():
	GUIDE.enable_mapping_context(mapping_context)


func _process(delta:float) -> void:
	# GUIDE already gives us a full 2D axis. We don't need to build it
	# ourselves using Input.get_vector.
	position += move_action.get_value_axis_2d().normalized() * speed * delta
