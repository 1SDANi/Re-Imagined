class_name EquipMenu
extends CommandMenu

func _init() -> void:
	name = "Equip"
	commands = [
		DummyCommand.new("Wooden Sword"),
		DummyCommand.new("Wooden Staff"),
		DummyCommand.new("Wooden Shield"),
		DummyCommand.new("Kingdom Key"),
		DummyCommand.new("Jungle King")
	]
