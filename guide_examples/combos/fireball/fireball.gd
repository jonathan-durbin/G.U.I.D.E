extends Node2D

@export var speed:float = 600
var direction:float = 1.0


func _ready():
	await get_tree().create_timer(5).timeout
	queue_free()


func _process(delta):
	position.x += speed * direction * delta
