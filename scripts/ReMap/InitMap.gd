extends Node3D

@export var textures : Array[Image]
@export var texture_names : Array[String]
@export var resolution : int

@export var models : Array[Mesh]
@export var model_names : Array[String]

@export var primaries : Array[String]
@export var secondaries : Array[String]

@export var initial_primary : String
@export var initial_secondary : String

@export var reskin_tex : Array[String]

func _ready() -> void:
	game.map.setup(textures, texture_names, resolution, models, model_names)

	game.map.primaries = primaries
	game.map.secondaries = secondaries

	game.map.primary = initial_primary
	game.map.secondary = initial_secondary

	if reskin_tex.size() > 0:
		game.map.reskin_tex = reskin_tex
	else:
		game.map.reskin_tex = primaries
