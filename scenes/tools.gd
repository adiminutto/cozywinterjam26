extends Control
class_name Tools

@onready var place_button: Button = $Panel/ButtonBox/PlaceButton
@onready var move_button: Button = $Panel/ButtonBox/MoveButton
@onready var erase_button: Button = $Panel/ButtonBox/EraseButton
@onready var editor_object: EditorObject = $"../../EditorObject"

func _ready() -> void:
	#place_button.button_pressed = true
	pass
	
func _process(delta: float) -> void:
	editor_object.place_toggle = place_button.is_pressed()
	editor_object.move_toggle = move_button.is_pressed()
	editor_object.erase_toggle = erase_button.is_pressed()
	pass
