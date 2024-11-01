## Input from a single joy axis.
class_name GUIDEInputJoyAxis1D
extends GUIDEInputJoyBase

## The joy axis to sample
@export var axis:JoyAxis = JOY_AXIS_LEFT_X


func _input(event:InputEvent):
	if not event is InputEventJoypadMotion:
		return
		
	if event.axis != axis:
		return
		
	if joy_index > -1 and event.device != _joy_id:
		return
		
	_value.x = event.axis_value
