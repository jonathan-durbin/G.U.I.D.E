@tool
extends MarginContainer


@export var modifier_slot_scene:PackedScene
@export var trigger_slot_scene:PackedScene

@onready var _input_display = %InputDisplay
@onready var _modifiers:Container = %Modifiers
@onready var _triggers:Container = %Triggers
@onready var _add_modifier_button:Button = %AddModifierButton
@onready var _add_trigger_button:Button = %AddTriggerButton
@onready var _add_modifier_popup:PopupMenu = %AddModifierPopup
@onready var _add_trigger_popup:PopupMenu = %AddTriggerPopup

var _plugin:EditorPlugin
var _ui:GUIDEUI

var _mapping:GUIDEInputMapping

func _ready():
	_add_modifier_button.icon = get_theme_icon("Add", "EditorIcons")
	_add_trigger_button.icon = get_theme_icon("Add", "EditorIcons")
	
	var modifier_classes = ClassDB.get_inheriters_from_class("GUIDEModifier")
	for type in modifier_classes:
		var dummy = ClassDB.instantiate(type)
		_add_modifier_popup.add_item(dummy._editor_name())
		_add_modifier_popup.set_item_metadata(_add_modifier_popup.item_count - 1, type)
		
	var trigger_classes = ClassDB.get_inheriters_from_class("GUIDETrigger")
	for type in trigger_classes:
		var dummy = ClassDB.instantiate(type)
		_add_trigger_popup.add_item(dummy._editor_name())
		_add_trigger_popup.set_item_metadata(_add_trigger_popup.item_count - 1, type)
		

func initialize(plugin:EditorPlugin, ui:GUIDEUI) -> void:
	_plugin = plugin
	_ui = ui
	_input_display.initialize(ui)
	
	
	
func edit(mapping:GUIDEInputMapping) -> void:
	_mapping = mapping
	_input_display.input = _mapping.input
	for i in _mapping.modifiers.size():
		var modifier_slot = modifier_slot_scene.instantiate()
		_modifiers.add_child(modifier_slot)

		modifier_slot.modifier = _mapping.modifiers[i]
		modifier_slot.index = i
		
	for i in _mapping.triggers.size():
		var trigger_slot = trigger_slot_scene.instantiate()
		_triggers.add_child(trigger_slot)

		trigger_slot.trigger = _mapping.triggers[i]
		trigger_slot.index = i
		
		
func _on_add_modifier_button_pressed():
	_add_modifier_popup.popup()


func _on_add_trigger_button_pressed():
	_add_trigger_popup.popup()
