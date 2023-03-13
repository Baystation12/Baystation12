/datum/computer_file/report/recipient/command/generate_fields()
	..()
	set_access(list(list(access_heads, access_cent_creed)))

/datum/computer_file/report/recipient/command/report
	form_name = "REP-SCG"
	title = "Общая форма отчёта"
	logo = "\[solcrest\]"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/command/report/generate_fields()
	..()
	add_field(/datum/report_field/text_label/instruction, "Этот факс был отправлен командованием ГЭК Факел")
	add_field(/datum/report_field/date, "Дата")
	add_field(/datum/report_field/time, "Время")
	add_field(/datum/report_field/people/from_manifest, "Полное имя, звание и должность", required = 1)
	add_field(/datum/report_field/simple_text, "Приоритетность", required = 1)
	add_field(/datum/report_field/simple_text, "Тема", required = 1)
	add_field(/datum/report_field/pencode_text, "Сообщение", required = 1)
	add_field(/datum/report_field/signature, "Подпись", required = 1)
	set_access(list(list(access_qm, access_senadv, access_representative)), list(list(access_qm, access_senadv, access_representative)), override = 0)


/datum/computer_file/report/recipient/command/request_command
	form_name = "REQ-SCG"
	title = "Запрос к Командованию"
	logo = "\[logo\]"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/command/request_command/generate_fields()
	..()
	add_field(/datum/report_field/number, "Номер запроса ")
	add_field(/datum/report_field/people/from_manifest, "Полное имя, звание и должность запросившего", required = 1)
	add_field(/datum/report_field/pencode_text, "Содержание запроса", required = 1)
	add_field(/datum/report_field/pencode_text, "Причина запроса", required = 1)
	add_field(/datum/report_field/date, "Дата заполнения")
	add_field(/datum/report_field/time, "Время заполнения")
	add_field(/datum/report_field/text_label/instruction, "Документ является недействительным в случае отсутствия подписи или печати.")
	add_field(/datum/report_field/signature, "Подпись", required = 1)
	set_access(list(list(access_qm, access_senadv, access_representative)), list(list(access_qm, access_senadv, access_representative)), override = 0)


/datum/computer_file/report/recipient/command/decree
	form_name = "DEC-NTF"
	title = "Указ Командования"
	logo = "\[solcrest\]"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/command/decree/generate_fields()
	..()
	add_field(/datum/report_field/number, "Номер указа")
	add_field(/datum/report_field/people/from_manifest, "Полное имя, звание и должность распорядителя", required = 1)
	add_field(/datum/report_field/pencode_text, "Содержание распоряжения", required = 1)
	add_field(/datum/report_field/pencode_text, "Причина распоряжения", required = 1)
	add_field(/datum/report_field/date, "Дата заполнения")
	add_field(/datum/report_field/time, "Время заполнения")
	add_field(/datum/report_field/text_label/instruction, "Документ является недействительным в случае отсутствия подписи или печати.")
	add_field(/datum/report_field/signature, "Подпись", required = 1)

/datum/computer_file/report/recipient/command/crew_transfer
	form_name = "CTA-SGF-01"
	title = "Смена занимаемой должности"
	logo = "\[solcrest\]"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/command/crew_transfer/generate_fields()
	..()
	var/list/xo_fields = list()
	add_field(/datum/report_field/text_label/header, "ГЭК \"Факел\" - Офис Исполнительного офицера")
	add_field(/datum/report_field/people/from_manifest, "Полное имя и звание Исполнителя(Исполнительный/Командующий офицер)", required = 1)
	add_field(/datum/report_field/people/from_manifest, "Полное имя, звание и должность Заявителя", required = 1)
	add_field(/datum/report_field/date, "Дата заполнения")
	add_field(/datum/report_field/time, "Время заполнения")
	add_field(/datum/report_field/simple_text, "Запрашиваемая должность", required = 1)
	add_field(/datum/report_field/pencode_text, "Причина перевода", required = 1)
	add_field(/datum/report_field/text_label/instruction, "Документ является недействительным в случае отсутствия подписи или печати.")
	add_field(/datum/report_field/signature, "Подпись Заявителя", required = 1)
	xo_fields += add_field(/datum/report_field/signature, "Подпись Исполнителя(Исполнительный/Командующий офицер)")
	xo_fields += add_field(/datum/report_field/options/yes_no, "Одобрено")
	for(var/datum/report_field/field in xo_fields)
		field.set_access(access_edit = access_hop)

