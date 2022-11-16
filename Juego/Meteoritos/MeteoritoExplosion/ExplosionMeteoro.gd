extends Node2D
class_name ExplosionMeteorito

func _ready():
	$AnimationPlayer.play(anim_random())
	
func anim_random() -> String:
	randomize()
	var num_anim:int = $AnimationPlayer.get_animation_list().size() -1
	var indice_anim_aleatoria:int = randi() % num_anim + 1
	var lista_anim:Array = $AnimationPlayer.get_animation_list()
	
	return lista_anim[indice_anim_aleatoria]

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
