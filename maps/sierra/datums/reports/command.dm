/datum/computer_file/report/recipient
	logo = "\[sierralogo\]"
	available_on_ntnet = 0

/datum/computer_file/report/recipient/command/generate_fields()
	..()
	set_access(access_heads)

/datum/computer_file/report/recipient/command/crew_transfer
	form_name = "CTA-NTF-01"
	title = "Заявление на перевод"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/command/crew_transfer/generate_fields()
	..()
	var/list/hop_fields = list()
	add_field(/datum/report_field/text_label/header, "ИКН Сьерра - Командный департамент")
	add_field(/datum/report_field/people/from_manifest, "Полное имя Исполнителя (Глава Персонала/Капитан)", required = 1)
	add_field(/datum/report_field/people/from_manifest, "Полное имя Заявителя", required = 1)
	add_field(/datum/report_field/date, "Дата заполнения")
	add_field(/datum/report_field/time, "Время заполнения")
	add_field(/datum/report_field/simple_text, "Текущая должность", required = 1)
	add_field(/datum/report_field/simple_text, "Запрашиваемая должность", required = 1)
	add_field(/datum/report_field/pencode_text, "Причина перевода", required = 1)
	add_field(/datum/report_field/text_label/instruction, "Документ является недействительным в случае отсутствия подписи или печати.")
	add_field(/datum/report_field/signature, "Подпись Заявителя", required = 1)
	hop_fields += add_field(/datum/report_field/signature, "Подпись Исполнителя (Глава Персонала/Капитан)", required = 1)
	hop_fields += add_field(/datum/report_field/options/yes_no, "Одобрено")
	for(var/datum/report_field/field in hop_fields)
		field.set_access(access_edit = access_hop)

/datum/computer_file/report/recipient/command/access_modification
	form_name = "AMA-NTF-02"
	title = "Заявление на изменение доступа"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/command/access_modification/generate_fields()
	..()
	var/list/hop_fields = list()
	add_field(/datum/report_field/text_label/header, "ИКН Сьерра - Командный департамент")
	add_field(/datum/report_field/people/from_manifest, "Полное имя Исполнителя (Глава Персонала/Капитан)", required = 1)
	add_field(/datum/report_field/people/from_manifest, "Полное имя Заявителя", required = 1)
	add_field(/datum/report_field/date, "Дата заполнения", required = 1)
	add_field(/datum/report_field/time, "Время заполнения", required = 1)
	add_field(/datum/report_field/simple_text, "Текущая должность", required = 1)
	add_field(/datum/report_field/simple_text, "Запрашиваемый доступ", required = 1)
	add_field(/datum/report_field/pencode_text, "Причина расширения доступа", required = 1)
	add_field(/datum/report_field/simple_text, "Срок расширения доступа", required = 1)
	add_field(/datum/report_field/text_label/instruction, "Документ является недействительным в случае отсутствия подписи или печати.")
	add_field(/datum/report_field/signature, "Подпись Заявителя", required = 1)
	hop_fields += add_field(/datum/report_field/signature, "Подпись Исполнителя (Глава Персонала/Капитан)", required = 1)
	hop_fields += add_field(/datum/report_field/options/yes_no, "Одобрено")
	for(var/datum/report_field/field in hop_fields)
		field.set_access(access_edit = access_hop)

