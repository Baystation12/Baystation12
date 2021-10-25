#ifndef PSI_IMPLANT_AUTOMATIC
#define PSI_IMPLANT_AUTOMATIC "Security Level Derived"
#endif
#ifndef PSI_IMPLANT_SHOCK
#define PSI_IMPLANT_SHOCK     "Issue Neural Shock"
#endif
#ifndef PSI_IMPLANT_WARN
#define PSI_IMPLANT_WARN      "Issue Reprimand"
#endif
#ifndef PSI_IMPLANT_LOG
#define PSI_IMPLANT_LOG       "Log Incident"
#endif
#ifndef PSI_IMPLANT_DISABLED
#define PSI_IMPLANT_DISABLED  "Disabled"
#endif

/datum/map/torch // setting the map to use this list
	security_state = /decl/security_state/default/torchdept

//Torch map alert levels. Refer to security_state.dm.
/decl/security_state/default/torchdept
	all_security_levels = list(/decl/security_level/default/torchdept/code_green, /decl/security_level/default/torchdept/code_violet, /decl/security_level/default/torchdept/code_orange, /decl/security_level/default/torchdept/code_blue, /decl/security_level/default/torchdept/code_red, /decl/security_level/default/torchdept/code_delta)

/decl/security_level/default/torchdept
	icon = 'maps/torch/icons/security_state.dmi'

/decl/security_level/default/torchdept/code_green
	name = "Зелёный код"
	icon = 'icons/misc/security_state.dmi'

	light_max_bright = 0.25
	light_inner_range = 0.1
	light_outer_range = 1
	light_color_alarm = COLOR_GREEN
	light_color_status_display = COLOR_GREEN

	overlay_alarm = "alarm_green"
	overlay_status_display = "status_display_green"
	alert_border = "alert_border_green"

	var/static/datum/announcement/priority/security/security_announcement_green = new(do_log = 0, do_newscast = 1, new_sound = sound('sound/misc/notice2.ogg'))

/decl/security_level/default/torchdept/code_green/switching_down_to()
	security_announcement_green.Announce("Все угрозы для судна и его экипажа были устранены. \
	Персоналу следует вернуться к выполнению рабочих обязанностей в штатном режиме.")
	notify_station()

/decl/security_level/default/torchdept/code_violet
	name = "Фиолетовый код"

	light_max_bright = 0.5
	light_inner_range = 1
	light_outer_range = 2
	light_color_alarm = COLOR_VIOLET
	light_color_status_display = COLOR_VIOLET

	psionic_control_level = PSI_IMPLANT_LOG

	overlay_alarm = "alarm_violet"
	overlay_status_display = "status_display_violet"
	alert_border = "alert_border_violet"

	up_description = "На судне обнаружена серьёзная медицинская угроза. \
	Всему медицинскому персоналу требуется обратиться к вышестоящим сотрудникам для получения инструкций. \
	Не-медицинскому персоналу следует выполнять инструкции от медицинского персонала."

	down_description = "На судне обнаружена серьёзная медицинская угроза. \
	Всему медицинскому персоналу требуется обратиться к вышестоящим сотрудникам для получения инструкций. \
	Не-медицинскому персоналу следует выполнять инструкции от медицинского персонала."

/decl/security_level/default/torchdept/code_orange
	name = "Оранжевый код"

	light_max_bright = 0.5
	light_inner_range = 1
	light_outer_range = 2
	light_color_alarm = COLOR_ORANGE
	light_color_status_display = COLOR_ORANGE
	overlay_alarm = "alarm_orange"
	overlay_status_display = "status_display_orange"
	alert_border = "alert_border_orange"

	psionic_control_level = PSI_IMPLANT_LOG

	up_description = "Судно имеет серьёзные структурные повреждения, а также испытывает отказы множества систем. \
	Всему инженерному персоналу требуется обратиться к вышестоящим сотрудникам для получения инструкций. \
	Весь не-инженерный персонал должен покинуть затронутые повреждениями отсеки. Рекомендуется ношение скафандров и \
	следование указаниям инженерного персонала."

	down_description = "Судно имеет серьёзные структурные повреждения, а также испытывает отказы множества систем. \
	Всему инженерному персоналу требуется обратиться к вышестоящим сотрудникам для получения инструкций. \
	Весь не-инженерный персонал должен покинуть затронутые повреждениями отсеки. Рекомендуется ношение скафандров и \
	следование указаниям инженерного персонала."

