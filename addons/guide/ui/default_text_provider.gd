extends GUIDETextProvider

func _init():
	priority = 0
	
func supports(input:GUIDEInput) -> bool:
	return true
	

func _format(input:String) -> String:
	return "[%s]" % [input]

	
func get_text(input:GUIDEInput) -> String:
	if input is GUIDEInputKey:
		var result:PackedStringArray = []
		if input.control:
			var ctrl = GUIDEInputKey.new()
			ctrl.key = KEY_CTRL
			result.append(get_text(ctrl))
		if input.alt:
			var alt = GUIDEInputKey.new()
			alt.key = KEY_ALT
			result.append(get_text(alt))
		if input.shift:
			var shift = GUIDEInputKey.new()
			shift.key = KEY_SHIFT
			result.append(get_text(shift))
		if input.meta:
			var meta = GUIDEInputKey.new()
			meta.key = KEY_META
			result.append(get_text(meta))
		result.append(_format(OS.get_keycode_string(DisplayServer.keyboard_get_label_from_physical(input.key))))
		return "+".join(result) 
	
	if input is GUIDEInputMouseAxis1D:
		match input.axis:
			GUIDEInputMouseAxis1D.GUIDEInputMouseAxis.X:
				return _format(tr("Mouse Left/Right"))
			GUIDEInputMouseAxis1D.GUIDEInputMouseAxis.Y:
				return _format(tr("Mouse Up/Down"))

	if input is GUIDEInputMouseAxis2D:
		return _format(tr("Mouse"))
		
	if input is GUIDEInputMouseButton:
		match input.button:
			MOUSE_BUTTON_LEFT:
				return _format(tr("Left Mouse Button"))
			MOUSE_BUTTON_RIGHT:
				return _format(tr("Right Mouse Button"))
			MOUSE_BUTTON_MIDDLE:
				return _format(tr("Middle Mouse Button"))
			MOUSE_BUTTON_WHEEL_UP:
				return _format(tr("Mouse Wheel Up"))
			MOUSE_BUTTON_WHEEL_DOWN:
				return _format(tr("Mouse Wheel Down"))
			MOUSE_BUTTON_WHEEL_LEFT:
				return _format(tr("Mouse Wheel Left"))
			MOUSE_BUTTON_WHEEL_RIGHT:
				return _format(tr("Mouse Wheel Right"))
			MOUSE_BUTTON_XBUTTON1:
				return _format(tr("Mouse Side 1"))
			MOUSE_BUTTON_XBUTTON2:
				return _format(tr("Mouse Side 2"))

	if input is GUIDEInputJoyAxis1D:
		match input.axis:
			JOY_AXIS_LEFT_X:
				return _format(tr("Left Stick Horizontal"))
			JOY_AXIS_LEFT_Y:
				return _format(tr("Left Stick Vertical"))
			JOY_AXIS_RIGHT_X:
				return _format(tr("Right Stick Horizontal"))
			JOY_AXIS_RIGHT_Y:
				return _format(tr("Right Stick Vertical"))
			JOY_AXIS_TRIGGER_LEFT:
				return _format(tr("Left Trigger"))
			JOY_AXIS_TRIGGER_RIGHT:
				return _format(tr("Right Trigger"))
	
	if input is GUIDEInputJoyAxis2D:
		match input.x:
			JOY_AXIS_LEFT_X, JOY_AXIS_LEFT_Y:
				return _format(tr("Left Stick"))
			JOY_AXIS_RIGHT_X, JOY_AXIS_RIGHT_Y:
				return _format(tr("Right Stick"))
				
	if input is GUIDEInputJoyButton:
		return _format(tr("Joy %s") % [input.button])
		
		
	if input is GUIDEInputAction:
		return _format(tr("Action %s") % ["?" if input.action == null else input.action._editor_name()])

	return _format("??")
