extends Control

func _ready():
	GlobalTimer.center_timer()
	GlobalTimer.set_timer_visibility(true)

func _on_texture_button_pressed():
	GlobalTimer.time_reset()
	SceneDictionary.change_scene("title")


