extends Spatial


func _ready():
	$AnimationPlayer.play("BigToSmall")


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
