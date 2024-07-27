extends Node3D

var isFlying:bool = false
@onready var detectionArea = $"AnimalDetectionArea/CollisionShape3D"
const jump_height:float = 3
const jumpSpeedIncrease:float = 3
func _process(delta):
	if Input.is_action_just_pressed("jump"):
		if isFlying:
			if availableAnimal != null:
				mount_animal()
		else:
			leave_animal()
		
		
		
func mount_animal():
	GameManager.playerSpeed -= jumpSpeedIncrease
	reparent(availableAnimal)
	availableAnimal.isPlayerControlled = true
	position = availableAnimal.playerPosition
	isFlying = false
	
func leave_animal():
	GameManager.playerSpeed += jumpSpeedIncrease
	# Make controlled animal self controlled again
	get_parent().isPlayerControlled = false
	
	# Leave controlled animal
	reparent(get_parent().get_parent())
	
	# jump
	position.y = jump_height
	isFlying = true
	availableAnimal = null

var availableAnimal:Node3D
func _on_animal_detection_area_entered(area:Node3D):
	if area.is_in_group("animals"):
		availableAnimal = area

