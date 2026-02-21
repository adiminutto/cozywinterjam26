extends CanvasLayer

@onready var client_history_rox: MarginContainer = $ClientHistoryRox
@onready var open_journal_ui: MarginContainer = $OpenJournalUi
@onready var close_button: Button = $ClientHistoryRox/MarginContainer/VBoxContainer/CloseButton
@onready var open_button: Button = $OpenJournalUi/MarginContainer/HBoxContainer/OpenButton

func _process(delta: float) -> void:
	if open_button.is_pressed():
		open_journal_ui.hide()
		client_history_rox.show()
	if close_button.is_pressed():
		client_history_rox.hide()
		open_journal_ui.show()
