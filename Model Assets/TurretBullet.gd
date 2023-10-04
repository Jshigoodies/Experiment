extends RigidBody

var bullet_speed = 25.0

var explode = preload("res://Model Assets/TurretBulletExplosion.tscn")


func _ready():
	$LifeTime.connect("timeout", self, "_lifetime_end")

func set_direction(direction):
	# Set the bullet's initial linear velocity in the given direction.
	linear_velocity = direction.normalized() * bullet_speed

func _lifetime_end():
	$LifeTime.stop()
	queue_free()
	


func _on_Area_body_entered(body):
	if body.name:
		if not "Turret" in body.name:
			if not "TurretBullet" in body.name:
				queue_free()
				var explosion_instance = explode.instance()
				get_tree().get_root().add_child(explosion_instance)
				explosion_instance.set_global_transform(self.get_global_transform_interpolated())
