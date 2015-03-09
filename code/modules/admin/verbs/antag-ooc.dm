/client/proc/aooc()
	set category = "Admin"
	set name = "Antag OOC"

	if(!check_rights(R_ADMIN))	return

	var/msg = sanitize(copytext(input(usr, "", "Antag OOC") as text, 1, MAX_MESSAGE_LEN))
	if(!msg)	return

	var/display_name = src.key
	if(holder && holder.fakekey)
		display_name = holder.fakekey

	for(var/mob/M in mob_list)
		if((M.mind && M.mind.special_role && M.client) || (M.client && M.client.holder))
			M << "<font color='#960018'><span class='ooc'>" + create_text_tag("aooc", "Antag-OOC:", M.client) + " <EM>[display_name]:</EM> <span class='message'>[msg]</span></span></font>"

	log_ooc("Antag-OOC: [key] : [msg]")