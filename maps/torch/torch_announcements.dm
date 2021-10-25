/datum/map/torch
	emergency_shuttle_docked_message = "Внимание всему экипажу: спасательные капсулы разблокированы. У вас есть %ETD% чтобы занять места в спасательных капсулах."
	emergency_shuttle_leaving_dock = "Внимание всему экипажу: активация двигателей спасательных капсул. Расчетное время прибытия до пункта встречи шлюпок: %ETA%."

	emergency_shuttle_called_message = "Внимание всему экипажу: получен запрос аварийной эвакуации судна. Спасательные капсулы разблокируются через: %ETA%"
	emergency_shuttle_called_sound = sound('sound/AI/torch/abandonship.ogg', volume = 45)

	emergency_shuttle_recall_message = "Внимание всему экипажу: аварийная эвакуации отменена. Возвращайтесь к выполнению своих рабочих обязанностей."

	command_report_sound = sound('sound/AI/torch/commandreport.ogg', volume = 45)

	grid_check_message = "Обнаружены отклонения в работе энергосети %STATION_NAME%. Энергосеть аварийно отключена для полной калибровки. Пожалуйста, ожидайте."
	grid_check_sound = sound('sound/AI/torch/poweroff.ogg', volume = 45)

	grid_restored_message = "Накопители энергии %STATION_NAME% были заряжены из аварийного хранилища."
	grid_restored_sound = sound('sound/AI/torch/poweron.ogg', volume = 45)

	meteor_detected_sound = sound('sound/AI/torch/meteors.ogg', volume = 45)

	radiation_detected_message = "Зафиксировано повышение уровня радиации поблизости %STATION_NAME%. Всему экипажу настоятельно рекомендуется пройти в технические туннели."
	radiation_detected_sound = sound('sound/AI/torch/radiation.ogg', volume = 45)

	space_time_anomaly_sound = sound('sound/AI/torch/spanomalies.ogg', volume = 45)

	unknown_biological_entities_message = "Неизвестные биологические существа обнаружены в космическом пространстве %STATION_NAME%. Пожалуйста, ожидайте."

	unidentified_lifesigns_message = "Обнаружена неопознанная форма жизни на борту %STATION_NAME%. Настоятельно рекомендуется заблокировать все внешние шлюзы."
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
