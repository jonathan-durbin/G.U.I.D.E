@tool
extends RichTextLabel

signal clicked()

var _ui:GUIDEUI

var input:GUIDEInput:
	set(value):
		if value == input:
			return
		
		if is_instance_valid(input):
			input.changed.disconnect(_refresh)
		
		input = value
		
		if is_instance_valid(input):
			input.changed.connect(_refresh)

		_refresh()

func _refresh():
	if not is_instance_valid(input):
		return
		
	var text := await _ui.format_input_with_icons("%s", [input], 48)
	parse_bbcode(text)

 
func initialize(ui:GUIDEUI):
	_ui = ui
	

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			clicked.emit()


	
