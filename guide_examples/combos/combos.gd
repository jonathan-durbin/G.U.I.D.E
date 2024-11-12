extends Node2D

@export var mapping_context:GUIDEMappingContext
@export var move_left:GUIDEAction
@export var move_right:GUIDEAction
@export var fire:GUIDEAction


@onready var instructions_label = %InstructionsLabel

func _ready():
	GUIDE.enable_mapping_context(mapping_context)
	
	var _left_key = await _key_for_action(move_left)
	var _right_key = await _key_for_action(move_right)
	var _fire_key = await _key_for_action(fire)
	
	var text = "Press %s to move left.\n" % [_left_key]
	text+= "Press %s to move right.\n" % [_right_key] 
	text+= "Double-tap %s to dash left.\n" % [_left_key]
	text+= "Double-tap %s to dash right.\n" % [_right_key]
	text+= "Press %s > %s > %s to shoot a fireball to the left.\n"  % [_right_key, _left_key, _fire_key] 
	text+= "Press %s > %s > %s to shoot a fireball to the right.\n"  % [_left_key, _right_key, _fire_key] 
	
	instructions_label.parse_bbcode(text)


func _key_for_action(action:GUIDEAction):
	return await GUIDE.UI.format_action_as_icons("%s", action)
