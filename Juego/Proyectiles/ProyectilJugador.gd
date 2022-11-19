class_name Proyectil
extends Area2D

#Atributos
var velocidad: Vector2 = Vector2.ZERO
var dmg: float = 3.0

func _physics_process(delta):
	position += velocidad * delta

func crear(pos: Vector2, dir: float, vel:float, _dmg: int):
		position = pos
		rotation = dir
		velocidad = Vector2(vel,0).rotated(dir)
		
		
func _ready():
	pass


func _on_VisibilityNotifier2D_screen_exited():
	queue_free() # Replace with function body.


func hacer_dmg(otro_cuerpo: CollisionObject2D):
	if otro_cuerpo.has_method("recibir_dmg"):
		otro_cuerpo.recibir_dmg(dmg)
	queue_free()

func _on_ProyectilJugador_area_entered(area: Area2D) -> void:
	hacer_dmg(area)
	#print("proyectil area ent:" + area.name)
	
func _on_ProyectilJugador_body_entered(body):
	hacer_dmg(body)
	#print("proyectil body ent:" + body.name)
