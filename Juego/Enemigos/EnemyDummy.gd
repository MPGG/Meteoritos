extends Node2D


func _ready():
	pass


func _on_Area2D_body_entered(body):
	if body is Player:
		body.destruirNave() # Replace with function body.
