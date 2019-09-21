class_name ComputerClass
extends StaticBody2D
signal completed

var active = false
var progress = 0.0

func _ready():
	$Label.text = "%d" % progress

func _on_type():
	if active:
		progress += 1
		$Label.modulate.r = (100.0 - progress) / 100.0
		$Label.modulate.g = progress / 100.0
		$Label.text = "%d" % progress
		if progress == 100:
			emit_signal("completed", self)
			queue_free()

func activate():
	active = true
	$Label.show()

func deactivate():
	active = false
	$Label.hide()