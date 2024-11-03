@tool
extends MarginContainer

const ActionSlot = preload("../action_slot/action_slot.gd")

signal delete_requested()

@export var input_mapping_editor_scene:PackedScene
@onready var _action_slot:ActionSlot = %ActionSlot
@onready var _add_button:Button = %AddButton
@onready var _input_mappings:Container = %InputMappings
@onready var _delete_button:Button = %DeleteButton
@onready var _no_mappings:Control = %NoMappings

const ClassScanner = preload("../class_scanner.gd")

var _plugin:EditorPlugin
var _ui:GUIDEUI
var _scanner:ClassScanner
var _undo_redo:EditorUndoRedoManager

var _mapping:GUIDEActionMapping

func _ready():
	_action_slot.action_changed.connect(_on_action_changed)
	_add_button.icon = get_theme_icon("Add", "EditorIcons")
	_delete_button.icon = get_theme_icon("Remove", "EditorIcons")

func initialize(plugin:EditorPlugin, ui:GUIDEUI, scanner:ClassScanner):
	_plugin = plugin
	_ui = ui
	_scanner = scanner
	_undo_redo = _plugin.get_undo_redo()
	
	
func edit(mapping:GUIDEActionMapping):
	assert(_mapping == null)
	_mapping = mapping
	
	_mapping.changed.connect(_update)
	
	_update()
	
	
func _update():
	for child in _input_mappings.get_children():
		_input_mappings.remove_child(child)
		child.queue_free()

	_action_slot.action = _mapping.action
	
	_input_mappings.visible = not _mapping.input_mappings.is_empty()
	_no_mappings.visible = _mapping.input_mappings.is_empty()
	
	for i in _mapping.input_mappings.size():
		var input_mapping = _mapping.input_mappings[i]
		var input_mapping_editor = input_mapping_editor_scene.instantiate()
		_input_mappings.add_child(input_mapping_editor)

		input_mapping_editor.initialize(_plugin, _ui, _scanner)
		input_mapping_editor.edit(input_mapping)
		input_mapping_editor.delete_requested.connect(_on_input_mapping_delete_requested.bind(i))
	
	
func _on_action_changed():
	_undo_redo.create_action("Change action")
	_undo_redo.add_do_property(_mapping, "action", _action_slot.action)
	_undo_redo.add_undo_property(_mapping, "action", _mapping.action)
	_undo_redo.commit_action()
	

func _on_add_button_pressed():
	var values = _mapping.input_mappings.duplicate()
	var new_mapping = GUIDEInputMapping.new()
	values.append(new_mapping)

	_undo_redo.create_action("Add input mapping")
	
	_undo_redo.add_do_property(_mapping, "input_mappings", values)
	_undo_redo.add_undo_property(_mapping, "input_mappings", _mapping.input_mappings)

	_undo_redo.commit_action()
	

func _on_input_mapping_delete_requested(index:int):
	var values = _mapping.input_mappings.duplicate()
	values.remove_at(index)

	_undo_redo.create_action("Delete input mapping")
	_undo_redo.add_do_property(_mapping, "input_mappings", values)
	_undo_redo.add_undo_property(_mapping, "input_mappings", _mapping.input_mappings)

	_undo_redo.commit_action()


func _on_delete_button_pressed():
	delete_requested.emit()
