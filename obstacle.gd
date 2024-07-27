extends StaticBody3D

@export_category("Avoidance")
@export var direction:int = AvoidanceDirection.Left

func _on_avoidance_trigger_body_entered(body):
	if body.has_method("on_avoidance_trigger_detected"):
		body.on_avoidance_trigger_detected(direction)
