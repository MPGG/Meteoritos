extends CanvasLayer

onready var info_zona_recarga:ContenedorInformacion = $InfoZonaRecarga
onready var info_meteoritos:ContenedorInformacion = $InfoMeteoritos
onready var info_tiempo_restante:ContenedorInformacion = $InfoTiempoRestante
onready var info_laser:ContenedorInformacionEnergia = $InfoLaser
onready var info_escudo:ContenedorInformacionEnergia = $InfoEscudo
func _ready():
	conectar_seniales()
	

func fade_in():
	$FadeCanvas/AnimationPlayer.play("fade_in")
func fade_out():
	$FadeCanvas/AnimationPlayer.play_backwards("fade_in")

func conectar_seniales():
# warning-ignore:return_value_discarded
	Eventos.connect("nivel_iniciado",self,"fade_out")
# warning-ignore:return_value_discarded
	Eventos.connect("nivel_terminado",self,"fade_in")
# warning-ignore:return_value_discarded
	Eventos.connect("detecto_zona_recarga",self,"_on_detecto_zona_recarga")
# warning-ignore:return_value_discarded
	Eventos.connect("cambio_numero_meteoritos",self,"_on_actualizar_info_meteoritos")
# warning-ignore:return_value_discarded
	Eventos.connect("actualizar_tiempo",self,"_on_actualizar_info_tiempo")
# warning-ignore:return_value_discarded
	Eventos.connect("cambio_energia_laser",self,"_on_actualizar_energia_laser")
# warning-ignore:return_value_discarded
	Eventos.connect("ocultar_energia_laser",info_laser,"ocultar")
# warning-ignore:return_value_discarded
	Eventos.connect("cambio_energia_escudo",self,"_on_actualizar_energia_escudo")
# warning-ignore:return_value_discarded
	Eventos.connect("ocultar_energia_escudo",info_escudo,"ocultar")
# warning-ignore:return_value_discarded
	Eventos.connect("nave_destruida",self,"_on_nave_destruida")
func _on_detecto_zona_recarga(en_zona:bool):
	if en_zona:
		info_zona_recarga.mostrar_suavizado()
	else:
		info_zona_recarga.ocultar_suavizado()
func _on_actualizar_info_meteoritos(numero:int):
	info_meteoritos.mostrar_suavizado()
	info_meteoritos.modificar_texto(
		"Meteoritos Restantes: {cant}".format({"cant":numero})
	)
func _on_actualizar_info_tiempo(t:int):
# warning-ignore:narrowing_conversion
	var minutos:int = floor(t * 0.01666)
	var segundos:int = t % 60
	info_tiempo_restante.modificar_texto("Tiempo restante: %02d:%02d" % [minutos,segundos])
	if t % 10 == 0:
		info_tiempo_restante.mostrar_suavizado()
	if t == 11:
		info_tiempo_restante.auto_ocultar = false
		#perdon pero muy al pedo un setter aca
	elif t == 0:
		info_tiempo_restante.ocultar()
func _on_actualizar_energia_laser(e_max:float,e_act:float):
	info_laser.mostrar()
	info_laser.actualizar_energia(e_max,e_act)
func _on_actualizar_energia_escudo(energia_max:float, energia_actual:float):
	info_escudo.mostrar()
	info_escudo.actualizar_energia(energia_max, energia_actual)
func _on_nave_destruida(nave:NaveBase, _pos,_expl):
	if nave is Player:
		get_tree().call_group("contenedor_info","set_esta_activo",false)
		get_tree().call_group("contenedor_info","ocultar")
