@tool
class_name GUIDEInputKey
extends GUIDEInput

## The physical keycode of the key.
@export var key:Key:
	set(value):
		if value == key:
			return
		key = value
		emit_changed()	
		

@export_group("Modifiers")
## Whether shift must be pressed.
@export var shift:bool = false:
	set(value):
		if value == shift:
			return
		shift = value
		emit_changed()	

## Whether control must be pressed.
@export var control:bool = false:
	set(value):
		if value == control:
			return
		control = value
		emit_changed()	
		
## Whether alt must be pressed.
@export var alt:bool = false:
	set(value):
		if value == alt:
			return
		alt = value
		emit_changed()		
	
		
## Whether meta/win/cmd must be pressed.
@export var meta:bool = false:
	set(value):
		if value == meta:
			return
		meta = value
		emit_changed()	


func _input(event:InputEvent):
	if not event is InputEventKey:
		return
	
	if event.physical_keycode != key:
		return
		
	# Modifiers must look EXACTLY as specified
	
	if event.shift_pressed != shift:
		return

	if event.ctrl_pressed != control:
		return

	if event.alt_pressed != alt:
		return

	if event.meta_pressed != meta:
		return
		
	_value.x = 1.0 if event.pressed else 0.0

func _is_same_as(other:GUIDEInput) -> bool:
	return other is GUIDEInputKey \
			and other.key == key \
			and other.shift == shift \
			and other.control == control \
			and other.alt == alt \
			and other.meta == meta

func _to_string():
	return "(GUIDEInputKey: key=" + str(key) + ", shift="  + str(shift) + ", alt=" + str(alt) + ", control=" + str(control) + ", meta="+ str(meta) + ")"


func _editor_name() -> String:
	return "Key"
	
func _editor_description() -> String:
	return "A button press on the keyboard."
	

func _native_value_type() -> GUIDEAction.GUIDEActionValueType:
	return GUIDEAction.GUIDEActionValueType.BOOL
