@tool
class_name GUIDEInputMouseButton
extends GUIDEInput


@export var button:MouseButton = MOUSE_BUTTON_LEFT:
	set(value):
		if value == button:
			return
		button = value
		emit_changed()		
	

func _input(event:InputEvent):
	if not event is InputEventMouseButton:
		return
	
	if event.button != button:
		return
		
	_value.x = 1.0 if event.pressed else 0.0

func _is_same_as(other:GUIDEInput) -> bool:
	return other is GUIDEInputMouseButton and other.button == button


func _to_string():
	return "(GUIDEInputMouseButton: button=" + str(button) + ")"


func _editor_name() -> String:
	return "Mouse Button"
	
func _editor_description() -> String:
	return "A press of a mouse button. The mouse wheel is also a button."
	

func _native_value_type() -> GUIDEAction.GUIDEActionValueType:
	return GUIDEAction.GUIDEActionValueType.BOOL
