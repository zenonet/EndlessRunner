extends Node3D

@onready var normalSpeed:float = randf_range(6, 12)
const avoidanceDistance = 1.2
@export var isPlayerControlled:bool = false

const HORIZONTAL_SPEED = 8

@onready var targetX:float = global_position.x 
@onready var playerPosition = $PlayerPosition.position

func _process(delta):
	if isPlayerControlled:
		var input = Input.get_axis("right", "left")
		position.x += input * HORIZONTAL_SPEED * delta
	else:
		var relativeSpeed:float = normalSpeed - GameManager.playerSpeed
		# print("relative speed: %f; world speed: %f" % [relativeSpeed, GameManager.playerSpeed])
		position.z += relativeSpeed*delta
		global_position.x = move_toward(global_position.x, targetX, 4*delta)

func on_avoidance_trigger_detected(direction:int):
	targetX += direction * avoidanceDistance


func _on_body_entered(body):
	if !isPlayerControlled: return
	# if object is obstacle
	if body.is_in_group("obstacles"):
		GameManager.game_over.emit()


func _on_area_entered(area):
	if !isPlayerControlled: return
	
	if (area.is_in_group("animals") && !area.isPlayerControlled):
		GameManager.game_over.emit()
