## Helper class for modelling sets
var _values:Dictionary = {}

func add(value:Variant) -> void:
	_values[value] = value
	
	
func remove(value:Variant) -> void:
	_values.erase(value)
	

func clear() -> void:
	_values.clear()
	
	
func has(value:Variant) -> bool:
	return _values.has(value)

func values() -> Array:
	return _values.keys()
