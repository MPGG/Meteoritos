extends Node

var player_actual: Player = null setget set_player_actual,get_player_actual
var lastPos:Vector2
func set_player_actual(player:Player):
	player_actual = player
func get_player_actual()->Player:
	return player_actual
	
func _ready():
# warning-ignore:return_value_discarded
	Eventos.connect("nave_destruida",self,"_on_nave_destruida")
func _on_nave_destruida(nave:NaveBase,_pos, _expl):
	if nave is Player:
		player_actual = null
