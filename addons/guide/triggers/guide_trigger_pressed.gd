## A trigger that activates when the input is pushed down. Will only emit a
## trigger event once. Holding the input will not trigger further events.
class_name GUIDETriggerPressed
extends GUIDETrigger


func _update_state(input:Vector3, delta:float, value_type:GUIDEAction.GUIDEActionValueType) -> GUIDETriggerState:
	if _is_actuated(input, value_type):
		if not _is_actuated(_last_value, value_type):
			return GUIDETriggerState.TRIGGERED
		
	return GUIDETriggerState.NONE
