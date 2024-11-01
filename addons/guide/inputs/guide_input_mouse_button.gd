class_name GUIDEInputMouseButton
extends GUIDEInput

@export var button:MouseButton = MOUSE_BUTTON_LEFT

func _input(event:InputEvent):
	if not event is InputEventMouseButton:
		return
	
	if event.button != button:
		return
		
	_value.x = 1.0 if event.pressed else 0.0

func _is_same_as(other:GUIDEInput) -> bool:
	return other is GUIDEInputMouseButton and other.button == button
