extends Position2D

export var direccion:Vector2 = Vector2(1,1)
export var rango_tamanio_meteorito:Vector2 = Vector2(0.5,2.2)

func _ready():
	pass
#	yield(owner, "ready")
#	spawnear_meteorito()

func spawnear_meteorito():
	Eventos.emit_signal("spawn_meteorito",
						global_position,
						direccion,
						tamanio_meteorito_random())

func tamanio_meteorito_random() -> float:
	randomize()
	return rand_range(rango_tamanio_meteorito[0], rango_tamanio_meteorito[1])
