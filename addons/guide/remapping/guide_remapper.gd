class_name GUIDERemapper

var _remapping_config:GUIDERemappingConfig = GUIDERemappingConfig.new()

const GUIDESet = preload("../guide_set.gd")

## Loads the default bindings as they are currently configured in the mapping contexts and then
## applies the given mapping config on top to produce a new remapping config to work on.
func initialize(mapping_contexts:Array[GUIDEMappingContext], remapping_config:GUIDERemappingConfig = null):
	_remapping_config = remapping_config if remapping_config != null else GUIDERemappingConfig.new()
	
	for mapping_context in mapping_contexts:
		if not is_instance_valid(mapping_context):
			push_error("Cannot add null mapping context. Ignoring.")
			return

		for binding in mapping_context.mappings:
			var action := binding.action
			for i in binding.input_mappings.size():
				# add any new defaults that may exist
				if not _remapping_config._has(mapping_context, action, i):
					_remapping_config._bind(mapping_context, action, binding.input_mappings[i].input)
				
			
			
## Finalizes editing and returns the finished remapping config.
func finalize() -> GUIDERemappingConfig:
	return _remapping_config.duplicate()
	

## Gets a list of all sections for the given mapping context
func get_categories(context:GUIDEMappingContext) -> Array[String]:
	var result:GUIDESet = GUIDESet.new()
	for mapping in context.mappings:
		result.add(mapping.action.display_category)
		
	return result.values()


## Returns a list of all collisions when this new input would be applied
func get_input_collisions(context:GUIDEMappingContext, action:GUIDEAction, input:GUIDEInput, index:int = 0) -> Array[Dictionary]:
	var potential_collisions := _remapping_config._get_mappings_using_input(input)
	var result:Array[Dictionary] = [] 
	for collision in potential_collisions:
		if collision.context == context and collision.action == action and collision.index == index:
			continue  # collisions with self are allowed
		result.append(collision)
			
	return result

## Gets the list of rebindable actions for the given sect
func get_remappable_actions(context:GUIDEMappingContext, category:String) -> Array[GUIDEAction]:
	var result:GUIDESet = GUIDESet.new()
	for mapping in context.mappings:
		var action := mapping.action
		if action.is_remappable and action.display_category == category:
			result.add(action)

	return result.values()


## Gets the input currently bound to the action in the given context.
func get_bound_input_or_null(context:GUIDEMappingContext, action:GUIDEAction, index:int = 0) -> GUIDEInput:
	if not _check_action(context, action):
		return null

	return _remapping_config._get_bound_input_or_null(context, action, index)
	
## Sets the bound input to the new value. Removes all colliding bindings automatically.	Returns a list 
## with all changed items, which can be used to update the UI.
func set_bound_input(context:GUIDEMappingContext, action:GUIDEAction, input:GUIDEInput, index:int = 0) -> Array[Dictionary]:
	if not _check_action(context, action):
		return []
		
	# remove all colliding input
	var collisions := _remapping_config._get_mappings_using_input(input)
	var has_target:bool = false
	for collision in collisions:
		if collision.context == context and collision.action == action and collision.index == index:
			has_target = true
		_remapping_config._unbind(collision.context, collision.action, collision.index)

	_remapping_config._bind(context, action, input , index)
	
	if not has_target:
		collisions.append({
			"context" : context,
			"action" : action,
			"index" : index
		})
	
	return collisions
	

## Clears the bound input. Returns a list with all changed items, which can be used to
## update the UI. This should only ever contain one item but it's a list to keep consistency
## with the set_bound_input API.	
func clear_bound_input(context:GUIDEMappingContext, action:GUIDEAction, index:int = 0) -> Array[Dictionary]:
	if not _check_action(context, action):
		return []

	_remapping_config._unbind(context, action, index)
	
	return [{
			"context" : context,
			"action" : action,
			"index" : index
		}]
	
	
## Verifies that the action is remappable and belongs to the given context.	
func _check_action(context:GUIDEMappingContext, action:GUIDEAction) -> bool:
	if not action.is_remappable:
		push_error("Action is not remappable.")
		return false
	
	var found := false
	for mapping in context.mappings:
		if mapping.action == action:
			found = true
			break
			
	if not found:
		push_error("Action does not belong to context.")
		return false
		
	return true


	
	
		
