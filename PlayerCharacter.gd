extends Node3D

var isFlying:bool = false

const jump_height:float = 3
func _process(delta):
	if Input.is_action_just_pressed("jump"):
		leave_animal()
		
func leave_animal():
	# Make controlled animal self controlled again
	get_parent().isPlayerControlled = false
	
	# Leave controlled animal
	reparent(get_parent().get_parent())
	
	# jump
	position.y = jump_height
	


func _on_animal_detection_area_entered(area):
	pass # Replace with function body.
