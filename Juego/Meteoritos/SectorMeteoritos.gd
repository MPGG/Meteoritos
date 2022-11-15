extends Node2D
class_name SectorMeteoritos

#export var cant_meteoritos:int = 10
var cant_meteoritos:int = 10
var intervalo_spawn:float = 1.2
var spawners:Array

func crear(pos: Vector2, meteoritos:int):
	global_position = pos
	cant_meteoritos = meteoritos

func _ready():
	almacenar_spawners()
	conectar_seniales_detectores()

func almacenar_spawners():
	for spawner in $Spawners.get_children():
		spawners.append(spawner)
func spawner_random() -> int:
	randomize()
	return randi() %spawners.size()

func conectar_seniales_detectores():
	for detector in $SensoresRespawn.get_children():
		detector.connect("body_entered",self,"_on_detector_body_entered")
		
func _on_Timer_timeout():
	if cant_meteoritos == 0:
		$Timer.stop()
		return
	
	spawners[spawner_random()].spawnear_meteorito()
	cant_meteoritos -= 1
	
func _on_detector_body_entered(body: Node):
	body.set_esta_en_sector(false)
