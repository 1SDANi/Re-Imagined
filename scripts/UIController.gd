extends Node

var _pause_ui : Control
var _game_ui : Control

@export var PauseUI : NodePath
@export var GameUI : NodePath

func _ready() -> void:
	_pause_ui = get_node(PauseUI)
	_game_ui = get_node(GameUI)

func _process(_delta: float) -> void:
	if game.input.is_mouse_free():
		_pause_ui.set_process_mode(PROCESS_MODE_INHERIT)
		_pause_ui.set_visible(true)
		_game_ui.set_process_mode(PROCESS_MODE_DISABLED)
		_game_ui.set_visible(false)
	else:
		_pause_ui.set_process_mode(PROCESS_MODE_DISABLED)
		_pause_ui.set_visible(false)
		_game_ui.set_process_mode(PROCESS_MODE_INHERIT)
		_game_ui.set_visible(true)
