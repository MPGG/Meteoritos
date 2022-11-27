extends Node


export var tiempo_transicion:float = 4.0
export(float,-50.0,-20.0,5.0) var volumen_apagado = -40.0

onready var musica_nivel:AudioStreamPlayer = $MusicaNivel
onready var musica_combate:AudioStreamPlayer = $MusicaCombate
onready var tween_on = $TweenMusicOn
onready var tween_off = $TweenMusicOff
onready var lista_musicas:Dictionary = {
	"menu_principal": $MusicaMenuPrincipal
} setget ,get_lista_musicas


var vol_original_musica_off = 0.0

func get_lista_musicas() -> Dictionary:
	return lista_musicas

func set_streams(stream_musica:AudioStream, stream_combate:AudioStream):
	musica_nivel.stream = stream_musica
	musica_combate.stream = stream_combate
func play_musica_nivel():
	stop_todo()
	musica_nivel.play()
func play_musica(musica: AudioStreamPlayer):
	stop_todo()
	musica.play()
func stop_todo():
	for nodo in get_children():
		if nodo is AudioStreamPlayer:
			nodo.stop()
			
func transicion_musicas():
	if musica_nivel.playing:
		fade_in(musica_combate)
		fade_out(musica_nivel)
	else:
		fade_in(musica_nivel)
		fade_out(musica_combate)
		
func fade_in(mus:AudioStreamPlayer):
	var vol_orig = mus.volume_db
	mus.volume_db = volumen_apagado
	mus.play()
	tween_on.interpolate_property(
		mus,
		"volume_db",
		volumen_apagado,
		vol_orig,
		tiempo_transicion,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tween_on.start()
	
func fade_out(mus:AudioStreamPlayer):
	#var vol_orig = mus.volume_db
	mus.volume_db = volumen_apagado
	mus.play()
	tween_on.interpolate_property(
		mus,
		"volume_db",
		mus.volume_db,
		volumen_apagado,
		tiempo_transicion,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tween_on.start()


func _on_TweenMusicOff_tween_all_completed(obj:Object,_etc):
	obj.stop()
	obj.volume_db = vol_original_musica_off

func play_boton():
	$BotonMenu.play()
