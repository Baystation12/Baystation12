/datum/map/torch/setup_map()
	..()
	system_name = generate_system_name()
	minor_announcement = new(new_sound = sound('sound/AI/torch/commandreport.ogg', volume = 45))

/datum/map/torch/get_map_info()
	. = list()
	. +=  "Вы находитесь на борту " + replacetext_char("<b>[station_name]</b>", "\improper", "") + ", космического корабля Экспедиционного Корпуса. Его главная цель - поиск разумной жизни, а также разведка систем, встречаемых по пути. \
	Судно укомплектовано государственным персоналом из ЦПСС, а также нанятыми контрактниками. \
	Эта часть космоса является неизученной, и находится далеко от территории ЦПСС. Вы можете встретить различные аванпосты или дрейфующие корабли, но ни одно из признанных государств не претендует на эти территории."
	return jointext(., "<br>")

/datum/map/torch/send_welcome()
	var/obj/effect/overmap/visitable/ship/torch = SSshuttle.ship_by_type(/obj/effect/overmap/visitable/ship/torch)

	var/welcome_text = "<center><img src = sollogo.png /><br /><font size = 3><b>ГЭК \"Факел\"</b> Показания сенсоров:</font><br>"
	welcome_text += "Отчёт сгенирирован [stationdate2text()] в [stationtime2text()]</center><br /><br />"
	welcome_text += "<hr>Текущая система:<br /><b>[torch ? system_name : "Unknown"]</b><br /><br>"

	if (torch) //If the overmap is disabled, it's possible for there to be no torch.
		var/list/space_things = list()
		welcome_text += "Текущие координаты:<br /><b>[torch.x]:[torch.y]</b><br /><br>"
		welcome_text += "Следующая система для прыжка:<br /><b>[generate_system_name()]</b><br /><br>"
		welcome_text += "Дней до Солнечной Системы:<br /><b>[rand(15,45)] days</b><br /><br>"
		welcome_text += "Дней с последнего визита в порт:<br /><b>[rand(60,180)] days</b><br /><hr>"
		welcome_text += "Результаты сканирования показали следующие потенциальные объекты для исследования:<br />"

		for(var/zlevel in map_sectors)
			var/obj/effect/overmap/visitable/O = map_sectors[zlevel]
			if(O.name == torch.name)
				continue
			if(istype(O, /obj/effect/overmap/visitable/ship/landable)) //Don't show shuttles
				continue
			if (O.hide_from_reports)
				continue
			space_things |= O

		var/list/distress_calls
		for(var/obj/effect/overmap/visitable/O in space_things)
			var/location_desc = " at present co-ordinates."
			if(O.loc != torch.loc)
				var/bearing = round(90 - Atan2(O.x - torch.x, O.y - torch.y),5) //fucking triangles how do they work
				if(bearing < 0)
					bearing += 360
				location_desc = ", bearing [bearing]."
			if(O.has_distress_beacon)
				LAZYADD(distress_calls, "[O.has_distress_beacon][location_desc]")
			welcome_text += "<li>\A <b>[O.name]</b>[location_desc]</li>"

		if(LAZYLEN(distress_calls))
			welcome_text += "<br><b>Distress calls logged:</b><br>[jointext(distress_calls, "<br>")]<br>"
		else
			welcome_text += "<br>No distress calls logged.<br />"
		welcome_text += "<hr>"

	post_comm_message("SEV Torch Sensor Readings", welcome_text)
	minor_announcement.Announce(message = "New [GLOB.using_map.company_name] Update available at all communication consoles.")
