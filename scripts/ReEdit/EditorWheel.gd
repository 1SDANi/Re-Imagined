class_name EditorWheel
extends CommandWheel

func _init(user : Actor, controller : EditorController) -> void:
	var _commands : Array[Command] = [EditorMenu.new(self, controller)]
	super(user, _commands)
