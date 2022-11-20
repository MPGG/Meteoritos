class_name EnemigoInterceptor
extends EnemigoBase

enum ESTADO_IA{IDLE,ATACANDOQ,ATACANDOP,PERSECUCION}
var estado_ia_actual:int = ESTADO_IA.IDLE

export var potencia_max:float = 800.0

var potencia_actual:float = 0.0

func _ready():
	Eventos.emit_signal("minimapa_objeto_creado")

func _integrate_forces(state:Physics2DDirectBodyState):
	linear_velocity += dir_player.normalized() * potencia_actual * state.get_step()
	 
	linear_velocity.x = clamp(linear_velocity.x,-potencia_max,potencia_max)
	linear_velocity.y = clamp(linear_velocity.y,-potencia_max,potencia_max)

func controlador_estados_ia(nuevo_estado:int):
	match nuevo_estado:
		ESTADO_IA.IDLE:
			canon.set_esta_disparando(false)
			potencia_actual = 0.0
		ESTADO_IA.ATACANDOQ:
			canon.set_esta_disparando(true)
			potencia_actual = 0.0
		ESTADO_IA.ATACANDOP:
			canon.set_esta_disparando(true)
			potencia_actual = potencia_max
		ESTADO_IA.PERSECUCION:
			canon.set_esta_disparando(false)
			potencia_actual = potencia_max
		_:
			printerr("EnemigoInterceptor: Error de estado")



func _on_EnemigoInterceptor_body_entered(body):
	#print("asdasdasdasdadsda")
	_on_body_entered(body)


func _on_AreaDisparo_body_entered(_body):
	controlador_estados_ia(ESTADO_IA.ATACANDOP) # Replace with function body.


func _on_AreaDisparo_body_exited(_body):
	controlador_estados_ia(ESTADO_IA.PERSECUCION)


func _on_AreaDeteccion_body_entered(_body):
	controlador_estados_ia(ESTADO_IA.ATACANDOQ)


func _on_AreaDeteccion_body_exited(_body):
	controlador_estados_ia(ESTADO_IA.ATACANDOP)
