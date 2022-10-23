extends Node2D

onready var cont_proyectiles:Node

#Callbacks
func _ready():
	conectarSenales()
	crearContenedores()

#Funcs
func conectarSenales() -> void:
	Eventos.connect("proyectilDisparado",self,"_on_disparo")

func crearContenedores() -> void:
	cont_proyectiles = Node.new()
	cont_proyectiles.name = "ContenedorProyectiles"
	add_child(cont_proyectiles)
	
func _on_disparo(p:Proyectil):
	cont_proyectiles.add_child(p)
