/datum/computer_file/report/recipient/service
	logo = "\[solcrest\]"
/datum/computer_file/report/recipient/service/food_menu
	form_name = "SCG-SER-02"
	title = "Меню бара"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/service/food_menu/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "ГЭК \"Факел\" - Отдел обслуживания")
	add_field(/datum/report_field/date, "Дата")
	add_field(/datum/report_field/text_label, "Первые блюда")
	add_field(/datum/report_field/pencode_text, "Список блюд")
	add_field(/datum/report_field/text_label, "Вторые блюда")
	add_field(/datum/report_field/pencode_text, "Список блюд")
	add_field(/datum/report_field/text_label, "Десерты")
	add_field(/datum/report_field/pencode_text, "Список блюд")
	add_field(/datum/report_field/text_label, "Напитки")
	add_field(/datum/report_field/pencode_text, "Список блюд")
	add_field(/datum/report_field/text_label/instruction, "Ответственный за меню оставляет за собой право изменения действующего меню. Наличие блюда в меню не дает полной гарантии наличия в настоящем или будущем времени данного блюда.")
	add_field(/datum/report_field/signature, "Подпись ответственного")

/datum/computer_file/report/recipient/service/drinks_menu
	form_name = "SCG-SER-11"
	title = "Меню бара - напитки"
	available_on_ntnet = TRUE

/datum/computer_file/report/recipient/service/drinks_menu/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "ГЭК \"Факел\" - Отдел обслуживания")
	add_field(/datum/report_field/date, "Дата")
	add_field(/datum/report_field/text_label, "Алкогольные напитки")
	add_field(/datum/report_field/pencode_text, "Список напитков")
	add_field(/datum/report_field/text_label, "Алкогольные коктейли")
	add_field(/datum/report_field/pencode_text, "Список коктейлей")
	add_field(/datum/report_field/text_label, "Безалкогольные напитки")
	add_field(/datum/report_field/pencode_text, "Список блюд")
	add_field(/datum/report_field/text_label, "Безалкогольные коктейли")
	add_field(/datum/report_field/pencode_text, "Список коктейлей")
	add_field(/datum/report_field/text_label/instruction, "Ответственный за меню оставляет за собой право изменения действующего меню. Наличие напитка в меню не дает полной гарантии наличия в настоящем или будущем времени данного напитка.")
	add_field(/datum/report_field/signature, "Подпись ответственного")
