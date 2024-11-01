class_name GUIDETriggerDown
extends GUIDETrigger

func _update_state(input:Vector3, delta:float, value_type:GUIDEAction.GUIDEActionValueType) -> GUIDETriggerState:
	# if the input is actuated, then the trigger is triggered.
	if _is_actuated(input, value_type):
		return GUIDETriggerState.TRIGGERED
	# otherwise, the trigger is not triggered.
	return GUIDETriggerState.NONE
