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
		parse_bbcode("[center][i]<not bound>[/i][/center]")
		tooltip_text = ""
		return
		
	var text := await _ui.format_input_with_icons("%s", [input], 64)
	parse_bbcode("[center]" + text + "[/center]")
	tooltip_text = input.resource_path

 
func initialize(ui:GUIDEUI):
	_ui = ui
	

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			clicked.emit()


	
