var/list/event_staff_list = list()

proc/load_event_staff()
	event_staff_list = file2list("config/event_staff.txt")

proc/is_event_staff(client/C)
	if(event_staff_list)
		for(var/line in event_staff_list)
			if(!length(line))				continue
			if(line && findtext(line, "[C]"))
				return 1

	return 0