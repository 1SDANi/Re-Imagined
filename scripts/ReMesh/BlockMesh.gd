extends HardMesh
class_name BlockMesh

func _ready() -> void:
	super()
	game.set_block_mesh(get_path())
