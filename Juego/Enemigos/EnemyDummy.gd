extends Node2D

var hp: float = 10.0


func _ready():
	pass


func _on_Area2D_body_entered(body):
	if body is Player:
		body.destruirNave() # Replace with function body.

func recibir_dmg(dmg):
	hp -= dmg
	if hp <= 0.0:
		#destruir
		queue_free()

func _process(delta):
	$Canon.set_esta_disparando(true)
