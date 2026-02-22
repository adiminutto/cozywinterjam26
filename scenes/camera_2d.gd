extends Camera2D

@export var zoom_speed : float = 10;

var zoom_target : Vector2
var ZOOM_MAX = Vector2(1, 1)
var ZOOM_MIN = Vector2(2, 2)

var drag_mouse_pos = Vector2.ZERO
var drag_camera_pos = Vector2.ZERO
var is_dragging : bool = false

var camera_start_pos: Vector2

func _ready() -> void:
	# Set camera start_pos
	camera_start_pos = position
	zoom_target = zoom
	pass

func _process(delta: float) -> void:
	## TODO - We can define static zoom values to also reset 
	if Input.is_action_just_pressed("camera_reset"):
		position = camera_start_pos
	cameraZoom(delta)
	clickAndDrag()

func cameraZoom(delta):
	if Input.is_action_just_pressed("cam_zoom_in") and zoom <= ZOOM_MIN:
		zoom_target *= 1.1
	
	if Input.is_action_just_pressed("cam_zoom_out") and zoom >= ZOOM_MAX:
		zoom_target *= 0.9
	
	zoom = zoom.slerp(zoom_target, zoom_speed * delta)
	
func clickAndDrag():
	## TODO: ADD ANCHOR
	if !is_dragging and Input.is_action_just_pressed("camera_pan"):
		drag_mouse_pos = get_viewport().get_mouse_position()
		drag_camera_pos = position
		is_dragging = true
		
	if is_dragging and Input.is_action_just_released("camera_pan"):
		is_dragging = false
	
	if is_dragging:
		var move_vector = get_viewport().get_mouse_position() - drag_mouse_pos
		position = drag_camera_pos - move_vector * 1/zoom.x
