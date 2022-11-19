class_name EnemigoOrbital
extends EnemigoBase

export var rango_max_ataque:float = 1400.0
export var velocidad:float = 400.0

onready var detector_obstaculo:RayCast2D = $DetectorObstaculo

var base_duenia:Node2D
var ruta:Path2D
var path_follow:PathFollow2D

func create(pos:Vector2, duenia:Node2D, ruta_duenia:Path2D):
	global_position = pos
	base_duenia = duenia
	ruta = ruta_duenia
	path_follow = PathFollow2D.new()
	ruta.add_child(path_follow)

func _ready():
	canon.set_esta_disparando(true)
# warning-ignore:return_value_discarded
	Eventos.connect("base_destruida",self,"_on_base_destruida")

func _process(delta):
	path_follow.offset += velocidad * delta
	position = path_follow.global_position

func rotar_hacia_player():
	.rotar_hacia_player()
	if dir_player.length() > rango_max_ataque or detector_obstaculo.is_colliding():
		canon.set_esta_disparando(false)
	else:
		canon.set_esta_disparando(true)

func _on_base_destruida(base:Node2D, _pos):
	if base == base_duenia:
		destruirNave()
	
