extends RigidBody

var bullet_speed = 75.0

func _ready():
	pass

func set_direction(direction):
	# Set the bullet's initial linear velocity in the given direction.
	linear_velocity = direction.normalized() * bullet_speed
