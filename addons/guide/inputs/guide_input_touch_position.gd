@tool
class_name GUIDEInputTouchPosition
extends GUIDEInput

const GUIDETouchState = preload("guide_touch_state.gd")

## The number of fingers to be tracked.
@export_range(1, 5, 1, "or_greater") var finger_count:int = 1:
	set(value):
		if value < 1:
			value = 1
		finger_count = value
		emit_changed()

## If this is true, then this input will only react if the amount
## of fingers exactly matches the finger count.
@export var exact:bool = true:
	set(value):
		exact = value
		emit_changed()

## The index of the finger that should be reported (0 = first finger, 1 = second finger, etc.). 
## If -1, reports the average position of all fingers currently touching.
@export_range(-1, 4, 1, "or_greater") var finger_index:int = -1:
	set(value):
		if value < -1:
			value = -1
		finger_index = value
		emit_changed()
		

func _begin_usage():
	_value = Vector3.INF
	

func _input(event:InputEvent) -> void:
	# update touch state
	if not GUIDETouchState.process_input_event(event):
	 	# not touch-related
		return
		
	# update finger position
	var position := GUIDETouchState.get_finger_position(finger_index, finger_count, exact)
	if not position.is_finite():
		_value = Vector3.INF
		return
		
	_value = Vector3(position.x, position.y, 0) 

		
func is_same_as(other:GUIDEInput):
	return other is GUIDEInputTouchPosition and \
		other.finger_count == finger_count and \
		other.exact == exact and \
		other.finger_index == finger_index


func _to_string():
	return "(GUIDEInputTouchPosition finger_count=" + str(finger_count) + " exact=" + str(exact) + \
		" finger_index=" + str(finger_index) +")"


func _editor_name() -> String:
	return "Touch Position"

	
func _editor_description() -> String:
	return "Position of a touching finger."


func _native_value_type() -> GUIDEAction.GUIDEActionValueType:
	return GUIDEAction.GUIDEActionValueType.AXIS_2D
