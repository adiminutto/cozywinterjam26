extends CanvasLayer

@onready var client_history_rox: MarginContainer = $ClientHistoryRox
@onready var open_journal_ui: MarginContainer = $OpenJournalUi
@onready var close_button: Button = $ClientHistoryRox/MarginContainer/VBoxContainer/CloseButton
@onready var open_button: Button = $OpenJournalUi/MarginContainer/HBoxContainer/OpenButton
@onready var submit_ui: MarginContainer = $SubmitUi
@onready var submit_button: Button = $SubmitUi/MarginContainer/HBoxContainer/SubmitButton
@onready var decoration_shop: Control = $DecorationShop
@onready var tools: Tools = $Tools
@onready var funds: Control = $Funds

func _process(delta: float) -> void:
	if open_button.is_pressed():
		open_journal_ui.hide()
		client_history_rox.show()
	if close_button.is_pressed():
		client_history_rox.hide()
		open_journal_ui.show()
	if submit_button.is_pressed():
		decoration_shop.hide()
		tools.hide()
		funds.hide()
		EventBus.submission.emit()
