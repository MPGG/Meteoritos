extends Node2D

#onreadys

onready var cont_proyectiles:Node
onready var cont_meteoritos:Node
onready var camara_nivel:Camera2D = $CameraNivel
onready var contenedor_sector_meteoritos:Node
onready var camara_player =$Player/CameraPlayer
onready var contenedor_enemigos:Node
onready var actualizador_timer:Timer = $ActualizadorTimer
#exports
export var explosion:PackedScene = null
export var meteorito:PackedScene = null
export var explosion_meteorito:PackedScene = null
export var sector_meteoritos:PackedScene = null
export var enemigo_interceptor:PackedScene = null
export var rele_masa:PackedScene = null
export var tiempo_limite:int
export var mus_nivel:AudioStream = null
export var mus_combate:AudioStream = null

export(String, FILE, "*.tscn")var prox_nivel = ""



export var tiempo_transicion_camara:float = 1.6

var meteoritos_totales:int = 0
var player:Player = null
var numero_bases_enemigas:int = 0

#Callbacks
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	conectarSenales()
	crearContenedores()
	player = DatosJuego.get_player_actual()
	numero_bases_enemigas = contabilizar_bases_enemigas()
	Eventos.emit_signal("nivel_iniciado")
	actualizador_timer.start()
	Eventos.emit_signal("actualizar_tiempo",tiempo_limite)
	MusicaJuego.set_streams(mus_nivel,mus_combate)
	MusicaJuego.play_musica_nivel()
	

#Funcs
func conectarSenales() -> void:
# warning-ignore:return_value_discarded
	Eventos.connect("proyectilDisparado",self,"_on_disparo")
# warning-ignore:return_value_discarded
	Eventos.connect("nave_destruida",self,"_on_Nave_Destruida")
# warning-ignore:return_value_discarded
	Eventos.connect("spawn_meteorito",self,"_on_spawn_meteoritos")
# warning-ignore:return_value_discarded
	Eventos.connect("meteorito_destruido",self,"_on_meteorito_destruido")
# warning-ignore:return_value_discarded
	Eventos.connect("base_destruida",self,"_on_base_destruida")
# warning-ignore:return_value_discarded
	Eventos.connect("spawn_orbital",self,"_on_spawn_orbital")
# warning-ignore:return_value_discarded
	Eventos.connect("nave_en_sector_peligro",self,"_on_nave_en_sector_peligro")
# warning-ignore:return_value_discarded
	Eventos.connect("nivel_completado",self,"_on_nivel_completado")

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

func _on_nivel_completado():
	Eventos.emit_signal("nivel_terminado")
	yield(get_tree().create_timer(1.0),"timeout")
# warning-ignore:return_value_discarded
	get_tree().change_scene(prox_nivel)
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
		DatosJuego.lastPos = pos
		$RestartTimer.start()
	
# warning-ignore:unused_variable
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
		Eventos.emit_signal("cambio_numero_meteoritos",num_peligros)
	elif tipo_peligro == "Enemigo":
		crear_sector_enemigos(num_peligros)

func crear_sector_meteoritos(centro_camara:Vector2, numero_peligros:int):
	MusicaJuego.transicion_musicas()
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
# warning-ignore:unused_variable
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
	Eventos.emit_signal("cambio_numero_meteoritos",meteoritos_totales)
	#print("Nivel.gd:Metoeritos totales:" + str(meteoritos_totales))
	if meteoritos_totales == 0:
		MusicaJuego.transicion_musicas()
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



func _on_TweenCamara_tween_completed(object: Object, _key:NodePath):
	if object.name == "CameraPlayer":
		object.global_position = $Player.global_position

func crear_posicion_aleatoria(rango_h:float, rango_v:float) -> Vector2:
	randomize()
	var randx = rand_range(-rango_h, rango_h)
	var randy = rand_range(-rango_v,rango_v)
	return Vector2(randx,randy)
	
func _on_base_destruida(_base,pos_partes:Array):
	for pos in pos_partes:
		crear_explosion(pos)
		yield(get_tree().create_timer(0.5),"timeout")
	numero_bases_enemigas -= 1
	if numero_bases_enemigas == 0:
		crear_rele()
		
func crear_explosion(
	posicion:Vector2,
	numero:int = 1,
	intervalo:float = 0.0,
	rangos_aleatorios:Vector2 = Vector2(0.0,0.0)):
# warning-ignore:unused_variable
		for i in range(numero):
			var new_explosion:Node2D = explosion.instance()
			new_explosion.global_position = posicion + crear_posicion_aleatoria(
				rangos_aleatorios.x,
				rangos_aleatorios.y
			)
			add_child(new_explosion)
			yield(get_tree().create_timer(intervalo),"timeout")
	
func _on_spawn_orbital(enemigo: EnemigoOrbital):
	contenedor_enemigos.add_child(enemigo)

func contabilizar_bases_enemigas() -> int:
	return $ContenedorBasesEnemigas.get_child_count()
	
func crear_rele():
	var new_rele_masa:ReleDeMasa = rele_masa.instance()
	var pos_aleatoria:Vector2 = crear_posicion_aleatoria(400.0,200.0)
	var margen:Vector2 = Vector2(600.0,600.0)
	
	if pos_aleatoria.x < 0:
		margen.x *= -1
	if pos_aleatoria.y < 0:
		margen.y *= -1
	
	
	new_rele_masa.global_position = DatosJuego.lastPos + (margen+pos_aleatoria)
	add_child(new_rele_masa)


func _on_RestartTimer_timeout():
	Eventos.emit_signal("nivel_terminado")
	yield(get_tree().create_timer(1.0),"timeout")
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()

func destruir_nivel():
	crear_explosion(
		DatosJuego.lastPos,
		2,
		1.5,
		Vector2(300.0,200.0)
	)


func _on_ActualizadorTimer_timeout():
	tiempo_limite -= 1
	Eventos.emit_signal("actualizar_tiempo",tiempo_limite)
	if tiempo_limite == 0:
		destruir_nivel()
