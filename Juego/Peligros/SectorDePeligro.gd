extends Area2D

export(String, "vacio", "Meteorito", "Enemigo")var tipo_peligro
export var numero_peligros:int = 10


func _on_body_entered(_body:Node):
	$CollisionShape2D.set_deferred("disabled",true)
	yield(get_tree().create_timer(0.1),"timeout")
	enviar_senial()
func enviar_senial():
	Eventos.emit_signal(
		"nave_en_sector_peligro",
		$Position2D.global_position,
		tipo_peligro,
		numero_peligros
	)
	queue_free()

