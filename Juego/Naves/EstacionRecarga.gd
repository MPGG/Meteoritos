class_name EstacionRecarga
extends Node2D

export var energia:float = 6.0
export var radio_energia_entregada:float = 0.05

var nave_player:Player = null
var player_en_zona:bool = false

onready var sfx_carga:AudioStreamPlayer = $CargaSFX

func _unhandled_input(event):
	if not puede_recargar(event):
		return
		
	controlar_energia()
	
	#print("EstacionRecarga.gd: Energia Estacion: ",energia)
	if event.is_action("recargar_escudo"):
		nave_player.get_escudo().controlar_energia(radio_energia_entregada)
	elif event.is_action("recargar_laser"):
		nave_player.get_laser().controlar_energia(radio_energia_entregada)
	if event.is_action_released("recargar_escudo"):
		Eventos.emit_signal("ocultar_energia_laser")
	elif event.is_action_released("recarga_escudo"):
		Eventos.emit_signal("ocultar_energia_escudo")

func _on_AreaColision_body_entered(body: Node):
	if body.has_method("destruir"):
		body.destruir()
	if body.has_method("destruirNave"):
		body.destruirNave()

func controlar_energia():
	energia -= radio_energia_entregada
	if energia <= 0.0:
		$VacioSFX.play()


func _on_AreaRecarga_body_entered(body):
	if body is Player:
		nave_player = body
		player_en_zona = true
		Eventos.emit_signal("detecto_zona_recarga",true)
	
	body.set_gravity_scale(0.1)


func _on_AreaRecarga_body_exited(body):
	body.set_gravity_scale(0.0) # Replace with function body.
	if body is Player:
		player_en_zona = false
		Eventos.emit_signal("detecto_zona_recarga",false)

func puede_recargar(event)->bool:
	var hay_input = event.is_action("recargar_escudo") or event.is_action("recargar_laser")
	if hay_input and player_en_zona and energia > 0.0:
		if !sfx_carga.playing:
			sfx_carga.play()
		return true
	return false
