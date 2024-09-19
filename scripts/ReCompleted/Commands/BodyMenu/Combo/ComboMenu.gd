class_name ComboMenu
extends CommandMenu

func _init() -> void:
	name = "Combo"
	commands = [
		DummyCommand.new("Slash"),
		DummyCommand.new("Swing"),
		DummyCommand.new("Stab"),
		DummyCommand.new("Slapshot")
	]
