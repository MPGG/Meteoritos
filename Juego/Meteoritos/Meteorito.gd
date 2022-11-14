extends RigidBody2D

class_name Meteorito

onready var impacto_sfx = $SFX_Impacto
onready var animator = $AnimationPlayer

export var vel_lineal_base:Vector2 = Vector2(300.0,300.0)
export var vel_ang_base:float = 3.0
export var hitpoints_base:float = 10.0

var hitpoints:float

func _ready():
	angular_velocity = vel_ang_base

func crear(pos:Vector2, dir: Vector2, tamanio:float):
	position = pos
	#Calcular masa, sprite, colisionador
	mass *= tamanio
	
	$Sprite.scale = Vector2.ONE * tamanio
	
	#radio = diametro / 2	
	var radio:int = int($Sprite.texture.get_size().x / 2.3 * tamanio)
	var forma_colision:CircleShape2D = CircleShape2D.new()
	forma_colision.radius = radio
	$CollisionShape2D.shape = forma_colision
	
	#Calcular velocidades
	linear_velocity = (vel_lineal_base * dir / tamanio) * random_vel()
	angular_velocity = (vel_ang_base / tamanio) * random_vel()
	
	#Hitpoints
	hitpoints = hitpoints_base * tamanio
	
	#Debug
	#print("Hitpoints: ", hitpoints)

func recibir_dmg(dmg:float):
	hitpoints -= dmg
	if hitpoints <= 0:
		destruir()
	animator.play("impact")
	impacto_sfx.play()

func destruir():
	$CollisionShape2D.set_deferred("disabled",true)
	#animator.play("destroy")
	Eventos.emit_signal("meteorito_destruido",global_position)
	queue_free()

func random_vel() -> float:
	randomize()
	return rand_range(1.1,1.4)