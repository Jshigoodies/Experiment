extends RigidBody


var speed = 100.0  # Adjust the speed of the bullet as needed

func _ready():
	# Set the initial velocity to move the bullet forward along its local Z-axis
	linear_velocity = Vector3(0, 0, -speed)
