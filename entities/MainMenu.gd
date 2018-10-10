extends CenterContainer
signal play

func _ready():
	pass
		
	
	

func set_score(score):
	$VBoxContainer/VBoxContainer/HighScore.text = "High Score: %d$" % score

func _on_Button_pressed():
	get_tree().paused = false
	hide()
	emit_signal("play")