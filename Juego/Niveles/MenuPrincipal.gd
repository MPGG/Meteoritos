extends Node

export(String, FILE, "*.tscn")var nivel_inicial = ""

func _ready():
	MusicaJuego.play_musica(MusicaJuego.get_lista_musicas().menu_principal)


func _on_Button_pressed():
	MusicaJuego.play_boton()
# warning-ignore:return_value_discarded
	get_tree().change_scene(nivel_inicial)


func _on_ButtonSalir_pressed():
	get_tree().quit() # Replace with function body.
