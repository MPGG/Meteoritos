class_name CameraPlayer
extends CamaraJuego

export var variacion_zoom:float = 0.1
export var zoom_min:float = 0.8
export var zoom_max:float = 1.5


func _unhandled_input(event):
	if event.is_action_pressed("zoom_in"):
		controlar_zoom(-variacion_zoom)
	elif event.is_action_pressed("zoom_out"):
		controlar_zoom(variacion_zoom)

func controlar_zoom(mod_zoom:float):
	zoom.x = clamp(zoom.x + mod_zoom,zoom_min,zoom_max)
	zoom.y = clamp(zoom.y + mod_zoom,zoom_min,zoom_max)
	zoom_suavizado(zoom.x,zoom.y,0.15)
	