/datum/computer_file/report/recipient/command/access_modification
	form_name = "AMA-SGF-02"
	title = "Получение расширенного доступа"
	logo = "\[solcrest\]"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/command/access_modification/generate_fields()
	..()
	var/list/xo_fields = list()
	add_field(/datum/report_field/text_label/header, "ГЭК \"Факел\" - Офис Исполнительного офицера")
	add_field(/datum/report_field/people/from_manifest, "Полное имя и звание Исполнителя(Исполнительный/Командующий офицер)", required = 1)
	add_field(/datum/report_field/people/from_manifest, "Полное имя, звание и должность Заявителя", required = 1)
	add_field(/datum/report_field/date, "Дата заполнения")
	add_field(/datum/report_field/time, "Время заполнения")
	add_field(/datum/report_field/simple_text, "Запрашиваемый доступ", required = 1)
	add_field(/datum/report_field/pencode_text, "Причина расширения доступа", required = 1)
	add_field(/datum/report_field/simple_text, "Срок расширения доступа")
	add_field(/datum/report_field/text_label/instruction, "Документ является недействительным в случае отсутствия подписи или печати.")
	add_field(/datum/report_field/signature, "Подпись Заявителя", required = 1)
	xo_fields += add_field(/datum/report_field/signature, "Подпись Исполнителя(Исполнительный/Командующий офицер)")
	xo_fields += add_field(/datum/report_field/options/yes_no, "Одобрено")
	for(var/datum/report_field/field in xo_fields)
		field.set_access(access_edit = access_hop)

/datum/computer_file/report/recipient/command/borging
	form_name = "CC-SGF-09"
	title = "Контракт на добровольную Кибернетизацию"
	logo = "\[solcrest\]"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/command/borging/generate_fields()
	..()
	var/list/xo_fields = list()
	add_field(/datum/report_field/text_label/header, "ГЭК \"Факел\" - Офис Исполнительного офицера")
	add_field(/datum/report_field/people/from_manifest, "Полное имя и звание Исполнителя(Исполнительный/Командующий офицер)")
	add_field(/datum/report_field/people/from_manifest, "Полное имя и звание Заявителя", required = 1)
	add_field(/datum/report_field/date, "Дата заполнения")
	add_field(/datum/report_field/time, "Время заполнения")
	add_field(/datum/report_field/text_label/instruction, "Я, нижеподписавшийся, настоящим соглашаюсь добровольно пройти прижизненную лоботомию с намерением киборгизации \
	или ассимиляции с ИИ, и я осознаю все последствия такого акта. Я также понимаю, что эта операция может быть необратимой, и что мой трудовой договор будет расторгнут.")
	add_field(/datum/report_field/signature, "Подпись Заявителя")
	xo_fields += add_field(/datum/report_field/signature, "Подпись Исполнителя(Исполнительный/Командующий офицер)")
	xo_fields += add_field(/datum/report_field/options/yes_no, "Одобрено")
	for(var/datum/report_field/field in xo_fields)
		field.set_access(access_edit = access_hop)

/datum/computer_file/report/recipient/command/gratitude
	form_name = "CC-SGF-11"
	title = "Благодарность"
	logo = "\[solcrest\]"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/command/gratitude/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "ГЭК \"Факел\" - Офис Исполнительного офицера")
	add_field(/datum/report_field/text_label, "Благодарность")
	add_field(/datum/report_field/pencode_text, "Текст благодарности")
	add_field(/datum/report_field/people/from_manifest, "Полное имя, звание и должность лица, получившего благодарность", required = 1)
	add_field(/datum/report_field/people/from_manifest, "Полное имя и звание лица, выдавшего благодарность", required = 1)
	add_field(/datum/report_field/date, "Дата заполнения")
	add_field(/datum/report_field/time, "Время заполнения")
	add_field(/datum/report_field/signature, "Подпись лица, выдавшего благодарность", required = 1)

/datum/computer_file/report/recipient/command/issuing_bonuses
	form_name = "CC-SGF-12"
	title = "Представление о премировании"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/command/issuing_bonuses/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "ГЭК \"Факел\" - Офис Исполнительного офицера")
	add_field(/datum/report_field/people/from_manifest, "Полное имя, звание и должность лица, получившего премию", required = 1)
	add_field(/datum/report_field/simple_text, "Департамент", required = 1)
	add_field(/datum/report_field/simple_text, "Размер премии", required = 1)
	add_field(/datum/report_field/pencode_text, "Причина премирования", required = 1)
	add_field(/datum/report_field/people/from_manifest, "Полное имя, звание и должность лица, назначившего премирование", required = 1)
	add_field(/datum/report_field/signature, "Подпись лица, назначившего премирование", required = 1)
	add_field(/datum/report_field/signature, "Подпись о получении премиальных", required = 1)
	add_field(/datum/report_field/date, "Дата заполнения")
	add_field(/datum/report_field/time, "Время заполнения")
