extends Spatial

var bullet_scene = preload("res://Model Assets/bullet.tscn")

func _input(event):
	if event.is_action_pressed("right_mouse_button"):
		shoot()
		
func shoot():
	var bullet_instance = bullet_scene.instance()
	var bullet = bullet_instance
	
	get_tree().get_root().add_child(bullet)
	bullet.set_global_transform($GunMuzzle.get_global_transform())
