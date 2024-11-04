@tool
extends MarginContainer

const ClassScanner = preload("../class_scanner.gd")
const Utils = preload("../utils.gd")

@export var action_mapping_editor_scene:PackedScene

@onready var _title_label:Label = %TitleLabel
@onready var _action_mappings:Container = %ActionMappings
@onready var _editing_view:Control = %EditingView
@onready var _empty_view = %EmptyView
@onready var _add_button:Button = %AddButton
@onready var _some_mappings:Control = %SomeMappings
@onready var _no_mappings:Control = %NoMappings

var _plugin:EditorPlugin
var _current_context:GUIDEMappingContext
var _ui:GUIDEUI
var _undo_redo:EditorUndoRedoManager
var _scanner:ClassScanner


func _ready():
	_title_label.add_theme_font_override("font", get_theme_font("title", "EditorFonts"))
	_add_button.icon = get_theme_icon("Add", "EditorIcons")
	_ui = GUIDEUI.new()
	_scanner = ClassScanner.new()
	add_child(_ui)
	
	_editing_view.visible = false
	_empty_view.visible = true


func initialize(plugin:EditorPlugin) -> void:
	_plugin = plugin
	_undo_redo = plugin.get_undo_redo()
	
	
func edit(context:GUIDEMappingContext) -> void:
	if is_instance_valid(_current_context):
		_current_context.changed.disconnect(_refresh)
		
	_current_context = context
	
	if is_instance_valid(_current_context):
		_current_context.changed.connect(_refresh)
	
	_refresh()
	
	
func _refresh():
	_editing_view.visible = is_instance_valid(_current_context)
	_empty_view.visible = not is_instance_valid(_current_context)
	
	if not is_instance_valid(_current_context):
		return
	
	_some_mappings.visible = not _current_context.mappings.is_empty()
	_no_mappings.visible = _current_context.mappings.is_empty()
	
	_title_label.text = _current_context._editor_name()
	_title_label.tooltip_text = _current_context.resource_path
	
	Utils.clear(_action_mappings)
		
	for i in _current_context.mappings.size():
		var mapping = _current_context.mappings[i]
		
		var mapping_editor = action_mapping_editor_scene.instantiate()
		mapping_editor.initialize(_plugin, _ui, _scanner)
		
		_action_mappings.add_child(mapping_editor)
		
		mapping_editor.edit(mapping)
		mapping_editor.delete_requested.connect(_on_action_mapping_delete_requested.bind(i))


func _on_action_mapping_delete_requested(index:int):
	var mappings = _current_context.mappings.duplicate()
	mappings.remove_at(index)
	
	_undo_redo.create_action("Delete action mapping")
	
	_undo_redo.add_do_property(_current_context, "mappings", mappings)
	_undo_redo.add_undo_property(_current_context, "mappings", _current_context.mappings)
	
	_undo_redo.commit_action()
	

func _on_add_button_pressed():
	var mappings = _current_context.mappings.duplicate()
	var new_mapping := GUIDEActionMapping.new()
	var new_action := GUIDEAction.new()
	new_action.name = "new_action"
	new_mapping.action = new_action
	mappings.append(new_mapping)
	
	_undo_redo.create_action("Add action mapping")
	
	_undo_redo.add_do_property(_current_context, "mappings", mappings)
	_undo_redo.add_undo_property(_current_context, "mappings", _current_context.mappings)
	
	_undo_redo.commit_action()
