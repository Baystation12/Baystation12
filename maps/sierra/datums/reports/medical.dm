/datum/computer_file/report/recipient/med/generate_fields()
	..()
	set_access (list(list(access_medical_equip, access_psychiatrist)))

/datum/computer_file/report/recipient/med/recipe
	form_name = "NT-MED-01"
	title = "Назначение рецепта медицинского препарата"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/med/recipe/generate_fields()
	..()
	var/list/cmo_fields = list()
	add_field(/datum/report_field/text_label/header, "ИКН Сьерра - Медицинский департамент")
	add_field(/datum/report_field/people/from_manifest, "Сотрудник, назначающий рецепт", required = 1)
	add_field(/datum/report_field/signature, "Подпись сотрудника", required = 1)
	add_field(/datum/report_field/simple_text, "Наименование препарата", required = 1)
	add_field(/datum/report_field/people/from_manifest, "Имя и должность пациента", required = 1)
	add_field(/datum/report_field/simple_text, "Рекомендуемые дозировки", required = 1)
	add_field(/datum/report_field/text_label/instruction,"Рецепт действителен 30 (тридцать) стандартных земных суток с момента выдачи, начиная со дня получения.")
	add_field(/datum/report_field/date, "Дата выдачи рецепта")
	add_field(/datum/report_field/pencode_text, "Постановление врача", required = 1)
	cmo_fields += add_field(/datum/report_field/signature, "Подпись главного врача", required = 1)
	set_access(access_edit = access_medical)
	for(var/datum/report_field/field in cmo_fields)
		field.set_access(access_edit = access_cmo)

/datum/computer_file/report/recipient/med/checkup
	form_name = "NT-MED-03b"
	title = "Контрольный список для медицинского осмотра"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/med/checkup/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "ИКН Сьерра - Медицинский департамент")
	add_field(/datum/report_field/people/from_manifest, "Пациент")
	add_field(/datum/report_field/date, "Дата")
	add_field(/datum/report_field/time, "Время")
	add_field(/datum/report_field/number, "Пульс(уд/мин)")
	add_field(/datum/report_field/simple_text, "Кровяное давление")
	add_field(/datum/report_field/simple_text, "Как звучит сердце?")
	add_field(/datum/report_field/simple_text, "Как звучат лёгкие?")
	add_field(/datum/report_field/simple_text, "Занимается ли пациент спортом?")
	add_field(/datum/report_field/simple_text, "Если пациент курит, то сколько раз в день?")
	add_field(/datum/report_field/simple_text, "Реакция зрачков на свет")
	add_field(/datum/report_field/simple_text, "Подвергался ли пациент радиационному облучению в недавнее время?")
	add_field(/datum/report_field/simple_text, "Болел ли пациент каким-либо заболеваниями в недавнее время?")
	add_field(/datum/report_field/pencode_text, "Дополнительные заметки")
	add_field(/datum/report_field/signature, "Подпись врача", required = 1)

/datum/computer_file/report/recipient/med/insanity_resolution
	logo = "\[sierralogo\]"
	form_name = "NT-MED-02"
	title = "Постановление о невменяемости"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/med/insanity_resolution/generate_fields()
	..()
	var/list/cmo_fields = list()
	add_field(/datum/report_field/text_label/header, "ИКН Сьерра - Медицинский департамент")
	add_field(/datum/report_field/people/from_manifest, "Имя и должность пациента", required = 1)
	add_field(/datum/report_field/simple_text, "Дата рождения", required = 1)
	add_field(/datum/report_field/number, "Возраст", required = 1)
	add_field(/datum/report_field/simple_text, "Диагноз", required = 1)
	cmo_fields += add_field(/datum/report_field/pencode_text, "Постановление главврача", required = 1)
	cmo_fields += add_field(/datum/report_field/signature, "Подпись главного врача", required = 1)
	add_field(/datum/report_field/date, "Дата", required = 1)
	add_field(/datum/report_field/time, "Время", required = 1)
	add_field(/datum/report_field/text_label/instruction,"Признание невменяемым означает полное отстранение от выполнения должностных обязанностей. \
	Документ является недействительным при отсутствии подписи и печати главврача.")
	for(var/datum/report_field/field in cmo_fields)
		field.set_access(access_edit = access_cmo)

/datum/computer_file/report/recipient/med/report_autopsy
	logo = "\[sierralogo\]"
	form_name = "NT-MED-03"
	title = "Отчет о вскрытии"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/med/report_autopsy/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "ИКН Сьерра - Медицинский департамент")
	add_field(/datum/report_field/people/from_manifest, "Имя и должность погибшего", required = 1)
	add_field(/datum/report_field/simple_text, "Раса", required = 1)
	add_field(/datum/report_field/simple_text, "Пол", required = 1)
	add_field(/datum/report_field/number, "Возраст", required = 1)
	add_field(/datum/report_field/date, "Дата смерти", required = 1)
	add_field(/datum/report_field/time, "Время смерти", required = 1)
	add_field(/datum/report_field/simple_text, "Причина смерти", required = 1)
	add_field(/datum/report_field/pencode_text, "Дополнительные сведения")
	add_field(/datum/report_field/date, "Дата вскрытия", required = 1)
	add_field(/datum/report_field/time, "Время вскрытия", required = 1)
	add_field(/datum/report_field/people/from_manifest, "Вскрытие проводил", required = 1)
	add_field(/datum/report_field/signature, "Подпись", required = 1)
	add_field(/datum/report_field/text_label/instruction, "Сотрудник, проводящий вскрытие, обязан обеспечить безопасную доставку личных и служебных вещей погибшего в Отдел Защиты Активов объекта, \
	либо их хранение в морге объекта.")
	set_access(access_morgue, access_morgue)

/datum/computer_file/report/recipient/med/medical_services
	logo = "\[sierralogo\]"
	form_name = "NT-MED-05"
	title = "Справка об оказании медицинских услуг"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/med/medical_services/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "ИКН Сьерра - Медицинский департамент")
	add_field(/datum/report_field/number, "Номер справки")
	add_field(/datum/report_field/people/from_manifest, "Имя и должность пациента", required = 1)
	add_field(/datum/report_field/simple_text, "Раса", required = 1)
	add_field(/datum/report_field/simple_text, "Пол", required = 1)
	add_field(/datum/report_field/number, "Возраст", required = 1)
	add_field(/datum/report_field/pencode_text, "Причины госпитализации", required = 1)
	add_field(/datum/report_field/pencode_text, "Синопсис оказанных услуг", required = 1)
	add_field(/datum/report_field/pencode_text, "Дополнительные сведения")
	add_field(/datum/report_field/date, "Дата оказания услуги")
	add_field(/datum/report_field/time, "Время заполнения")
	add_field(/datum/report_field/people/from_manifest, "Лечение проводил", required = 1)
	add_field(/datum/report_field/signature, "Подпись", required = 1)
	add_field(/datum/report_field/text_label/instruction, "Документ имеет юридическую силу исключительно в случае наличия подписи сотрудника, \
	а также печати Главного Врача, либо любых двух и более печатей действующих на объекте сотрудников командного департамента.")
