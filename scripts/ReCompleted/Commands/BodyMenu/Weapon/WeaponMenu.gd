class_name WeaponMenu
extends CommandMenu

func _init() -> void:
	name = "Weapon"
	commands = [
		DummyCommand.new("Shuriken"),
		DummyCommand.new("Fuuma Shuriken"),
		DummyCommand.new("Bomb"),
		DummyCommand.new("Smoke Bomb"),
		DummyCommand.new("Fire Bomb")
	]
