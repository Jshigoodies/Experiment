extends KinematicBody

signal camera_shake

const MOUSE_SENSITIVITY = 0.2

onready var camera = $CamRoot/Camera
onready var particleSystem = $boosterEffect/Particles
onready var gunCamera = $CamRoot/Camera/ViewportContainer/Viewport/gunCam
onready var boost_animation = $CamRoot/Camera/ViewportContainer/boostUI/boostingUI

var velocity = Vector3.ZERO
var current_vel = Vector3.ZERO
var dir = Vector3.ZERO

var speed

const SPEED = 10
const SPRINT_SPEED = 30
const ACCEL = 15.0

const GRAVITY = -40.0
const JUMP_SPEED = 15
var jump_counter = 0
const AIR_ACCEL = 9.0

var is_boosting = false
var is_cooldown = false


var max_health = 100
var current_health = max_health
onready var health_display = $CamRoot/Camera/ViewportContainer/Health/HealthBar

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$BoostTimer.connect("timeout", self, "_on_BoosterTimer_timeout")
	health_display.value = max_health

func _process(delta):
	window_activity()
	gunCamera.global_transform = camera.global_transform
	

func _physics_process(delta):
	dir = Vector3.ZERO
	
	if Input.is_action_pressed("foward"):
		dir -= camera.global_transform.basis.z
	if Input.is_action_pressed("backward"):
		dir += camera.global_transform.basis.z
	if Input.is_action_pressed("right"):
		dir += camera.global_transform.basis.x
	if Input.is_action_pressed("left"):
		dir -= camera.global_transform.basis.x
		
	dir = dir.normalized()
	
	
	velocity.y += GRAVITY * delta
	
	if is_on_floor():
		jump_counter = 0
	
	if Input.is_action_just_pressed("jump") and jump_counter < 1:
		jump_counter += 1
		velocity.y = JUMP_SPEED
		$Audio/jump.play()
		
	
	if Input.is_action_just_pressed("sprint"):
		if is_boosting == false:
			boost_animation.play("boosting")
			is_boosting = true
			particleSystem.emitting = true
			$BoostTimer.start()
			emit_signal("camera_shake")
	
	if is_boosting:
		speed = SPRINT_SPEED
	else:
		speed = SPEED
	
	if Input.is_action_pressed("left") or Input.is_action_pressed("right") or Input.is_action_pressed("foward") or Input.is_action_pressed("backward") or Input.is_action_just_pressed("jump"):
		$animations/gunSway.play("gunSway")
			
	
	
	var target_vel = dir * speed
	
	var accel = ACCEL if is_on_floor() else AIR_ACCEL
	
	current_vel = current_vel.linear_interpolate(target_vel, accel * delta)
	
	velocity.x = current_vel.x
	velocity.z = current_vel.z
	
	
	velocity = move_and_slide(velocity, Vector3.UP, true, 4, deg2rad(45))

func _input(event):
	if event is InputEventMouseMotion:
		$CamRoot.rotate_x((deg2rad(event.relative.y * MOUSE_SENSITIVITY * -1)))
		$CamRoot.rotation_degrees.x = clamp($CamRoot.rotation_degrees.x, -90, 90)
		self.rotate_y((deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1)))

func window_activity():
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
func _on_BoosterTimer_timeout():
	is_boosting = false
	particleSystem.emitting = false


func take_damage(damage):
	current_health -= damage
	if current_health <= 0:
		current_health = 0
		# You can handle character death here
	health_display.value = current_health

func heal(healing_amount):
	current_health += healing_amount
	if current_health > max_health:
		current_health = max_health
	health_display.value = current_health




func _on_hit_area_entered(area):
	if area.name == "Area" || area.name == "TurretBulletExplosion":
		take_damage(1)
		# print("Health is now at")
		# print(current_health)
			

func get_health():
	return current_health

func get_max_health():
	return max_health
