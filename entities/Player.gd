extends KinematicBody2D
signal move_box(dir)
signal type

enum Objects {NOTHING, COMPUTER, VALVE, BOX}

const Box = preload("res://entities/Box.gd")
const Computer = preload("res://entities/Computer.gd")
const Valve = preload("res://entities/Valve.gd")
const SPEED = 100
const PUSH_SPEED = 10
const ACCEL = 400

const WALKS = {
	left = "walk-left",
	right = "walk-right",
	up = "walk-up",
	down = "walk-down",
}

const PUSHES = {
	left = "push-left",
	right = "push-right",
	up = "push-up",
	down = "push-down",
}

const IDLES = {
	left = "idle-left",
	right = "idle-right",
	up = "idle-up",
	down = "idle-down",
}

var velocity = Vector2()
var motion = Vector2()
var direction = "right"

var work = NOTHING
var touching = NOTHING
var last_collision = null

func _ready():
	pass

func _physics_process(delta):
	if work == NOTHING:
		walk(delta)
	elif work == BOX:
		push(delta)

func _on_job_completed():
	stop_working()

func push(delta):
	emit_signal("move_box", motion)
	move_and_slide(motion * PUSH_SPEED)
	motion.x = max(motion.x - delta * 4, 0) if motion.x > 0 else min(motion.x + delta * 4, 0)
	motion.y = max(motion.y - delta * 4, 0) if motion.y > 0 else min(motion.y + delta * 4, 0)
	if motion.x == 0 and motion.y == 0:
		$AnimationPlayer.play(PUSHES[direction])
	elif not $AnimationPlayer.is_playing():
		$AnimationPlayer.play(PUSHES[direction])

func walk(delta):
	motion.x = 0
	motion.y = 0
	if Input.is_key_pressed(KEY_A):
		direction = "left"
		motion.x = -ACCEL

	elif Input.is_key_pressed(KEY_D):
		direction = "right"
		motion.x = ACCEL

	if Input.is_key_pressed(KEY_W):
		direction = "up"
		motion.y = -ACCEL

	elif Input.is_key_pressed(KEY_S):
		direction = "down"
		motion.y = ACCEL

	if motion.x == 0 and motion.y == 0:
		$AnimationPlayer.play(IDLES[direction])
	else:
		if $AnimationPlayer.current_animation != WALKS[direction]:
			$AnimationPlayer.play(WALKS[direction])

	if motion.x == 0:
		velocity.x = max(velocity.x - ACCEL * delta, 0) if velocity.x > 0 else min(velocity.x + ACCEL * delta, 0)
	else:
		velocity.x = clamp(velocity.x + motion.x, -SPEED, SPEED)

	if motion.y == 0:
		velocity.y = max(velocity.y - ACCEL * delta, 0) if velocity.y > 0 else min(velocity.y + ACCEL * delta, 0)
	else:
		velocity.y = clamp(velocity.y + motion.y, -SPEED, SPEED)
	if motion.x != 0 or motion.y != 0:
		touching = NOTHING
		last_collision = null
		move_and_slide(velocity)
		for i in range(0, get_slide_count()):
			var collision = get_slide_collision(i)
			var collider = collision.collider
			if collider is Box:
				touching = BOX
				last_collision = collider
			elif collider is Computer:
				touching = COMPUTER
				last_collision = collider
			elif collider is Valve:
				touching = VALVE
				last_collision = collider

func _on_completed(object):
	stop_working()

func stop_working():
	last_collision.deactivate()
	last_collision = null
	$Normal.show()
	$Pushing.hide()
	work = NOTHING
	touching = NOTHING

func _input(event):
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		if event.scancode == KEY_SPACE:
			if work != NOTHING:
				stop_working()

			elif touching != NOTHING:
				work = touching
				if touching == BOX:
					motion.x = 0
					motion.y = 0
					$Normal.hide()
					$Pushing.show()
					last_collision.activate()

				elif touching == COMPUTER:
					last_collision.activate()
				
				elif touching == VALVE:
					last_collision.activate()

		else:
			match work:
				BOX:
					match event.scancode:
						KEY_A:
							motion.x -= 1
						KEY_W:
							motion.y -= 1
						KEY_D:
							motion.x += 1
						KEY_S:
							motion.y += 1

				COMPUTER:
					emit_signal("type")



