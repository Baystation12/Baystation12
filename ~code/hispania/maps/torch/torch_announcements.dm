/datum/map/torch
	emergency_shuttle_docked_message = "Atencion a todos: las capsulas de escape ahora estan desbloqueadas. Tu tienes %ETD% para abordar las capsulas de escape."
	emergency_shuttle_leaving_dock = "Atencion a todos: las capsulas de escape han sido lanzadas, llegando al punto de encuentro en %ETA%."

	emergency_shuttle_called_message = "Atencion a todos: los procedimientos de evacuacion de emergencia estan activos. Las capsulas de escape se desbloquearan en %ETA%"
	emergency_shuttle_called_sound = sound('sound/AI/torch/abandonship.ogg', volume = 45)

	emergency_shuttle_recall_message = "Atencion todos: secuencia de evacuacion de emergencia abortada. Vuelva a las condiciones normales de funcionamiento."

	command_report_sound = sound('sound/AI/torch/commandreport.ogg', volume = 45)

	grid_check_message = "Actividad anormal detectada la red electrica de la %STATION_NAME%. Como precaucion, la energia de %STATION_NAME% debe apagarse por tiempo indefinido."
	grid_check_sound = sound('sound/AI/torch/poweroff.ogg', volume = 45)

	grid_restored_message = "Enviar energia a la %STATION_NAME% sera restaurado en este momento"
	grid_restored_sound = sound('sound/AI/torch/poweron.ogg', volume = 45)

	meteor_detected_sound = sound('sound/AI/torch/meteors.ogg', volume = 45)

	radiation_detected_message = "Altos niveles de radiacion detectados en la proximidad de la %STATION_NAME%. Evacue a uno de los túneles de mantenimiento blindados."
	radiation_detected_sound = sound('sound/AI/torch/radiation.ogg', volume = 45)

	space_time_anomaly_sound = sound('sound/AI/torch/spanomalies.ogg', volume = 45)

	unknown_biological_entities_message = "Entidades biologicas desconocidas han sido detectadas cerca de la %STATION_NAME%, Por favor espere."

	unidentified_lifesigns_message = "Signos de vida no identificados detectados. Bloquee todos los puntos de acceso exteriores."
	unidentified_lifesigns_sound = sound('sound/AI/torch/aliens.ogg', volume = 45)

	lifesign_spawn_sound = sound('sound/AI/torch/aliens.ogg', volume = 45)

	electrical_storm_moderate_sound = sound('sound/AI/torch/electricalstormmoderate.ogg', volume = 45)
	electrical_storm_major_sound = sound('sound/AI/torch/electricalstormmajor.ogg', volume = 45)

/datum/map/torch/level_x_biohazard_sound(var/bio_level)
	switch(bio_level)
		if(7)
			return sound('sound/AI/torch/outbreak7.ogg', volume = 45)
		else
			return sound('sound/AI/torch/outbreak5.ogg', volume = 45)
