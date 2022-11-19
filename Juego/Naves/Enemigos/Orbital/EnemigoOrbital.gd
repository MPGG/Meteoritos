class_name EnemigoOrbital
extends EnemigoBase

export var rango_max_ataque:float = 1400.0

var base_duenia:Node2D

func create(pos:Vector2, duenia:Node2D):
	global_position = pos
	base_duenia = duenia

func _ready():
	canon.set_esta_disparando(true)
	Eventos.connect("base_destruida",self,"_on_base_destruida")

func rotar_hacia_player():
	.rotar_hacia_player()
	if dir_player.length() > rango_max_ataque:
		canon.set_esta_disparando(false)
	else:
		canon.set_esta_disparando(true)

func _on_base_destruida(base:Node2D, _pos):
	if base == base_duenia:
		destruirNave()
	
