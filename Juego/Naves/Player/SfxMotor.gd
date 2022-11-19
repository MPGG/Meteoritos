class_name Motor
extends AudioStreamPlayer2D

export var tiempo_trans:float = 0.3
export var vol_apagado:float = -100.0

onready var tween_snd:Tween = $Tween

var vol_orig:float

func _ready():
	vol_orig = volume_db
	volume_db = vol_apagado
	

func sonido_on() -> void:
	if not playing:
		play()
	efecto_transicion(volume_db, vol_orig)

func sonido_off() -> void:
	efecto_transicion(volume_db, vol_apagado)
	
func efecto_transicion(desde_vol: float, hasta_vol: float) -> void:
# warning-ignore:return_value_discarded
	tween_snd.interpolate_property(
		self,
		"volume_db",
		desde_vol,
		hasta_vol,
		tiempo_trans,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT_IN
	)
# warning-ignore:return_value_discarded
	tween_snd.start()
