extends Node

@export var joystick_scheme:GUIDEMappingContext
@export var keyboard_scheme:GUIDEMappingContext

@export var move_action:GUIDEAction
@export var shoot_action:GUIDEAction
@export var switch_input_scheme_action:GUIDEAction

@onready var _instructions_label:RichTextLabel = %InstructionsLabel

var _current_input_scheme:GUIDEMappingContext

func _ready():
	# When we get a command to switch the input scheme, we
	# switch.
	switch_input_scheme_action.triggered.connect(_switch_input_scheme)
	
	# And switch now to enable keyboard
	_switch_input_scheme()


func _switch_input_scheme():
	# If a scheme was enabled, disable it.
	if _current_input_scheme != null:
		GUIDE.disable_mapping_context(_current_input_scheme)

	# Now enable the other one
	match _current_input_scheme:
		keyboard_scheme:
			GUIDE.enable_mapping_context(joystick_scheme)
			_current_input_scheme = joystick_scheme
		_: # this applies both to the current scheme being unset 
		   # or being the joystick scheme
			GUIDE.enable_mapping_context(keyboard_scheme)
			_current_input_scheme = keyboard_scheme
	
	_refresh_instructions()				
			
	
func _refresh_instructions():
	var move_input = await GUIDE.UI.format_action_with_icons("%s", move_action)
	var shoot_input = await GUIDE.UI.format_action_with_icons("%s", shoot_action)
	var instruction_text = "Use %s to move, %s to shoot." % [move_input, shoot_input]
	_instructions_label.parse_bbcode(instruction_text)
