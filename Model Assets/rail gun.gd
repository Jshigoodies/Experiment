extends Spatial

var bullet_scene = preload("res://Model Assets/bullet.tscn")

func _input(event):
	if event.is_action_pressed("right_mouse_button"):
		shoot()
		
func shoot():
	var bullet_instance = bullet_scene.instance()
	var bullet = bullet_instance
	bullet.global_transform.origin = $GunMuzzle.global_transform.origin
	bullet.global_transform.basis = $GunMuzzle.global_transform.basis
	
	get_tree().current_scene.add_child(bullet)
