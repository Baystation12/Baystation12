/datum/computer_file/report/recipient/exp/generate_fields()
	..()
	set_access(access_explorer)

/datum/computer_file/report/recipient/exp/planet
	form_name = "NT-EXP-19p"
	title = "Отчет по экзопланете"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/exp/planet/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "ИКН Сьерра - Экспедиционный департамент")
	add_field(/datum/report_field/text_label/instruction, "Следующие колонки заполняются членом, входящего в состав экспедиционной команды, после возвращения с планеты на Сьерру.")
	add_field(/datum/report_field/number, "Номер отчета")
	add_field(/datum/report_field/simple_text, "Местоположение", required = 1)
	add_field(/datum/report_field/date, "Дата")
	add_field(/datum/report_field/people/list_from_manifest, "Участники экспедиции", required = 1)
	add_field(/datum/report_field/pencode_text, "Информация по атмосфере", required = 1)
	add_field(/datum/report_field/pencode_text, "Информация по местности", required = 1)
	add_field(/datum/report_field/pencode_text, "Обитаемость планеты", required = 1)
	add_field(/datum/report_field/pencode_text, "Наличие фауны", required = 1)
	add_field(/datum/report_field/options/yes_no, "Наличие флоры", required = 1)
	add_field(/datum/report_field/pencode_text, "Материалы/Инструменты, которые были использованы", required = 1)
	add_field(/datum/report_field/pencode_text, "Найденные предметы или материалы", required = 1)
	add_field(/datum/report_field/pencode_text, "Наблюдения", required = 1)
	add_field(/datum/report_field/signature,"Подпись ответственного, за заполнение документа", required = 1)
	add_field(/datum/report_field/text_label/instruction, "После заполнения данного документы, а также последующего его утверждения,\
	директор исследований должен отправить данный документ по факсу Центральному Командованию и Капитану, после чего занести этот документ в архив.")

/datum/computer_file/report/recipient/exp/fauna
	form_name = "NT-EXP-19f"
	title = "Отчет по фауне"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/exp/fauna/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "ИКН Сьерра - Экспедиционный департамент")
	add_field(/datum/report_field/text_label/instruction, "Следующие колонки заполняются членом, входящего в состав экспедиционной команды, после открытия и изучения инопланетной жизни.")
	add_field(/datum/report_field/number, "Номер рапорта")
	add_field(/datum/report_field/simple_text, "Местоположение", required = 1)
	add_field(/datum/report_field/date, "Дата")
	add_field(/datum/report_field/people/list_from_manifest, "Участники экспедиции", required = 1)
	add_field(/datum/report_field/pencode_text, "Анатомия/Внешний вид", required = 1)
	add_field(/datum/report_field/pencode_text, "Локомоция", required = 1)
	add_field(/datum/report_field/pencode_text, "Чем питается", required = 1)
	add_field(/datum/report_field/pencode_text, "Среда обитания", required = 1)
	add_field(/datum/report_field/pencode_text, "Поведение", required = 1)
	add_field(/datum/report_field/pencode_text, "Специальная характеристика(и)", required = 1)
	add_field(/datum/report_field/simple_text, "Классификация", required = 1)
	add_field(/datum/report_field/text_label/instruction, "После заполнения данного документы, а также последующего его утверждения,\
	директор исследований должен отправить данный документ по факсу Центральному Командованию и Капитану, после чего занести этот документ в архив, закрепив его с документом об экзопланете.")

/datum/computer_file/report/recipient/exp/flora
	form_name = "NT-EXP-19g"
	title = "Отчет по флоре"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/exp/flora/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "ИКН Сьерра - Экспедиционный департамент")
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
	add_field(/datum/report_field/text_label/instruction, "После заполнения данного документы, а также последующего его утверждения,\
	директор исследований должен отправить данный документ по факсу Центральному Командованию и Капитану, после чего занести этот документ в архив, закрепив его с документом об экзопланете.")
