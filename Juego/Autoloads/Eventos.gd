extends Node

# warning-ignore:unused_signal
signal proyectilDisparado(proyectil)
# warning-ignore:unused_signal
signal nave_destruida(nave, posicion, explosiones)
# warning-ignore:unused_signal
signal spawn_meteorito(global_position,direccion,tamanio)
# warning-ignore:unused_signal
signal meteorito_destruido(pos)
# warning-ignore:unused_signal
signal nave_en_sector_peligro(centro_camara,tipo_peligro,num_peligros)
# warning-ignore:unused_signal
signal base_destruida(base, posiciones)

signal spawn_orbital(orbital)

signal nivel_iniciado()
signal nivel_terminado()
signal detecto_zona_recarga(entrando)

signal cambio_numero_meteoritos(num)

signal actualizar_tiempo(tiempo_restante)

signal cambio_energia_laser(energia_max,energia_actual)
signal ocultar_energia_laser()

signal cambio_energia_escudo(emax,eact)
signal ocultar_energia_escudo()

signal minimapa_objeto_creado()
signal minimapa_objeto_destruido(obj)

signal nivel_completado()
