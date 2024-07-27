extends Node3D

var currentSpeed = 12.5
const avoidanceDistance = 1.2
@export var isPlayerControlled:bool = false

const SPEED = 0.05

@onready var targetX:float = position.x 
func _process(delta):
	if isPlayerControlled:
		var input = Input.get_axis("right", "left")
		position.x += input * SPEED
	else:
		var relativeSpeed:float = currentSpeed - GameManager.playerSpeed
		global_position.z += relativeSpeed*delta
		position.x = move_toward(position.x, targetX, 4*delta)

func on_avoidance_trigger_detected(direction:int):
	print("avoiding obstacle...")
	targetX += direction * avoidanceDistance


func _on_body_entered(body):
	# if object is obstacle
	if isPlayerControlled && body.get_collision_layer() == 2:
		GameManager.game_over.emit()
