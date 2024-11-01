extends Node2D

@export var speed:float = 100

@export var mapping_context:GUIDEMappingContext
@onready var animation_player:AnimationPlayer = %AnimationPlayer

@export var jump_action:GUIDEAction
@export var somersault_action:GUIDEAction

func _ready():
	GUIDE.enable_mapping_context(mapping_context)
	jump_action.triggered.connect(_play.bind("jump"))
	somersault_action.triggered.connect(_play.bind("somersault"))
	
func _play(animation:String):
	if animation_player.is_playing():
		return
		
	animation_player.play(animation)
	

