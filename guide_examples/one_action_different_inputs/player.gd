extends ColorRect

@export var speed:float = 100

@export var mapping_context:GUIDEMappingContext
@export var move_action:GUIDEAction

func _ready():
	GUIDE.enable_mapping_context(mapping_context)


func _process(delta:float) -> void:
	position += move_action.get_value_axis_2d().normalized() * speed * delta
