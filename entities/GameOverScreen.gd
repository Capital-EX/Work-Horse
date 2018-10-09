extends CenterContainer

func _ready():
	pass

func _on_Replay_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Main.tscn")
