class_name ValveClass

extends StaticBody2D
signal completed
var turns = 3
var active = false
var old_angle = 0
var start_angle = 0
var delta_mouse_pos = Vector2()
var old_mouse_pos = Vector2()
onready var Valve = $Overlay/Valve
onready var TurnsLeft = $Overlay/Valve/TurnsLeft
onready var Wheel = $Overlay/Valve/Wheel
var state = [false, false, false, false]

func _ready():
	TurnsLeft.text = "Turns Left: %d" % turns

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	if active:
		Wheel.rotation = Wheel.global_position.angle_to_point(get_global_mouse_position()) - start_angle
	delta_mouse_pos = mouse_pos - old_mouse_pos
	old_mouse_pos = mouse_pos

func activate():
	set_all_false()
	$Overlay/Triggers.look_at(get_global_mouse_position())
	var mouse_pos = get_global_mouse_position()
	old_mouse_pos = mouse_pos
	start_angle = Wheel.global_position.angle_to(mouse_pos)
	old_angle = start_angle
	active = true
	Valve.show()
	
func deactivate():
	active = false
	Valve.hide()

func set_all_false():
	state[0] = false
	state[1] = false
	state[2] = false
	state[3] = false

func are_all_true():
	return state[0] and state[1] and state[2] and state[3]
	
func are_all_false():
	return not (state[0] and state[1] and state[2] and state[3])

func in_order(i):
	return state[(i + 3) % 4] and state[(i + 1) % 4]

func enable(i):
	if active and are_all_false() or in_order(i):
		state[i] = true
		if are_all_true():
			set_all_false()
			turns -= 1
			$Overlay/Valve/TurnsLeft.text = "Turns Left: %d" % turns
			if turns == 0:
				emit_signal("completed", self)
				queue_free()
	else:
		set_all_false()

func _on_A_mouse_entered():
	enable(0)

func _on_B_mouse_entered():
	enable(1)

func _on_C_mouse_entered():
	enable(2)

func _on_D_mouse_entered():
	enable(3)

