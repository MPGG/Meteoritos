class_name NaveBase
extends RigidBody2D

#Exports

export var hitpoints:float = 100.0

#Enum
enum ESTADO {SPAWN, VIVO, INVENCIBLE, MUERTO}

#Atributos

var estado_actual:int = ESTADO.SPAWN

#Onreadys
onready var colisionador: CollisionShape2D = $CollisionShape2D
onready var hit_sfx:AudioStreamPlayer = $SfxHit
onready var canon = $Canon



#Callbacks
func _ready() -> void:
	cambiar_estado(estado_actual)
	



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
			canon.set_puede_disparar(false)
			Eventos.emit_signal("nave_destruida",self, global_position,3)
			queue_free()
		_:
			printerr("Error de estado de jugador")
	estado_actual = estado


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
