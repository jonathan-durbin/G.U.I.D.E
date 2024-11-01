class_name GUIDEInputKey
extends GUIDEInput

@export var key:Key

@export_group("Modifiers")
@export var shift:bool = false
@export var control:bool = false
@export var alt:bool = false
@export var meta:bool = false


func _input(event:InputEvent):
	if not event is InputEventKey:
		return
	
	if event.keycode != key:
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
