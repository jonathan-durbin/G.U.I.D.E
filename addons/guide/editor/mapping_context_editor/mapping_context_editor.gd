@tool
extends MarginContainer

@export var action_mapping_editor_scene:PackedScene

@onready var _title_label:Label = %TitleLabel
@onready var _action_mappings:Container = %ActionMappings
@onready var _editing_view:Control = %EditingView
@onready var _empty_view = %EmptyView

var _plugin:EditorPlugin
var _current_context:GUIDEMappingContext
var _ui:GUIDEUI

func _ready():
	_title_label.add_theme_font_override("font", get_theme_font("title", "EditorFonts"))
	_ui = GUIDEUI.new()
	add_child(_ui)

func initialize(plugin:EditorPlugin) -> void:
	_plugin = plugin
	
func edit(context:GUIDEMappingContext) -> void:
	_current_context = context
	_title_label.text = context._editor_name()
	
	_refresh()
	
	
func _refresh():
	_editing_view.visible = is_instance_valid(_current_context)
	_empty_view.visible = not is_instance_valid(_current_context)
	
	if not is_instance_valid(_current_context):
		return
	
	for child in _action_mappings.get_children():
		_action_mappings.remove_child(child)
		child.queue_free()
		
	for mapping in _current_context.mappings:
		var mapping_editor = action_mapping_editor_scene.instantiate()
		mapping_editor.initialize(_plugin, _ui)
		
		_action_mappings.add_child(mapping_editor)
		
		mapping_editor.edit(mapping)
		