/datum/computer_file/report/recipient/command/fire
	form_name = "D-NTF-01"
	title = "Прекращение трудового контракта NT"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/command/fire/generate_fields()
	..()
	var/list/hop_fields = list()
	add_field(/datum/report_field/text_label/header, "ИКН Сьерра - Командный департамент")
	add_field(/datum/report_field/text_label/instruction, "К документу должно быть прикрепленно личное дело сотрудника.")
	add_field(/datum/report_field/people/from_manifest, "Полное имя Исполнителя (Глава Персонала/Капитан)", required = 1)
	add_field(/datum/report_field/people/from_manifest, "Полное имя Уволенного", required = 1)
	add_field(/datum/report_field/date, "Дата заполнения")
	add_field(/datum/report_field/time, "Время заполнения")
	add_field(/datum/report_field/simple_text, "Занимаемая должность Уволенного", required = 1)
	add_field(/datum/report_field/simple_text, "Новая должность Уволенного", required = 1)
	add_field(/datum/report_field/pencode_text, "Причина увольнения", required = 1)
	add_field(/datum/report_field/text_label/instruction, "Документ является недействительным в случае отсутствия подписи или печати.")
	add_field(/datum/report_field/signature, "Подпись Увольняемого (если требуется)")
	hop_fields += add_field(/datum/report_field/signature, "Подпись Исполнителя (Глава Персонала/Капитан)", required = 1)
	hop_fields += add_field(/datum/report_field/options/yes_no, "Одобрено")
	for(var/datum/report_field/field in hop_fields)
		field.set_access(access_edit = access_hop)

/datum/computer_file/report/recipient/command/decree
	form_name = "DEC-NTF"
	title = "Корпоративный Указ"
	logo ="\[logo\]"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/command/decree/generate_fields()
	..()
	add_field(/datum/report_field/number, "Номер указа")
	add_field(/datum/report_field/people/from_manifest, "Полное имя распорядителя", required = 1)
	add_field(/datum/report_field/pencode_text, "Содержание распоряжения", required = 1)
	add_field(/datum/report_field/pencode_text, "Причина распоряжения", required = 1)
	add_field(/datum/report_field/date, "Дата заполнения")
	add_field(/datum/report_field/time, "Время заполнения")
	add_field(/datum/report_field/text_label/instruction, "Документ является недействительным в случае отсутствия подписи или печати.")
	add_field(/datum/report_field/signature, "Подпись", required = 1)

/datum/computer_file/report/recipient/command/request_corporate
	form_name = "REQ-NTF"
	title = "Корпоративный Запрос"
	logo = "\[logo\]"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/command/request_corporate/generate_fields()
	..()
	add_field(/datum/report_field/number, "Номер запроса ")
	add_field(/datum/report_field/people/from_manifest, "Полное имя запросившего", required = 1)
	add_field(/datum/report_field/pencode_text, "Содержание запроса", required = 1)
	add_field(/datum/report_field/pencode_text, "Причина запроса", required = 1)
	add_field(/datum/report_field/date, "Дата заполнения")
	add_field(/datum/report_field/time, "Время заполнения")
	add_field(/datum/report_field/text_label/instruction, "Документ является недействительным в случае отсутствия подписи или печати.")
	add_field(/datum/report_field/signature, "Подпись", required = 1)
	set_access(list(list(access_qm, access_el)), list(list(access_qm, access_el)), override = 0)

/datum/computer_file/report/recipient/command/issuing_bonuses
	form_name = "CTA-IB-01"
	title = "Представление о премировании сотрудника"
	logo = "\[logo\]"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/command/issuing_bonuses/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "ИКН Сьерра - Командный департамент")
	add_field(/datum/report_field/people/from_manifest, "Имя, фамилия и должность сотрудника", required = 1)
	add_field(/datum/report_field/simple_text, "Департамент", required = 1)
	add_field(/datum/report_field/simple_text, "Размер премии", required = 1)
	add_field(/datum/report_field/pencode_text, "Причина премирования", required = 1)
	add_field(/datum/report_field/people/from_manifest, "Полное имя, фамилия и должность сотрудника, назначившего премирование", required = 1)
	add_field(/datum/report_field/signature, "Подпись сотрудника, назначившего премирование", required = 1)
	add_field(/datum/report_field/signature, "Подпись о получении премиальных", required = 1)
	add_field(/datum/report_field/date, "Дата заполнения")
	add_field(/datum/report_field/time, "Время заполнения")
