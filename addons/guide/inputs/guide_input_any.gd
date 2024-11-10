## Input that triggers if any input from the given device class
## is given.
@tool
class_name GUIDEInputAny
extends GUIDEInput

## Should input from the mouse be considered?
@export var mouse:bool = false

## Should input from gamepads/joysticks be considered?
@export var joy:bool = false

## Should input from the keyboard be considered?
@export var keyboard:bool = false

func _input(event:InputEvent):
	if mouse and event is InputEventMouse:
		print("Any - MOUSE")	
		_value = Vector3.RIGHT
		return
			
	if joy and (event is InputEventJoypadButton or event is InputEventJoypadMotion):
		print("Any - JOY")	
		_value = Vector3.RIGHT
		return 
			
	if keyboard and (event is InputEventKey):
		print("Any - KEY")	
		_value = Vector3.RIGHT
		return
			
	_value = Vector3.ZERO		


func _editor_name() -> String:
	return "Any Input"
	
	
func _editor_description() -> String:
	return "Input that triggers if any input from the given device class is given."
	
	
func _native_value_type() -> GUIDEAction.GUIDEActionValueType:
	return GUIDEAction.GUIDEActionValueType.BOOL
