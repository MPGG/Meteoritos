class_name Proyectil
extends Area2D

#Atributos
var velocidad: Vector2 = Vector2.ZERO
var dmg: float

func _physics_process(delta):
	position += velocidad * delta

func crear(pos: Vector2, dir: float, vel:float, dmg: int):
		position = pos
		rotation = dir
		velocidad = Vector2(vel,0).rotated(dir)
		
		
func _ready():
	pass


func _on_VisibilityNotifier2D_screen_exited():
	queue_free() # Replace with function body.
