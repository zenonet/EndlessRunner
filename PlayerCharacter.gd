extends Node3D

var isFlying:bool = false
var isDecending:bool = false
var isLanding:bool = false
@onready var detectionArea = $"AnimalDetectionArea/CollisionShape3D"
const jump_height:float = 3
const jumpSpeedIncrease:float = 3

var isAnimalAvailable:bool = false
var flyingSpeedX:float = 0

func _ready():
	if get_parent().is_in_group("animals"):
		get_parent().on_player_mounted(self)


func _process(delta):
	if Input.is_action_just_pressed("jump"):
		if isFlying:
			if isAnimalAvailable:
				start_mounting()
		else:
			leave_animal()
			
	if isFlying:
		if isLanding:
			var globalTargetPos:Vector3 = availableAnimal.playerPosition + availableAnimal.global_position
			global_position = global_position.move_toward(globalTargetPos, 10*delta)
			if global_position.distance_squared_to(globalTargetPos) < .2:
				mount_animal()
		else:
			if isDecending:
				position.y -= delta
				if position.y <= 0:
					GameManager.game_over.emit()
			else:
				position.y = move_toward(position.y, jump_height, 8*delta)
				if position.y == jump_height:
					isDecending = true
			global_position.x -= flyingSpeedX*delta

func _input(event):
	# event.device is -1 when the touch is emulated by mouse
	if event.device == -1 || (!(event is InputEventScreenTouch) && !(event is InputEventScreenDrag)): return

	var is_drag:bool = event is InputEventScreenDrag
	var is_press:bool = !is_drag and event.is_pressed()
	var is_release:bool = !is_drag and !event.is_pressed()
	
	if isFlying && is_press && isAnimalAvailable:
		start_mounting()
	
	if !isFlying && is_release:
		leave_animal()

func start_mounting():
	if !isAnimalAvailable: return
	
	isLanding = true
	availableAnimal.isMountingProccessStarted = true
func mount_animal():
	print("Mounting...")
	GameManager.playerSpeed -= jumpSpeedIncrease
	reparent(availableAnimal)
	availableAnimal.isPlayerControlled = true
	position = availableAnimal.playerPosition
	isFlying = false
	isLanding = false
	availableAnimal.on_player_mounted(self)
	
func leave_animal():
	if isFlying: return
	GameManager.playerSpeed += jumpSpeedIncrease
	# Make controlled animal self controlled again
	get_parent().isPlayerControlled = false
	flyingSpeedX = get_parent().speedX
	
	# Leave controlled animal
	reparent(get_parent().get_parent())
	
	availableAnimal.isMountingProccessStarted = false
	
	# jump
	isFlying = true
	isDecending = false
	isAnimalAvailable = false

var availableAnimal:Node3D = null
func _on_animal_detection_area_entered(area:Node3D):
	if area.is_in_group("animals"):
		availableAnimal = area
		isAnimalAvailable = true
		
func _on_animal_detection_area_exited(area:Node3D):
	if area == availableAnimal:
		isAnimalAvailable = false
		

func _on_body_entered(body):
	if body.is_in_group("obstacles"):
		GameManager.game_over.emit()
