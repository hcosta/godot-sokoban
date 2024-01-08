extends Node

func _ready() -> void:
	# Al inicializar el controlador, se buscan todos los objetos Target en la escena.
	# Se asume que cada objeto Target ha sido asignado al grupo "targets" para poder identificarlos.
	# Se recorren todos estos Targets para conectar su señal de cambio ('target_done_changed') al método correspondiente en este script.
	var targets = get_tree().get_nodes_in_group("targets")
	for target in targets:
		# Conecta la señal 'target_done_changed' de cada Target a la función '_on_Target_done_changed' en este script.
		# Esto permite que el controlador responda cada vez que un Target cambia su estado de completado.
		target.connect("target_done_changed", _on_Target_done_changed)

func _on_Target_done_changed(is_done):
	# Esta función se llama cada vez que un Target emite la señal 'target_done_changed'.
	# 'is_done' es un booleano que indica si el Target está en estado completado (true) o no (false).
	print("Target event")  # Imprime un mensaje cada vez que un Target cambia de estado.
	# Si el Target está completado ('is_done' es true), verifica si todos los Targets están completados.
	if is_done and are_all_targets_done():
		# Si todos los Targets están completados, imprime "Level completed".
		print("Level completed")

func are_all_targets_done() -> bool:
	# Esta función verifica si todos los Targets están en estado completado.
	# Recorre todos los Targets en el grupo "targets".
	for target in get_tree().get_nodes_in_group("targets"):
		# Si encuentra un Target que no está completado (done es false), retorna false.
		if not target.done:
			return false
	# Si todos los Targets están completados (no se encontró ningún Target no completado), retorna true.
	return true
