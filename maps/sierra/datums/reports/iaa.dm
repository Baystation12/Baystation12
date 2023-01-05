/datum/computer_file/report/recipient/iaa/generate_fields()
	..()
	set_access(access_heads)

/datum/computer_file/report/recipient/iaa/incident
	form_name = "IA-NTCO-01"
	logo ="\[logo\]"
	title = "Рапорт об инциденте на корабле"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/iaa/incident/generate_fields()
	..()
	var/list/heads_fields = list()
	add_field(/datum/report_field/date, "Дата")
	add_field(/datum/report_field/time, "Время")
	add_field(/datum/report_field/simple_text, "Краткое изложение инцидента", required = 1)
	add_field(/datum/report_field/pencode_text, "Подробное описание инцидента", required = 1)
	add_field(/datum/report_field/people/from_manifest, "Данный рапорт был составлен", required = 1)
	add_field(/datum/report_field/signature, "Подпись", required = 1)
	heads_fields += add_field(/datum/report_field/people/from_manifest, "Данный рапорт был рассмотрен и утвержден", required = 1)
	heads_fields += add_field(/datum/report_field/signature, "Подпись", required = 1)
	add_field(/datum/report_field/text_label/instruction, "Документ является недействительным в случае отсутствия подписи и печати Агента Внутренних Дел или департамента.")
	for(var/datum/report_field/field in heads_fields)
		field.set_access(access_edit = access_heads)

/datum/computer_file/report/recipient/iaa/incident_staff
	form_name = "HR-NTCO-01a"
	logo ="\[logo\]"
	title = "Рапорт об инцидентах, произошедших с сотрудниками"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/iaa/incident_staff/generate_fields()
	..()
	var/list/heads_fields = list()
	add_field(/datum/report_field/date, "Дата")
	add_field(/datum/report_field/time, "Время")
	add_field(/datum/report_field/pencode_text, "Описание происшествия", required = 1)
	add_field(/datum/report_field/people/list_from_manifest, "Сотрудник(и) замеченные в прошествии (по возможности укажите должности и фотографии)", required = 1)
	add_field(/datum/report_field/pencode_text, "Подробности происшествия", required = 1)
	add_field(/datum/report_field/people/from_manifest, "Данный рапорт был составлен", required = 1)
	add_field(/datum/report_field/signature, "Подпись", required = 1)
	heads_fields += add_field(/datum/report_field/people/from_manifest, "Данный рапорт был рассмотрен и утвержден", required = 1)
	heads_fields += add_field(/datum/report_field/signature, "Подпись", required = 1)
	add_field(/datum/report_field/text_label/instruction, "Документ является недействительным в случае отсутствия подписи и печати Агента Внутренних Дел или департамента.")
	for(var/datum/report_field/field in heads_fields)
		field.set_access(access_edit = access_heads)

/datum/computer_file/report/recipient/iaa/incident_assets
	form_name = "HR-NTCO-01b"
	logo ="\[logo\]"
	title = "Рапорт о происшествии с активами"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/iaa/incident_assets/generate_fields()
	..()
	var/list/heads_fields = list()
	add_field(/datum/report_field/text_label/instruction, "Для сотрудников NanoTrasen, форма HR-NTCO-01a.")
	add_field(/datum/report_field/date, "Дата")
	add_field(/datum/report_field/time, "Время")
	add_field(/datum/report_field/pencode_text, "Описание происшествия", required = 1)
	add_field(/datum/report_field/pencode_text, "Подробности происшествия", required = 1)
	add_field(/datum/report_field/people/list_from_manifest, "Раненые или убитые сотрудники NanoTrasen", required = 1)
	add_field(/datum/report_field/pencode_text, "Список потерянных активов NanoTrasen", required = 1)
	add_field(/datum/report_field/people/from_manifest, "Данный рапорт был составлен", required = 1)
	add_field(/datum/report_field/signature, "Подпись", required = 1)
	heads_fields += add_field(/datum/report_field/people/from_manifest, "Данный рапорт был рассмотрен и утвержден", required = 1)
	heads_fields += add_field(/datum/report_field/signature, "Подпись", required = 1)
	add_field(/datum/report_field/text_label/instruction, "Документ является недействительным в случае отсутствия подписи и печати Агента Внутренних Дел или департамента.")
	for(var/datum/report_field/field in heads_fields)
		field.set_access(access_edit = access_heads)

