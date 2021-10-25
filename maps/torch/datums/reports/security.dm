
/datum/computer_file/report/recipient/sec
	logo = "\[solcrest\]"

/datum/computer_file/report/recipient/sec/generate_fields()
	..()
	set_access(access_brig)

/datum/computer_file/report/recipient/sec/incident
	form_name = "SCG-SEC-01"
	title = "Отчет об происшествии"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/sec/incident/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "ГЭК \"Факел\" - Охранный Отдел")
	add_field(/datum/report_field/text_label/instruction, "Заполняется дежурным офицером.")
	add_field(/datum/report_field/time, "Время происшествия", required = 1)
	add_field(/datum/report_field/simple_text, "Тип происшествия/преступления", required = 1)
	add_field(/datum/report_field/simple_text, "Местоположение", required = 1)
	add_field(/datum/report_field/people/from_manifest, "Отчет заполнил", required = 1)
	add_field(/datum/report_field/people/list_from_manifest, "Офицер(ы), которые были на месте происшествия", required = 1)
	add_field(/datum/report_field/pencode_text, "Персонал, участвующий в инциденте", required = 1)
	add_field(/datum/report_field/text_label/instruction, "(Ж-Жертва, П-Подозреваемый, С-Свидетель, Пр-Пропавший, A-Арестованный, М-Мертвец)")
	add_field(/datum/report_field/pencode_text, "Описание предметов/Материального ущерба", required = 1)
	add_field(/datum/report_field/text_label/instruction, "(П-Поврежденный, У-Улика, Пр-Потерянный, В-Восстановленный, Ук-Украденный)")
	add_field(/datum/report_field/pencode_text, "Полное описание происшествия", required = 1)
	add_field(/datum/report_field/signature, "Подпись офицера, составившего отчет", required = 1)
	set_access(access_edit = access_brig)

/datum/computer_file/report/recipient/sec/investigation
	form_name = "SCG-SEC-02"
	title = "Отчет о расследовании"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/sec/investigation/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "ГЭК \"Факел\" - Охранный Отдел")
	add_field(/datum/report_field/text_label/instruction, "Для ознакомления авторизованному персоналу.")
	add_field(/datum/report_field/people/from_manifest, "Имя", required = 1)
	add_field(/datum/report_field/date, "Дата", required = 1)
	add_field(/datum/report_field/time, "Время", required = 1)
	add_field(/datum/report_field/pencode_text, "Отчёт по делу", required = 1)
	add_field(/datum/report_field/pencode_text, "Основная информация", required = 1)
	add_field(/datum/report_field/pencode_text, "Вложения")
	add_field(/datum/report_field/pencode_text, "Наблюдения")
	set_access(access_edit = access_brig)

/datum/computer_file/report/recipient/sec/evidence
	form_name = "SCG-SEC-02b"
	title = "Отчет об уликах"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/sec/report_evidence/generate_fields()
	..()
	var/list/det_fields = list()
	add_field(/datum/report_field/text_label/header, "ГЭК \"Факел\" - Охранный Отдел")
	add_field(/datum/report_field/date, "Дата")
	add_field(/datum/report_field/time, "Время")
	add_field(/datum/report_field/people/from_manifest, "Конфисковано у", required = 1)
	add_field(/datum/report_field/pencode_text, "Список конфискованных предметов", required = 1)
	add_field(/datum/report_field/signature, "Подпись офицера проводившего конфискацию", required = 1)
	det_fields += add_field(/datum/report_field/signature, "Подпись Смотрителя брига/Главы Службы Безопасности", required = 1)
	set_access(access_edit = access_brig)
	for(var/datum/report_field/field in det_fields)
		field.set_access(access_edit = access_armory)

