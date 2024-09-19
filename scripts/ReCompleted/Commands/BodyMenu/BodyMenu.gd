class_name BodyMenu
extends CommandMenu

func _init() -> void:
	name = "Body"
	commands = [
		ComboMenu.new(),
		KataMenu.new(),
		LimitMenu.new(),
		FormMenu.new(),
		WeaponMenu.new()
	]
	for command : Command in commands:
		if command is CommandMenu:
			(command as CommandMenu).set_last(self)
