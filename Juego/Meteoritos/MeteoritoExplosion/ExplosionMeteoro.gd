extends Node2D
class_name ExplosionMeteorito

func _ready():
	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
