extends Area3D

const SPEED = 0.05
func _process(delta):
	var input = Input.get_axis("right", "left")
	position.x += input * SPEED


func _on_body_entered(body):
	# if object is obstacle
	if body.get_collision_layer() == 2:
		print("Game over")