/decl/security_level/default/torchdept/code_blue
	name = "Cиний код"
	icon = 'icons/misc/security_state.dmi'

	light_max_bright = 0.5
	light_inner_range = 1
	light_outer_range = 2
	light_color_alarm = COLOR_BLUE
	light_color_status_display = COLOR_BLUE
	overlay_alarm = "alarm_blue"
	overlay_status_display = "status_display_blue"
	alert_border = "alert_border_blue"

	psionic_control_level = PSI_IMPLANT_LOG

	up_description = "На борту судна предположительно присутствует угроза безопасности для экипажа и самого судна. \
	Всей охране требуется обратиться к вышестоящим сотрудникам для получения указаний; \
	разрешено обыскивать сотрудников и отсеки, а так же держать оружие на виду."

	down_description = "Прямая угроза экипажу и судну отстуствует. На судне всё ещё может оставаться угроза безопасности для экипажа и самого судна. \
	Всей охране требуется обратиться к вышестоящим сотрудникам для получения указаний; \
	разрешено обыскивать сотрудников и отсеки, а так же держать оружие на виду."

/decl/security_level/default/torchdept/code_red
	name = "Красный код"
	icon = 'icons/misc/security_state.dmi'

	light_max_bright = 0.75
	light_inner_range = 1
	light_outer_range = 3
	light_color_alarm = COLOR_RED
	light_color_status_display = COLOR_RED
	overlay_alarm = "alarm_red"
	overlay_status_display = "status_display_red"
	alert_border = "alert_border_red"
	psionic_control_level = PSI_IMPLANT_DISABLED

	up_description = "Присутствует прямая угроза безопасности для экипажа и самого судна. \
	Весь экипаж должен обратиться к командующему составу для получения инструкций. \
	Охране разрешено обыскивать сотрудников и отсеки, а так же держать оружие на виду. Все убежища были разблокированы."

	var/static/datum/announcement/priority/security/security_announcement_red = new(do_log = 0, do_newscast = 1, new_sound = sound('sound/misc/redalert1.ogg'))

/decl/security_level/default/torchdept/code_red/switching_up_to()
	security_announcement_red.Announce(up_description, "Внимание! Красный код!")
	notify_station()
	GLOB.using_map.toggle_crew_sensors(3)
	GLOB.using_map.unbolt_saferooms()

/decl/security_level/default/torchdept/code_red/switching_down_to()
	security_announcement_red.Announce("Код Дельта был отключён. \
	Весь экипаж должен обратиться к командующему составу для получения инструкций. \
	Охране разрешено обыскивать сотрудников и отсеки, а так же держать оружие на виду.")
	notify_station()
	GLOB.using_map.toggle_crew_sensors(3)

/decl/security_level/default/torchdept/code_delta
	name = "код Дельта"
	icon = 'icons/misc/security_state.dmi'

	light_max_bright = 0.75
	light_inner_range = 0.1
	light_outer_range = 3
	light_color_alarm = COLOR_RED
	light_color_status_display = COLOR_NAVY_BLUE

	overlay_alarm = "alarm_delta"
	overlay_status_display = "status_display_delta"
	alert_border = "alert_border_delta"

	var/static/datum/announcement/priority/security/security_announcement_delta = new(do_log = 0, do_newscast = 1, new_sound = sound('sound/effects/siren.ogg'))

/decl/security_level/default/torchdept/code_delta/switching_up_to()
	security_announcement_delta.Announce("Процедуры кода Дельта вступили в силу. Весь экипаж обязан выполнять все приказы, данные командующим составом. Любое нарушение этих приказов карается смертью. Это не учебная тревога.", "Внимание! Код Дельта!")
	notify_station()
	GLOB.using_map.toggle_crew_sensors(3)

#undef PSI_IMPLANT_AUTOMATIC
#undef PSI_IMPLANT_SHOCK
#undef PSI_IMPLANT_WARN
#undef PSI_IMPLANT_LOG
#undef PSI_IMPLANT_DISABLED
