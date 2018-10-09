extends KinematicBody2D

var motion = Vector2()
var slide = 10
var active = false

func _ready():
	pass
	
func _physics_process(delta):
	if motion.x != 0 or motion.y != 0:
		move_and_slide(motion * slide)
	motion.x = max(motion.x - delta * 4, 0) if motion.x > 0 else min(motion.x + delta * 4, 0)
	motion.y = max(motion.y - delta * 4, 0) if motion.y > 0 else min(motion.y + delta * 4, 0)

func _on_move(vector):
	if active:
		motion = vector

func activate():
	active = true
	
func deactivate():
	active = false

func is_active():