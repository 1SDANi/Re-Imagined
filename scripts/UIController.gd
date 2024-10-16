extends Node

var _pause_ui : Control
var _game_ui : Control
var _command_ui : Control
var _menu_title : RichTextLabel
var _menu_1 : RichTextLabel
var _menu_2 : RichTextLabel
var _menu_3 : RichTextLabel
var _menu_4 : RichTextLabel
var _menu_5 : RichTextLabel
var _command_control : Control
var _command_1 : RichTextLabel
var _command_2 : RichTextLabel
var _command_3 : RichTextLabel
var _command_4 : RichTextLabel
var _command_5 : RichTextLabel

var hide : Array[NodePath]
var show : Array[NodePath]

@export var PauseUI : NodePath
@export var GameUI : NodePath
@export var CommandUI : NodePath
@export var MenuTitle : NodePath
@export var Menu1 : NodePath
@export var Menu2 : NodePath
@export var Menu3 : NodePath
@export var Menu4 : NodePath
@export var Menu5 : NodePath
@export var CommandControl : NodePath
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
	_menu_1 = get_node(Menu1)
	_menu_2 = get_node(Menu2)
	_menu_3 = get_node(Menu3)
	_menu_4 = get_node(Menu4)
	_menu_5 = get_node(Menu5)
	_command_control = get_node(CommandControl)
	_command_1 = get_node(Command1)
	_command_2 = get_node(Command2)
	_command_3 = get_node(Command3)
	_command_4 = get_node(Command4)
	_command_5 = get_node(Command5)
	if not game.CommandUpdate.connect(command_update) != OK:
		pass