/datum/computer_file/report/recipient/sec/arrest
	form_name = "SCG-SEC-03"
	title = "Отчет о задержании"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/sec/arrest/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "ГЭК \"Факел\" - Охранный Отдел")
	add_field(/datum/report_field/text_label/instruction, "Отчет заполняется задерживающим офицером, либо смотрителем брига. Отчет должен быть подписан и утвержден перед концом смены!")
	add_field(/datum/report_field/people/from_manifest, "Докладывающий Офицер")
	add_field(/datum/report_field/people/list_from_manifest, "Участники задержания")
	add_field(/datum/report_field/date, "Дата")
	add_field(/datum/report_field/time, "Время Инцидента")
	add_field(/datum/report_field/people/from_manifest, "Задержанный")
	add_field(/datum/report_field/simple_text, "Статьи")
	add_field(/datum/report_field/simple_text, "Приговор")
	add_field(/datum/report_field/pencode_text, "Изъятое личное имущество")
	add_field(/datum/report_field/text_label/instruction, "На следующие 8 вопросов следует отвечать в формате ДА/НЕТ")
	add_field(/datum/report_field/simple_text, "Имеется Риск Побега?")
	add_field(/datum/report_field/simple_text, "Имеется Риск Суицида?")
	add_field(/datum/report_field/simple_text, "Был ли предоставлен Ордер?")
	add_field(/datum/report_field/simple_text, "Уведомлен ли задержанный о своих правах?")
	add_field(/datum/report_field/simple_text, "Проведен ли обыск?")
	add_field(/datum/report_field/simple_text, "Была ли дана возможность совершить чистосердечное признание?")
	add_field(/datum/report_field/simple_text, "Сенсоры костюма были зафиксированы на третьем уровне?")
	add_field(/datum/report_field/simple_text, "Если потребовалась, была ли оказана Первая Медицинская Помощь?")
	add_field(/datum/report_field/simple_text, "Если ПМП была оказана, какие травмы были у задержанного?")
	add_field(/datum/report_field/text_label/instruction, "Этот документ ДОЛЖЕН быть утвержден и рассмотрен Главой Службы Безопасности или Смотрителем Брига.")
	add_field(/datum/report_field/signature, "Подпись Докладывающего Офицера")
	set_access(access_edit = access_brig)

/datum/computer_file/report/recipient/sec/armory
	form_name = "SCG-SEC-05"
	title = "Инвентаризация оружейной"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/sec/armory/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "ИКН \"Сьерра\" - Охранный департамент")
	add_field(/datum/report_field/date, "Дата")
	add_field(/datum/report_field/time, "Время")
	add_field(/datum/report_field/text_label, "Снаряжение")
	add_field(/datum/report_field/simple_text, "Наручники")
	add_field(/datum/report_field/simple_text, "Гранаты с слезоточивым газом")
	add_field(/datum/report_field/simple_text, "Светошумовые гранаты")
	add_field(/datum/report_field/text_label, "Оружие")
	add_field(/datum/report_field/simple_text, "LAEP90 и LAEP90-S")
	add_field(/datum/report_field/simple_text, "Электрокарабин X-10 и другие электрокарабины")
	add_field(/datum/report_field/simple_text, "Ионные ружья и пистолеты")
	add_field(/datum/report_field/simple_text, "Лазерные карабины")
	add_field(/datum/report_field/simple_text, "Боевые дробовики")
	add_field(/datum/report_field/pencode_text, "Прочее оружие")
	add_field(/datum/report_field/text_label, "Броня")
	add_field(/datum/report_field/simple_text, "Противоударные шлемы и броня")
	add_field(/datum/report_field/simple_text, "Бронежилеты и пуленепробиваемые шлемы")
	add_field(/datum/report_field/simple_text, "Аблятивные шлемы и броня")
	add_field(/datum/report_field/simple_text, "Бронещиты")
	add_field(/datum/report_field/signature, "Подпись лица, проводившего ревезию", required = 1)
	set_access(access_armory, access_armory)

/datum/computer_file/report/recipient/sec/ltc
	form_name = "SCG-SEC-05"
	title = "Лицензия на оружие"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/sec/ltc/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "ГЭК \"Факел\" - Охранный Отдел")
	add_field(/datum/report_field/text_label/instruction, "Заполняется КО/ИО/ГСБ. Документ должен быть подписан и утвержден, дабы считаться действительным. Все бумажные копии должны быть проштампованы.")
	add_field(/datum/report_field/people/from_manifest, "Заявитель")
	add_field(/datum/report_field/date, "Дата вступления лицензии в силу")
	add_field(/datum/report_field/time, "Время вступления лицензии в силу")
	add_field(/datum/report_field/simple_text, "Причина Оформления")
	add_field(/datum/report_field/simple_text, "Авторизовано Владение")
	add_field(/datum/report_field/text_label/instruction, "Данная лицензия выдается по желанию Командующего Офицера, Исполнительного Офицера, либо Главы Службы Безопасности, и соответственно может быть аннулирована ими по любой причине. \
	В случае применения лицензированного предмета в целях нарушения закона, данная лицензия может быть аннулирована любым членом охранного отдела при исполнении. \
	Все носители лицензии обязаны исполнять соблюдать локальные законы/регуляции. Открытое ношение оружия запрещено, только если при составлении лицензии не указано обратное. \
	Настоящий документ обязателен к ношению, в случае, если Заявитель хочет применить/применяет оружие, либо предмет, на который распространяется данная лицензия. \
	Копии данного документа должны быть предоставлены Командующему Офицеру, Исполнительному Офицеру, Главе Службы Безопасности, а также Смотрителю Брига.")
	add_field(/datum/report_field/signature, "Подпись лица, выдавшего лицензию")
	set_access(list(list(access_captain, access_hop, access_hos)), list(list(access_captain, access_hop, access_hos)))
