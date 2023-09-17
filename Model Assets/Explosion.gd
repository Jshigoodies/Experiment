extends Area

signal screen_shake_explosion

func _ready():
	$AnimationPlayer.play("explosion")
	emit_signal("screen_shake_explosion")


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()


