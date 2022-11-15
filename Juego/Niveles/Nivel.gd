extends Node2D

#onreadys

onready var cont_proyectiles:Node
onready var cont_meteoritos:Node
onready var camara_nivel:Camera2D = $CameraNivel
onready var contenedor_sector_meteoritos:Node
#exports
export var explosion:PackedScene = null
export var meteorito:PackedScene = null
export var explosion_meteorito:PackedScene = null
export var sector_meteoritos:PackedScene = null

export var tiempo_transicion_camara:float = 1.6




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
	Eventos.connect("nave_en_sector_peligro",self,"_on_nave_en_sector_peligro")

func crearContenedores() -> void:
	cont_proyectiles = Node.new()
	cont_proyectiles.name = "ContenedorProyectiles"
	add_child(cont_proyectiles)
	cont_meteoritos = Node.new()
	cont_meteoritos.name = "ContenedorMeteoritos"
	add_child(cont_meteoritos)
	contenedor_sector_meteoritos = Node.new()
	contenedor_sector_meteoritos.name = "ContenedorSectorMeteoritos"
	add_child(contenedor_sector_meteoritos)
	
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

func _on_nave_en_sector_peligro(centro_cam:Vector2, tipo_peligro:String, num_peligros:int):
	if tipo_peligro == "Meteorito":
		crear_sector_meteoritos(centro_cam, num_peligros)
		pass
	elif tipo_peligro == "Enemigo":
		#Como arriba
		pass

func crear_sector_meteoritos(centro_camara:Vector2, numero_peligros:int):
	var new_sector_meteoritos:SectorMeteoritos = sector_meteoritos.instance()
	new_sector_meteoritos.crear(centro_camara, numero_peligros)
	camara_nivel.global_position = centro_camara
	#camara_nivel.current = true
	contenedor_sector_meteoritos.add_child(new_sector_meteoritos)
	transicion_camaras(
		$Player/Camera2D.global_position,
		camara_nivel.global_position,
		camara_nivel
	)

func transicion_camaras(desde:Vector2, hasta:Vector2, camara_actual:Camera2D):
	$TweenCamara.interpolate_property(
		camara_actual,
		"global_position",
		desde,
		hasta,
		tiempo_transicion_camara,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	camara_actual.current = true
	$TweenCamara.start()
