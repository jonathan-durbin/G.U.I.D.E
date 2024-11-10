extends Node

const GUIDESet = preload("guide_set.gd")
const GUIDEReset = preload("guide_reset.gd")
const GUIDEInputTracker = preload("guide_input_tracker.gd")
const GUIDEUI = preload("ui/guide_ui.gd")

## The currently active contexts. Key is the context, value is the priority
var _active_contexts:Dictionary = {}
## The currently active action mappings.
var _active_action_mappings:Array[GUIDEActionMapping] = []

## The currently active remapping config.
var _active_remapping_config:GUIDERemappingConfig

## All currently active inputs as collected from the active input mappings
var _active_inputs:GUIDESet = GUIDESet.new()

## A reference to the reset node which resets inputs that need a reset per frame
## This is an extra node because the reset should run at the end of the frame
## before new input is processed at the beginning of the frame.
var _reset_node:GUIDEReset

var _ui:GUIDEUI
var UI:GUIDEUI:
	get: return _ui

func _ready():
	_reset_node = GUIDEReset.new()
	_ui = GUIDEUI.new()
	add_child(_ui)
	add_child(_reset_node)
	# attach to the current viewport to get input events
	GUIDEInputTracker._instrument.call_deferred(get_viewport())
	
	get_tree().node_added.connect(_on_node_added)
	


## Called when a node is added to the tree. If the node is a window
## GUIDE will instrument it to get events when the window is focused.	
func _on_node_added(node:Node) -> void:
	if not node is Window:
		return
		
	GUIDEInputTracker._instrument(node)
	

## Injects input into GUIDE. GUIDE will call this automatically but 
## can also be used to manually inject input for GUIDE to handle 
func inject_input(event:InputEvent) -> void:
	if event is InputEventAction:
		return  # we don't react to Godot's built-in events
	
	for input:GUIDEInput in _active_inputs.values():
		input._input(event)
	
	
## Processes all currently active actions
func _process(delta:float) -> void:
	for action_mapping:GUIDEActionMapping in _active_action_mappings:
		
		var action:GUIDEAction = action_mapping.action
				
		# Walk over all input mappings for this action and consolidate state
		# and result value.
		var consolidated_value:Vector3 = Vector3.ZERO
		var consolidated_trigger_state:GUIDETrigger.GUIDETriggerState
		
		for input_mapping:GUIDEInputMapping in action_mapping.input_mappings:
			input_mapping._update_state(delta, action.action_value_type)
			consolidated_value += input_mapping._value
			consolidated_trigger_state = max(consolidated_trigger_state, input_mapping._state)
			
		
		# Now state change events.
		match(action._last_state):
			GUIDEAction.GUIDEActionState.TRIGGERED:
				match(consolidated_trigger_state):
					GUIDETrigger.GUIDETriggerState.NONE:
						action._completed(consolidated_value)
					GUIDETrigger.GUIDETriggerState.ONGOING:
						action._ongoing(consolidated_value)
					GUIDETrigger.GUIDETriggerState.TRIGGERED:
						action._triggered(consolidated_value)
						
			GUIDEAction.GUIDEActionState.ONGOING:
				match(consolidated_trigger_state):
					GUIDETrigger.GUIDETriggerState.NONE:
						action._cancelled(consolidated_value)
					GUIDETrigger.GUIDETriggerState.ONGOING:
						action._ongoing(consolidated_value)
					GUIDETrigger.GUIDETriggerState.TRIGGERED:
						action._triggered(consolidated_value)
						
			GUIDEAction.GUIDEActionState.COMPLETED:
				match(consolidated_trigger_state):
					GUIDETrigger.GUIDETriggerState.NONE:
						# nothing happens.
						pass
					GUIDETrigger.GUIDETriggerState.ONGOING:
						action._started(consolidated_value)
					GUIDETrigger.GUIDETriggerState.TRIGGERED:
						action._triggered(consolidated_value)
							
## Checks the currently activated mapping contexts and retrieves the highest
## priority mapping for the given action. Then returns all inputs currently
## used in this mapping.
func get_inputs_bound_to_action(action:GUIDEAction) -> Array[GUIDEInput]:	
	var result:Array[GUIDEInput] = []
	for mapping in _active_action_mappings:
		if mapping.action == action:
			for input_mapping in mapping.input_mappings:
				result.append(input_mapping.input)
			break
			
	return result

