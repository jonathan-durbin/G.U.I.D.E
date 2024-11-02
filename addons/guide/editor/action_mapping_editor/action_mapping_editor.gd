@tool
extends MarginContainer

const ActionSlot = preload("../action_slot/action_slot.gd")

@export var input_mapping_editor_scene:PackedScene

@onready var _action_slot:ActionSlot = %ActionSlot
@onready var _add_button:Button = %AddButton
@onready var _input_mappings:Container = %InputMappings

var _plugin:EditorPlugin
var _ui:GUIDEUI
var _undo_redo:EditorUndoRedoManager

var _mapping:GUIDEActionMapping

func _ready():
	_action_slot.action_changed.connect(_on_action_changed)
	_add_button.icon = get_theme_icon("Add", "EditorIcons")
	

func initialize(plugin:EditorPlugin, ui:GUIDEUI):
	_plugin = plugin
	_ui = ui
	_undo_redo = _plugin.get_undo_redo()
	
	
func edit(mapping:GUIDEActionMapping):
	_mapping = mapping
	_action_slot.action = _mapping.action
	
	for input_mapping in _mapping.input_mappings:
		var input_mapping_editor = input_mapping_editor_scene.instantiate()
		_input_mappings.add_child(input_mapping_editor)

		input_mapping_editor.initialize(_plugin, _ui)
		input_mapping_editor.edit(input_mapping)
	
func _on_action_changed():
	_undo_redo.create_action("Change action")
	_undo_redo.add_do_property(_mapping, "action", _action_slot.action)
	_undo_redo.add_undo_property(_mapping, "action", _mapping.action)
	_undo_redo.commit_action()
	