func command_update() -> void:
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
		var category : String
		var command : String
		var menu_panel : PanelContainer
		var command_panel : PanelContainer
		var pos : Vector2
		_menu_title.text = "[center][b]" + menu.category + "[b][center]"

		if menu.commands.size() > 0:
			category = menu.commands[menu.origin].category
			command = menu.commands[menu.origin].name
			_menu_1.text = "[center][b]" + category + "[b][center]"
			_command_1.text = "[center][b]" + command + "[b][center]"
			menu_panel = _menu_1.get_parent().get_parent()
			command_panel = _command_1.get_parent().get_parent()
			if menu.index == menu.origin:
				menu_panel.add_theme_stylebox_override("panel", active)
				command_panel.add_theme_stylebox_override("panel", passive)
				if _menu_1.text == _command_1.text:
					command_panel.set_visible(false)
				else:
					command_panel.set_visible(true)
			else:
				menu_panel.add_theme_stylebox_override("panel", passive)
				command_panel.add_theme_stylebox_override("panel", passive)
				command_panel.set_visible(false)
		else:
			_menu_1.text = ""
			_command_1.text = ""
			menu_panel = _menu_1.get_parent().get_parent()
			command_panel = _command_1.get_parent().get_parent()
			menu_panel.add_theme_stylebox_override("panel", passive)
			command_panel.add_theme_stylebox_override("panel", passive)
			command_panel.set_visible(false)

		if menu.commands.size() > 1:
			category = menu.commands[menu.origin + 1].category
			command = menu.commands[menu.origin + 1].name
			_menu_2.text = "[center][b]" + category + "[b][center]"
			_command_2.text = "[center][b]" + command + "[b][center]"
			menu_panel = _menu_2.get_parent().get_parent()
			command_panel = _command_2.get_parent().get_parent()
			if menu.index == menu.origin + 1:
				menu_panel.add_theme_stylebox_override("panel", active)
				command_panel.add_theme_stylebox_override("panel", passive)
				if _menu_2.text == _command_2.text:
					command_panel.set_visible(false)
				else:
					command_panel.set_visible(true)
			else:
				menu_panel.add_theme_stylebox_override("panel", passive)
				command_panel.add_theme_stylebox_override("panel", passive)
				command_panel.set_visible(false)
		else:
			_menu_2.text = ""
			_command_2.text = ""
			menu_panel = _menu_2.get_parent().get_parent()
			command_panel = _command_2.get_parent().get_parent()
			menu_panel.add_theme_stylebox_override("panel", passive)
			command_panel.add_theme_stylebox_override("panel", passive)
			command_panel.set_visible(false)

		if menu.commands.size() > 2:
			category = menu.commands[menu.origin + 2].category
			command = menu.commands[menu.origin + 2].name
			_menu_3.text = "[center][b]" + category + "[b][center]"
			_command_3.text = "[center][b]" + command + "[b][center]"
			menu_panel = _menu_3.get_parent().get_parent()
			command_panel = _command_3.get_parent().get_parent()
			if menu.index == menu.origin + 2:
				menu_panel.add_theme_stylebox_override("panel", active)
				command_panel.add_theme_stylebox_override("panel", passive)
				if _menu_3.text == _command_3.text:
					command_panel.set_visible(false)
				else:
					command_panel.set_visible(true)
			else:
				menu_panel.add_theme_stylebox_override("panel", passive)
				command_panel.add_theme_stylebox_override("panel", passive)
				command_panel.set_visible(false)
		else:
			_menu_3.text = ""
			_command_3.text = ""
			menu_panel = _menu_3.get_parent().get_parent()
			command_panel = _command_3.get_parent().get_parent()
			menu_panel.add_theme_stylebox_override("panel", passive)
			command_panel.add_theme_stylebox_override("panel", passive)
			command_panel.set_visible(false)

		if menu.commands.size() > 3:
			category = menu.commands[menu.origin + 3].category
			command = menu.commands[menu.origin + 3].name
			_menu_4.text = "[center][b]" + category + "[b][center]"
			_command_4.text = "[center][b]" + command + "[b][center]"
			menu_panel = _menu_4.get_parent().get_parent()
			command_panel = _command_4.get_parent().get_parent()
			if menu.index == menu.origin + 3:
				menu_panel.add_theme_stylebox_override("panel", active)
				command_panel.add_theme_stylebox_override("panel", passive)
				if _menu_4.text == _command_4.text:
					command_panel.set_visible(false)
				else:
					command_panel.set_visible(true)
			else:
				menu_panel.add_theme_stylebox_override("panel", passive)
				command_panel.add_theme_stylebox_override("panel", passive)
				pos = Vector2(_command_4.global_position.x, _menu_title.global_position.y)
				command_panel.set_visible(false)
		else:
			_menu_4.text = ""
			_command_4.text = ""
			menu_panel = _menu_4.get_parent().get_parent()
			command_panel = _command_4.get_parent().get_parent()
			menu_panel.add_theme_stylebox_override("panel", passive)
			command_panel.add_theme_stylebox_override("panel", passive)
			command_panel.set_visible(false)

		if menu.commands.size() > 4:
			category = menu.commands[menu.origin + 4].category
			command = menu.commands[menu.origin + 4].name
			_menu_5.text = "[center][b]" + category + "[b][center]"
			_command_5.text = "[center][b]" + command + "[b][center]"
			menu_panel = _menu_5.get_parent().get_parent()
			command_panel = _command_5.get_parent().get_parent()
			if menu.index == menu.origin + 4:
				menu_panel.add_theme_stylebox_override("panel", active)
				command_panel.add_theme_stylebox_override("panel", passive)
				if _menu_5.text == _command_5.text:
					command_panel.set_visible(false)
				else:
					command_panel.set_visible(true)
			else:
				menu_panel.add_theme_stylebox_override("panel", passive)
				command_panel.add_theme_stylebox_override("panel", passive)
				command_panel.set_visible(false)
		else:
			_menu_5.text = ""
			_command_5.text = ""
			menu_panel = _menu_5.get_parent().get_parent()
			command_panel = _command_5.get_parent().get_parent()
			menu_panel.add_theme_stylebox_override("panel", passive)
			command_panel.add_theme_stylebox_override("panel", passive)
			command_panel.set_visible(false)
