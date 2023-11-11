extends AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	play()

func _on_audio_finished():
	# The audio finished playing, so start playing it again
	play()
