/datum/computer_file/report/recipient/service_agreement
	form_name = "GEN-01"
	title = "Договор оказания услуг"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/service_agreement/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "Стороны договора")
	add_field(/datum/report_field/date, "Дата составления документа", required = 1)
	add_field(/datum/report_field/simple_text, "Исполнитель", required = 1)
	add_field(/datum/report_field/simple_text, "Заказчик", required = 1)
	add_field(/datum/report_field/text_label/instruction, "Сторонами могут быть: организация, корпорация или частное лицо. В случае частного лица указать имя, фамилию и должность, если такая предусмотрена. \
	Стороны указываемые в настоящем договоре несут друг перед другом ответственность о добросовестном выполнении своих обязательств. Договор может быть расторгнут по инициативе любой из сторон до акта подписания данного договора.")
	add_field(/datum/report_field/pencode_text, "Перечень оказываемых услуг(название, цена)", required = 1)
	add_field(/datum/report_field/options/yes_no, "Бартер", required = 1)
	add_field(/datum/report_field/signature, "Подпись исполнителя", required = 1)
	add_field(/datum/report_field/signature, "Подпись заказчика", required = 1)
	add_field(/datum/report_field/date, "Дата")
	add_field(/datum/report_field/time, "Время")
	add_field(/datum/report_field/text_label/instruction, "Подпись сторон означает выполнение обязательств перед друг другом. \
	Подписанный документ имеет юридическую силу и неполное или недоброкачественное выполнение обязательств может быть обжаловано в соответствующих инстанциях. \
	Необходимо указывать точное и полное  наименование услуг. Исполнитель указывает цену самостоятельно, общую стоимость необходимо указывать в соответствующей графе,\
	так же исполнитель в праве установить бартер взамен оказания своих услуг. Под бартером подразумевается натуральный обмен товара на товар. \
	Так же допускается обмен на услугу. С точки зрения договора это должен быть равноценный обмен.")

/datum/computer_file/report/recipient/buy_agreement
	form_name = "GEN-02"
	title = "Договор купли-продажи"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/buy_agreement/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "Стороны договора")
	add_field(/datum/report_field/simple_text, "Продавец", required = 1)
	add_field(/datum/report_field/simple_text, "Покупатель", required = 1)
	add_field(/datum/report_field/text_label/instruction, "Сторонами могут быть: организация, корпорация или частное лицо. В случае частного лица указать имя, фамилию и должность, если такая предусмотрена. \
	Стороны указываемые в настоящем договоре несут друг перед другом ответственность о добросовестном выполнении своих обязательств. Договор может быть расторгнут по инициативе любой из сторон до акта подписания данного договора.")
	add_field(/datum/report_field/pencode_text, "Предметы продажи (наименование, количестно)", required = 1)
	add_field(/datum/report_field/options/yes_no, "Бартер", required = 1)
	add_field(/datum/report_field/number, "Общая стоимость", required = 1)
	add_field(/datum/report_field/signature, "Подпись покупателя об ознакомлении", required = 1)
	add_field(/datum/report_field/text_label, "Акт передачи")
	add_field(/datum/report_field/signature, "Подпись продавца о получении оплаты", required = 1)
	add_field(/datum/report_field/signature, "Подпись покупателя о получении товара", required = 1)
	add_field(/datum/report_field/date, "Дата")
	add_field(/datum/report_field/time, "Время")
	add_field(/datum/report_field/text_label/instruction, "Подпись сторон означает выполнение обязательств перед друг другом. \
	Подписанный документ имеет юридическую силу и неполное или недоброкачественное выполнение обязательств может быть обжаловано в соответствующих инстанциях. \
	Необходимо указывать точное и полное  наименование предмета или предметов продажи, а так же их количество (если данное уместно). \
	Для определения цены если допускается использование сканера, в случае бартера указать предмет обмена. Под бартером подразумевается натуральный обмен товара на товар. \
	Так же допускается обмен на услугу. С точки зрения договора это должен быть равноценный обмен.")
