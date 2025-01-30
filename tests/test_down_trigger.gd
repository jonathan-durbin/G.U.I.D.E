extends GUIDETestBase

var _context:GUIDEMappingContext
var _action:GUIDEAction
var _trigger:GUIDETrigger

func before_each():
	_context = mapping_context()
	_action = action()
	_trigger = trigger_down()

func test_down_trigger_works_for_key_input():
	var input = input_key(KEY_Q)
	map(_context, _action, input, [], [_trigger])
	GUIDE.enable_mapping_context(_context)
	
	# WHEN: i press the key
	await send_key_down(KEY_Q)
	
	# THEN: the action is triggered
	assert_triggered(_action)
	
	# WHEN: i release the key
	await send_key_up(KEY_Q)
	
	# THEN: the action is not triggered anymore
	assert_not_triggered(_action)



