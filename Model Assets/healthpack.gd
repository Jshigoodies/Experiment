extends RigidBody


func _ready():
	pass




func _on_healthpackArea_body_entered(body):
	if body.name == "Player":
		if body.get_health() != body.get_max_health():
			body.heal(10)
			queue_free()
