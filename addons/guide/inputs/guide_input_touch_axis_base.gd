@tool
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

## The index of the finger for which the delta should be reported 
## (0 = first finger, 1 = second finger, etc.). If -1, reports the average delta for 
## all fingers currently touching.
@export_range(-1, 4, 1, "or_greater") var finger_index:int = -1:
	set(value):
		if value < -1:
			value = -1
		finger_index = value
		emit_changed()
		
var _last_position:Vector2 = Vector2.INF

# We use the reset call to calculate the position for this frame
# so it can serve as reference for the next frame
func _needs_reset() -> bool:
	return true

func _reset() -> void:
	_last_position = GUIDETouchState.get_finger_position(finger_index, finger_count, exact)
	_apply_value(_calculate_value(_last_position))

func _input(event:InputEvent) -> void:
	if not GUIDETouchState.process_input_event(event):
		# not touch-related
		return
	
	# calculate live position from the cache
	var new_position:Vector2 = GUIDETouchState.get_finger_position(finger_index, finger_count, exact)

	_apply_value(_calculate_value(new_position))

func _apply_value(value:Vector2):
	pass	
			
func _calculate_value(new_position:Vector2) -> Vector2:
	# if we cannot calculate a delta because old or new position
	# are undefined, we say the delta is zero	
	if not _last_position.is_finite() or not new_position.is_finite():
		return Vector2.ZERO
		
	return new_position - _last_position

		
func is_same_as(other:GUIDEInput):
	return other is GUIDEInputTouchAxis2D and \
		other.finger_count == finger_count and \
		other.exact == exact and \
		other.finger_index == finger_index


