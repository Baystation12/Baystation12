/datum/computer_file/report/recipient/corp/generate_fields()
	..()
	set_access(list(list(access_heads, access_senadv, access_representative, access_cent_creed, access_liaison)))

/datum/computer_file/report/recipient/command/request_corporate
	form_name = "HR-NTCO-05"
	title = "Корпоративный Запрос"
	logo = "\[logo\]"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/command/request_corporate/generate_fields()
	..()
	add_field(/datum/report_field/number, "Номер запроса ")
	add_field(/datum/report_field/people/from_manifest, "Полное имя и должность запросившего", required = 1)
	add_field(/datum/report_field/pencode_text, "Содержание запроса", required = 1)
	add_field(/datum/report_field/pencode_text, "Причина запроса", required = 1)
	add_field(/datum/report_field/date, "Дата заполнения")
	add_field(/datum/report_field/time, "Время заполнения")
	add_field(/datum/report_field/text_label/instruction, "Документ является недействительным в случае отсутствия подписи или печати.")
	add_field(/datum/report_field/signature, "Подпись", required = 1)
	set_access(access_liaison, access_liaison)
/datum/computer_file/report/recipient/corp/incident
	form_name = "HR-NTCO-01"
	title = "Рапорт об инциденте на корабле"
	logo = "\[logo\] \[solcrest\]"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/corp/incident/generate_fields()
	..()
	add_field(/datum/report_field/simple_text, "Судно")
	add_field(/datum/report_field/date, "Дата")
	add_field(/datum/report_field/time, "Время")
	add_field(/datum/report_field/simple_text, "Описание инцидента", required = 1)
	add_field(/datum/report_field/pencode_text, "Детали инцидента", required = 1)
	add_field(/datum/report_field/simple_text, "Вовлечённые отделы", required = 1)
	add_field(/datum/report_field/signature, "Подпись", required = 1)
	add_field(/datum/report_field/signature, "Подпись свидетеля")

/datum/computer_file/report/recipient/corp/incident_corpstaff
	form_name = "HR-NTCO-01a"
	title = "Рапорт об инциденте с корпоративными сотрудниками"
	logo = "\[logo\]"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/corp/incident_corpstaff/generate_fields()
	..()
	add_field(/datum/report_field/simple_text, "Судно")
	add_field(/datum/report_field/date, "Дата")
	add_field(/datum/report_field/time, "Время")
	add_field(/datum/report_field/simple_text, "Описание инцидента", required = 1)
	add_field(/datum/report_field/people/list_from_manifest, "Вовлечённый сотрудник(и) (Полное имя, должность)", required = 1)
	add_field(/datum/report_field/pencode_text, "Детали инцидента", required = 1)
	add_field(/datum/report_field/signature, "Подпись", required = 1)
	add_field(/datum/report_field/signature, "Подпись свидетеля")
	set_access(access_liaison, access_liaison)

/datum/computer_file/report/recipient/corp/incident_corpassets
	form_name = "HR-NTCO-01b"
	title = "Рапорт об инциденте с корпоративным активами"
	logo = "\[logo\]"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/corp/incident_corpassets/generate_fields()
	..()
	add_field(/datum/report_field/simple_text, "Судно")
	add_field(/datum/report_field/date, "Дата")
	add_field(/datum/report_field/time, "Время")
	add_field(/datum/report_field/simple_text, "Описание инцидента", required = 1)
	add_field(/datum/report_field/pencode_text, "Детали инцидента", required = 1)
	add_field(/datum/report_field/people/list_from_manifest, "Раненые корпоративные сотрудники")
	add_field(/datum/report_field/pencode_text, "Описание ранений")
	add_field(/datum/report_field/pencode_text, "Потерянные корпоративные активы (Актив, стоимость в таллерах)")
	add_field(/datum/report_field/signature, "Подпись", required = 1)
	add_field(/datum/report_field/signature, "Подпись свидетеля")
	set_access(access_liaison, access_liaison)

/datum/computer_file/report/recipient/corp/incident_xenostaff
	form_name = "HR-NTCO-01b"
	title = "Рапорт об инциденте с сотрудником-ксеносом, имеющим рабочую визу"
	logo = "\[logo\] \[solcrest\]"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/corp/incident_xenostaff/generate_fields()
	..()
	add_field(/datum/report_field/text_label/instruction, "Если сотрудник-ксенос не имеет рабочую визу, то используйте форму HR-NTCO-01c-A")
	add_field(/datum/report_field/simple_text, "Судно")
	add_field(/datum/report_field/date, "Дата")
	add_field(/datum/report_field/time, "Время")
	add_field(/datum/report_field/simple_text, "Описание инцидента", required = 1)
	add_field(/datum/report_field/people/list_from_manifest, "Вовлечённый сотрудник(и)-ксенос(ы) (Полное имя, должность)", required = 1)
	add_field(/datum/report_field/pencode_text, "Детали инцидента", required = 1)
	add_field(/datum/report_field/signature, "Подпись", required = 1)
	add_field(/datum/report_field/signature, "Подпись свидетеля")

