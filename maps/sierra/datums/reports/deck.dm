/datum/computer_file/report/recipient/deck/generate_fields()
	..()
	set_access(access_cargo)

/datum/computer_file/report/recipient/deck/shuttle
	form_name = "NT-DEC-32"
	title = "Предварительная проверка шаттла"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/deck/shuttle/generate_fields()
	..()
	var/list/permission_fields = list()
	add_field(/datum/report_field/text_label/header, "ИКН Сьерра - Департамент снабжения")
	add_field(/datum/report_field/date, "Дата заполнения")
	add_field(/datum/report_field/time, "Время заполнения")
	add_field(/datum/report_field/simple_text, "Название шаттла", required = 1)
	add_field(/datum/report_field/text_label/instruction, "Следующий пункт рекомендуется заполнить в порядке посещения пунктов назначения.")
	add_field(/datum/report_field/pencode_text, "Пункт(ы) Назначения", required = 1)
	add_field(/datum/report_field/simple_text, "Место Дислокации", required = 1)
	add_field(/datum/report_field/simple_text, "Причина вылета", required = 1)
	add_field(/datum/report_field/text_label, "Предполетная подготовка")
	add_field(/datum/report_field/options/yes_no, "Корпус левой стороны без повреждений?", required = 1)
	add_field(/datum/report_field/options/yes_no, "Корпус правой стороны без повреждений?", required = 1)
	add_field(/datum/report_field/options/yes_no, "Все окна установлены и закреплены?", required = 1)
	add_field(/datum/report_field/options/yes_no, "Сопла форсунок очищены?", required = 1)
	add_field(/datum/report_field/options/yes_no, "Присутствует ли утечка топлива?", required = 1)
	add_field(/datum/report_field/options/yes_no, "Давление топлива превышает 300kPa?", required = 1)
	add_field(/datum/report_field/options/yes_no, "Портативный генератор на борту?", required = 1)
	add_field(/datum/report_field/options/yes_no, "Заряд SMESа имеет более 60%?", required = 1)
	add_field(/datum/report_field/options/yes_no, "Все камеры в рабочем состоянии?", required = 1)
	add_field(/datum/report_field/options/yes_no, "Давление в канистре воздушных шлюзов больше 200kPa?", required = 1)
	add_field(/datum/report_field/options/yes_no, "Набор первой помощи на борту?", required = 1)
	add_field(/datum/report_field/options/yes_no, "Набор инструментов на борту?", required = 1)
	add_field(/datum/report_field/options/yes_no, "Скафандры для членов экспедиции на борту?", required = 1)
	add_field(/datum/report_field/options/yes_no, "Другая необходимая экипировка на борту?", required = 1)
	add_field(/datum/report_field/options/yes_no, "Все члены экспедиции на борту?", required = 1)
	add_field(/datum/report_field/options/yes_no, "Герметичность шлюзов с обеих сторон?", required = 1)
	permission_fields += add_field(/datum/report_field/options/yes_no, "Разрешение на вылет из ангара?", required = 1)
	permission_fields += add_field(/datum/report_field/signature, "Для разрешения на вылет, поставьте подпись либо печать здесь", required = 1)
	for(var/datum/report_field/field in permission_fields)
		field.set_access(access_edit=list(list(access_el, access_qm, access_heads)))
	set_access(list(list(access_guppy, access_expedition_shuttle, access_petrov)),list(list(access_guppy, access_expedition_shuttle, access_petrov)))

/datum/computer_file/report/recipient/deck/docking
	form_name = "NT-DEC-33"
	title = "Отчет о пристыкованном судне"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/deck/docking/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "ИКН Сьерра - Департамент снабжения")
	add_field(/datum/report_field/text_label/header, "ОБЩАЯ ИНФОРМАЦИЯ")
	add_field(/datum/report_field/date, "Дата заполнения")
	add_field(/datum/report_field/time, "Время заполнения")
	add_field(/datum/report_field/simple_text, "Название судна", required = 1)
	add_field(/datum/report_field/simple_text, "Владелец/Пилот судна", required = 1)
	add_field(/datum/report_field/simple_text, "Назначение судна", required = 1)
	add_field(/datum/report_field/people/from_manifest, "Состыковку произвел", required = 1)
	add_field(/datum/report_field/text_label, "ОБЩАЯ ИНФОРМАЦИЯ ГРУЗА")
	add_field(/datum/report_field/pencode_text, "Перечислите вид груза, находящегося на судне", required = 1)
	add_field(/datum/report_field/text_label, "ИНФОРМАЦИЯ ОБ ОПАСНОМ ГРУЗЕ СУДНА")
	add_field(/datum/report_field/options/yes_no, "Вооружение?", required = 1)
	add_field(/datum/report_field/options/yes_no, "Живой груз?", required = 1)
	add_field(/datum/report_field/options/yes_no, "Биологический материал?", required = 1)
	add_field(/datum/report_field/options/yes_no, "Химическая или радиационная опасность?", required = 1)
	add_field(/datum/report_field/signature, "Для разрешение на посещение судна, рапсишитесь/поставьте печать здесь", required = 1)
	add_field(/datum/report_field/text_label, "ОТСТЫКОВКА И ОТЪЕЗД")
	add_field(/datum/report_field/time, "Время отстыковки")
	add_field(/datum/report_field/pencode_text,"Дополнительные заметки во время отстыковки")
	set_access(access_security, override = 0)

/datum/computer_file/report/recipient/request
	form_name = "NT-DEC-34"
	title = "Запрос в отдел поставок"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/request/generate_fields()
	..()
	var/list/cargo_fields = list()
	add_field(/datum/report_field/text_label/header, "ИКН Сьерра - Департамент снабжения")
	add_field(/datum/report_field/simple_text, "Наименование отдела, запрашивающего предметы или материалы", required = 1)
	add_field(/datum/report_field/people/from_manifest, "Имя и должность запрашивающего", required = 1)
	add_field(/datum/report_field/signature, "Подпись запрашивающего", required = 1)
	add_field(/datum/report_field/date, "Дата заполнения")
	add_field(/datum/report_field/time, "Время заполнения")
	add_field(/datum/report_field/pencode_text, "Список запрашиваемых предметов или материалов", required = 1)
	add_field(/datum/report_field/text_label/instruction, "При необходимости - вписать дополнительные пункты в списке. Пустые графы заполнить, как N/A.")
	add_field(/datum/report_field/simple_text, "Причина запроса", required = 1)
	add_field(/datum/report_field/signature, "Подпись запрашивающего")
	cargo_fields+= add_field(/datum/report_field/signature, "Подпись квартирмейстера или работника карго", required = 1)
	for(var/datum/report_field/field in cargo_fields)
		field.set_access(access_edit = access_cargo)
