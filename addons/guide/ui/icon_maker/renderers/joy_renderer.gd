@tool
extends GUIDEIconRenderer

@onready var _joy_axis:Control = %JoyAxis
@onready var _joy_axis_text:Label = %JoyAxisText
@onready var _joy_stick:Control = %JoyStick
@onready var _joy_2d:Control = %Joy2D
@onready var _joy_left_right:Control = %JoyLeftRight
@onready var _joy_up_down:Control = %JoyUpDown
@onready var _joy_button:Control = %JoyButton
@onready var _joy_button_text:Label = %JoyButtonText


func supports(input:GUIDEInput) -> bool:
	return input is GUIDEInputJoyAxis1D or input is GUIDEInputJoyAxis2D or input is GUIDEInputJoyButton
	
	
func render(input:GUIDEInput) -> void:
	_joy_axis.visible = false
	_joy_button.visible = false
	_joy_stick.visible = false
	_joy_left_right.visible = false
	_joy_up_down.visible = false
	_joy_2d.visible = false
		
	if input is GUIDEInputJoyAxis1D:
		_joy_axis.visible = true
		match input.axis:
			JOY_AXIS_LEFT_X:
				_joy_left_right.visible = true
				_joy_axis_text.text = "L"
			JOY_AXIS_LEFT_Y:
				_joy_up_down.visible = true
				_joy_axis_text.text = "L"
			JOY_AXIS_RIGHT_X:
				_joy_left_right.visible = true
				_joy_axis_text.text = "R"
			JOY_AXIS_RIGHT_Y:
				_joy_up_down.visible = true
				_joy_axis_text.text = "R"
			JOY_AXIS_TRIGGER_LEFT:
				_joy_up_down.visible = true
				_joy_axis_text.text = "LT"
			JOY_AXIS_TRIGGER_RIGHT:
				_joy_up_down.visible = true
				_joy_axis_text.text = "RT"
			_:
				_joy_stick.visible = true
				_joy_axis_text.text = str(input.axis)
				
	
	if input is GUIDEInputJoyAxis2D:
		_joy_axis.visible = true
		_joy_2d.visible = true
		match input.x:
			JOY_AXIS_LEFT_X, JOY_AXIS_LEFT_Y:
				_joy_axis_text.text  = "L"	
			JOY_AXIS_RIGHT_X, JOY_AXIS_RIGHT_Y:
				_joy_axis_text.text = "R"
			_:
				_joy_axis_text.text = str(input.x)
		
	if input is GUIDEInputJoyButton:
		_joy_button.visible = true
		# TODO: This should probably be more sophisticated but for now
		# let's stick with 80/20
		_joy_button_text.text = str(input.button)
			
	call("queue_sort")
 
func cache_key(input:GUIDEInput) -> String:
	return "7581f483-bc68-411f-98ad-dc246fd2593a" + input.to_string()
