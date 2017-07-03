var/global/list/uplink_locations = list("PDA", "Headset", "None")

/datum/preferences
	var/uplinklocation = "PDA"
	var/exploit_record = ""

/datum/category_item/player_setup_item/antagonism/basic
	name = "Setup"
	sort_order = 2

/datum/category_item/player_setup_item/antagonism/basic/load_character(var/savefile/S)
	S["uplinklocation"] >> pref.uplinklocation
	S["exploit_record"] >> pref.exploit_record

/datum/category_item/player_setup_item/antagonism/basic/save_character(var/savefile/S)
	S["uplinklocation"] << pref.uplinklocation
	S["exploit_record"] << pref.exploit_record

/datum/category_item/player_setup_item/antagonism/basic/sanitize_character()
	pref.uplinklocation	= sanitize_inlist(pref.uplinklocation, uplink_locations, initial(pref.uplinklocation))

/datum/category_item/player_setup_item/antagonism/basic/content(var/mob/user)
	. +="<b>Antag Setup:</b><br>"
	. +="Uplink Type: <a href='?src=\ref[src];antagtask=1'>[pref.uplinklocation]</a><br>"
	. +="Exploitable information:<br>"
	if(jobban_isbanned(user, "Records"))
		. += "<b>You are banned from using character records.</b><br>"
	else
		. +="<a href='?src=\ref[src];exploitable_record=1'>[TextPreview(pref.exploit_record,40)]</a><br>"

/datum/category_item/player_setup_item/antagonism/basic/OnTopic(var/href,var/list/href_list, var/mob/user)
	if (href_list["antagtask"])
		pref.uplinklocation = next_in_list(pref.uplinklocation, uplink_locations)
		return TOPIC_REFRESH

	if(href_list["exploitable_record"])
		var/exploitmsg = sanitize(input(user,"Set exploitable information about you here.","Exploitable Information", html_decode(pref.exploit_record)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		if(!isnull(exploitmsg) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.exploit_record = exploitmsg
			return TOPIC_REFRESH

	return ..()
