@tool
@icon("res://addons/guide/triggers/guide_trigger.svg")
class_name GUIDETrigger
extends Resource


enum GUIDETriggerState {
	## The trigger did not fire.
	NONE,
	## The trigger's conditions are partially met
	ONGOING,
	## The trigger has fired.
	TRIGGERED
}

@export var actuation_threshold:float = 0.5
var _last_value:Vector3


func _update_state(input:Vector3, delta:float, value_type:GUIDEAction.GUIDEActionValueType) -> GUIDETriggerState:
	return GUIDETriggerState.NONE

	
func _is_actuated(input:Vector3, value_type:GUIDEAction.GUIDEActionValueType) -> bool:
	match value_type:
		GUIDEAction.GUIDEActionValueType.AXIS_1D, GUIDEAction.GUIDEActionValueType.BOOL:
			return _is_axis1d_actuated(input)
		GUIDEAction.GUIDEActionValueType.AXIS_2D:
			return _is_axis2d_actuated(input)
		GUIDEAction.GUIDEActionValueType.AXIS_3D:
			return _is_axis3d_actuated(input)
			
	return false

## Checks if a 1D input is actuated.
func _is_axis1d_actuated(input:Vector3) -> bool:
	return abs(input.x) > actuation_threshold
	
## Checks if a 2D input is actuated.
func _is_axis2d_actuated(input:Vector3) -> bool:
	return Vector2(input.x, input.y).length_squared() > actuation_threshold * actuation_threshold

## Checks if a 3D input is actuated.
func _is_axis3d_actuated(input:Vector3) -> bool:
	return input.length_squared() > actuation_threshold * actuation_threshold
	
func _editor_name() -> String:
	return "GUIDETrigger"
	
func _editor_description() -> String:
	return ""
