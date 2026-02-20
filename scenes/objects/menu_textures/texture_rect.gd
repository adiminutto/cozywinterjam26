extends TextureRect

@export var this_scene: PackedScene

@onready var editor_object: EditorObject = $"../../../../../../../../../EditorObject"

#@onready var object_cursor = get_node("/root/game/editor_object")
@onready var cursor_sprite = editor_object.get_child(0)

func _ready() -> void:
	#self.connect("input_event", _item_clicked)
	print(editor_object)
	pass

func _on_gui_input(event: InputEvent) -> void:
	if (event is InputEvent):
		if (event.is_action_pressed("left_click")):
			editor_object.can_place = false
			editor_object.current_item = this_scene
			cursor_sprite.texture = texture
	pass # Replace with function body.
