@tool
extends Window

const ClassScanner = preload("../class_scanner.gd")

@onready var _input_display = %InputDisplay

var _scanner:ClassScanner
var _ui:GUIDEUI 

	
func initialize(ui:GUIDEUI, scanner:ClassScanner):
	_ui = ui
	_scanner = scanner
	_input_display.initialize(_ui)
	
	

func _on_close_requested():
	hide()
	queue_free()
