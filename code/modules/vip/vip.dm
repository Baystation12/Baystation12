/proc/is_vip(var/client/C)
	return istype(C) && ((C.ckey in vips) || (C in admins))

/client/proc/cmd_vip_say(msg as text)
	set category = "OOC"
	set name = "Vsay"
	set desc = "VIP channel, only seen by other VIPs."
	set hidden = 1

	if(!is_vip(src))
		return

	if(say_disabled)
		usr << "<span class='danger'>Speech is currently admin-disabled.</span>"
		return

	msg = sanitize(msg)
	if (!msg)
		return
	log_vip("[mob.name]/[key] : [msg]")
	for(var/client/C in clients)
		if(!is_vip(C))
			continue
		C << "<span class='vip_channel'>" + create_text_tag("vip", "VIP:", C) + " <span class='name'>[src.key]</span>: <span class='message'>[msg]</span></span>"

/datum/admins/proc/reload_vips()
	set category = "Admin"
	set desc = "Reload the VIP list."
	set name = "Reload VIPs"

	if(!check_rights(R_ADMIN)) return
	load_vips()
	log_admin("[key_name(usr)] reloaded the VIP list.")

/datum/admins/proc/show_vips()
	set category = "Admin"
	set desc = "Show the VIP list."
	set name = "Show VIPs"

	if(!check_rights(R_ADMIN)) return
	usr << "<b>VIPs:</b>"
	for(var/tkey in vips) usr << "- [tkey]"

/mob/Login()
	..()
	if(client.IsByondMember())
		vips |= client.ckey

/client/proc/add_vip_verbs()
	verbs |= /client/proc/cmd_vip_say
