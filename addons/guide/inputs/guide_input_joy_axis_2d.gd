## Input from two joy axes.
class_name GUIDEInputJoyAxis2D
extends GUIDEInputJoyBase

## The joy axis to sample for x input.
@export var x:JoyAxis = JOY_AXIS_LEFT_X
## The joy axis to sample for y input.
@export var y:JoyAxis = JOY_AXIS_LEFT_Y


func _input(event:InputEvent):
	if not event is InputEventJoypadMotion:
		return
		
	if event.axis != x and event.axis != y:
		return
		
	if joy_index > -1 and event.device != _joy_id:
		return
		
	if event.axis == x:
		_value.x = event.axis_value
		return
		
	if event.axis == y:
		_value.y = event.axis_value
