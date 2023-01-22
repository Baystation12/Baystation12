/datum/computer_file/report/recipient/exp
	logo = "\[eclogo\]"

/datum/computer_file/report/recipient/exp/generate_fields()
	..()
	set_access(access_explorer)

/datum/computer_file/report/recipient/exp/fauna
	form_name = "SCG-EXP-19f"
	title = "Отчет по фауне"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/exp/fauna/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "ГЭК \"Факел\" - Экспедиционный Корпус")
	add_field(/datum/report_field/text_label/instruction, "Следующие колонки заполняются членом, входящего в состав экспедиционной команды, после открытия и изучения инопланетной жизни.")
	add_field(/datum/report_field/number, "Номер рапорта")
	add_field(/datum/report_field/simple_text, "Местоположение", required = 1)
	add_field(/datum/report_field/date, "Дата")
	add_field(/datum/report_field/time, "Время")
	add_field(/datum/report_field/people/list_from_manifest, "Участники экспедиции", required = 1)
	add_field(/datum/report_field/pencode_text, "Анатомия/Внешний вид", required = 1)
	add_field(/datum/report_field/pencode_text, "Локомоция", required = 1)
	add_field(/datum/report_field/pencode_text, "Чем питается", required = 1)
	add_field(/datum/report_field/pencode_text, "Среда обитания", required = 1)
	add_field(/datum/report_field/pencode_text, "Поведение", required = 1)
	add_field(/datum/report_field/pencode_text, "Специальная характеристика(и)", required = 1)
	add_field(/datum/report_field/simple_text, "Классификация", required = 1)
	add_field(/datum/report_field/text_label/instruction, "После заполнения данного документа, а также последующего его утверждения,\
	Главный Научный Офицер должен отправить данный документ по факсу Корпоративному Связному и Командующему Офицеру, после чего хранить копию этого документа в своём офисе, как и другие отчёты о прогрессе миссии.")


/datum/computer_file/report/recipient/exp/planet
	form_name = "SCG-EXP-17"
	title = "Отчет по экзопланете"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/exp/planet/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "ГЭК \"Факел\" - Экспедиционный Корпус")
	add_field(/datum/report_field/text_label/instruction, "Следующие колонки заполняются членом, входящего в состав экспедиционной команды, после возвращения с планеты на борт судна.")
	add_field(/datum/report_field/date, "Дата")
	add_field(/datum/report_field/time, "Время")
	add_field(/datum/report_field/simple_text, "Название планеты", required = 1)
	add_field(/datum/report_field/people/list_from_manifest, "Участники экспедиции", required = 1)
	add_field(/datum/report_field/pencode_text, "Информация по местности", required = 1)
	add_field(/datum/report_field/simple_text, "Обитаемость", required = 1)
	add_field(/datum/report_field/pencode_text, "Описание фауны", required = 1)
	add_field(/datum/report_field/pencode_text, "Описание флоры", required = 1)
	add_field(/datum/report_field/pencode_text, "Точки интереса", required = 1)
	add_field(/datum/report_field/pencode_text, "Наблюдения")
	add_field(/datum/report_field/text_label/instruction, "После заполнения данного документа, а также последующего его утверждения,\
	Главный Научный Офицер должен отправить данный документ по факсу Корпоративному Связному и Командующему Офицеру, после чего хранить копию этого документа в своём офисе, как и другие отчёты о прогрессе миссии.")

/datum/computer_file/report/recipient/exp/flora
	form_name = "SCG-EXP-20g"
	title = "Отчет по флоре"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/exp/flora/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "ГЭК \"Факел\" - Экспедиционный Корпус")
	add_field(/datum/report_field/text_label/instruction, "Следующие колонки заполняются членом, входящего в состав экспедиционной команды, после открытия и изучения инопланетной жизни.")
	add_field(/datum/report_field/number, "Номер рапорта")
	add_field(/datum/report_field/simple_text, "Местоположение", required = 1)
	add_field(/datum/report_field/date, "Дата")
	add_field(/datum/report_field/people/list_from_manifest, "Участники экспедиции", required = 1)
	add_field(/datum/report_field/pencode_text, "Строение/Внешний вид", required = 1)
	add_field(/datum/report_field/pencode_text, "Условия произрастания", required = 1)
	add_field(/datum/report_field/pencode_text, "Среда обитания", required = 1)
	add_field(/datum/report_field/pencode_text, "Описание плодов", required = 1)
	add_field(/datum/report_field/pencode_text, "Анализ плодов", required = 1)
	add_field(/datum/report_field/pencode_text, "Специальная характеристика(и)", required = 1)
	add_field(/datum/report_field/simple_text, "Классификация", required = 1)
	add_field(/datum/report_field/text_label/instruction, "После заполнения данного документа, а также последующего его утверждения,\
	Главный Научный Офицер должен отправить данный документ по факсу Корпоративному Связному и Командующему Офицеру, после чего хранить копию этого документа в своём офисе, как и другие отчёты о прогрессе миссии.")

/datum/computer_file/report/recipient/shuttle/post_flight
	logo = "\[eclogo\]"
	form_name = "SCG-EXP-3"
