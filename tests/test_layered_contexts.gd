extends GUIDETestBase

var _context1:GUIDEMappingContext
var _context2:GUIDEMappingContext
var _action1:GUIDEAction
var _action2:GUIDEAction

func _setup():
	_context1 = mapping_context()
	_context2 = mapping_context()
	_action1 = action_bool()
	_action2 = action_bool()
	
	map(_context1, _action1, input_key(KEY_A))
	map(_context2, _action2, input_key(KEY_B))
	

## https://github.com/godotneers/G.U.I.D.E/issues/89
## When layering contexts we should not get duplicate action mappings.
func test_mapping_works():
	GUIDE.enable_mapping_context(_context1)

	assert_int(GUIDE._active_action_mappings.size()).is_equal(1)
	
	# when i add the second context
	GUIDE.enable_mapping_context(_context2)
	
	assert_int(GUIDE._active_action_mappings.size()).is_equal(2)

