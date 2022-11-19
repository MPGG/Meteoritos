class_name BaseEnemiga
extends Node2D

export var hitpoints:float = 30.0

onready var impacto_sfx:AudioStreamPlayer2D = $ImpactoSFX

var esta_destruida:bool = false

func _ready():
	$AnimationPlayer.play(elegir_animacion_aleatoria())
	
func elegir_animacion_aleatoria()->String:
	randomize()
	var num_anim:int = $AnimationPlayer.get_animation_list().size() -1
	var indice_anim_aleatoria:int = randi() % num_anim + 1
	var lista_animacion:Array = $AnimationPlayer.get_animation_list()
	return lista_animacion[indice_anim_aleatoria]
func recibir_dmg(dmg:float):
	hitpoints -= dmg
	
	if hitpoints <= 0 and not esta_destruida:
		esta_destruida = true
		destruir()
		
		
	impacto_sfx.play()

func destruir():
	var posicion_partes = []
	for parte in $Sprites.get_children():
		posicion_partes.append(parte.global_position)
	Eventos.emit_signal("base_destruida",posicion_partes)
	queue_free()

func _on_AreaColision_body_entered(body):
	if body.has_method("destruir"):
		body.destruir()
	elif body.has_method("destruirNave"):
		body.destruirNave()
