@tool
extends GUIDEIconRenderer

@onready var _mouse_2d:Control = %Mouse2D
@onready var _mouse_left:Control = %MouseLeft
@onready var _mouse_right:Control = %MouseRight
@onready var _mouse_middle:Control = %MouseMiddle
@onready var _mouse_wheel_up:Control = %MouseWheelUp
@onready var _mouse_wheel_down:Control = %MouseWheelDown
@onready var _mouse_wheel_left:Control = %MouseWheelLeft
@onready var _mouse_wheel_right:Control = %MouseWheelRight
@onready var _mouse_side_a:Control = %MouseSideA
@onready var _mouse_side_b:Control = %MouseSideB
@onready var _mouse_left_right:Control = %MouseLeftRight
@onready var _mouse_up_down:Control = %MouseUpDown


func supports(input:GUIDEInput) -> bool:
	return input is GUIDEInputMouseButton or input is GUIDEInputMouseAxis1D or input is GUIDEInputMouseAxis2D
	
	
func render(input:GUIDEInput) -> void:
	for child in get_children():
		child.visible = false
		
	if input is GUIDEInputMouseAxis2D:
		_mouse_2d.visible = true
		
	if input is GUIDEInputMouseButton:
		match input.button:
			MOUSE_BUTTON_LEFT:
				_mouse_left.visible = true
			MOUSE_BUTTON_RIGHT:
				_mouse_right.visible = true
			MOUSE_BUTTON_MIDDLE:
				_mouse_middle.visible = true
			MOUSE_BUTTON_WHEEL_UP:
				_mouse_wheel_up.visible = true
			MOUSE_BUTTON_WHEEL_DOWN:
				_mouse_wheel_down.visible = true
			MOUSE_BUTTON_WHEEL_LEFT:
				_mouse_wheel_left.visible = true
			MOUSE_BUTTON_WHEEL_RIGHT:
				_mouse_wheel_right.visible = true
			MOUSE_BUTTON_XBUTTON1:
				_mouse_side_a.visible = true
			MOUSE_BUTTON_XBUTTON2:
				_mouse_side_b.visible = true
				
	if input is GUIDEInputMouseAxis1D:
		if input.axis == GUIDEInputMouseAxis1D.GUIDEInputMouseAxis.X:
			_mouse_left_right.visible = true			
		else:
			_mouse_up_down.visible = true			
		
	
	call("queue_sort")
 
func cache_key(input:GUIDEInput) -> String:
	return "7e27520a-b6d8-4451-858d-e94330c82e85" + input.to_string()
