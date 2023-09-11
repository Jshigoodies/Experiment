extends KinematicBody

signal camera_shake

const MOUSE_SENSITIVITY = 0.1

onready var camera = $CamRoot/Camera

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

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$BoostTimer.connect("timeout", self, "_on_BoosterTimer_timeout")

func _process(delta):
	window_activity()
	

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
		
	
	if Input.is_action_just_pressed("sprint"):
		if is_boosting == false:
			is_boosting = true
			$BoostTimer.start()
			emit_signal("camera_shake")
	
	if is_boosting:
		speed = SPRINT_SPEED
	else:
		speed = SPEED
	
	
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
