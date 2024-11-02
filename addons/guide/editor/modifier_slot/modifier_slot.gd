@tool
extends Control
signal modifier_changed()
signal delete_requested()

@onready var _delete_button:Button = %DeleteButton
@onready var _line_edit:LineEdit = %LineEdit

func _ready():
	_delete_button.icon = get_theme_icon("Remove", "EditorIcons")

var index:int
var modifier:GUIDEModifier:
	set(value):
		modifier = value
		if modifier == null:
			_line_edit.text = "<none>"
		else:
			_line_edit.text = modifier._editor_name()

	
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


func _on_delete_button_pressed():
	delete_requested.emit()
