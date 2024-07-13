extends SoftMesh
class_name SlopeMesh

func _ready() -> void:
	super()
	game.set_slope_mesh(get_path())
