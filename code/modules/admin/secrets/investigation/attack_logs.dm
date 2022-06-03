/datum/admin_secret_item/investigation/attack_logs
	name = "Attack Logs"
	var/list/filters_per_client

/datum/admin_secret_item/investigation/attack_logs/New()
	..()
	filters_per_client = list()

/datum/admin_secret_item/investigation/attack_logs/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	var/dat = list()
	dat += "<a href='?src=\ref[src]'>Refresh</a> | "
	dat += get_filter_html(user)
	dat += " | <a href='?src=\ref[src];reset=1'>Reset</a>"
	dat += "<HR>"
	dat += "<table border='1' style='width:100%;border-collapse:collapse;'>"
	dat += "<tr><th style='text-align:left;'>Time</th><th style='text-align:left;'>Attacker</th><th style='text-align:left;'>Intent</th><th style='text-align:left;'>Zone Sel</th><th style='text-align:left;'>Victim</th></tr>"

	for(var/log in attack_log_repository.attack_logs_)
		var/datum/attack_log/al = log
		if(filter_log(user, al))
			continue

		dat += "<tr><td>[al.station_time]</td>"

		if(al.attacker)
			dat += "<td>[al.attacker.key_name(check_if_offline = FALSE)] <a HREF='?_src_=holder;adminplayeropts=[al.attacker.ref]'>PP</a></td>"
		else
			dat += "<td></td>"

		dat += "<td>[al.intent]</td>"

		dat += "<td>[al.zone_sel]</td>"

		if(al.victim)
			dat += "<td>[al.victim.key_name(check_if_offline = FALSE)] <a HREF='?_src_=holder;adminplayeropts=[al.victim.ref]'>PP</a></td>"
		else
			dat += "<td></td>"

		dat += "</tr>"
		dat += "<tr><td colspan=5>[al.message]"
		if(al.location)
			dat += " <a HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[al.location.x];Y=[al.location.y];Z=[al.location.z]'>JMP</a>"
		dat += "</td></tr>"
	dat += "</table>"

	var/datum/browser/popup = new(user, "admin_attack_logs", "Attack Logs", 800, 400)
	popup.set_content(jointext(dat, null))
	popup.open()

/datum/admin_secret_item/investigation/attack_logs/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(href_list["refresh"])
		. = 1
	if(href_list["reset"])
		reset_user_filters(usr)
		. = 1
	if(.)
		execute(usr)

/datum/admin_secret_item/investigation/attack_logs/proc/get_user_filters(var/mob/user)
	if(!user.client)
		return list()

	. = filters_per_client[user.client]
	if(!.)
		. = list()
		for(var/af_type in subtypesof(/attack_filter))
			var/attack_filter/af = af_type
			if(initial(af.category) == af_type)
				continue
			. += new af_type(src)
		filters_per_client[user.client] = .

/datum/admin_secret_item/investigation/attack_logs/proc/get_filter_html(user)
	. = list()
	for(var/filter in get_user_filters(user))
		var/attack_filter/af = filter
		. += af.get_html()
	. = jointext(.," | ")

/datum/admin_secret_item/investigation/attack_logs/proc/filter_log(user, var/datum/attack_log/al)
	for(var/filter in get_user_filters(user))
		var/attack_filter/af = filter
		if(af.filter_attack(al))
			return TRUE
	return FALSE

/datum/admin_secret_item/investigation/attack_logs/proc/reset_user_filters(user)
	for(var/filter in get_user_filters(user))
		var/attack_filter/af = filter
		af.reset()

/attack_filter
	var/category = /attack_filter
	var/datum/admin_secret_item/investigation/attack_logs/holder

/attack_filter/New(var/holder)
	..()
	src.holder = holder

/attack_filter/Topic(href, href_list)
	if(..())
		return TRUE
	if(OnTopic(href_list))
		holder.execute(usr)
		return TRUE

/attack_filter/proc/get_html()
	return

/attack_filter/proc/reset()
	return

/attack_filter/proc/filter_attack(var/datum/attack_log/al)
	return FALSE

/attack_filter/proc/OnTopic(href_list)
	return FALSE

/*
* Filter logs with one or more missing clients
*/
/attack_filter/no_client
	var/filter_missing_clients = TRUE

/attack_filter/no_client/get_html()
	. = list()
	. += "Must have clients: "
	if(filter_missing_clients)
		. += "<span class='linkOn'>Yes</span><a href='?src=\ref[src];no=1'>No</a>"
	else
		. += "<a href='?src=\ref[src];yes=1'>Yes</a><span class='linkOn'>No</span>"
	. = jointext(.,null)

/attack_filter/no_client/OnTopic(href_list)
	if(href_list["yes"] && !filter_missing_clients)
		filter_missing_clients = TRUE
		return TRUE
	if(href_list["no"] && filter_missing_clients)
		filter_missing_clients = FALSE
		return TRUE

/attack_filter/no_client/reset()
	filter_missing_clients = initial(filter_missing_clients)

/attack_filter/no_client/filter_attack(var/datum/attack_log/al)
	if(!filter_missing_clients)
		return FALSE
	if(al.attacker && al.attacker.client.ckey == NO_CLIENT_CKEY)
		return TRUE
	if(al.victim && al.victim.client.ckey == NO_CLIENT_CKEY)
		return TRUE
	return FALSE

/*
	Either subject must be the selected client
*/
/attack_filter/must_be_given_ckey
	var/ckey_filter
	var/check_attacker = TRUE
	var/check_victim = TRUE
	var/description = "Either ckey is"

/attack_filter/must_be_given_ckey/reset()
	ckey_filter = null

/attack_filter/must_be_given_ckey/get_html()
	return "[description]: <a href='?src=\ref[src];select_ckey=1'>[ckey_filter ? ckey_filter : "*ANY*"]</a>"

/attack_filter/must_be_given_ckey/OnTopic(href_list)
	if(!href_list["select_ckey"])
		return
	var/ckey = input("Select ckey to filter on","Select ckey", ckey_filter) as null|anything in get_ckeys()
	if(ckey)
		if(ckey == "*ANY*")
			ckey_filter = null
		else
			ckey_filter = ckey
		return TRUE

/attack_filter/must_be_given_ckey/proc/get_ckeys()
	. = list()
	for(var/log in attack_log_repository.attack_logs_)
		var/datum/attack_log/al = log
		if(check_attacker && al.attacker && al.attacker.client.ckey != NO_CLIENT_CKEY)
			. |= al.attacker.client.ckey
		if(check_victim && al.victim && al.victim.client.ckey != NO_CLIENT_CKEY)
			. |= al.victim.client.ckey
	. = sortList(.)
	. += "*ANY*"

/attack_filter/must_be_given_ckey/filter_attack(var/datum/attack_log/al)
	if(!ckey_filter)
		return FALSE
	if(check_attacker && al.attacker && al.attacker.client.ckey == ckey_filter)
		return FALSE
	if(check_victim && al.victim && al.victim.client.ckey == ckey_filter)
		return FALSE
	return TRUE

/*
	Attacker must be the selected client
*/
/attack_filter/must_be_given_ckey/attacker
	description = "Attacker ckey is"
	check_victim = FALSE

/attack_filter/must_be_given_ckey/attacker/filter_attack(al)
	return ..(al, TRUE, FALSE)

/*
	Victim must be the selected client
*/
/attack_filter/must_be_given_ckey/victim
	description = "Victim ckey is"
	check_attacker = FALSE

/attack_filter/must_be_given_ckey/victim/filter_attack(al)
	return ..(al, FALSE, TRUE)