/datum/computer_file/report/recipient/iaa/incident_repstaff
	form_name = "HR-NTCO-01e"
	logo ="\[logo\]"
	title = "Отчет персонала о происшествии"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/iaa/incident_repstaff/generate_fields()
	..()
	var/list/heads_fields = list()
	add_field(/datum/report_field/text_label/instruction, "Только для доклада о нескольких участниках, связанных как с экипажем корабля, так и с персоналом NT")
	add_field(/datum/report_field/date, "Дата")
	add_field(/datum/report_field/time, "Время")
	add_field(/datum/report_field/pencode_text, "Описание происшествия", required = 1)
	add_field(/datum/report_field/people/list_from_manifest, "Экипаж и сотрудники, участвующие в происшествии", required = 1)
	add_field(/datum/report_field/pencode_text, "Подробности происшествия", required = 1)
	add_field(/datum/report_field/people/from_manifest, "Данный рапорт был составлен", required = 1)
	add_field(/datum/report_field/signature, "Подпись", required = 1)
	heads_fields += add_field(/datum/report_field/people/from_manifest, "Данный рапорт был рассмотрен и утвержден", required = 1)
	heads_fields += add_field(/datum/report_field/signature, "Подпись", required = 1)
	add_field(/datum/report_field/text_label/instruction, "Документ является недействительным в случае отсутствия подписи и печати Агента Внутренних Дел или департамента.")
	for(var/datum/report_field/field in heads_fields)
		field.set_access(access_edit = access_heads)

/datum/computer_file/report/recipient/archive
	form_name = "HR-NTCO-04a"
	logo ="\[logo\]"
	title = "Внутренний архив"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/archive/generate_fields()
	..()
	add_field(/datum/report_field/date, "Дата")
	add_field(/datum/report_field/pencode_text, "Меморандум", required = 1)
	add_field(/datum/report_field/signature, "Подпись", required = 1)
	add_field(/datum/report_field/text_label/instruction, "Документ является недействительным в случае отсутствия печати Агента Внутренних Дел или департамента.")

/datum/computer_file/report/recipient/iaa/memo
	form_name = "HR-NTCO-04a"
	logo ="\[logo\]"
	title = "Межведомственная памятка"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/iaa/memo/generate_fields()
	..()
	var/list/capiaa_fields = list()
	add_field(/datum/report_field/date, "Дата")
	add_field(/datum/report_field/pencode_text, "Меморандум", required = 1)
	capiaa_fields += add_field(/datum/report_field/signature, "Подпись", required = 1)
	add_field(/datum/report_field/text_label/instruction, "Документ является недействительным в случае отсутствия печати Агента Внутренних Дел или капитана.")
	set_access(list(list(access_captain, access_iaa)), list(list(access_captain, access_iaa)))
	for(var/datum/report_field/field in capiaa_fields)
		field.set_access(access_edit = list(list(access_captain, access_iaa)))

/datum/computer_file/report/recipient/iaa/work_visa
	form_name = "HR-NTCO-03b"
	logo ="\[logo\]"
	title = "Запрос рабочей визы"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/iaa/work_visa/generate_fields()
	..()
	var/list/iaa_fields = list()
	add_field(/datum/report_field/date, "Дата")
	add_field(/datum/report_field/time, "Время")
	add_field(/datum/report_field/simple_text, "Получатель визы", required = 1)
	iaa_fields += add_field(/datum/report_field/signature, "Подпись, выписывающего визу", required = 1)
	add_field(/datum/report_field/signature, "Подпись получателя", required = 1)
	add_field(/datum/report_field/text_label/instruction, "Документ является недействительным в случае отсутствия печати Агента Внутренних Дел.")
	for(var/datum/report_field/field in iaa_fields)
		field.set_access(access_edit = access_iaa)

