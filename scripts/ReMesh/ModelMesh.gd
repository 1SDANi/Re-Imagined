class_name ModelMesh
extends HardMesh

func _ready() -> void:
	super()
	game.set_model_mesh(get_path())
	await owner.ready
	update_albedo(game.map.get_atlas_texture())
	update_mesher(game.map.get_mesher())

func update_albedo(_albedo : Texture2D) -> void:
	(material_override as StandardMaterial3D).albedo_texture = _albedo

func update_mesher(_mesher : VoxelMesherBlocky) -> void:
	mesher = _mesher
