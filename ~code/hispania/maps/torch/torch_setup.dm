/datum/map/torch/setup_map()
	..()
	system_name = generate_system_name()
	minor_announcement = new(new_sound = sound('sound/AI/torch/commandreport.ogg', volume = 45))

/datum/map/torch/get_map_info()
	. = list()
	. +=  "Estas a bordo del " + replacetext("<b>[station_name]</b>", "\improper", "") + ", una nave estelar del Cuerpo Expedicionario. Su mision principal es buscar especies alienigenas inteligentes no descubiertas y la exploracion general en el camino."
	. +=  "La nave cuenta con una combinacion de personal del gobierno de SCG y contratistas contratados."
	. +=  "Esta area del espacio esta inexplorada, lejos del territorio SCG. Es posible que encuentre puestos de avanzada remotos o cascos a la deriva, pero ningun gobierno reconocido tiene derecho a reclamar este sector."
	. +=  "Se le invita a todos los nuevos tripulantes a pedir guia en las mecanicas del juego a la administracion, los cuales estaran encantados de instruir a nuevos tripulantes."
	return jointext(., "<br>")

/datum/map/torch/send_welcome()
	var/obj/effect/overmap/visitable/ship/torch = SSshuttle.ship_by_type(/obj/effect/overmap/visitable/ship/torch)

	var/welcome_text = "<center><img src = sollogo.png /><br /><font size = 3><b>SEV Torch</b> Sensor Readings:</font><br>"
	welcome_text += "Informe generado del [stationdate2text()] a [stationtime2text()]</center><br /><br />"
	welcome_text += "<hr>Sistema actual:<br /><b>[torch ? system_name : "Unknown"]</b><br /><br>"

	if (torch) //If the overmap is disabled, it's possible for there to be no torch.
		var/list/space_things = list()
		welcome_text += "Coordenadas actuales:<br /><b>[torch.x]:[torch.y]</b><br /><br>"
		welcome_text += "Siguiente sistema apuntado para salto:<br /><b>[generate_system_name()]</b><br /><br>"
		welcome_text += "Tiempo de viaje a Sol:<br /><b>[rand(15,45)] dias</b><br /><br>"
		welcome_text += "Tiempo desde la ultima visita al puerto:<br /><b>[rand(60,180)] dias</b><br /><hr>"
		welcome_text += "Los resultados del escaneo muestran los siguientes puntos de interes:<br />"

		for(var/zlevel in map_sectors)
			var/obj/effect/overmap/visitable/O = map_sectors[zlevel]
			if(O.name == torch.name)
				continue
			if(istype(O, /obj/effect/overmap/visitable/ship/landable)) //Don't show shuttles
				continue
			if (O.hide_from_reports)
				continue
			space_things |= O

		for(var/obj/effect/overmap/visitable/O in space_things)
			var/location_desc = " en las coordenadas actuales."
			if(O.loc != torch.loc)
				var/bearing = round(90 - Atan2(O.x - torch.x, O.y - torch.y),5) //fucking triangles how do they work
				if(bearing < 0)
					bearing += 360
				location_desc = ", Llevando [bearing]."
			welcome_text += "<li>\A <b>[O.name]</b>[location_desc]</li>"

		welcome_text += "<hr>"

	post_comm_message("Lecturas del sensor de antorcha SEV", welcome_text)
	minor_announcement.Announce(message = "Nueva [GLOB.using_map.company_name] Actualizacion disponible en todas las consolas de comunicacion.")
