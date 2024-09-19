class_name HeartMenu
extends CommandMenu

func _init() -> void:
	name = "Heart"
	commands = [
		FocusMenu.new(),
		MagicMenu.new(),
		LinkMenu.new(),
		SummonMenu.new(),
		PortalMenu.new()
	]
	for command : CommandMenu in commands:
		if command is CommandMenu:
			(command as CommandMenu).set_last(self)
