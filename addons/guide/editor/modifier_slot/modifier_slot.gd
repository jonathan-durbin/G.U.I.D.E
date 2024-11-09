@tool
extends Control
signal modifier_changed()

@onready var _line_edit:LineEdit = %LineEdit

var modifier:GUIDEModifier:
	set(value):
		modifier = value
		
		if modifier == null:
			_line_edit.text = "<none>"
			_line_edit.tooltip_text = ""
		else:
			_line_edit.text = modifier._editor_name()
			_line_edit.tooltip_text = modifier.resource_path

	
func _can_drop_data(at_position, data) -> bool:
	if not data is Dictionary:
		return false
		
	if data.has("files"):
		for file in data["files"]:
			if ResourceLoader.load(file) is GUIDEModifier:
				return true
		
	return false	
	
	
func _drop_data(at_position, data) -> void:
	
	for file in data["files"]:
		var item = ResourceLoader.load(file) 
		if item is GUIDEModifier:
			modifier = item
			modifier_changed.emit()


func _on_line_edit_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if is_instance_valid(modifier):
				EditorInterface.edit_resource(modifier)
