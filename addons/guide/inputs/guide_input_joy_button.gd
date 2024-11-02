class_name GUIDEInputJoyButton
extends GUIDEInputJoyBase

@export var button:JoyButton = JOY_BUTTON_A

func _input(event:InputEvent):
	if not event is InputEventJoypadButton:
		return
	
	if event.button != button:
		return
	
	
	if joy_index > -1 and event.device != _joy_id:
		return
		
	_value.x = 1.0 if event.pressed else 0.0

func _is_same_as(other:GUIDEInput) -> bool:
	return other is GUIDEInputJoyButton and other.button == button

func _to_string():
	return "(GUIDEInputJoyButton: button=" + str(button) + ", joy_index="  + str(joy_index) + ")"
