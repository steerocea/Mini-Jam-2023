extends Control

func _ready():
	GlobalTimer.center_timer()
	GlobalTimer.set_timer_visibility(false)

func _on_startbutton_pressed():
	GlobalTimer.set_timer_visibility(true)
	GlobalTimer.time_reset()
	GlobalTimer.time_start()
	SceneDictionary.change_scene("level-1")
	
func _on_htpbutton_pressed():
	SceneDictionary.change_scene("how-to-play")
