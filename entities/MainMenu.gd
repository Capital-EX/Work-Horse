extends CenterContainer
signal play

func _ready():
	var file = File.new()
	var score = 0
	if file.file_exists("user://high.score"):
		file.open("user://high.score", File.READ)
		score = file.get_32()
		
	$VBoxContainer/VBoxContainer/HighScore.text = "High Score: %d$" % score
		
	


func _on_Button_pressed():
	get_tree().paused = false
	hide()
	emit_signal("play")