extends Camera

var is_shaking = false
var shake_duration = 0.3
var shake_intensity = 0.15
var original_position

func _start_screen_shake():
	if !is_shaking:
		is_shaking = true
		original_position = transform.origin
		var elapsed_time = 0.0
		while elapsed_time < shake_duration:
			var offset = Vector3(rand_range(-shake_intensity, shake_intensity), rand_range(-shake_intensity, shake_intensity), rand_range(-shake_intensity, shake_intensity))
			transform.origin = original_position + offset
			yield(get_tree().create_timer(0.02), "timeout")
			elapsed_time += 0.02
		transform.origin = original_position
		is_shaking = false



func _on_Player_camera_shake():
	_start_screen_shake()
