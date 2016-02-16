var/list/vips = list()

/hook/startup/proc/loadVips()
	load_vips()
	return 1

/proc/load_vips()
	vips.Cut()
	var/list/lines = file2list("config/vips.txt")
	for(var/line in lines)
		if(!length(line) || copytext(line,1,2) == "#")
			continue
		var/newkey = ckey(line)
		if(newkey)
			vips |= newkey

	for(var/client/C)
		if(C.IsByondMember())
			vips |= C.ckey
