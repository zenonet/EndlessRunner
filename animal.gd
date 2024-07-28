extends Node3D

@onready var normalSpeed:float = randf_range(6, 12)
const avoidanceDistance = 1.2
@export var isPlayerControlled:bool = false
var isMountingProccessStarted:bool = false

const HORIZONTAL_SPEED = 8

@onready var targetX:float = global_position.x 
@onready var playerPosition = $PlayerPosition.position

var dragInput:float = 0
func _ready():
	$WarningText.visible = false

func _process(delta):
	if isPlayerControlled:
		var input = Input.get_axis("right", "left") + dragInput
		position.x += input * HORIZONTAL_SPEED * delta
		dragInput = 0
	else:
		var relativeSpeed:float = normalSpeed - GameManager.playerSpeed
		# print("relative speed: %f; world speed: %f" % [relativeSpeed, GameManager.playerSpeed])
		position.z += relativeSpeed*delta
		global_position.x = move_toward(global_position.x, targetX, 4*delta)
		
	if isPlayerControlled || isMountingProccessStarted:
		# Move the animal towards z=0 to keep it on the screen
		position.z = move_toward(position.z, 0, 5*delta)

func _input(event):
	if !isPlayerControlled: return
	
	var is_drag:bool = event is InputEventScreenDrag
	
	if is_drag:
		dragInput = event.relative.x * -0.08

var playerNode:Node3D
var isTimerForWarning:bool = true
func on_player_mounted(player):
	playerNode = player
	isTimerForWarning = true
	$ThrowOffTimer.start(10)

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


func _on_throw_off_timer_timeout():
	if !isPlayerControlled:
		return
	if isTimerForWarning:
		$WarningText.visible = true
		$ThrowOffTimer.start(3)
		isTimerForWarning = false
	else:
		$WarningText.visible = false
		playerNode.leave_animal()
