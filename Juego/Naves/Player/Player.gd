class_name Player
extends NaveBase

export var potencia_motor:int = 20
export var potencia_rotacion:int = 170
export var estela_maxima:int = 150

var empuje:Vector2 = Vector2.ZERO
var dir_rotacion:int = 0

onready var laser = $LaserBeam2D setget ,get_laser
onready var estela: Estela = $Pos2DTrailInicio2/Trail2D
onready var motor_sfx:Motor = $SfxMotor
onready var escudo:Escudo = $Escudo setget ,get_escudo

func get_laser() -> RayoLaser:
	return laser
func get_escudo() -> Escudo:
	return escudo

func _ready():
	DatosJuego.set_player_actual(self)

func _integrate_forces(_state) -> void:
	apply_central_impulse(empuje.rotated(rotation))
	apply_torque_impulse(dir_rotacion * potencia_rotacion)
	pass
func _process(_delta) -> void:
	playerInput()

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
func desactivar_controles():
	cambiar_estado(ESTADO.SPAWN)
	empuje = Vector2.ZERO
	motor_sfx.sonido_off()
	laser.set_is_casting(false)
