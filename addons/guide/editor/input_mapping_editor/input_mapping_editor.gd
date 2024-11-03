@tool
extends MarginContainer

signal delete_requested()

const ClassScanner = preload("../class_scanner.gd")

@export var modifier_slot_scene:PackedScene
@export var trigger_slot_scene:PackedScene
@export var binding_dialog_scene:PackedScene

@onready var _input_display = %InputDisplay
@onready var _modifiers:Container = %Modifiers
@onready var _triggers:Container = %Triggers
@onready var _add_modifier_button:Button = %AddModifierButton
@onready var _add_trigger_button:Button = %AddTriggerButton
@onready var _add_modifier_popup:PopupMenu = %AddModifierPopup
@onready var _add_trigger_popup:PopupMenu = %AddTriggerPopup
@onready var _delete_button:Button = %DeleteButton
@onready var _edit_input_button:Button = %EditInputButton

var _plugin:EditorPlugin
var _ui:GUIDEUI
var _scanner:ClassScanner
var _undo_redo:EditorUndoRedoManager

var _mapping:GUIDEInputMapping

func _ready():
	_add_modifier_button.icon = get_theme_icon("Add", "EditorIcons")
	_add_trigger_button.icon = get_theme_icon("Add", "EditorIcons")
	_delete_button.icon = get_theme_icon("Remove", "EditorIcons")
	_edit_input_button.icon = get_theme_icon("Edit", "EditorIcons")
	
	
func initialize(plugin:EditorPlugin, ui:GUIDEUI, scanner:ClassScanner) -> void:
	_plugin = plugin
	_ui = ui
	_scanner = scanner
	_undo_redo = plugin.get_undo_redo()
	_input_display.initialize(ui)
	_input_display.clicked.connect(_on_input_display_clicked)
	
	
	
func edit(mapping:GUIDEInputMapping) -> void:
	assert(_mapping == null)
	_mapping = mapping
	_mapping.changed.connect(_update)
	_update()
	
func _update():
	for child in _modifiers.get_children():
		_modifiers.remove_child(child)
		child.queue_free()
		
	for child in _triggers.get_children():
		_triggers.remove_child(child)
		child.queue_free()
		
	
	_input_display.input = _mapping.input
	for i in _mapping.modifiers.size():
		var modifier_slot = modifier_slot_scene.instantiate()
		_modifiers.add_child(modifier_slot)

		modifier_slot.modifier = _mapping.modifiers[i]
		modifier_slot.index = i
		modifier_slot.modifier_changed.connect(_on_modifier_changed.bind(modifier_slot))
		modifier_slot.delete_requested.connect(_on_modifier_delete_requested.bind(modifier_slot))
		
	for i in _mapping.triggers.size():
		var trigger_slot = trigger_slot_scene.instantiate()
		_triggers.add_child(trigger_slot)

		trigger_slot.trigger = _mapping.triggers[i]
		trigger_slot.index = i
		trigger_slot.trigger_changed.connect(_on_trigger_changed.bind(trigger_slot))
		trigger_slot.delete_requested.connect(_on_trigger_delete_requested.bind(trigger_slot))
		
		
func _on_add_modifier_button_pressed():
	_fill_popup(_add_modifier_popup, "GUIDEModifier")
	_add_modifier_popup.popup(Rect2(get_global_mouse_position(), Vector2.ZERO))


func _on_add_trigger_button_pressed():
	_fill_popup(_add_trigger_popup, "GUIDETrigger")
	_add_trigger_popup.popup(Rect2(get_global_mouse_position(), Vector2.ZERO))
	
	
func _fill_popup(popup:PopupMenu, base_clazz:StringName):
	popup.clear(true)
	
	var inheritors := _scanner.find_inheritors(base_clazz)
	for type in inheritors.keys():
		var class_script:Script = inheritors[type]
		var dummy = class_script.new()
		popup.add_item(dummy._editor_name())
		popup.set_item_tooltip(popup.item_count -1, dummy._editor_description())
		popup.set_item_metadata(popup.item_count - 1, class_script)



func _on_add_modifier_popup_index_pressed(index:int) -> void:
	var script = _add_modifier_popup.get_item_metadata(index)
	var new_modifier = script.new()
	
	_undo_redo.create_action("Add " + new_modifier._editor_name() + " modifier")
	var modifiers = _mapping.modifiers.duplicate()
	modifiers.append(new_modifier)
	
	_undo_redo.add_do_property(_mapping, "modifiers", modifiers)
	_undo_redo.add_undo_property(_mapping, "modifiers", _mapping.modifiers)
	
	_undo_redo.commit_action()


func _on_add_trigger_popup_index_pressed(index):
	var script = _add_trigger_popup.get_item_metadata(index)
	var new_trigger = script.new()
	
	_undo_redo.create_action("Add " + new_trigger._editor_name() + " trigger")
	var triggers = _mapping.triggers.duplicate()
	triggers.append(new_trigger)
	
	_undo_redo.add_do_property(_mapping, "triggers", triggers)
	_undo_redo.add_undo_property(_mapping, "triggers", _mapping.triggers)
	
	_undo_redo.commit_action()


func _on_modifier_changed(slot) -> void:
	var index = slot.index
	var new_modifier = slot.modifier
	
	_undo_redo.create_action("Replace modifier")
	var modifiers = _mapping.modifiers.duplicate()
	modifiers[index] = new_modifier
	
	_undo_redo.add_do_property(_mapping, "modifiers", modifiers)
	_undo_redo.add_undo_property(_mapping, "modifiers", _mapping.modifiers)
	
	_undo_redo.commit_action()
	
	
func _on_trigger_changed(slot) -> void:
	var index = slot.index
	var new_trigger = slot.trigger
	
	_undo_redo.create_action("Replace trigger")
	var triggers = _mapping.triggers.duplicate()
	triggers[index] = new_trigger
	
	_undo_redo.add_do_property(_mapping, "triggers", triggers)
	_undo_redo.add_undo_property(_mapping, "triggers", _mapping.triggers)
	
	_undo_redo.commit_action()
	
	
func _on_modifier_delete_requested(slot) -> void:
	var index = slot.index
	
	_undo_redo.create_action("Delete modifier")
	var modifiers = _mapping.modifiers.duplicate()
	modifiers.remove_at(index)
	
	_undo_redo.add_do_property(_mapping, "modifiers", modifiers)
	_undo_redo.add_undo_property(_mapping, "modifiers", _mapping.modifiers)
	
	_undo_redo.commit_action()
	
	
func _on_trigger_delete_requested(slot) -> void:
	var index = slot.index
	
	_undo_redo.create_action("Delete trigger")
	var triggers = _mapping.triggers.duplicate()
	triggers.remove_at(index)
	
	_undo_redo.add_do_property(_mapping, "triggers", triggers)
	_undo_redo.add_undo_property(_mapping, "triggers", _mapping.triggers)
	
	_undo_redo.commit_action()	


func _on_delete_button_pressed():
	delete_requested.emit()


func _on_input_display_clicked():
	if is_instance_valid(_mapping.input):
		EditorInterface.edit_resource(_mapping.input)


func _on_edit_input_button_pressed():
	var dialog = binding_dialog_scene.instantiate()
	EditorInterface.popup_dialog_centered(dialog)
