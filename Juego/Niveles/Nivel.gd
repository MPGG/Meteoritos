extends Node2D

#onreadys
onready var cont_proyectiles:Node

#exports
export var explosion:PackedScene = null

#Callbacks
func _ready():
	conectarSenales()
	crearContenedores()

#Funcs
func conectarSenales() -> void:
	Eventos.connect("proyectilDisparado",self,"_on_disparo")
	Eventos.connect("nave_destruida",self,"_on_Nave_Destruida")

func crearContenedores() -> void:
	cont_proyectiles = Node.new()
	cont_proyectiles.name = "ContenedorProyectiles"
	add_child(cont_proyectiles)
	
func _on_disparo(p:Proyectil):
	cont_proyectiles.add_child(p)

func _on_Nave_Destruida(pos:Vector2,num):
	for i in range(num):
		var new_expl:Node2D = explosion.instance()
		new_expl.global_position = pos
		add_child(new_expl)
		yield(get_tree().create_timer(0.6),"timeout")
