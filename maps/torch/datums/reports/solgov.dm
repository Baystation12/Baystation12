
/datum/computer_file/report/recipient/sol
	logo = "\[solcrest\]"
	form_name = "SCG-REP-00"

/datum/computer_file/report/recipient/sol/generate_fields()
	..()
	set_access(access_representative)

/datum/computer_file/report/recipient/sol/audit
	form_name = "SCG-REP-12"
	title = "Проверка департамента"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/sol/audit/generate_fields()
	add_field(/datum/report_field/date, "Дата")
	add_field(/datum/report_field/time, "Время")
	add_field(/datum/report_field/simple_text, "Название отдела", required = 1)
	add_field(/datum/report_field/pencode_text, "Положительные наблюдения")
	add_field(/datum/report_field/pencode_text, "Отрицательные наблюдения")
	add_field(/datum/report_field/pencode_text, "Другие заметки")
	add_field(/datum/report_field/signature, "Подпись", required = 1)
	add_field(/datum/report_field/options/yes_no, "Одобрено")
	set_access(list(list(access_heads, access_liaison)), list(list(access_heads, access_liaison)))
	..()

/datum/computer_file/report/recipient/sol/crewman_incident
	form_name = "SCG-REP-4"
	title = "Рапорт об инцидентах, произошедших с экипажем корабля"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/sol/crewman_incident/generate_fields()
	add_field(/datum/report_field/date, "Дата")
	add_field(/datum/report_field/time, "Время")
	add_field(/datum/report_field/people/from_manifest, "Вовлечённый член экипажа", required = 1)
	add_field(/datum/report_field/simple_text, "Описание инцидента", required = 1)
	add_field(/datum/report_field/pencode_text, "Детали инцидента", required = 1)
	add_field(/datum/report_field/signature, "Подпись", required = 1)
	add_field(/datum/report_field/options/yes_no, "Одобрено")
	set_access(list(list(access_heads, access_representative, access_senadv, access_cent_creed)), list(list(access_heads, access_representative, access_senadv, access_cent_creed)), override = 0)
	..()

/datum/computer_file/report/recipient/sol/work_visa
	form_name = "SCG-REP-03b"
	title = "Получение рабочей визы"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/sol/work_visa/generate_fields()
	var/datum/report_field/temp_field
	add_field(/datum/report_field/date, "Дата")
	add_field(/datum/report_field/time, "Время")
	add_field(/datum/report_field/people/from_manifest, "Получатель визы", required = 1)
	add_field(/datum/report_field/simple_text, "Раса получателя", required = 1)
	temp_field = add_field(/datum/report_field/signature, "Подпись, выписывающего визу", required = 1)
	add_field(/datum/report_field/signature, "Подпись получателя", required = 1)
	add_field(/datum/report_field/options/yes_no, "Одобрено")
	temp_field.set_access(access_edit = access_representative)
	..()
