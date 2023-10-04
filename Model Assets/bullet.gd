extends RigidBody


var explosion = preload("res://Model Assets/Explosion.tscn")

var bullet_speed = 50.0  # Adjust the bullet's speed as needed.

func _ready():
	$LifetimeBullet.connect("timeout", self, "_lifetime_end")

func set_direction(direction):
	# Set the bullet's initial linear velocity in the given direction.
	linear_velocity = direction.normalized() * bullet_speed

func _lifetime_end():
	$LifetimeBullet.stop()
	queue_free()
	
	

func _on_BulletArea_body_entered(body):
	if body.name:
		if not "Player" in body.name:
			if not "bullet" in body.name:
				queue_free()
				var explosion_instance = explosion.instance()
				get_tree().get_root().add_child(explosion_instance)
				explosion_instance.set_global_transform(self.get_global_transform_interpolated())
