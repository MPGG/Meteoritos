extends Node2D

#onreadys

onready var cont_proyectiles:Node
onready var cont_meteoritos:Node
onready var camara_nivel:Camera2D = $CameraNivel
onready var contenedor_sector_meteoritos:Node
onready var camara_player =$Player/CameraPlayer
onready var contenedor_enemigos:Node
#exports
export var explosion:PackedScene = null
export var meteorito:PackedScene = null
export var explosion_meteorito:PackedScene = null
export var sector_meteoritos:PackedScene = null
export var enemigo_interceptor:PackedScene = null


export var tiempo_transicion_camara:float = 1.6

var meteoritos_totales:int = 0
var player:Player = null

#Callbacks
func _ready():
	conectarSenales()
	crearContenedores()
	player = DatosJuego.get_player_actual()

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
	contenedor_enemigos = Node.new()
	contenedor_enemigos.name = "ContenedorEnemigos"
	add_child(contenedor_enemigos)
	
func _on_disparo(p:Proyectil):
	cont_proyectiles.add_child(p)

func _on_Nave_Destruida(nave: Player, pos:Vector2,num):
	if nave is Player:
		transicion_camaras(
			pos,
			pos + crear_posicion_aleatoria(-200.0,200),
			camara_nivel,
			tiempo_transicion_camara
		)
	
	for i in range(num):
		var new_expl:Node2D = explosion.instance()
		new_expl.global_position = pos + crear_posicion_aleatoria(-50.0,50.0)
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
	
	controlar_meteoritos_restantes()

func _on_nave_en_sector_peligro(centro_cam:Vector2, tipo_peligro:String, num_peligros:int):
	if tipo_peligro == "Meteorito":
		crear_sector_meteoritos(centro_cam, num_peligros)
	elif tipo_peligro == "Enemigo":
		crear_sector_enemigos(num_peligros)

func crear_sector_meteoritos(centro_camara:Vector2, numero_peligros:int):
	meteoritos_totales = numero_peligros
	var new_sector_meteoritos:SectorMeteoritos = sector_meteoritos.instance()
	new_sector_meteoritos.crear(centro_camara, numero_peligros)
	camara_nivel.global_position = centro_camara
	#camara_nivel.current = true
	contenedor_sector_meteoritos.add_child(new_sector_meteoritos)
	camara_nivel.devolver_zoom_original()
	transicion_camaras(
		camara_player.global_position,
		camara_nivel.global_position,
		camara_nivel,
		tiempo_transicion_camara
	)
func crear_sector_enemigos(num_enemigos:int):
	for i in range(num_enemigos):
		var new_interceptor:EnemigoInterceptor = enemigo_interceptor.instance()
		var spawn_pos:Vector2 = crear_posicion_aleatoria(1000.0,800.0)
		new_interceptor.global_position = player.global_position + spawn_pos
		contenedor_enemigos.add_child(new_interceptor)

func transicion_camaras(desde:Vector2, hasta:Vector2, camara_actual:Camera2D, tiempo_transicion:float):
	$TweenCamara.interpolate_property(
		camara_actual,
		"global_position",
		desde,
		hasta,
		tiempo_transicion,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	camara_actual.current = true
	$TweenCamara.start()

func controlar_meteoritos_restantes():
	meteoritos_totales -= 1
	#print("Nivel.gd:Metoeritos totales:" + str(meteoritos_totales))
	if meteoritos_totales == 0:
		contenedor_sector_meteoritos.get_child(0).queue_free()
		camara_player.set_puede_hacer_zoom(true)
		var zoom_actual = camara_player.zoom
		camara_player.zoom_suavizado(zoom_actual.x,zoom_actual.y,1.0)
		transicion_camaras(
			camara_nivel.global_position,
			camara_player.global_position,
			camara_player,
			tiempo_transicion_camara * 0.1
		)



func _on_TweenCamara_tween_completed(object: Object, key:NodePath):
	if object.name == "CameraPlayer":
		object.global_position = $Player.global_position

func crear_posicion_aleatoria(rango_h:float, rango_v:float) -> Vector2:
	randomize()
	var randx = rand_range(-rango_h, rango_h)
	var randy = rand_range(-rango_v,rango_v)
	return Vector2(randx,randy)
	
