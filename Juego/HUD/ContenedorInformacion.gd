class_name ContenedorInformacion
extends NinePatchRect

export var auto_ocultar:bool = false

onready var texto_contenedor:Label = $Label
onready var auto_ocultar_timer = $AutoOcultarTimer
onready var animaciones:AnimationPlayer = $AnimationPlayer

var esta_activo:bool = true setget set_esta_activo

func set_esta_activo(valor:bool):
	esta_activo = valor

func mostrar():
	if esta_activo:
		$AnimationPlayer.play("mostrar")
func ocultar():
	if not esta_activo:
		$AnimationPlayer.stop()
	$AnimationPlayer.play("ocultar")
func mostrar_suavizado():
	if not esta_activo:
		return
	$AnimationPlayer.play("mostrar_suavizado")
	if auto_ocultar:
		auto_ocultar_timer.start()
func ocultar_suavizado():
	if esta_activo:
		$AnimationPlayer.play("ocultar_suavizado")
func modificar_texto(text:String):
	texto_contenedor.text = text



func _on_AutoOcultarTimer_timeout():
	ocultar_suavizado()
