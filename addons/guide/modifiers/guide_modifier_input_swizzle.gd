class_name GUIDEModifierInputSwizzle
extends GUIDEModifier

enum GUIDEInputSwizzleOperation {
	YXZ,
	ZYX,
	XZY,
	YZX,
	ZXY
}

@export var order:GUIDEInputSwizzleOperation = GUIDEInputSwizzleOperation.YXZ


func _modify_input(input:Vector3, delta:float, value_type:GUIDEAction.GUIDEActionValueType) -> Vector3:
	match order:
		GUIDEInputSwizzleOperation.YXZ:
			return Vector3(input.y, input.x, input.z)
		GUIDEInputSwizzleOperation.ZYX:
			return Vector3(input.z, input.y, input.x)
		GUIDEInputSwizzleOperation.XZY:
			return Vector3(input.x, input.z, input.y)
		GUIDEInputSwizzleOperation.YZX:
			return Vector3(input.y, input.z, input.x)
		GUIDEInputSwizzleOperation.ZXY:
			return Vector3(input.z, input.x, input.y)
		_:
			push_error("Unknown order ", order , " this is most likely a bug, please report it.")
			return input
			
			
			
