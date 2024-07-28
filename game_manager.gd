extends Node

@onready var main: PackedScene = preload("res://main.tscn")
@onready var mainMenu: PackedScene = preload("res://scenes/main_menu.tscn")
signal game_over()

var distance:float = 0
var playerSpeed:float = 12

var hadInitialTouch:bool = false

func _ready():
	game_over.connect(on_game_over)
	get_parent().add_child(mainMenu.instantiate())
	
func on_game_over():
	print("Game over")
	distance = 0
	playerSpeed = 12
	for c in get_children():
		c.queue_free()
	
	start_game()
	
func start_game():
	var menu = get_parent().find_child("MainMenu", false, false)
	if menu:
		menu.queue_free()

	add_child(main.instantiate())
