extends Spatial

enum {
	IDLE,
	ALERT,
	STUNNED
}

var state = IDLE
onready var raycast = $RayCast

func _ready():
	pass

func _process(delta):
	if raycast.is_colliding():
		state = ALERT
	else:
		state = IDLE
		
	match state:
		IDLE:
			print("IDLE")
		ALERT:
			print("ALERT")
		STUNNED:
			print("STUNNED")
