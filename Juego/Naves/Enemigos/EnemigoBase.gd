extends NaveBase
class_name EnemigoBase

func _ready():
	canon.set_esta_disparando(true)

func _on_body_entered(body: Node):
	._on_Player_body_entered(body)
	if body is Player:
		body.destruirNave()
		destruirNave()		
