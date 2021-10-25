/datum/computer_file/report/recipient/sci/generate_fields()
	..()
	set_access(access_xenobiology)

/datum/computer_file/report/recipient/sci/anomaly
	form_name = "SCG-SCI-1546"
	title = "Изучение Аномалий"
	logo = "\[eclogo\]"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/sci/anomaly/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "Экспедиционный Корпус ЦПСС - Отдел Исследований и Разработок - ГЭК \"Факел\" ")
	add_field(/datum/report_field/simple_text, "Кодовое название AO", required = 1)
	add_field(/datum/report_field/people/from_manifest, "Отчет заполнял", required = 1)
	add_field(/datum/report_field/pencode_text, "Процедуры сдерживания", required = 1)
	add_field(/datum/report_field/pencode_text, "Общее описание", required = 1)
	add_field(/datum/report_field/simple_text, "Примерный возраст AO", required = 1)
	add_field(/datum/report_field/simple_text, "Уровень угрозы AO", required = 1)

/datum/computer_file/report/recipient/sci/prototype
	form_name = "EC-SCI-07"
	title = "Передача прототипов оборудования"
	logo = "\[eclogo\]"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/sci/prototype/generate_fields()
	..()
	var/list/rd_fields = list()
	var/list/sci_fields = list()
	add_field(/datum/report_field/text_label/header, "Экспедиционный Корпус ЦПСС - Отдел Исследований и Разработок - ГЭК \"Факел\" ")
	add_field(/datum/report_field/simple_text, "Отдел, в который передаются прототипы", required = 1)
	sci_fields += add_field(/datum/report_field/people/from_manifest, "Полное имя и звание научного сотрудника, передающего прототипы", required = 1)
	sci_fields += add_field(/datum/report_field/signature, "Подпись научного сотрудника", required = 1)
	add_field(/datum/report_field/people/from_manifest, "Полное имя и звание сотрудника, принимающего прототипы", required = 1)
	add_field(/datum/report_field/signature, "Подпись принимающего сотрудника", required = 1)
	add_field(/datum/report_field/date, "Дата передачи")
	add_field(/datum/report_field/time, "Время передачи")
	add_field(/datum/report_field/pencode_text, "Список передаваемых прототипов", required = 1)
	add_field(/datum/report_field/text_label/instruction, "При необходимости - вписать дополнительные пункты в списке. Пустые графы заполнить, как N/A")
	rd_fields += add_field(/datum/report_field/signature, "Подпись Главного Научного Офицера")
	for(var/datum/report_field/field in sci_fields)
		field.set_access(access_edit = access_xenobiology)
	for(var/datum/report_field/field in rd_fields)
		field.set_access(access_edit = access_rd)

/datum/computer_file/report/recipient/sci/augmentations
	form_name = "AG17-N1"
	title = "Аугментация сотрудника"
	logo = "\[eclogo\]"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/sci/augmentations/generate_fields()
	..()
	var/list/rd_fields = list()
	var/list/sci_fields = list()
	var/list/heads_fields = list()
	add_field(/datum/report_field/text_label/header, "Экспедиционный Корпус ЦПСС - Отдел Исследований и Разработок - ГЭК \"Факел\" ")
	add_field(/datum/report_field/simple_text, "Отдел, в котором работает аугментируемый", required = 1)
	add_field(/datum/report_field/people/from_manifest, "Имя и звание сотрудника, в которого имплантируются аугментации", required = 1)
	sci_fields += add_field(/datum/report_field/people/from_manifest, "Имя и звание, проводящего операцию", required = 1)
	sci_fields += add_field(/datum/report_field/signature, "Подпись сотрудника, проводящего операцию", required = 1)
	add_field(/datum/report_field/date, "Дата аугментации")
	add_field(/datum/report_field/time, "Время аугментации")
	add_field(/datum/report_field/simple_text, "Причина аугментации", required = 1)
	add_field(/datum/report_field/options/yes_no, "Добавить инфомацию об аугментациях в базу данных?")
	add_field(/datum/report_field/pencode_text, "Список аугментаций", required = 1)
	add_field(/datum/report_field/text_label/instruction, "Каждую аугментацию оформить в виде: часть тела, если протез - описать марку протеза, функционал, название. \
	При необходимости - вписать дополнительные пункты в списке. Пустые графы заполнить, как N/A.")
	rd_fields += add_field(/datum/report_field/signature, "Подпись Главного Научного Офицера")
	heads_fields += add_field(/datum/report_field/signature, "Подпись главы отдела аугментированного")
	set_access(access_robotics, access_robotics, override = 0)
	for(var/datum/report_field/field in rd_fields)
		field.set_access(access_edit = access_rd)
	for(var/datum/report_field/field in sci_fields)
		field.set_access(access_edit = access_xenobiology)
	for(var/datum/report_field/field in heads_fields)
		field.set_access(access_edit = access_heads)
