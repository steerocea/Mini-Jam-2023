extends Control

func _ready():
	GlobalTimer.center_timer()
	GlobalTimer.set_timer_visibility(false)

func _on_menubutton_pressed():
	GlobalTimer.time_reset()
	SceneDictionary.change_scene("title")
