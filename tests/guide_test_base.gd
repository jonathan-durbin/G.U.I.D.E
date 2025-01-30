class_name GUIDETestBase
extends GutTest

#------------------- Lifecycle ---------------------------------------------

func after_each():
	# Clear all mapping contexts after each test
	for context in GUIDE._active_contexts:
		GUIDE.disable_mapping_context(context)

#------------------- Setup -------------------------------------------------

func action(name:String = "action") -> GUIDEAction:
	var result = GUIDEAction.new()
	result.name = name
	return result
	
func input_key(key:Key) -> GUIDEInputKey:
	var result = GUIDEInputKey.new()
	result.key = key
	return result
	
func input_mouse_axis2d() -> GUIDEInputMouseAxis2D:
	return GUIDEInputMouseAxis2D.new()
	
func mapping_context() -> GUIDEMappingContext:
	return GUIDEMappingContext.new()

	
func trigger_down() -> GUIDETriggerDown:
	return GUIDETriggerDown.new()
	
	
func map(context:GUIDEMappingContext, action:GUIDEAction, input:GUIDEInput, \
	modifiers:Array[GUIDEModifier] = [], triggers:Array[GUIDETrigger] = []):
	var action_mapping:GUIDEActionMapping = null
	
	for mapping in context.mappings:
		if mapping.action == action:
			action_mapping = mapping
			break
			
	if action_mapping == null:
		action_mapping = GUIDEActionMapping.new()
		action_mapping.action = action
		context.mappings.append(action_mapping)	
	
	var input_mapping = GUIDEInputMapping.new()
	input_mapping.input = input
	input_mapping.modifiers = modifiers
	input_mapping.triggers = triggers
	
	action_mapping.input_mappings.append(input_mapping)
	
#------------------ Input simulation ----------------------------------------

func send_key_down(key:Key) -> void:
	var input = InputEventKey.new()
	input.physical_keycode = key
	input.pressed = true
	Input.parse_input_event(input)
	await wait_f(1)
	
func send_key_up(key:Key) -> void:
	var input = InputEventKey.new()
	input.physical_keycode = key
	input.pressed = false
	Input.parse_input_event(input)
	await wait_f(1)
	

#------------------ Custom asserts -------------------------------------------

func assert_triggered(action:GUIDEAction):
	assert_true(action.is_triggered(), "Action should be triggered but is not.")
	
func assert_not_triggered(action:GUIDEAction):
	assert_false(action.is_triggered(), "Action should not be triggered but is.")


#------------------ Other stuff -------------------------------------------
func wait_f(frames:int):
	# +2 is because we will get one process_frame for the end of
	# the current frame and we want to wait to the frame after
	# the amount of frames specified.
	for i in frames + 2:
		await get_tree().process_frame
