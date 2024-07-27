extends Node3D

var currentSpeed = 12
const avoidanceDistance = 1.2
@export var isPlayerControlled:bool = false

const HORIZONTAL_SPEED = 8

@onready var targetX:float = position.x 
@onready var playerPosition = $PlayerPosition.position

func _ready():
	# Leave the moving part of the world
	if get_parent().is_in_group("chunks"):
		# print("Reparenting animal")
		var z = global_position.z
		reparent($"../../..")
		global_position.z = z

func _process(delta):
	if isPlayerControlled:
		var input = Input.get_axis("right", "left")
		position.x += input * HORIZONTAL_SPEED * delta
	else:
		var relativeSpeed:float = currentSpeed - GameManager.playerSpeed
		print("relative speed: %f; world speed: %f" % [relativeSpeed, GameManager.playerSpeed])
		position.z += relativeSpeed*delta
		position.x = move_toward(position.x, targetX, 4*delta)

func on_avoidance_trigger_detected(direction:int):
	targetX += direction * avoidanceDistance


func _on_body_entered(body):
	# if object is obstacle
	if isPlayerControlled and body.is_in_group("obstacles"):
		GameManager.game_over.emit()