/datum/computer_file/report/recipient/corp/incident_xenostaffnovisa
	form_name = "HR-NTCO-01c-A"
	title = "Рапорт об инциденте с сотрудником-ксеносом, не имеющим рабочую визу"
	logo = "\[logo\] \[solcrest\]"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/corp/incident_xenostaffnovisa/generate_fields()
	..()
	add_field(/datum/report_field/simple_text, "Судно")
	add_field(/datum/report_field/date, "Дата")
	add_field(/datum/report_field/time, "Время")
	add_field(/datum/report_field/simple_text, "Описание инцидента", required = 1)
	add_field(/datum/report_field/people/list_from_manifest, "Вовлечённый сотрудник(и)-ксенос(ы) (Полное имя, должность)", required = 1)
	add_field(/datum/report_field/pencode_text, "Детали инцидента", required = 1)
	add_field(/datum/report_field/signature, "Подпись", required = 1)
	add_field(/datum/report_field/signature, "Подпись свидетеля")

/datum/computer_file/report/recipient/corp/incident_synthstaff
	form_name = "HR-EXO-01d"
	title = "Рапорт об инцидентах с сотрудниками-синтетиками"
	logo = "\[logo\] \[solcrest\]"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/corp/incident_synthstaff/generate_fields()
	..()
	add_field(/datum/report_field/simple_text, "Судно")
	add_field(/datum/report_field/date, "Дата")
	add_field(/datum/report_field/time, "Время")
	add_field(/datum/report_field/simple_text, "Описание инцидента", required = 1)
	add_field(/datum/report_field/people/list_from_manifest, "Сотрудники-синтетики замешанные в инциденте", required = 1)
	add_field(/datum/report_field/pencode_text, "Детали инцидента", required = 1)
	add_field(/datum/report_field/signature, "Подпись", required = 1)
	add_field(/datum/report_field/signature, "Подпись свидетеля")

/datum/computer_file/report/recipient/corp/incident_corpcrew
	form_name = "HR-NTCO-01e"
	title = "Рапорт об инциденте с корпоративным персоналом и экипажем корабля"
	logo = "\[logo\] \[solcrest\]"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/corp/incident_corpcrew/generate_fields()
	..()
	add_field(/datum/report_field/text_label/instruction, "Для инцидентов в которые вовлечены как корпоративный персонал, так и экипаж корабля")
	add_field(/datum/report_field/simple_text, "Судно")
	add_field(/datum/report_field/date, "Дата")
	add_field(/datum/report_field/time, "Время")
	add_field(/datum/report_field/simple_text, "Описание инцидента", required = 1)
	add_field(/datum/report_field/people/list_from_manifest, "Вовлечённый член(ы) экипажа (Полное имя, звание, должность)", required = 1)
	add_field(/datum/report_field/people/list_from_manifest, "Вовлечённый сотрудник(и) (Полное имя, должность)", required = 1)
	add_field(/datum/report_field/pencode_text, "Детали инцидента", required = 1)
	add_field(/datum/report_field/signature, "Подпись", required = 1)
	add_field(/datum/report_field/signature, "Подпись свидетеля")

/datum/computer_file/report/recipient/corp/volunteer
	form_name = "HR-NTCO-02b"
	title = "Запрос добровольца для исследований"
	logo = "\[logo\]"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/corp/volunteer/generate_fields()
	..()
	var/list/temp_fields = list()
	add_field(/datum/report_field/people/from_manifest, "Полное имя добровольца", required = 1)
	add_field(/datum/report_field/simple_text, "Предполагаемая процедура(ы)", required = 1)
	add_field(/datum/report_field/simple_text, "Компенсация для добровольца(если есть)")
	add_field(/datum/report_field/people/list_from_manifest, "Ответственный(ые) за исследования", required = 1)
	add_field(/datum/report_field/text_label/instruction, "Подписывая, \"Доброволец\" соглашается освободить Организацию Экспедиционного корпуса, включая корпорации-партнеры, и её сотрудников от любой ответственности или ответственности за травмы, ущерб, потерю имущества или побочные эффекты, которые могут возникнуть в результате предполагаемой процедуры. Если документ подписан уполномоченным представителем ЭКСО, таким как Корпоративный Представитель - то этот документ считается просмотренным, но документ становится действительным только в том случае, если она заверен печатью.")
	add_field(/datum/report_field/signature, "Подпись добровольца", required = 1)
	temp_fields += add_field(/datum/report_field/signature, "Подпись Корпоративного Представителя", required = 1)
	temp_fields += add_field(/datum/report_field/options/yes_no, "Одобрено")
	set_access(access_liaison, access_liaison)
	for(var/datum/report_field/temp_field in temp_fields)
		temp_field.set_access(access_edit = access_liaison)

