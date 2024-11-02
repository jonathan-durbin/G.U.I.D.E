@tool
extends LineEdit

signal action_changed()

var index:int

var action:GUIDEAction:
	set(value):
		action = value
		if action == null:
			text = "<none>"
		else:
			text = action.resource_path.get_file()
	
	
func _can_drop_data(at_position, data) -> bool:
	if not data is Dictionary:
		return false
		
	if data.has("files"):
		for file in data["files"]:
			if ResourceLoader.load(file) is GUIDEAction:
				return true
		
	return false	
	
	
func _drop_data(at_position, data) -> void:
	
	for file in data["files"]:
		var item = ResourceLoader.load(file) 
		if item is GUIDEAction:
			action = item
			action_changed.emit()

