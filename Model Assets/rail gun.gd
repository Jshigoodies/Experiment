extends Spatial

var bullet_scene = preload("res://Model Assets/bullet.tscn")

func _input(event):
	if event.is_action_released("right_mouse_button"):
		shoot()
		
		

func shoot():
	var bullet_instance = bullet_scene.instance()
	var direction = $GunMuzzle.global_transform.basis.z  # Assumes the gun faces in the -Z direction
	bullet_instance.set_direction(direction)
	var bullet = bullet_instance
	
	
	
	get_tree().get_root().add_child(bullet)
	bullet.set_global_transform($GunMuzzle.get_global_transform())
	
	
