extends Node3D

var currentSpeed = 12.5

func _process(delta):
	var relativeSpeed:float = currentSpeed - GameManager.playerSpeed
	global_position.z += relativeSpeed*delta

func _on_avoidance_trigger_body_entered(direction:AvoidanceDirection):
	pass
