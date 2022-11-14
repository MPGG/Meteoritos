extends Position2D

export var direccion:Vector2 = Vector2(1,1)

func _ready():
	yield(owner, "ready")
	spawnear_meteorito()

func spawnear_meteorito():
	Eventos.emit_signal("spawn_meteorito",global_position,direccion)
