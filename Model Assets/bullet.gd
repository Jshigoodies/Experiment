extends RigidBody


var bullet_speed = 50.0  # Adjust the bullet's speed as needed.

func _ready():
	pass  # Optional setup code here.

func set_direction(direction):
	# Set the bullet's initial linear velocity in the given direction.
	linear_velocity = direction.normalized() * bullet_speed
