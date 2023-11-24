/singleton/cultural_info/get_text_details()
	. = list()
	var/list/spoken_langs = get_spoken_languages()
	if(LAZYLEN(spoken_langs))
		. += "<b>Основной язык(и):</b> [english_list(spoken_langs)]."
	if(LAZYLEN(secondary_langs))
		. += "<b>Доступные языки:</b> [english_list(secondary_langs)]."
	if(!isnull(economic_power))
		. += "<b>Экономическая сила:</b> [round(100 * economic_power)]%"
		
#define COLLAPSED_CULTURE_BLURB_LEN 48
/singleton/cultural_info/get_description(header, append, verbose = TRUE)
	var/list/dat = list()
	dat += "<table padding='8px'><tr>"
	dat += "<td width='260px'>"
	var/translatedname = name
	if(header)
		if(nickname)
			translatedname = nickname
		header += translatedname
	dat += "[header ? header : "<b>[desc_type]:</b>[translatedname]"]<br>"
	if(verbose)
		dat += "<small>"
		dat += "[jointext(get_text_details(), "<br>")]"
		dat += "</small>"
	dat += "</td><td width>"
	if(verbose || length(get_text_body()) <= COLLAPSED_CULTURE_BLURB_LEN)
		dat += "[get_text_body()]"
	else
		dat += "[copytext(get_text_body(), 1, COLLAPSED_CULTURE_BLURB_LEN)] \[...\]"
	dat += "</td>"
	if(append)
		dat += "<td width = '100px'>[append]</td>"
	dat += "</tr></table>"
	return jointext(dat, null)
#undef COLLAPSED_CULTURE_BLURB_LEN
