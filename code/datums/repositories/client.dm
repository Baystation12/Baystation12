var/const/NO_CLIENT_CKEY = "*no ckey*"

var/repository/client/client_repository = new()

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
	var/client_key = client2unique(M.client)
	. = clients_[client_key]
	if(!.)
		. = new/datum/client_lite(M)
		clients_[client_key] = .

/datum/client_lite
	var/mob_name = "*no mob*"
	var/key      = "*no key*"
	var/ckey     = NO_CLIENT_CKEY
	var/rank
	var/ref      // If ref is unset but ckey is different from NO_CLIENT_KEY that means the client wasn't logged in at the time

/datum/client_lite/New(var/mob/M)
	if(!M)
		return
	if(!istype(M))
		CRASH("Non-mob supplied: [log_info_line(M)]")

	mob_name = M.real_name || M.name
	key = M.key || key
	ckey = trim_left(M.ckey, list("@"))  || ckey

	set_client_values(M.client)

/datum/client_lite/proc/key_name(var/pm_link = TRUE, var/check_if_offline = TRUE)
	set_client_values()
	if(!ref)
		if(ckey == NO_CLIENT_CKEY)
			return "[key]/([mob_name])"
		else
			return "[key]/([mob_name]) (DC)"
	if(check_if_offline && !client_by_ckey(ckey))
		return "[key]/([mob_name]) (DC)"
	return pm_link ? "<a href='?priv_msg=[ref]'>[key]</a>/([mob_name])[rank ? " \[[rank]\]" : ""]" : "[key]/([mob_name])"

/datum/client_lite/proc/set_client_values(var/client/C)
	if(ref || ckey == NO_CLIENT_CKEY)
		return
	C = C || client_by_ckey(ckey)
	if(!C)
		return
	key = C.key // Update in case of an aghost having returned to its body.
	ref = any2ref(C)
	rank = (C.holder && C.holder.rank) || rank

/proc/client_by_ckey(ckey)
	for(var/client/C)
		if(C.ckey == ckey)
			return C
