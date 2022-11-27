class_name BarraSalud
extends ProgressBar

onready var tween:Tween = $TweenVis

export var siempre_visible:bool = false
export var es_top_level:bool = false

func _ready():
	modulate = Color(1,1,1,siempre_visible)
	
	set_as_toplevel(es_top_level)
	if es_top_level:
		rect_global_position = owner.global_position + rect_position

func controlar_barra(hp_nave,mostrar):
	value = hp_nave
	
	if not tween.is_active() and modulate.a != int(mostrar):
# warning-ignore:return_value_discarded
		tween.interpolate_property(
			self,
			"modulate",
			Color(1,1,1,not mostrar),
			Color(1,1,1,mostrar),
			1.0,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN_OUT
		)
# warning-ignore:return_value_discarded
		tween.start()


func _on_TweenVis_tween_all_completed():
	if modulate.a == 1.0:
		controlar_barra(value,false)
		
func set_valores(hp:float):
	max_value = hp
	value = hp

func set_hitpoints_actual(hp:float):
	value = hp
