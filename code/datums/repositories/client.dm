var/global/const/NO_CLIENT_CKEY = "*no ckey*"

var/global/repository/client/client_repository = new()

/repository/client
	var/list/clients_

/repository/client/New()
	..()
	clients_ = list()

// A lite client is unique per ckey and mob ref (save for ref conflicts.. oh well)
/repository/client/proc/get_lite_client(var/mob/M)
	if(isclient(M))
		var/client/C = M // BYOND is supposed to ensure clients always have a mob
		M = C.mob
	. = clients_[mob2unique(M)]
	if(!.)
		. = new/datum/client_lite(M)
		clients_[mob2unique(M)] = .

/datum/client_lite
	var/name = "*no mob*"
	var/key  = "*no key*"
	var/ckey = NO_CLIENT_CKEY
	var/ref // If ref is unset but ckey is set that means the client wasn't logged in at the time

/datum/client_lite/New(var/mob/M)
	if(!M)
		return

	name = M.real_name ? M.real_name : M.name
	key = M.key ? M.key : key
	ckey = M.ckey ? M.ckey : ckey
	ref = M.client ? any2ref(M.client) : ref

/datum/client_lite/proc/key_name(var/pm_link = TRUE, var/check_if_offline = TRUE, var/datum/ticket/ticket = null)
	if(!ref && ckey != NO_CLIENT_CKEY)
		var/client/C = client_by_ckey(ckey)
		if(C)
			ref = any2ref(C)

	if(!ref)
		if(ckey == NO_CLIENT_CKEY)
			return "[key]/([name])"
		else
			return "[key]/([name]) (DC)"
	if(check_if_offline && !client_by_ckey(ckey))
		return "[key]/([name]) (DC)"
	return pm_link ? "<a href='?priv_msg=[ref];ticket=\ref[ticket]'>[key]</a>/([name])[rank2text()]" : "[key]/([name])"

/datum/client_lite/proc/rank2text()
	var/client/C = client_by_ckey(ckey)
	if(!C || (C && !C.holder))
		return
	return " \[[C.holder.rank]\]"

/proc/client_by_ckey(ckey)
	for(var/client/C)
		if(C.ckey == ckey)
			return C
