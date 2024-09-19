class_name MindMenu
extends CommandMenu

func _init() -> void:
	name = "Mind"
	commands = [
		ItemMenu.new(),
		CalloutMenu.new(),
		StrategyMenu.new(),
		OrderMenu.new(),
		EquipMenu.new()
	]
	for command : CommandMenu in commands:
		if command is CommandMenu:
			(command as CommandMenu).set_last(self)