/datum/computer_file/report/recipient/corp/deny
	form_name = "HR-NTCO-02b-A"
	title = "Отказ от добровольца для исследований"
	logo = "\[logo\]"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/corp/deny/generate_fields()
	..()
	add_field(/datum/report_field/text_label, "Мы с сожалением сообщаем вам, что ваша добровольческая заявка на службу в качестве испытуемого в Организации Экспедиционного корпуса была отклонена. \
	Мы благодарим вас за ваш интерес к развитию исследований. В приложении вы найдете копию вашей оригинальной формы для ваших записей. С уважением,")
	add_field(/datum/report_field/signature, "Подпись Корпоративного Представителя", required = 1)
	add_field(/datum/report_field/people/from_manifest, "Полное имя добровольца", required = 1)
	add_field(/datum/report_field/text_label/header, "Причина для отказа")
	add_field(/datum/report_field/options/yes_no, "Физически непригоден")
	add_field(/datum/report_field/options/yes_no, "Психически непригоден")
	add_field(/datum/report_field/options/yes_no, "Отмена проекта")
	add_field(/datum/report_field/simple_text, "Другое")
	add_field(/datum/report_field/options/yes_no, "Одобрено")
	set_access(access_liaison, access_liaison)

/datum/computer_file/report/recipient/corp/fire
	form_name = "C-0102"
	title = "Увольнение корпоративного сотрудника"
	logo = "\[logo\]"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/corp/fire/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "Уведомление об увольнении сотрудника")
	add_field(/datum/report_field/people/from_manifest, "Полное имя", required = 1)
	add_field(/datum/report_field/number, "Возраст", required = 1)
	add_field(/datum/report_field/simple_text, "Должность", required = 1)
	add_field(/datum/report_field/pencode_text, "Причина увольнения", required = 1)
	add_field(/datum/report_field/date, "Дата заполнения")
	add_field(/datum/report_field/time, "Время заполнения")
	add_field(/datum/report_field/signature, "Авторизовано", required = 1)
	add_field(/datum/report_field/text_label/instruction, "Прикрепите личное дело к данному уведомлению.")
	set_access(access_liaison, access_liaison)

/datum/computer_file/report/recipient/corp/payout
	form_name = "C-3310"
	title = "Выплата оставшегося оклада погибшему сотруднику"
	logo = "\[logo\]"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/corp/payout/generate_fields()
	..()
	add_field(/datum/report_field/people/from_manifest, "Данный документ разрешает выплату оставшегося оклада")
	add_field(/datum/report_field/pencode_text, "Помимо полной выплаты оставшихся личных активов: (Актив, [GLOB.using_map.local_currency_name_singular] Стоимость)")
	add_field(/datum/report_field/pencode_text, "Включая личные вещи")
	add_field(/datum/report_field/text_label, "Должно быть немедленно отправлено ближайшему родственнику сотрудника.")
	add_field(/datum/report_field/signature, "Подпись", required = 1)
	add_field(/datum/report_field/options/yes_no, "Одобрено")

//No access restrictions for easier use.
/datum/computer_file/report/recipient/sales
	form_name = "C-2192"
	title = "Корпоративный договор купли-продажи и Квитанция"

	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/sales/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "Информация о продукте")
	add_field(/datum/report_field/simple_text, "Наименование продукта", required = 1)
	add_field(/datum/report_field/simple_text, "Тип продукта", required = 1)
	add_field(/datum/report_field/number, "Стоимость единицы продукции (В таллерах)", required = 1)
	add_field(/datum/report_field/number, "Кол-во запрошенных единиц продукции", required = 1)
	add_field(/datum/report_field/number, "Итоговая цена(T)", required = 1)
	add_field(/datum/report_field/text_label/header, "Информация о продавце")
	add_field(/datum/report_field/text_label/instruction, "\"Покупатель\" может не возвращать какие-либо проданные единицы продукции для повторной компенсации в таллерах, но может вернуть товар за идентичный товар или товар из равного материала (не таллеры). \"Продавец\" соглашается приложить все усилия для ремонта или замены любых предметов, которые не соответствуют своему назначению из-за неисправности или производственной ошибки, но не из-за ущерба, причиненного пользователем.")
	add_field(/datum/report_field/simple_text, "Полное имя продавца", required = 1)
	add_field(/datum/report_field/signature, "Подпись", required = 1)
	add_field(/datum/report_field/options/yes_no, "Одобрено")
