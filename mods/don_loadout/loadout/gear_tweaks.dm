/datum/gear_tweak/proc/get_random()
	return get_default()

/datum/gear_tweak/color/get_random()
	return valid_colors ? pick(valid_colors) : rgb(rand(200) + 55, rand(200) + 55, rand(200) + 55)

/datum/gear_tweak/color/get_contents(list/metadata)
	return "Цвет: [SPAN_COLOR(metadata, "&#9899;")]"

/datum/gear_tweak/path/get_contents(list/metadata)
	return "Тип: [metadata]"

/datum/gear_tweak/contents/get_contents(list/metadata)
	return "Содержимое: [english_list(metadata, and_text = ", ", final_comma_text = "")]"

/datum/gear_tweak/reagents/get_contents(list/metadata)
	return "Реагенты: [metadata]"

/datum/gear_tweak/custom_name/get_contents(list/metadata)
	return "Название: [metadata]"

/datum/gear_tweak/custom_desc/get_contents(list/metadata)
	return "Описание: [metadata]"

/datum/gear_tweak/tablet/get_contents(list/metadata)
	. = ..()
	return "Компоненты: [.]"
