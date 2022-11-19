extends NaveBase
class_name EnemigoBase

var player_objetivo:Player = null
var dir_player:Vector2
var frame_actual:int = 0

func _ready():
	player_objetivo = DatosJuego.get_player_actual()
# warning-ignore:return_value_discarded
	Eventos.connect("nave_destruida",self,"_on_nave_destruida")
	#canon.set_esta_disparando(true)
	
func _physics_process(_delta):
	frame_actual += 1
	if frame_actual % 3 == 0:
		rotar_hacia_player()
	
func _on_body_entered(body: Node):
	._on_Player_body_entered(body)
	if body is Player:
		body.destruirNave()
		destruirNave()		

func _on_nave_destruida(nave: NaveBase, _pos,_expl):
	if nave is Player:
		player_objetivo = null

func rotar_hacia_player():
	if player_objetivo:
		dir_player = player_objetivo.global_position - global_position
		rotation = dir_player.angle()
