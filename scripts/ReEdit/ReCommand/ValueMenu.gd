class_name ValueMenu
extends CommandMenu

enum OP
{
	ADD,
	SUB,
	INC,
	DEC,
	SET
}

var main : float
var minor : float

func _init(_n : String, _l : CommandMenu, _c : Array[Command]) -> void:
	super(_n, _l, _c)

func update_commands() -> void:
	update_name()
	super()

func update_name() -> void:
	rename(commands[index].name)

func calc(op : OP, _adjust : float) -> void:
	match(op):
		OP.ADD:
			calc_add(_adjust)
		OP.SUB:
			calc_sub(_adjust)
		OP.SET:
			calc_set(_adjust)
		OP.INC:
			calc_inc(_adjust)
		OP.DEC:
			calc_dec(_adjust)
	game.command_update()

func calc_set(_adjust : float) -> void:
	main = _adjust
	if is_zero_approx(main): main = 0

func calc_add(_adjust : float) -> void:
	calc_set(main + minor)

func calc_sub(_adjust : float) -> void:
	calc_set(main - minor)

func calc_adjust(_adjust : float) -> void:
	minor = _adjust
	if is_zero_approx(minor): minor = 0

func calc_inc(_adjust : float) -> void:
	calc_adjust(minor + _adjust)

func calc_dec(_adjust : float) -> void:
	calc_adjust(minor - _adjust)
