class_name BaseEnemiga
extends Node2D

export var hitpoints:float = 50.0
export var orbital:PackedScene = null
export var numero_orbitales:int = 6
export var intervalo_spawn:float = 1.8
export(Array,PackedScene) var rutas

onready var impacto_sfx:AudioStreamPlayer2D = $ImpactoSFX
onready var timer_spawner:Timer = $TimerSpawnerEnemigos

var esta_destruida:bool = false
var posicion_spawn:Vector2 = Vector2.ZERO
var ruta_seleccionada:Path2D

func _ready():
	timer_spawner.wait_time = intervalo_spawn
	$AnimationPlayer.play(elegir_animacion_aleatoria())
	$BarraSalud.set_valores(hitpoints)
	seleccionar_ruta()

# warning-ignore:unused_argument
func _process(delta):
	var player_objetivo:Player = DatosJuego.get_player_actual()
	if not player_objetivo:
		return
	
	var dir_player:Vector2 = player_objetivo.global_position - global_position
# warning-ignore:unused_variable
	var angulo_player:float = rad2deg(dir_player.angle())
	#print("BaseEnemiga: anguloPlayer:",angulo_player)
	

func elegir_animacion_aleatoria()->String:
	randomize()
	var num_anim:int = $AnimationPlayer.get_animation_list().size() -1
	var indice_anim_aleatoria:int = randi() % num_anim + 1
	var lista_animacion:Array = $AnimationPlayer.get_animation_list()
	return lista_animacion[indice_anim_aleatoria]
func recibir_dmg(dmg:float):
	hitpoints -= dmg
	
	if hitpoints <= 0 and not esta_destruida:
		esta_destruida = true
		destruir()
		
	$BarraSalud.set_hitpoints_actual(hitpoints)
	impacto_sfx.play()

func destruir():
	var posicion_partes = []
	for parte in $Sprites.get_children():
		posicion_partes.append(parte.global_position)
	Eventos.emit_signal("base_destruida",self,posicion_partes)
	Eventos.emit_signal("minimapa_objeto_destruido",self)
	queue_free()

func _on_AreaColision_body_entered(body):
	if body.has_method("destruir"):
		body.destruir()
	elif body.has_method("destruirNave"):
		body.destruirNave()

func spawnear_orbital():
	numero_orbitales -= 1
	#var pos_spawn:Vector2 = deteccion_cuadrante()
	ruta_seleccionada.global_position = global_position
	
	var new_orbital:EnemigoOrbital = orbital.instance()
	new_orbital.create(
		global_position + posicion_spawn,
		self,
		ruta_seleccionada
		)
	Eventos.emit_signal("spawn_orbital",new_orbital)

func deteccion_cuadrante() -> Vector2:
	var player_objetivo:Player = DatosJuego.get_player_actual()
	
	if not player_objetivo:
		return Vector2.ZERO
	
	var dir_player:Vector2 = player_objetivo.global_position - global_position
	var angulo_player:float = rad2deg(dir_player.angle())
	
	if abs(angulo_player) <= 45.0:
		ruta_seleccionada.rotation_degrees = 180.0
		return $PosicionesSpawn/Este.position
	elif abs(angulo_player) > 135.0 and abs(angulo_player) <= 180:
		ruta_seleccionada.rotation_degrees = 0.0
		return $PosicionesSpawn/Oeste.position
	elif abs(angulo_player) > 45.0 and abs(angulo_player) <= 135.0:
		if sign(angulo_player) > 0:
			ruta_seleccionada.rotation_degrees = 270.0
			return $PosicionesSpawn/Sur.position
		else:
			ruta_seleccionada.rotation_degrees = 90.0
			return $PosicionesSpawn/Norte.position
		
		
	return $PosicionesSpawn/Norte.position
	
func seleccionar_ruta():
	randomize()
	var indice_ruta:int = randi() % rutas.size() - 1
	ruta_seleccionada = rutas[indice_ruta].instance()
	add_child(ruta_seleccionada)

func _on_VisibilityNotifier2D_screen_entered():
	#Spawnear orbitales...
	$VisibilityNotifier2D.queue_free()
	
	posicion_spawn = deteccion_cuadrante()
	spawnear_orbital()
	timer_spawner.start()
#	var new_orbital:EnemigoOrbital = orbital.instance()
#	new_orbital.create(
#		global_position + $PosicionesSpawn/Norte.global_position,
#		self
#	)
#	Eventos.emit_signal("spawn_orbital",new_orbital)


func _on_TimerSpawnerEnemigos_timeout():
	if numero_orbitales == 0:
		timer_spawner.stop()
		return
	spawnear_orbital()
