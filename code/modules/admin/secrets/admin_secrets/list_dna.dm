/datum/admin_secret_item/admin_secret/list_dna
	name = "List DNA (Blood)"

/datum/admin_secret_item/admin_secret/list_dna/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	var/dat = "<B>Showing DNA from blood.</B><HR>"
	dat += "<table cellspacing=5><tr><th>Name</th><th>DNA</th><th>Blood Type</th></tr>"
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.dna && H.ckey)
			dat += "<tr><td>[H]</td><td>[H.dna.unique_enzymes]</td><td>[H.b_type]</td></tr>"
	dat += "</table>"
	user << browse(dat, "window=DNA;size=440x410")
