class_name CamaraJuego
extends Camera2D

onready var tween_zoom:Tween = $TweenZoom

var zoom_original:Vector2
var puede_hacer_zoom:bool = true setget set_puede_hacer_zoom

func _ready():
	zoom_original = zoom
	
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
