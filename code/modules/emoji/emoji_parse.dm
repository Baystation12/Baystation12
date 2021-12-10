GLOBAL_VAR_INIT(emojis, 'icons/emoji.dmi')

/proc/emoji_parse(text, var/client/C)
	if(!config.emojis)
		return text
	var/parsed = ""
	var/pos = 1
	var/search = 0
	var/emoji = ""
	var/static/list/emojis = icon_states(GLOB.emojis)
	while(1)
		search = findtext_char(text, ":", pos)
		parsed += copytext_char(text, pos, search)
		if(search)
			pos = search
			search = findtext_char(text, ":", pos+1)
			if(search)
				emoji = lowertext(copytext_char(text, pos+1, search))
				if(emoji in emojis)
					parsed += icon2html(icon(GLOB.emojis, emoji), C, realsize= TRUE)
					// parsed += " <img class=icon src=\ref[GLOB.emojis] iconstate='[emoji]'>"
					pos = search + 1
				else
					parsed += copytext_char(text, pos, search)
					pos = search
				emoji = ""
				continue
			else
				parsed += copytext_char(text, pos, search)
		break
	return parsed
