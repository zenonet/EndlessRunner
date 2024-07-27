extends Node

@onready var main: PackedScene = preload("res://main.tscn")

signal game_over()

var distance:float = 0
var playerSpeed:float = 12

func _ready():
	game_over.connect(on_game_over)
	add_child(main.instantiate())
	
func on_game_over():
	print("Game over")
	distance = 0
	playerSpeed = 12
	for c in get_children():
		c.queue_free()
	
	add_child(main.instantiate())
