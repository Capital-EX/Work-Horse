class_name BoxButtonClass
extends Node2D
signal completed

var target = null
var triggers = {
	left = false,
	top = false,
	right = false,
	bottom = false,
}

func _ready():
	pass

func activate(body, trigger):
	if body is BoxClass:
		if not target:
			target = body
		triggers[trigger] = true
		
		if triggers.left and triggers.top and triggers.right and triggers.left:
			emit_signal("completed", self)
			queue_free()
			target.queue_free()

func deactivate(body, trigger):
	if body is BoxClass and body.is_active():
		if not target:
			target = body
		triggers[trigger] = false
		if not (triggers.left and triggers.top and triggers.right and triggers.left):
			target = null

func _on_Left_body_entered(body):
	activate(body, "left")

func _on_Top_body_entered(body):
	activate(body, "top")

func _on_Right_body_entered(body):
	activate(body, "right")

func _on_Bottom_body_entered(body):
	activate(body, "bottom")

func _on_Left_body_exited(body):
	deactivate(body, "left")

func _on_Top_body_exited(body):
	deactivate(body, "top")

func _on_Right_body_exited(body):
	deactivate(body, "right")

func _on_Bottom_body_exited(body):
	deactivate(body, "bottom")
