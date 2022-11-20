extends Area2D
class_name Escudo

var esta_activado:bool = false setget, get_esta_activado
var energia_original:float

export var energia:float = 8.0
export var desgaste: float = -1.6

func _process(delta):
	controlar_energia(desgaste * delta)
	#energia += desgaste * delta
	if energia <= 0.0:
		#print("escudo.gd: sin energia, desactivando...")
		desactivar()

func _ready():
	energia_original = energia
	set_process(false)
	controlar_colisionador(true)
	

func controlar_colisionador(esta_desactivado:bool):
	$CollisionShape2D.set_deferred("disabled",esta_desactivado)

func activar():
	#print("Escudo.gd: activar")
	if energia <= 0.0:
		return
	esta_activado = true
	controlar_colisionador(false)
	$AnimationPlayer.play("activandose")

func desactivar():
	set_process(false)
	esta_activado = false
	controlar_colisionador(true)
	$AnimationPlayer.play_backwards("activandose")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "activandose" and esta_activado:
		$AnimationPlayer.play("activado")
		set_process(true)

func get_esta_activado() -> bool:
	return esta_activado


func _on_Escudo_area_entered(area):
	area.queue_free()

func controlar_energia(consumo:float):
	energia += consumo
	#print("Escudo.gd: Energia escudo: ", energia)
	
	if energia > energia_original:
		energia = energia_original
	elif energia <= 0.0:
		desactivar()
	Eventos.emit_signal("cambio_energia_escudo",energia_original,energia)
