extends CanvasLayer

@onready var textbox_container: MarginContainer = $TextboxContainer
@onready var start: Label = $TextboxContainer/MarginContainer/HBoxContainer/Start
@onready var end: Label = $TextboxContainer/MarginContainer/HBoxContainer/End
@onready var label: Label = $TextboxContainer/MarginContainer/HBoxContainer/Label

## TODO: ADD PORTRAIT NEXT TO TEXT BOX
## TODO: ADD NAME NEXT TO TEXT BOX
const CHAR_READ_RATE = 0.05

enum State {
	READY,
	READING,
	FINISHED
}

var current_state = State.READY
var text_queue = []

var tween = create_tween()

func _process(delta: float) -> void:
	match current_state:
		State.READY:
			#print(text_queue)
			if len(text_queue)>0:
				tween = create_tween()
				display_text()
		State.READING:
			if Input.is_action_just_pressed("ui_accept"):
				label.visible_ratio = 1.0
				tween.stop()
				end.text = Definitions.TEXTBOX_END_SYMBOL
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				change_state(State.READY)
				hide_textbox()
				
func _ready() -> void:
	print("Starting state: State.READY")
	hide_textbox()
	#queue_text("First text queued")
	#queue_text("Second text queued")
	#queue_text("Third text queued")
	#queue_text("Fourth text queued")
	#display_text("This text should be added!")
	
func queue_text(next_text):
	text_queue.push_back(next_text)

func hide_textbox():
	start.text = ""
	end.text = ""
	label.text = ""
	textbox_container.hide()

func show_textbox():
	start.text = Definitions.TEXTBOX_START_SYMBOL
	textbox_container.show()

func display_text():
	var next_text = text_queue.pop_front()
	label.text = next_text
	change_state(State.READING)
	show_textbox()
	label.visible_ratio=0.0
	tween.tween_property(label,"visible_ratio", 1.0, len(next_text) * CHAR_READ_RATE).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	change_state(State.FINISHED)
	end.text = Definitions.TEXTBOX_END_SYMBOL

func change_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			print("Changing state to: State.READY")
		State.READING:
			print("Changing state to: State.READING")
		State.FINISHED:
			print("Changing state to: State.FINISHED")
