@tool
class_name GUIDEModifierNegate
extends GUIDEModifier

@export var x:bool = true:
	set(value):
		x = value
		_update_caches()
		
@export var y:bool = true:
	set(value):
		y = value
		_update_caches()

@export var z:bool = true:
	set(value):
		z = value
		_update_caches()

var _multiplier:Vector3 = Vector3.ONE * -1

func _update_caches():
	_multiplier.x = -1 if x else 1
	_multiplier.y = -1 if y else 1
	_multiplier.z = -1 if z else 1
		

func _modify_input(input:Vector3, delta:float, value_type:GUIDEAction.GUIDEActionValueType) -> Vector3:
	return input * _multiplier

func _editor_name() -> String:
	return "Negate"	
