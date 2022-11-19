extends Area2D

var nave_player:Player = null
var player_en_zona :bool = false

func _on_AreaAtraccion_body_entered(body):
	if body is Player:
		nave_player = body
		player_en_zona = true
	
	body.set_gravity_scale(0.1)


func _on_AreaAtraccion_body_exited(body):
	body.set_gravity_scale(0.0) # Replace with function body.
	if body is Player:
		player_en_zona = false
