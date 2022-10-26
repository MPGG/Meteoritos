class_name Player
extends RigidBody2D

#Exports
export var potencia_motor:int = 20
export var potencia_rotacion:int = 170

#Atributos
var empuje:Vector2 = Vector2.ZERO
var dir_rotacion:int = 0

#Onreadys
onready var canon = $Canon
onready var laser = $LaserBeam2D

#Metodos

func _unhandled_input(event) -> void:
	if event.is_action_pressed("fire2"):
		laser.set_is_casting(true)
	if event.is_action_released("fire2"):
		laser.set_is_casting(false)

func _integrate_forces(state) -> void:
	apply_central_impulse(empuje.rotated(rotation))
	apply_torque_impulse(dir_rotacion * potencia_rotacion)
	pass
func _process(delta) -> void:
	playerInput()
	
func playerInput() -> void:
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
