


datum/dir/file/program/background/emailserver
	progname = "emailserver"
	var/list/users = list()
	var/servername = "herpderp.com"

datum/dir/file/program/background/emailserver/ForwardPacket(var/datum/packet/P)
	var/list/info = P.extrainfo
	if(P.info == "EMAILSEND")
		if(!info)
			return
		var/user = info["user"]
		var/pass = info["pass"]
		var/datum/emailuser/X = users[user]
		if(!X)
			return
		if(pass != X.pass)
			return
		var/content = info["content"]
		var/subject = info["subject"]
		var/too = info["too"]
		var/datum/emailuser/Y = users[too]
		if(!Y)
			return
		var/datum/email/E = new()
		E.subject = subject
		E.contains = content
		E.from = X.name
		Y.emails += E
		return
	if(P.info == "EMAILGET")
		var/user = info["user"]
		var/pass = info["pass"]
		var/datum/emailuser/X = users[user]
		if(!X)
			return
		if(pass != X.pass)
			return
		var/list/emails = list()
		for(var/datum/email/Y in X.emails)
			emails += Y
		new /datum/packet("EMAILRECV",P.from,P.where,emails)
		return // This will send all the emails to the client
	if(P.info == "EMAILREG")
		world << info["user"]
		var/user = info["user"]
		var/X = users[user]
		if(X)
			return // NOTEIFY THEM SOMEHOW LATER
		var/datum/emailuser/ZX = new()
		ZX.name = "[user]"
		ZX.fullname = "[user]@[servername]"
		ZX.pass = info["pass"]
		var/list/xd = list("okay")
		new /datum/packet("EMAILREG",P.from,P.where,xd)
		return