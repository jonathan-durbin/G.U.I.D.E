@icon("res://addons/guide/guide_internal.svg")
@tool
## A mapping from actuated input to a trigger result
class_name GUIDEInputMapping
extends Resource

## The input to be actuated
@export var input:GUIDEInput:
	set(value):
		if value == input:
			return
		input = value
		emit_changed()


## A list of modifiers that preprocess the actuated input before
## it is fed to the triggers.
@export var modifiers:Array[GUIDEModifier] = []:
	set(value):
		if value == modifiers:
			return
		modifiers = value
		emit_changed()


## A list of triggers that could trigger the mapped action.
@export var triggers:Array[GUIDETrigger] = []:
	set(value):
		if value == triggers:
			return
		triggers = value
		emit_changed()


var _default_trigger:GUIDETrigger
var _state:GUIDETrigger.GUIDETriggerState = GUIDETrigger.GUIDETriggerState.NONE
var _value:Vector3 = Vector3.ZERO


func _update_state(delta:float, value_type:GUIDEAction.GUIDEActionValueType):
	# Collect the current input value
	var input_value:Vector3 = input._value if input != null else Vector3.ZERO
	
	# Run it through all modifiers
	for modifier:GUIDEModifier in modifiers:
		input_value = modifier._modify_input(input_value, delta, value_type)
		
	_value = input_value
	
	# Run over all triggers
	var result:int = GUIDETrigger.GUIDETriggerState.NONE
	if triggers.is_empty():
		if _default_trigger == null:
			_default_trigger = GUIDETriggerDown.new()
			_default_trigger.actuation_threshold = 0
			
		result = _default_trigger._update_state(_value, delta, value_type)
	else:
		for trigger:GUIDETrigger in triggers:
			var trigger_result:GUIDETrigger.GUIDETriggerState = trigger._update_state(_value, delta, value_type)
			trigger._last_value = _value
		
			# Higher value results take precedence over lower value results
			result = max(result, trigger_result)
		
	_state = result

	
