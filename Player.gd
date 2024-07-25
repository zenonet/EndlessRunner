extends CharacterBody3D

const SPEED = 0.05
func _process(delta):
	var input = Input.get_axis("right", "left")
	position.x += input * SPEED