## Applies an input remapping config. This will override all input bindings in the 
## currently loaded mapping contexts with the bindings from the configuration.	
func set_remapping_config(config:GUIDERemappingConfig) -> void:
	if config == _active_remapping_config:
		return
	_active_remapping_config = config
	_update_caches()
	
## Enables the given context with the given priority. Lower numbers have higher priority.
func enable_mapping_context(context:GUIDEMappingContext, priority:int = 0):
	if not is_instance_valid(context):
		push_error("Null context given. Ignoring.")
		return
		
	_active_contexts[context] = priority
	_update_caches()
	
	
## Disables the given mapping context.
func disable_mapping_context(context:GUIDEMappingContext):
	if not is_instance_valid(context):
		push_error("Null context given. Ignoring.")
		return

	_active_contexts.erase(context)
	_update_caches()

	
func _update_caches():
	# Notify existing inputs that they aren no longer required
	for input:GUIDEInput in _active_inputs.values():
		input._end_usage()
		
	# Cancel all actions, so they don't remain in weird states.
	for mapping:GUIDEActionMapping in _active_action_mappings:
		match mapping.action._last_state:
			GUIDEAction.GUIDEActionState.ONGOING:
				mapping.action._cancelled(Vector3.ZERO)
			GUIDEAction.GUIDEActionState.TRIGGERED:
				mapping.action._completed(Vector3.ZERO)
				
	_active_inputs.clear()
	_active_action_mappings.clear()
	
	var sorted_contexts:Array[Dictionary] = []
	
	for context:GUIDEMappingContext in _active_contexts.keys():
		sorted_contexts.append({"context": context, "priority": _active_contexts[context]})

	sorted_contexts.sort_custom( func(a,b): return a.priority < b.priority )
	
	# The actions we already have processed. Same action may appear in different
	# contexts, so if we find the same action twice, only the first instance wins.
	var processed_actions:GUIDESet = GUIDESet.new()

	for entry:Dictionary in sorted_contexts:
		var context:GUIDEMappingContext = entry.context
		for action_mapping:GUIDEActionMapping in context.mappings:
			var action := action_mapping.action
			# If the action was already configured in a higher priority context,
			# we'll skip it.
			if processed_actions.has(action):
				# skip
				continue
			processed_actions.add(action)
			
			var effective_mapping := action_mapping
			# if we have a remapping configuration, then all remappable actions
			# will need to be updated
			if is_instance_valid(_active_remapping_config) and action.is_remappable:
				effective_mapping = GUIDEActionMapping.new()
				effective_mapping.action = action
				
				# now update the input mappings
				for index in action_mapping.input_mappings.size():
					var bound_input = _active_remapping_config._get_bound_input_or_null(context, action, index)
					if bound_input == null:
						continue # not bound in remapping config, so don't bind it here either 
					# collect the input
					_active_inputs.add(bound_input)
					var new_input_mapping := GUIDEInputMapping.new()
					new_input_mapping.input = bound_input
					# triggers and modifiers cannot be re-bound so we can just use the one
					# from the original configuration
					new_input_mapping.modifiers = action_mapping.input_mappings[index].modifiers
					new_input_mapping.triggers = action_mapping.input_mappings[index].triggers
			else:
				# if the action is not remappable, we can use the original mapping and just
				# collect the inputs
				for input_mapping in action_mapping.input_mappings:
					if input_mapping.input != null:
						_active_inputs.add(input_mapping.input)
				
			# if any binding remains, add the mapping to the list of active
			# action mappings
			if not effective_mapping.input_mappings.is_empty():
				_active_action_mappings.append(effective_mapping)
				
	# TODO, consolidate inputs, so we don't check for the same key in multiple places
	
	# finally collect which inputs we need to reset per frame
	_reset_node._inputs_to_reset.clear()
	for input:GUIDEInput in _active_inputs.values():
		if input._needs_reset():
			_reset_node._inputs_to_reset.append(input)
		# Notify inputs that GUIDE is about to use them
		input._begin_usage()
	
	
