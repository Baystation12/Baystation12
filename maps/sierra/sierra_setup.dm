/datum/map/sierra/setup_map()
	..()
	system_name = generate_system_name()
	minor_announcement = new(new_sound = sound('sound/AI/torch/commandreport.ogg', volume = 45))

/datum/map/sierra/map_info(victim)
	to_chat(victim, "<h2>Информация о карте</h2>")
	to_chat(victim, "Вы находитесь на борту <b>[station_name]</b>, исследовательского судна корпорации НаноТрейзен. Основная миссия вашего объекта - проведение исследований на нейтральной территории, как правило, на известной границе космоса с целью нахождения новых залежей форона, космических объектов, артефактов и останков инопланетных цивилизаций.")
	to_chat(victim, "Охрана судна укомплектована сотрудниками Службы Безопасности НаноТрайзен и частных предприятий.")
	to_chat(victim, "Помимо ЧВК в охране, в остальных отделах также присутствуют подрядчики. Их наняли как выдающихся специалистов в своей области, что превзошли корпоративного кандидата. Как правило, они либо работают на себя (civilian), либо на другую корпорацию (contractor). Полезные ссылки:")
	to_chat(victim, "<a href='https://sierra.ss220.space/index.php/Стандартные_процедуры_ИКН_Сьерра'>Процедуры НТ</a>, <a href='https://sierra.ss220.space/index.php/Корпоративные_законы'>Регуляции НТ</a>, <a href='https://sierra.ss220.space/index.php/Коды_угрозы ИКН_Сьерра'>Коды угроз НТ</a>, <a href='https://sierra.ss220.space/index.php/Итак,_Вы_хотите_узнать_о_мире_корпораций%3F'>Список корпораций</a>.")
	to_chat(victim, "<br><span class='danger'>Внимание!</span> На данный момент существует баг, из-за которого слоты с персонажами могут не загрузиться. Если он произошел - зайдите во вкладку OOC и нажмите 'Fix characters load'.")

/datum/map/sierra/send_welcome()
	var/welcome_text = "<center><img src = sierralogo.png /><br /><font size = 3><b>NSV Sierra</b> Показания Сенсоров:</font><hr />"
	welcome_text += "Отчет сгенерирован [stationdate2text()] в [stationtime2text()]</center><br /><br />"
	welcome_text += "Текущая система: <b>[GLOB.using_map.system_name]</b><br />"
	welcome_text += "Следующая система для прыжка: <b>[generate_system_name()]</b><br />"
	welcome_text += "Дней до Солнечной Системы: <b>[rand(15,45)]</b><br />"
	welcome_text += "Дней с последнего визита в порт: <b>[rand(60,180)]</b><br />"
	welcome_text += "Результаты сканирования показали следующие потенциальные объекты для исследования:<br />"

	var/list/space_things = list()
	var/obj/overmap/sierra = map_sectors["1"]
	for(var/zlevel in map_sectors)
		var/obj/overmap/visitable/O = map_sectors[zlevel]
		if(O.name == sierra.name)
			continue
		if(istype(O, /obj/overmap/visitable/ship/landable)) //Don't show shuttles
			continue
		if(O.hide_from_reports)
			continue
		space_things |= O

	var/list/distress_calls
	for(var/obj/overmap/visitable/O in space_things)
		var/location_desc = " на текущем квадрате."
		if(O.loc != sierra.loc)
			var/bearing = round(90 - Atan2(O.x - sierra.x, O.y - sierra.y),5) //fucking triangles how do they work
			if(bearing < 0)
				bearing += 360
			location_desc = ", по азимуту [bearing]."
		welcome_text += "<li>\A <b>[O.name]</b>[location_desc]</li>"

	if(LAZYLEN(distress_calls))
		welcome_text += "<br><b>Обнаружены сигналы бедствия:</b><br>[jointext(distress_calls, "<br>")]<br>"
	else
		welcome_text += "<br>Сигналов бедствия не обнаружено.<br />"

	welcome_text += "<hr>"

	post_comm_message("NSV Sierra Sensor Readings", welcome_text)
	minor_announcement.Announce(message = "Сканирование сектора завершено. Информация передана в базу данных консолей связи.")
