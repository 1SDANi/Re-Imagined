class_name NamePopup
extends Node

@export var Cancel : Button
@export var Name : LineEdit
@export var Confirm : Button

func text() -> String:
	return Name.text
