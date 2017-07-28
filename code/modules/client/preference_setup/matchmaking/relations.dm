/*
/datum/category_item/player_setup_item/relations/content(mob/user)
	.=list()
	. += "Characters with enabled relations are paired up randomly after spawn. You can terminate relations when you first open relations info window, but after that it's final."
	. += "<hr>"
	. += "<br><b>What do they know about you?</b> This is the general info that all kinds of your connections would know. <a href='?src=\ref[src];relation_info=["general"]'>Edit</a>"
	. += "<br><i>[pref.relations_info["general"] ? pref.relations_info["general"] : "Nothing specific."]</i>"
	. += "<hr>"
	for(var/T in subtypesof(/datum/relation))
		var/datum/relation/R = T
		. += "<b>[initial(R.name)]</b>\t"
		if(initial(R.name) in pref.relations)
			. += "<span class='linkOn'>On</span>"
			. += "<a href='?src=\ref[src];relation=[initial(R.name)]'>Off</a>"
		else
			. += "<a href='?src=\ref[src];relation=[initial(R.name)]'>On</a>"
			. += "<span class='linkOn'>Off</span>"
		. += "<br><i>[initial(R.desc)]</i>"
		. += "<br><b>What do they know about you?</b><a href='?src=\ref[src];relation_info=[initial(R.name)]'>Edit</a>"
		. += "<br><i>[pref.relations_info[initial(R.name)] ? pref.relations_info[initial(R.name)] : "Nothing specific."]</i>"
		. += "<hr>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/relations/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["relation"])
		var/R = href_list["relation"]
		pref.relations ^= R
		return TOPIC_REFRESH
	if(href_list["relation_info"])
		var/R = href_list["relation_info"]
		var/info = sanitize(input("Character info", "What would you like the other party for this connection to know about your character?",pref.relations_info[R]) as message|null)
		if(info)
			pref.relations_info[R] = info
		return TOPIC_REFRESH
	return ..()
*/