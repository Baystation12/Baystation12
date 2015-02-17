var/list/titles = list()

proc/load_titles()
	titles = file2list("config/titles.txt")

proc/is_titled(client/C)
	if(titles)
		for(var/line in titles)
			if(!length(line))				continue
			if(line && findtext(line, "[C]"))
				return 1
	return 0

proc/get_title(client/C)
	if(titles)
		for(var/line in titles)
			if(!length(line))				continue
			//Return the title
			if(findtext(line,"[C.ckey] - event"))
				return 1
			else if(findtext(line,"[C.ckey] - sprite"))
				return 2

	return 0
