extends MarginContainer

export var escala_zoom:float = 4.0
export var tiempo_visible:float = 5.0

var escala_grilla:Vector2
var player:Player = null
var esta_visible:bool = true setget set_esta_visible

onready var zona_renderizado:TextureRect = $CuadroMinimapa/ContenedorIconos/ZonaRenderizadoMinimapa
onready var icono_player:Sprite = $CuadroMinimapa/ContenedorIconos/ZonaRenderizadoMinimapa/IPlayer

onready var icono_base:Sprite = $CuadroMinimapa/ContenedorIconos/ZonaRenderizadoMinimapa/IBaseEnemiga
onready var icono_estacion: Sprite = $CuadroMinimapa/ContenedorIconos/ZonaRenderizadoMinimapa/IEstacion
onready var icono_interceptor:Sprite = $CuadroMinimapa/ContenedorIconos/ZonaRenderizadoMinimapa/IInterceptor
onready var icono_rele:Sprite = $CuadroMinimapa/ContenedorIconos/ZonaRenderizadoMinimapa/IRele
onready var items_mini_mapa:Dictionary = {}

func set_esta_visible(vis):
	if vis:
		$TimerInvisibilidad.start()
	esta_visible = vis
	$TweenInvisibilidad.interpolate_property(
		self,
		"modulate",
		Color(1,1,1,not vis),
		Color(1,1,1,vis),
		0.5,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	$TweenInvisibilidad.start()


func _ready():
	#set_process(false)
	icono_player.position = zona_renderizado.rect_size * 0.5
	escala_grilla = zona_renderizado.rect_size / (get_viewport_rect().size * escala_zoom)
	conectar_seniales()
	

func _process (delta: float):
	if not player:
		return
	icono_player.rotation_degrees = player.rotation_degrees + 90
	modificar_posicion_iconos()

func _on_nivel_iniciado():
	player = DatosJuego.get_player_actual()
	obtener_objetos_minimapa()
	set_process(true)
	
func conectar_seniales():
	Eventos.connect("nivel_iniciado", self, "_on_nivel_iniciado") 
	Eventos.connect("nave_destruida", self, "on_nave_destruida")
	Eventos.connect("minimapa_objeto_creado",self,"obtener_objetos_minimapa")
	Eventos.connect("minimapa_objeto_destruido",self,"quitar_icono")
func modificar_posicion_iconos():
	for i in items_mini_mapa:
		var item_icono = items_mini_mapa[i]
		var offset_pos:Vector2 = i.position - player.position
		#var pos_icono:Vector2 = offset_pos * escala_grilla + (zona_renderizado.rect_size * 0.5)
		var pos_icono:Vector2 = offset_pos * escala_grilla + icono_player.position
		pos_icono.x = clamp(pos_icono.x, 0,zona_renderizado.rect_size.x)
		pos_icono.y = clamp(pos_icono.y, 0,zona_renderizado.rect_size.y)
		item_icono.position = pos_icono
		
		if zona_renderizado.get_rect().has_point(pos_icono - zona_renderizado.rect_position):
			item_icono.scale = Vector2(0.5,0.5)
		else:
			item_icono.scale = Vector2(0.3,0.3)

func _on_nave_destruida(nave: NaveBase, _posicion, _explosiones):
	if nave is Player:
		player = null

func obtener_objetos_minimapa():
	var objetos_en_ventana: Array = get_tree().get_nodes_in_group("minimapa")
	for objeto in objetos_en_ventana:
		if not items_mini_mapa.has(objeto):
			var sprite_icono:Sprite
			if objeto is BaseEnemiga:
				sprite_icono = icono_base.duplicate()
			elif objeto is EstacionRecarga:
				sprite_icono = icono_estacion.duplicate()
			elif objeto is EnemigoInterceptor:
				sprite_icono = icono_interceptor.duplicate()
			elif objeto is ReleDeMasa:
				sprite_icono = icono_rele.duplicate()
			else:
				continue
			items_mini_mapa[objeto] = sprite_icono
			items_mini_mapa[objeto].visible = true
			zona_renderizado.add_child(items_mini_mapa[objeto])

func quitar_icono(obj:Node2D):
	if obj in items_mini_mapa:
		items_mini_mapa[obj].queue_free()
		items_mini_mapa.erase(obj)


func _on_TimerInvisibilidad_timeout():
	if esta_visible:
		set_esta_visible(false)
