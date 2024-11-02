@tool
extends Node

@onready var _sub_viewport:SubViewport = %SubViewport
@onready var _root:Node2D = %Root
@onready var _background:Control = %Background
@onready var _label:Label = %Label
@onready var _scene_holder = %SceneHolder

const MAX_SIZE:Vector2 = Vector2(512, 512)

var _pending_requests:Array[Job] = []
var _current_request:Job = null

func _ready():
	# don't needlessly eat performance
	set_process(false)
	DirAccess.make_dir_recursive_absolute("user://_guide_cache")
	

## Makes an icon for the given input and returns a Texture2D with the icon. Icons
## are cached on disk so subsequent calls for the same input will be faster.
func make_icon(input:GUIDEInput, height_px:int) -> Texture2D:
	var cache_key = (input.to_string() + str(height_px)).sha256_text()
	var cache_path = "user://_guide_cache/" + cache_key + ".res"
	if ResourceLoader.exists(cache_path):
		return ResourceLoader.load(cache_path, "Texture2D") 
	
	# We use an atlas texture as this allows us to return the texture already with a placeholder
	# and swap out the real texture once the texture is rendered. 
	var job = Job.new()
	job.height = height_px
	job.input = input
	_pending_requests.append(job)
	set_process(true)
	
	await job.done
	
	var image_texture = ImageTexture.create_from_image(job.result)
	ResourceSaver.save(image_texture, cache_path)
	image_texture.take_over_path(cache_path)
	
	return image_texture
		
	

func _process(delta):
	if _current_request == null and _pending_requests.is_empty():
		# nothing more to do..
		set_process(false)
		return 
		
	# nothing in progress, so pick the next request
	if _current_request == null:
		_current_request = _pending_requests.pop_front()
		var input = _current_request.input
		if input is GUIDEInputKey:
			_label.text = OS.get_keycode_string(input.key)
			# tell the subviewport to render a frame
		# TODO  - remaining cases
		# TODO different sizes for keys/buttons
		var scale =  float(_current_request.height) / float(MAX_SIZE.x)
		_root.scale = Vector2.ONE * scale
		_sub_viewport.size = MAX_SIZE * scale
		_sub_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
		return
		
	# we're done. make a copy of the viewport texture
	var image:Image = _scene_holder.texture.get_image()
	_current_request.result = image
	_current_request.done.emit()
	_current_request = null
	_sub_viewport.render_target_update_mode = SubViewport.UPDATE_DISABLED
			
		
class Job:
	signal done()
	var height:int
	var input:GUIDEInput
	var result:Image
	
	