/datum/computer_file/report/recipient/iaa/salary_deceased
	form_name = "HR-NTCO-03c"
	logo ="\[logo\]"
	title = "Выплата оставшегося оклада погибшему сотруднику"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/iaa/salary_deceased/generate_fields()
	..()
	var/list/iaahop_fields = list()
	add_field(/datum/report_field/date, "Дата")
	add_field(/datum/report_field/time, "Время")
	add_field(/datum/report_field/people/from_manifest, "Данный документ разрешает выплату оставшегося оклада погибшему сотруднику NT")
	add_field(/datum/report_field/pencode_text, "Помимо полной выплаты оставшихся личных активов(Актив, стоимость актива в талерах)", required = 1)
	add_field(/datum/report_field/pencode_text, "Включая личные вещи", required = 1)
	add_field(/datum/report_field/text_label, "Должно быть немедленно отправлено ближайшему родственнику сотрудника.")
	add_field(/datum/report_field/people/from_manifest, "Данный рапорт был составлен", required = 1)
	add_field(/datum/report_field/signature, "Подпись", required = 1)
	iaahop_fields += add_field(/datum/report_field/people/from_manifest, "Данный рапорт был рассмотрен", required = 1)
	iaahop_fields += add_field(/datum/report_field/signature, "Подпись", required = 1)
	add_field(/datum/report_field/text_label/instruction, "Документ является недействительным в случае отсутствия печати Агента Внутренних Дел.")
	for(var/datum/report_field/field in iaahop_fields)
		field.set_access(access_edit = list(list(access_hop, access_iaa)))

/datum/computer_file/report/recipient/iaa/check_citizenship
	form_name = "HR-NTCO-02a"
	logo ="\[logo\]"
	title = "Запрос проверки гражданства сотрудника"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/iaa/check_citizenship/generate_fields()
	..()
	var/list/iaahop_fields = list()
	add_field(/datum/report_field/date, "Дата")
	add_field(/datum/report_field/time, "Время")
	add_field(/datum/report_field/people/from_manifest, "Имя и должность сотрудника", required = 1)
	add_field(/datum/report_field/text_label/instruction, "Фото обязательно.")
	add_field(/datum/report_field/text_label, "Прошу вас выслать все личные записи на данного сотрудника.")
	iaahop_fields += add_field(/datum/report_field/people/from_manifest, "Данная форма был рассмотрена", required = 1)
	iaahop_fields += add_field(/datum/report_field/signature, "Подпись", required = 1)
	iaahop_fields += add_field(/datum/report_field/options/yes_no, "Данная форма была одобрена/отклонена")
	add_field(/datum/report_field/text_label/instruction, "Документ является недействительным в случае отсутствия печати Агента Внутренних Дел.")
	for(var/datum/report_field/field in iaahop_fields)
		field.set_access(access_edit = list(access_hop, access_iaa))
	set_access(access_security, override = 0)

/datum/computer_file/report/recipient/iaa/audit
	form_name = "HR-NTCO-03f"
	logo = "\[logo\]"
	title = "Аудит департамента ИКН Сьерра"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/iaa/audit/generate_fields()
	..()
	var/list/capiaa_fields = list()
	add_field(/datum/report_field/date, "Дата")
	add_field(/datum/report_field/time, "Время")
	add_field(/datum/report_field/people/from_manifest, "Глава департамента")
	add_field(/datum/report_field/pencode_text, "Положительные наблюдения")
	add_field(/datum/report_field/pencode_text, "Отрицательные наблюдения")
	add_field(/datum/report_field/pencode_text, "Прочие заметки")
	add_field(/datum/report_field/people/from_manifest, "Данный рапорт был составлен", required = 1)
	add_field(/datum/report_field/signature, "Подпись", required = 1)
	capiaa_fields += add_field(/datum/report_field/people/from_manifest, "Данный рапорт был рассмотрен", required = 1)
	capiaa_fields += add_field(/datum/report_field/signature, "Подпись", required = 1)
	add_field(/datum/report_field/text_label/instruction, "Документ является недействительным в случае отсутствия подписи или печати.")
	for(var/datum/report_field/field in capiaa_fields)
		field.set_access(access_edit = list(list(access_captain, access_iaa)))
