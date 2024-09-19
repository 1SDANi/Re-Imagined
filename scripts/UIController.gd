extends Node

var _pause_ui : Control
var _game_ui : Control
var _command_ui : Control
var _menu_title : RichTextLabel
var _command_1 : RichTextLabel
var _command_2 : RichTextLabel
var _command_3 : RichTextLabel
var _command_4 : RichTextLabel
var _command_5 : RichTextLabel

@export var PauseUI : NodePath
@export var GameUI : NodePath
@export var CommandUI : NodePath
@export var MenuTitle : NodePath
@export var Command1 : NodePath
@export var Command2 : NodePath
@export var Command3 : NodePath
@export var Command4 : NodePath
@export var Command5 : NodePath
@export var active: StyleBoxFlat
@export var passive: StyleBoxFlat

func _ready() -> void:
	_pause_ui = get_node(PauseUI)
	_game_ui = get_node(GameUI)
	_command_ui = get_node(CommandUI)
	_menu_title = get_node(MenuTitle)
	_command_1 = get_node(Command1)
	_command_2 = get_node(Command2)
	_command_3 = get_node(Command3)
	_command_4 = get_node(Command4)
	_command_5 = get_node(Command5)

func _process(_delta: float) -> void:
	if game.input.is_mouse_free():
		_pause_ui.set_process_mode(PROCESS_MODE_INHERIT)
		_pause_ui.set_visible(true)
		_game_ui.set_process_mode(PROCESS_MODE_DISABLED)
		_game_ui.set_visible(false)
		_command_ui.set_process_mode(PROCESS_MODE_DISABLED)
		_command_ui.set_visible(false)
	else:
		_pause_ui.set_process_mode(PROCESS_MODE_DISABLED)
		_pause_ui.set_visible(false)
		_game_ui.set_process_mode(PROCESS_MODE_INHERIT)
		_game_ui.set_visible(true)
		_command_ui.set_process_mode(PROCESS_MODE_INHERIT)
		_command_ui.set_visible(true)

		var menu : CommandMenu = game.actor.command_menu
		var command : String
		var panel : PanelContainer
		_menu_title.text = "[center][b]" + menu.name + "[b][center]"
		if menu.commands.size() > 0:
			command = menu.commands[menu.origin].name
			_command_1.text = "[center][b]" + command + "[b][center]"
			panel = _command_1.get_parent().get_parent()
			if menu.index == menu.origin:
				panel.add_theme_stylebox_override("panel", active)
			else:
				panel.add_theme_stylebox_override("panel", passive)
		else:
			_command_1.text = ""
			panel = _command_1.get_parent().get_parent()
			panel.add_theme_stylebox_override("panel", passive)
		if menu.commands.size() > 1:
			command = menu.commands[menu.origin + 1].name
			_command_2.text = "[center][b]" + command + "[b][center]"
			panel = _command_2.get_parent().get_parent()
			if menu.index == menu.origin + 1:
				panel.add_theme_stylebox_override("panel", active)
			else:
				panel.add_theme_stylebox_override("panel", passive)
		else:
			_command_2.text = ""
			panel = _command_2.get_parent().get_parent()
			panel.add_theme_stylebox_override("panel", passive)
		if menu.commands.size() > 2:
			command = menu.commands[menu.origin + 2].name
			_command_3.text = "[center][b]" + command + "[b][center]"
			panel = _command_3.get_parent().get_parent()
			if menu.index == menu.origin + 2:
				panel.add_theme_stylebox_override("panel", active)
			else:
				panel.add_theme_stylebox_override("panel", passive)
		else:
			_command_3.text = ""
			panel = _command_3.get_parent().get_parent()
			panel.add_theme_stylebox_override("panel", passive)
		if menu.commands.size() > 3:
			command = menu.commands[menu.origin + 3].name
			_command_4.text = "[center][b]" + command + "[b][center]"
			panel = _command_4.get_parent().get_parent()
			if menu.index == menu.origin + 3:
				panel.add_theme_stylebox_override("panel", active)
			else:
				panel.add_theme_stylebox_override("panel", passive)
		else:
			_command_4.text = ""
			panel = _command_4.get_parent().get_parent()
			panel.add_theme_stylebox_override("panel", passive)
		if menu.commands.size() > 4:
			command = menu.commands[menu.origin + 4].name
			_command_5.text = "[center][b]" + command + "[b][center]"
			panel = _command_5.get_parent().get_parent()
			if menu.index >= menu.origin + 4:
				panel.add_theme_stylebox_override("panel", active)
			else:
				panel.add_theme_stylebox_override("panel", passive)
		else:
			_command_5.text = ""
			panel = _command_5.get_parent().get_parent()
			panel.add_theme_stylebox_override("panel", passive)

