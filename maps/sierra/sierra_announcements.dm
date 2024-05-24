/datum/map/sierra
	shuttle_called_message = "Внимание всему персоналу: запущена процедура подготовки к подпространственному прыжку в следующий сектор. Расчетное время окончания зарядки генератора блюспейса: %ETA%."
	shuttle_called_sound = sound(ANNOUNCER_BLUESPACEJUMP_PREP, volume = 45)
	shuttle_docked_message = "Внимание всему персоналу: подготовка к подпространственному прыжку завершена. Начата процедура безопасной активации генератора подпространства. Расчетное время до начала прыжка: %ETD%."
	shuttle_docked_sound = sound(ANNOUNCER_BLUESPACEJUMP_INIT, volume = 45)
	shuttle_leaving_dock = "Внимание всему персоналу: прыжок начат. Примерное время окончания прыжка: %ETA%. Сохраняйте спокойствие и трезвость мышления."
	shuttle_leaving_dock_sound = sound(ANNOUNCER_BLUESPACEJUMP_START, volume = 45)
	shuttle_recall_message = "Внимание всему персоналу: процедура подготовки к подпространственному прыжку отменена. Возвращайтесь к исполнению своих рабочих обязанностей."

	emergency_shuttle_called_message = "Внимание всему персоналу: получен запрос аварийной эвакуации судна. Автоматическое подтверждение запроса через: %ETA%"
	emergency_shuttle_docked_message = "Внимание всему персоналу: процедура аварийной эвакуации подтверждена, спасательные капсулы разблокированы. У вас есть %ETD% чтобы занять места в спасательных капсулах."
	emergency_shuttle_leaving_dock = "Внимание всему персоналу: активация двигателей спасательных капсул. Расчетное время прибытия до пункта встречи шлюпок: %ETA%"
	emergency_shuttle_recall_message = "Внимание всему персоналу: аварийная эвакуации отменена. Возвращайтесь к выполнению своих рабочих обязанностей."
	emergency_shuttle_called_sound = sound(ANNOUNCER_ABANDONSHIP, volume = 45)

	command_report_sound = sound(ANNOUNCER_COMMANDREPORT, volume = 45)

	grid_check_message = "Обнаружены отклонения в работе энергосети %STATION_NAME%. Энергосеть аварийно отключена для полной калибровки. Пожалуйста, ожидайте."
	grid_check_sound = sound(ANNOUNCER_POWEROFF, volume = 45)

	grid_restored_message = "Накопители энергии %STATION_NAME% были заряжены из аварийного хранилища."
	grid_restored_sound = sound(ANNOUNCER_POWERON, volume = 45)

	meteor_detected_message = "Внимание всему персоналу, обнаружены метеориты прямо по курсу %STATION_NAME%. Настоятельно рекомендуется пройти в центр корабля до выхода из опасной зоны."
	meteor_detected_sound = sound(ANNOUNCER_METEORS, volume = 45)

	radiation_detected_message = "Зафиксировано повышение уровня радиации поблизости %STATION_NAME%. Всему персоналу настоятельно рекомендуется пройти в экранированные отсеки до покидания зоны повышенной радиоактивности. Экранированные отсеки - технические тоннели, челноки, камеры охраны, экстренные убежища, лифт, дормиторий."
	radiation_detected_sound = sound(ANNOUNCER_RADIATION, volume = 45)

	space_time_anomaly_sound = sound(ANNOUNCER_SPANOMALIES, volume = 45)

	unknown_biological_entities_message = "Неизвестные биологические существа обнаружены в космическом пространстве %STATION_NAME%. Настоятельно рекомендуется активировать режим сдерживания неизвестных форм жизни на генераторе щита."

	unidentified_lifesigns_message = "Обнаружена неопознанная форма жизни на борту %STATION_NAME%. Настоятельно рекомендуется заблокировать все внешние шлюзы и запретить стыковку гражданским судам."
	unidentified_lifesigns_sound = sound(ANNOUNCER_ALIENS, volume = 45)

	electrical_storm_moderate_sound = sound(ANNOUNCER_ELECTRICALSTORM_MOD, volume = 45)
	electrical_storm_major_sound = sound(ANNOUNCER_ELECTRICALSTORM_MAJ, volume = 45)

	// SIERRA TODO: port eris announcer to Bay12
	// use_job_frequency_announcement = FALSE
	// use_radio_announcement = TRUE

/datum/map/sierra/level_x_biohazard_announcement(bio_level)
	if(!isnum(bio_level))
		CRASH("Expected a number, was: [log_info_line(bio_level)]")
	if(bio_level < 1 || bio_level > 9)
		CRASH("Expected a number between 1 and 9, was: [log_info_line(bio_level)]")

	var/msg
	var/crew
	var/sound = GLOB.using_map.command_report_sound
	switch(bio_level)
		if(9)
			msg = "неопознанная форма жизни. Рекомендуется изолировать неизвестный организм и заварить вентиляционные шахты до постановки на содержание. Это максимальный уровень потенциальной угрозы"
			crew = "Командующему"
			sound = sound(ANNOUNCER_ALIENS, volume = 100)
		if(8)
			msg = "враждебные коррозийные организмы. Зафиксировано нарушение структурной целостности переборок"
			crew = "Инженерному и Охранному"
		if(6)
			msg = "опасные вредители. Рядом с вентиляционными шахтами обнаружены скопления паутины"
			crew = "Охранному"
		if(5)
			msg = "космические карпы. Настоятельно рекомендуется временно прервать всю внекорабельную деятельность"
			crew = "Охранному"
			sound = sound(ANNOUNCER_OUTBREAK5, volume = 100)
		if(4)
			msg = "быстрорастущие растения. Точное определение степени опасности невозможно из-за частых мутаций"
			crew = "Инженерному и Обслуживающему"
		if(3)
			msg = "вредоносные патогены"
			crew = "Медицинскому"
		if(2)
			msg = "коррозийные грибы. Имеется опасность поражения переборок"
			crew = "Инженерному"
		if(1)
			msg = "мелкие вредители"
			crew = "Обслуживающему"

	priority_announcement.Announce("Подтверждено наличие объекта [bio_level] уровня биологической угрозы - [msg]. [crew] персоналу требуется предпринять меры по ликвидации угрозы.", "Биоугроза", new_sound = sound)
