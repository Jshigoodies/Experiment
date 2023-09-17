extends Spatial

var bullet_scene = preload("res://Model Assets/bullet.tscn")
var is_charged = false
func _ready():
	$ChargeTimer.connect("timeout", self, "charge_timer_timeout")


func _input(event):
	if event.is_action_pressed("right_mouse_button") and !is_charged: # CHARGING
		$ChargeTimer.start()
		$AnimationPlayer.play("charge_indicator")
		$AudioStreamPlayer3D.play()
	if event.is_action_released("right_mouse_button") and is_charged: # FIRE
		is_charged = false
		shoot()
		$AnimationPlayer.play("Shoot")
		$bullet_sound.play()
	if event.is_action_released("right_mouse_button") and !is_charged: # let go too early
		$AnimationPlayer.play("Shoot")
		$ChargeTimer.stop()
		$AudioStreamPlayer3D.stop()
		
		

func shoot():
	var bullet_instance = bullet_scene.instance()
	var direction = $GunMuzzle.global_transform.basis.z  # Assumes the gun faces in the -Z direction
	bullet_instance.set_direction(direction)
	var bullet = bullet_instance
	
	
	
	get_tree().get_root().add_child(bullet)
	bullet.set_global_transform($GunMuzzle.get_global_transform())
	
func charge_timer_timeout():
	$ChargeTimer.stop()
	is_charged = true
	# print("FIRE FIRE FIRE")
