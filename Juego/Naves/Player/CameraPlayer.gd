extends Camera2D
class_name CameraPlayer

export var variacion_zoom:float = 0.1
export var zoom_min:float = 0.8
export var zoom_max:float = 1.5

onready var tween_zoom:Tween = $TweenZoom

var zoom_original:Vector2
var puede_hacer_zoom:bool = true setget set_puede_hacer_zoom

func _ready():
	zoom_original = zoom

func _unhandled_input(event):
	if event.is_action_pressed("zoom_in"):
		controlar_zoom(-variacion_zoom)
	elif event.is_action_pressed("zoom_out"):
		controlar_zoom(variacion_zoom)

func controlar_zoom(mod_zoom:float):
	zoom.x += clamp(zoom.x + mod_zoom,zoom_min,zoom_max)
	zoom.y += clamp(zoom.y + mod_zoom,zoom_min,zoom_max)
	zoom_suavizado(zoom.x,zoom.y,0.15)
	
func zoom_suavizado(zoomN_x:float,zoomN_y:float,tiempo_transicion:float):
	tween_zoom.interpolate_property(
		self,
		"zoom",
		zoom,
		Vector2(zoomN_x,zoomN_y),
		tiempo_transicion,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tween_zoom.start()

func devolver_zoom_original():
	puede_hacer_zoom = false
	zoom_suavizado(zoom_original.x,zoom_original.y,1.0)

func set_puede_hacer_zoom(puede:bool):
	puede_hacer_zoom = puede
