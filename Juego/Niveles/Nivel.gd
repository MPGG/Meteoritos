extends Node2D

#onreadys

onready var cont_proyectiles:Node
onready var cont_meteoritos:Node

#exports
export var explosion:PackedScene = null

export var meteorito:PackedScene = null
export var explosion_meteorito:PackedScene = null


#Callbacks
func _ready():
	conectarSenales()
	crearContenedores()

#Funcs
func conectarSenales() -> void:
	Eventos.connect("proyectilDisparado",self,"_on_disparo")
	Eventos.connect("nave_destruida",self,"_on_Nave_Destruida")
	Eventos.connect("spawn_meteorito",self,"_on_spawn_meteoritos")
	Eventos.connect("meteorito_destruido",self,"_on_meteorito_destruido")

func crearContenedores() -> void:
	cont_proyectiles = Node.new()
	cont_proyectiles.name = "ContenedorProyectiles"
	add_child(cont_proyectiles)
	cont_meteoritos = Node.new()
	cont_meteoritos.name = "ContenedorMeteoritos"
	add_child(cont_meteoritos)
	
func _on_disparo(p:Proyectil):
	cont_proyectiles.add_child(p)

func _on_Nave_Destruida(pos:Vector2,num):
	for i in range(num):
		var new_expl:Node2D = explosion.instance()
		new_expl.global_position = pos
		add_child(new_expl)
		yield(get_tree().create_timer(0.6),"timeout")

func _on_spawn_meteoritos(pos_spawn:Vector2, dir_meteorito:Vector2, tamanio:float):
	var new_meteorito:Meteorito = meteorito.instance()
	new_meteorito.crear(
		pos_spawn,
		dir_meteorito,
		tamanio		
	)
	cont_meteoritos.add_child(new_meteorito)
func _on_meteorito_destruido(pos: Vector2):
	var new_explosion:ExplosionMeteorito = explosion_meteorito.instance()
	new_explosion.global_position = pos
	add_child(new_explosion)
