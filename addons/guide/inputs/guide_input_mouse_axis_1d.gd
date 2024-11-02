class_name GUIDEInputMouseAxis1D
extends GUIDEInput

enum GUIDEInputMouseAxis {
	X,
	Y
}

@export var axis:GUIDEInputMouseAxis

# we don't get mouse updates when the mouse is not moving, so this needs to be 
# reset every frame
func _needs_reset() -> bool:
	return true

func _input(event:InputEvent) -> void:
	if not event is InputEventMouseMotion:
		return

	match axis:
		GUIDEInputMouseAxis.X:
			_value.x = event.relative.x
		GUIDEInputMouseAxis.Y:
			_value.x = event.relative.y
		
func _is_same_as(other:GUIDEInput):
	return other is GUIDEInputMouseAxis1D and other.axis == axis

func _to_string():
	return "(GUIDEInputMouseAxis1D: axis=" + str(axis) + ")"
