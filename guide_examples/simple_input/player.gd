extends Node2D

@export var speed:float = 100

@export var mapping_context:GUIDEMappingContext

@export var left_action:GUIDEAction
@export var right_action:GUIDEAction
@export var up_action:GUIDEAction
@export var down_action:GUIDEAction

func _ready():
	GUIDE.enable_mapping_context(mapping_context)

func _process(delta:float) -> void:
	var offset:Vector2 = Vector2.ZERO
	
	if left_action.is_triggered():
		offset.x = -1
	
	if right_action.is_triggered():
		offset.x = 1
		
	if up_action.is_triggered():
		offset.y = -1
		
	if down_action.is_triggered():
		offset.y = 1
		
	position += offset * speed * delta
