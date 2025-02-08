extends Node3D

@export var textures : Array[Image]
@export var texture_names : Array[String]
@export var resolution : int

@export var models : Array[Mesh]
@export var model_names : Array[String]

@export var save_dialog : FileDialog
@export var load_dialog : FileDialog

@export var edit_viewer : VoxelViewer

func _ready() -> void:
	game.map.setup(textures, texture_names, resolution, models, model_names)

	game.atlas_update()

	game.set_save_dialog(save_dialog)
	game.set_load_dialog(load_dialog)

	game.set_edit_viewer(edit_viewer)
