extends SoftMesh
class_name SmoothMesh

func _ready() -> void:
	super()
	game.set_smooth_mesh(get_path())
