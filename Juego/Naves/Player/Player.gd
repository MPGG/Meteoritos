class_name Player
extends RigidBody2D

#Exports
export var potencia_motor:int = 20
export var potencia_rotacion:int = 170
export var estela_maxima:int = 150
export var hitpoints:float = 100.0

#Enum
enum ESTADO {SPAWN, VIVO, INVENCIBLE, MUERTO}

#Atributos
var empuje:Vector2 = Vector2.ZERO
var dir_rotacion:int = 0
var estado_actual:int = ESTADO.SPAWN

#Onreadys
onready var canon = $Canon
onready var laser = $LaserBeam2D
onready var estela: Estela = $Pos2DTrailInicio/Trail2D
onready var motor_sfx:Motor = $SfxMotor
onready var hit_sfx:AudioStreamPlayer = $SfxHit
onready var colisionador: CollisionShape2D = $CollisionShape2D
onready var escudo:Escudo = $Escudo

#Callbacks
func _ready() -> void:
	cambiar_estado(estado_actual)
	
func _unhandled_input(event) -> void:
	if not esta_input_activo():
		return
	if event.is_action_pressed("fire2"):
		laser.set_is_casting(true)
	if event.is_action_released("fire2"):
		laser.set_is_casting(false)
	
	if event.is_action_pressed("moveForward"):
		estela.s_max_points(estela_maxima)
		motor_sfx.sonido_on()
	elif event.is_action_pressed("moveBackwards"):
		estela.s_max_points(0)
		motor_sfx.sonido_on()
	
	if (event.is_action_released("moveForward") or event.is_action_released("moveBackwards")):
		motor_sfx.sonido_off()
	if (event.is_action_pressed("shield") and not escudo.get_esta_activado()):
		escudo.activar()

func _integrate_forces(state) -> void:
	apply_central_impulse(empuje.rotated(rotation))
	apply_torque_impulse(dir_rotacion * potencia_rotacion)
	pass
func _process(delta) -> void:
	playerInput()

#Funcs
func cambiar_estado(estado: int) -> void:
	match estado:
		ESTADO.SPAWN:
			colisionador.set_deferred("disabled", true)
			canon.set_puede_disparar(false)
		ESTADO.VIVO:
			colisionador.set_deferred("disabled", false)
			canon.set_puede_disparar(true)
		ESTADO.INVENCIBLE:
			colisionador.set_deferred("disabled", true)
		ESTADO.MUERTO:
			colisionador.set_deferred("disabled",true)
			canon.set_puede_disparar(true)
			Eventos.emit_signal("nave_destruida",global_position,3)
			queue_free()
		_:
			printerr("Error de estado de jugador")
	estado_actual = estado

func playerInput() -> void:
	if not esta_input_activo():
		return
	empuje = Vector2.ZERO
	if Input.is_action_pressed("moveForward"):
		empuje = Vector2(potencia_motor,0)
	elif Input.is_action_pressed("moveBackwards"):
		empuje = Vector2(-potencia_motor,0)
	
	dir_rotacion = 0
	if Input.is_action_pressed("turnRight"):
		dir_rotacion += 1
	elif Input.is_action_pressed("turnLeft"):
		dir_rotacion += -1
	
	if Input.is_action_pressed("fire"):
		canon.set_esta_disparando(true)
	if Input.is_action_just_released("fire"):
		canon.set_esta_disparando(false)
func esta_input_activo() -> bool:
	if estado_actual in [ESTADO.MUERTO, ESTADO.SPAWN]:
		return false
	return true

func destruirNave():
	cambiar_estado(ESTADO.MUERTO)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "spawn":
		cambiar_estado(ESTADO.VIVO)
func recibir_dmg(dmg:float):
	hitpoints -= dmg
	if hitpoints <= 0:
		destruirNave()
	hit_sfx.play()


func _on_Player_body_entered(body):
	if body is Meteorito:
		body.destruir()
		destruirNave()
