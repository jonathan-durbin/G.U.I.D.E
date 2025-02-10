class_name GUIDETestBase
extends GutTest

#------------------- Lifecycle ---------------------------------------------
var start_frame:int = 0

func after_each():
	# Clear all mapping contexts after each test
	for context in GUIDE._active_contexts:
		GUIDE.disable_mapping_context(context)

func before_each():
	var tst = gut._current_test
	print("BEGIN: %s ----------------- " % gut._current_test.name )
	start_frame = Engine.get_process_frames()
	_setup()	
	
func _setup():
	pass

#------------------- Setup -------------------------------------------------

func mapping_context() -> GUIDEMappingContext:
	return GUIDEMappingContext.new()


func action(name:String, value_type:GUIDEAction.GUIDEActionValueType) -> GUIDEAction:
	var result := GUIDEAction.new()
	result.name = name
	result.action_value_type = value_type
	return result


func action_bool(name:String = "action") -> GUIDEAction:
	return action(name, GUIDEAction.GUIDEActionValueType.BOOL)


func action_1d(name:String = "action") -> GUIDEAction:
	return action(name, GUIDEAction.GUIDEActionValueType.AXIS_1D)


func action_2d(name:String = "action") -> GUIDEAction:
	return action(name, GUIDEAction.GUIDEActionValueType.AXIS_2D)


func action_3d(name:String = "action") -> GUIDEAction:
	return action(name, GUIDEAction.GUIDEActionValueType.AXIS_3D)

func input_action(action:GUIDEAction) -> GUIDEInputAction:
	var result := GUIDEInputAction.new()
	result.action = action
	return result
	
	
func input_key(key:Key) -> GUIDEInputKey:
	var result := GUIDEInputKey.new()
	result.key = key
	return result

	
func input_mouse_axis2d() -> GUIDEInputMouseAxis2D:
	return GUIDEInputMouseAxis2D.new()

	
func modifier_virtual_cursor(initial_position:Vector2 = Vector2(0.5, 0.5), \
		speed:Vector3=Vector3.ONE, \
		screen_scale:GUIDEModifierVirtualCursor.ScreenScale = GUIDEModifierVirtualCursor.ScreenScale.LONGER_AXIS, \
		apply_delta_time:bool = true
		) -> GUIDEModifierVirtualCursor:
	var result := GUIDEModifierVirtualCursor.new()
	result.initial_position = initial_position
	result.speed = speed
	result.screen_scale = screen_scale
	result.apply_delta_time = apply_delta_time
	return result
	
	
func modifier_input_swizzle(operation:GUIDEModifierInputSwizzle.GUIDEInputSwizzleOperation = \
		GUIDEModifierInputSwizzle.GUIDEInputSwizzleOperation.YXZ) -> GUIDEModifierInputSwizzle:
	var result := GUIDEModifierInputSwizzle.new()
	result.order = operation
	return result
	
	
func modifier_negate(x:bool = true, y:bool = true, z:bool = true) -> GUIDEModifierNegate:
	var result := GUIDEModifierNegate.new()
	result.x = x
	result.y = y
	result.z = z
	return result

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

func key_down(key:Key, wait:bool = true) -> void:
	var input = InputEventKey.new()
	input.physical_keycode = key
	input.pressed = true
	Input.parse_input_event(input)
	print_f("Key down %s" % OS.get_keycode_string(DisplayServer.keyboard_get_label_from_physical(key)))
	if wait:
		await wait_f(2)
	
func key_up(key:Key, wait:bool = true) -> void:
	var input = InputEventKey.new()
	input.physical_keycode = key
	input.pressed = false
	Input.parse_input_event(input)
	print_f("Key up %s" % OS.get_keycode_string(DisplayServer.keyboard_get_label_from_physical(key)))
	if wait:
		await wait_f(2)

func keys_down(keys:Array[Key], wait:bool = true) -> void:
	for key in keys:
		key_down(key, false)
		
	if wait:
		await wait_f(2)

func keys_up(keys:Array[Key], wait:bool = true) -> void:
	for key in keys:
		key_up(key, false)
		
	if wait:
		await wait_f(2)
	
	
func tap_key(key:Key) -> void:
	await key_down(key)
	await key_up(key)
	
	
func tap_keys(keys:Array[Key]) -> void:
	await keys_down(keys)
	await keys_up(keys)

#------------------ Custom asserts -------------------------------------------

func assert_triggered(action:GUIDEAction):
	assert_true(action.is_triggered(), "Action should be triggered but is not.")
	
func assert_not_triggered(action:GUIDEAction):
	assert_false(action.is_triggered(), "Action should not be triggered but is.")


#------------------ Other stuff -------------------------------------------
func log_signals(action:GUIDEAction):
	action.triggered.connect(print_f.bind("action triggered: '%s'" % action.name))
	action.cancelled.connect(print_f.bind("action cancelled: '%s'" % action.name))
	action.completed.connect(print_f.bind("action completed: '%s'" % action.name))
	action.started.connect(print_f.bind("action started: '%s'" % action.name))
	action.ongoing.connect(print_f.bind("action ongoing: '%s'" % action.name))

func wait_f(frames:int):
	var start = get_f()
	while start + frames > get_f():
		var tree = get_tree()
		if tree == null:
			fail_test("Got no tree. Did you forget to add an await somewhere?")
			return
		await get_tree().process_frame


func print_f(text:Variant = ""):
	print("[%s] %s" % [get_f(), text])

func get_f() -> int:
	return Engine.get_process_frames() - start_frame
