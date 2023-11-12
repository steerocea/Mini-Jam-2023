extends Node

#Place for packed scenes to be stored, for scene switching.
#Exists to avoid cyclic scene reference and avoid multiple preloading.

var scene_dictionary:Dictionary = {
	"Level_T": preload("res://Scenes/Levels/level_t.tscn"),
	"title": preload("res://Scenes/title-screen.tscn"),
	"game-over": preload("res://Scenes/game-over.tscn"),
	"level-2": preload("res://Scenes/Levels/level_2.tscn"),
	"level-3": preload("res://Scenes/Levels/level_3.tscn"),
	"level-4": preload("res://Scenes/Levels/level_4.tscn"),
	"level-5": preload("res://Scenes/Levels/level_5.tscn"),
	}

func change_scene(scene_key:String):
	if(scene_dictionary.has(scene_key)):
		get_tree().change_scene_to_packed(scene_dictionary[scene_key])
	else:
		var errStr = "Invalid scene key: " + scene_key + "\n";
		for key in scene_dictionary.keys():
			errStr += key + "\n"
		push_error("Invalid scene key: " + scene_key )
