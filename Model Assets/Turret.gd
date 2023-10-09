extends Spatial

var bullet_scene = preload("res://Model Assets/TurretBullet.tscn")
var death = preload("res://Model Assets/TurretDeath.tscn")

enum {
	IDLE,
	ALERT,
	STUNNED #Dies
}

var target

const TURN_SPEED = 9.75

var state = IDLE
onready var raycast = $RayCast
onready var eyes = $Eyes
onready var shoottimer = $ShootTimer

func _ready():
	pass

func _process(delta):
	match state:
		IDLE:
			pass
		ALERT:
			eyes.look_at(target.global_transform.origin, Vector3.UP)
			rotate_y(deg2rad(eyes.rotation.y * TURN_SPEED))
		STUNNED:
			pass


func _on_SightRange_body_entered(body):
	if body.is_in_group("MC"):
		state = ALERT
		target = body
		shoottimer.start()


func _on_SightRange_body_exited(body):
	if body.is_in_group("MC"):
		state = IDLE
		shoottimer.stop()
	


func _on_ShootTimer_timeout():
	var bullet_instance = bullet_scene.instance()
	var direction = $Muzzle.global_transform.basis.z * -1
	bullet_instance.set_direction(direction)
	var bullet = bullet_instance
	
	get_tree().get_root().add_child(bullet)
	bullet.set_global_transform($Muzzle.get_global_transform())
	
	
	


func _on_collide_area_entered(area):
	if area.name == "Explosion" || area.name == "BulletArea":
		queue_free()
		var death_instance = death.instance()
		get_tree().get_root().add_child(death_instance)
		death_instance.set_global_transform(self.get_global_transform())
