extends GUIDETestBase

var _context1: GUIDEMappingContext
var _context2: GUIDEMappingContext
var _action: GUIDEAction


func _setup():
	_context1 = mapping_context()
	_context2 = mapping_context()
	_action = action_bool("some_action")


func test_action_with_pressed_trigger_does_not_trigger_again_on_context_switch():
	var input := input_key(KEY_A)
	var trigger := trigger_pressed()
	map(_context1, _action, input, [], [trigger] )
	map(_context2, _action, input, [], [trigger] )
	
	GUIDE.enable_mapping_context(_context1)
	# when i press the key
	key_down(KEY_A, true)
	
	# then the action is triggered
	await assert_triggered(_action)
	
	await wait_f(10)
	
	# since we have a pressed trigger, the action should not trigger again
	await assert_not_triggered(_action)
	
	# when i switch to the second context
	GUIDE.enable_mapping_context(_context2)
	
	# then this should not trigger the action again, as the key is still down
	await assert_not_triggered(_action)


func test_action_with_down_trigger_triggers_again_on_context_switch():
	var input := input_key(KEY_A)
	var trigger := trigger_down()
	map(_context1, _action, input, [], [trigger] )
	map(_context2, _action, input, [], [trigger] )
	
	GUIDE.enable_mapping_context(_context1)
	# when i press the key
	key_down(KEY_A, true)
	
	# then the action is triggered
	await assert_triggered(_action)
	
	await wait_f(10)
	
	# since we have a down trigger, the action should trigger again
	await assert_triggered(_action)
	
	# when i switch to the second context
	GUIDE.enable_mapping_context(_context2)
	
	# then this should trigger the action again
	await assert_triggered(_action)
	
	await wait_f(10)
	
	# and should still do so
	await assert_triggered(_action)
