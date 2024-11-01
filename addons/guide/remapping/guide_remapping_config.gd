## A remapping configuration
class_name GUIDERemappingConfig
extends Resource

## Dictionary with remapped inputs. Structure is:
## { 
##    mapping_context : {
##         action : {
##            index : bound input
##             ...
##         }, ...
## }		
## The bound input can be NULL which means that this was deliberately unbound.	
@export var remapped_inputs:Dictionary = {}


## Binds the given input to the given action. Index can be given to have 
## alternative bindings for the same action.
func _bind(mapping_context:GUIDEMappingContext, action:GUIDEAction, input:GUIDEInput, index:int = 0) -> void:
	if not remapped_inputs.has(mapping_context):
		remapped_inputs[mapping_context] = {}
		
	if not remapped_inputs[mapping_context].has(action):
		remapped_inputs[mapping_context][action] = {}
		
	remapped_inputs[mapping_context][action][index] = input
	
	
## Unbinds the given input from the given action.	
func _unbind(mapping_context:GUIDEMappingContext, action:GUIDEAction, index:int = 0) -> void:
	_bind(mapping_context, action, null, index)
	
	
## Returns the bound input for the given action name and index. Returns null
## if there is matching binding.
func _get_bound_input_or_null(mapping_context:GUIDEMappingContext, action:GUIDEAction, index:int = 0) -> GUIDEInput:
	if not remapped_inputs.has(mapping_context):
		return null
		
	if not remapped_inputs[mapping_context].has(action):
		return null
		
	return remapped_inputs[mapping_context][action].get(index, null)
	
	
## Returns whether or not this mapping has a configuration for the given combination (even if the 
## combination is set to null).
func _has(mapping_context:GUIDEMappingContext, action:GUIDEAction, index:int = 0) -> bool:
	if not remapped_inputs.has(mapping_context):
		return false
		
	if not remapped_inputs[mapping_context].has(action):
		return false
		
	return remapped_inputs[mapping_context][action].has(index)
	

func _get_mappings_using_input(input:GUIDEInput) -> Array[Dictionary]:
	var result:Array[Dictionary] = []
	for context in remapped_inputs.keys():
		for action in context.keys():
			for index in action.keys():
				if action[index] != null and action[index]._is_same_as(GUIDEInput):
					result.append({
						"context" : context,
						"action" : action,
						"index" : index
					})
	return result
