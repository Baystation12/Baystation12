var/repository/client/client_repository = new()

/repository/client
	var/list/clients_

/repository/client/New()
	..()
	clients_ = list()

// A lite client is unique per ckey and mob ref (save for ref conflicts.. oh well)
/repository/client/proc/get_lite_client(var/client/C, var/mob/M)
	M = C && C.mob ? C.mob : M
	. = clients_[mobclient2unique(M,C)]
	if(!.)
		. = new/datum/client_lite(C, M)
		clients_[mobclient2unique(M,C)] = .

/datum/client_lite
	var/name = "*no mob*"
	var/key  = "*no key*"
	var/ckey = "*no key*"
	var/rank
	var/ref

/datum/client_lite/New(var/client/c, var/mob/M)
	name = M ? (M.real_name ? M.real_name : M.name) : name

	if(!c)
		return

	key = c.key
	ckey = c.ckey
	rank = c.holder ? c.holder.rank : ""
	ref = any2ref(c)

/datum/client_lite/proc/key_name(var/pm_link = TRUE, var/check_if_offline = TRUE)
	if(!ref)
		return "[key]/([name])"
	if(check_if_offline)
		var/client/C = locate(ref)
		if(!C)
			return "[key]/([name]) (DC)"
	return pm_link ? "<a href='?priv_msg=[ref]'>[key]</a>/([name])[rank2text()]" : "[key]/([name])"

/datum/client_lite/proc/rank2text()
	return rank ? " \[[rank]\]" : ""
