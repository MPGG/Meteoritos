class_name Canon
extends Node2D

#Export
export var proyectil:PackedScene = null
export var cadencia_disparo:float = 0.8
export var velocidad_proyectil:int =100
export var dmg_proyectil: int = 1

#Onready

onready var timer_enfriamiento:Timer = $TimerCooldown
onready var disparo_sfx = $DisparoSFX
onready var esta_enfriado:bool = true
onready var esta_disparando:bool = false setget set_esta_disparando

#Atts
var puntos_disparo:Array = []

#Set/gets

func set_esta_disparando(disparando: bool) -> void:
	esta_disparando = disparando

#callbacks

func _ready() ->void:
	almacenar_puntos_disparo()
	timer_enfriamiento.wait_time = cadencia_disparo
	
func _process(delta:float) -> void:
	if esta_disparando and esta_enfriado:
		disparar()

#funcs
func almacenar_puntos_disparo() -> void:
	for nodo in get_children():
		if nodo is Position2D:
			puntos_disparo.append(nodo)
 
func disparar() -> void:
	esta_enfriado = false
	disparo_sfx.play()
	timer_enfriamiento.start()
	for punto_disparo in puntos_disparo:
		var new_proyectil:Proyectil = proyectil.instance()
		new_proyectil.crear(
			punto_disparo.global_position,
			get_owner().rotation,
			velocidad_proyectil,
			dmg_proyectil
		)
		Eventos.emit_signal("proyectilDisparado",new_proyectil)
		print("disparanding")
	


func _on_TimerCooldown_timeout() -> void:
	esta_enfriado = true
