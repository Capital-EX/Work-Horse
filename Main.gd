extends Node2D

const Box = preload("res://entities/Box.tscn")
const BoxButton = preload("res://entities/Button.tscn")
const Computer = preload("res://entities/Computer.tscn")
const Valve = preload("res://entities/Valve.tscn")

const BoxButtonClass = preload("res://entities/Button.gd")
const ComputerClass = preload("res://entities/Computer.gd")
const ValveClass = preload("res://entities/Valve.gd")

var cash = 0
var jobs_todo = 0
var spaces = []
var test_point = RectangleShape2D.new()
var time = 6
onready var Player = $Objects/Player
onready var PlayerCollision = $Objects/Player/Shape
onready var player_shape = $Objects/Player/Shape.shape

func _ready():
	test_point.extents = Vector2(8, 8)
	$Gui/Hud/VBox/Time.text = "Time: %.1f" % time
	$Gui/Hud/VBox/Cash.text = "Cash: %d$" % cash
	spaces.resize(100)
	for y in range(0, 10):
		for x in range(0, 10):
			spaces[x + y * 10] = Vector2(56 + x * 16, 56 + y * 16)
	get_tree().paused = true

func _process(delta):
	time -= delta
	if time <= 0:
		get_tree().paused = true
		var file = File.new()
		file.open("user://high.score", File.WRITE)
		file.store_32(cash)
		$Gui/GameOverScreen/CenterContainer/Cash.text = "Cash: %d$" % cash
		$Gui/Hud/VBox.hide()
		$Gui/GameOverScreen.show()
	$Gui/Hud/VBox/Time.text = "Time: %.2f" % time
	
	
func _on_completed(job):
	var pay = 1
	if job is BoxButtonClass:
		pay = 10
		
	elif job is ComputerClass:
		pay = 5
		
	elif job is ValveClass:
		pay = 1
	
	jobs_todo -= 1
	cash += pay
	if $JobSpawner.is_stopped():
		$JobSpawner.start()
	$Gui/Hud/VBox/Cash.text = "Cash: %d$" % cash
	spaces.push_back(job.position)

func get_position():
	var index = randi() % len(spaces)
	var pos = spaces[index]
	while player_shape.collide(PlayerCollision.global_transform, test_point, Transform2D(0, pos)):
		index = randi() % len(spaces)
		pos = spaces[index]
	spaces.remove(index)
	return pos

func _on_JobSpawner_timeout():
	if jobs_todo < 10:
		var choice = randi() % 3
		jobs_todo += 1
		if jobs_todo > 10:
			$JobSpawner.stop()
		match choice:
			0:
				var box = Box.instance()
				var button = BoxButton.instance()
				$Objects.add_child(box)
				$Objects.add_child(button)
				box.position = get_position()
				button.position = get_position()
				button.connect("completed", self, "_on_completed")
				button.connect("completed", Player, "_on_completed")
				Player.connect("move_box", box, "_on_move")
				
			1: 
				var computer = Computer.instance()
				$Objects.add_child(computer)
				computer.position = get_position()
				computer.connect("completed", self, "_on_completed")
				computer.connect("completed", Player, "_on_completed")
				Player.connect("type", computer, "_on_type")
				
			2:
				var valve = Valve.instance()
				$Objects.add_child(valve)
				valve.position = get_position()
				valve.connect("completed", self, "_on_completed")
				valve.connect("completed", Player, "_on_completed")
	

func _on_play():
	$Gui/Hud.show()
