## Functions to show GUIDE mappings to the end user in the game UI.
@tool
extends Node

const IconMaker = preload("icon_maker/icon_maker.gd")
const KeyRenderer = preload("icon_maker/renderers/key_renderer.tscn")
const MouseRenderer = preload("icon_maker/renderers/mouse_renderer.tscn")
const JoyRenderer = preload("icon_maker/renderers/joy_renderer.tscn")
const ActionRenderer = preload("icon_maker/renderers/action_renderer.tscn")
const FallbackRenderer = preload("icon_maker/renderers/fallback_renderer.tscn")
const DefaultTextProvider = preload("default_text_provider.gd")

var _icon_maker:IconMaker

var _icon_renderers:Array[GUIDEIconRenderer] = []
var _text_providers:Array[GUIDETextProvider] = []

func _ready():
	_icon_maker = preload("icon_maker/icon_maker.tscn").instantiate()
	add_child(_icon_maker)
	add_icon_renderer(KeyRenderer.instantiate())
	add_icon_renderer(MouseRenderer.instantiate())
	add_icon_renderer(ActionRenderer.instantiate())
	add_icon_renderer(JoyRenderer.instantiate())
	add_icon_renderer(FallbackRenderer.instantiate())
	
	add_text_provider(DefaultTextProvider.new())
	
	
func add_icon_renderer(renderer:GUIDEIconRenderer) -> void:
	_icon_renderers.append(renderer)
	_icon_renderers.sort_custom(func(r1, r2): return r1.priority < r2.priority)
	
	
func remove_icon_renderer(renderer:GUIDEIconRenderer) -> void:
	_icon_renderers.erase(renderer)
	

func add_text_provider(provider:GUIDETextProvider) -> void:
	_text_providers.append(provider)
	_text_providers.sort_custom(func(r1, r2): return r1.priority < r2.priority)
	
	
func remove_text_provider(provider:GUIDETextProvider) -> void:
	_text_providers.erase(provider)


## Checks the currently activated mapping contexts and finds the highest priority binding
## for the given action. Formats this binding into the given string format. Add a `%s` to
## the string where the input should be. Only a single %s can be in the string.
func format_action_as_text(format:String, action:GUIDEAction) -> String:
	if action == null:
		push_error("Cannot determine input for null action.")
		return ""
		
	var inputs:Array[GUIDEInput] = GUIDE.get_inputs_bound_to_action(action)
	var replacements:Array[String] = []
	for input in inputs:
		replacements.append(format_input_as_text("%s", [input]))
		
	return format % [",".join(replacements)]
	
	
## Checks the currently activated mapping contexts and finds the highest priority binding
## for the given action. Formats this binding into icons using the given string format. Add a `%s` to
## the string where the input should be. Only a single %s can be in the string. Since icons are
## built in the background, you need to `await` on this function.
func format_action_with_icons(format:String, action:GUIDEAction, height_px:int = 32) -> String:
	if action == null:
		push_error("Cannot determine input for null action.")
		return ""
			
	var inputs:Array[GUIDEInput] = GUIDE.get_inputs_bound_to_action(action)
	var replacements:Array[String] = []
	for input in inputs:
		var icons = await format_input_as_icons("%s", [input])
		replacements.append(icons)
		
	return format % [",".join(replacements)]


## Formats the given string by replacing the placeholders with a textual description of the 
## given inputs. Can be used to show input in a UI (e.g. "press [A] to jump"). This is a bit
## more lightweight than rendering inputs to icons. If you want icons instead of text, use
## format_input_with_icons. Add a `%s` into the string where the input should be (e.g. "press %s to jump").
func format_input_as_text(format:String, inputs:Array[GUIDEInput]) -> String:
	var replacements:Array[String] = []
	for input in inputs:
		var found = false
		for provider in _text_providers:
			if provider.supports(input):
				replacements.append(provider.get_text(input))
				found = true
		if not found:
			push_warning("No text provider found for input ", input)
			replacements.append("[??]")
			
	return format % replacements
	
	
## Formats the given string into a BBCode replacing %s placeholders with icons representing
## the input. Can be used to show input in a UI with a RichTextLabel (e.g. "press 'A' to jump").
## Automatically handles input type and modifiers (e.g. Shift+A, etc.). Since icons are
## built in the background, you need to `await` on this function.
func format_input_as_icons(format:String, inputs:Array[GUIDEInput], height_px:int = 32) -> String:
	var replacements:Array[String] = []
	for input in inputs:
		var images = await get_input_icons(input, height_px)
		var replacement = ""
		for j in images.size():
			replacement += "[img]" + images[j].resource_path + "[/img]"
			if j + 1 < images.size():
				replacement += "+"
		replacements.append(replacement)
		
	return format % replacements
			
	
## Returns a set of icons representing the given input. For most inputs this will
## only be a single icon, but e.g. for combinations like Ctrl+Shift+S this will return
## 3 icons.	Since icons are built in the background, you need to `await` on this function.
func get_input_icons(input:GUIDEInput, height_px:int = 32) -> Array[Texture2D]:	
	var result:Array[Texture2D] = []
			
	# for GUIDEInputKey we have the additional wrinkle that this may actually
	# be more than 1 key  (e.g. Ctrl+Shift+A), so we may need to make more textures.
	if input is GUIDEInputKey:
		if input.control:
			var ctrl = GUIDEInputKey.new()
			ctrl.key = KEY_CTRL
			result.append_array(await get_input_icons(ctrl, height_px))
		if input.alt:
			var alt = GUIDEInputKey.new()
			alt.key = KEY_ALT
			result.append_array(await get_input_icons(alt, height_px))
		if input.shift:
			var shift = GUIDEInputKey.new()
			shift.key = KEY_SHIFT
			result.append_array(await get_input_icons(shift, height_px))
		if input.meta:
			var meta = GUIDEInputKey.new()
			meta.key = KEY_META
			result.append_array(await get_input_icons(meta, height_px))
			
	var new_icon:Texture2D = null
	for renderer in _icon_renderers:
		if renderer.supports(input):
			new_icon = await _icon_maker.make_icon(input, renderer, height_px)
			# first renderer wins
			break
		
	if new_icon == null:
		push_warning("No renderer found for input ", input)
		new_icon = PlaceholderTexture2D.new()
		new_icon.size = Vector2(height_px, height_px)
	
	result.append(new_icon)
	return result
			
			
			
	
			
			
	
		
			

