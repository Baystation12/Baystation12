/client
	var/datum/managed_browser/changelingevolution/changelingevolution = null

/datum/managed_browser/changelingevolution
	base_browser_id = "evolution_tree"
	title = "Evolution Tree"
	size_x = 480
	size_y = 600
	var/textbody = null

/datum/managed_browser/changelingevolution/New(client/new_client)
	if(!new_client.mob || !new_client.mob.mind || !new_client.mob.mind.changeling)
		message_admins("[new_client] tried to access changeling evolutions while not changeling.")
		qdel(src)

	..()

/datum/managed_browser/changelingevolution/Destroy()
	if(my_client)
		my_client.changelingevolution = null
	return ..()

/datum/managed_browser/changelingevolution/get_html()
	var/list/dat = list("<html><body>")
	var/geneticpoints_current = my_client.mob.mind.changeling.geneticpoints
	var/geneticpoints_max = my_client.mob.mind.changeling.max_geneticpoints

	dat += "<center>Genetic Points Available: [geneticpoints_current] / [geneticpoints_max] <br>"
	dat += "Obtain more by feeding on your own kind. <br> <hr>"
	dat += "<a style='background-color:#c72121;' href='?src=\ref[src];tutorial=1'>What am I?</a><br><hr>"
	dat += "<a style='background-color:#c72121;' href='?src=\ref[src];inherent=1'>Inherent</a>"
	dat += "<a style='background-color:#c72121;' href='?src=\ref[src];armor=1'>Armor</a>"
	dat += "<a style='background-color:#c72121;' href='?src=\ref[src];weapons=1'>Weapons</a>"
	dat += "<a style='background-color:#c72121;' href='?src=\ref[src];stings=1'>Stings</a>"
	dat += "<a style='background-color:#c72121;' href='?src=\ref[src];shrieks=1'>Shrieks</a>"
	dat += "<a style='background-color:#c72121;' href='?src=\ref[src];health=1'>Health</a>"
	dat += "<a style='background-color:#c72121;' href='?src=\ref[src];enhancements=1'>Enhancements</a></center>"
	if(textbody)
		dat += "<table border='1' style='width:100%; background-color:#000000;'>"
		dat += "[textbody]"
		dat += "</table>"
	dat += "</body></html>"

	return dat.Join()

/datum/managed_browser/changelingevolution/Topic(href, href_list[])
	if(!my_client)
		return FALSE

	if(href_list["close"])
		return

	if(href_list["inherent"])
		generate_abilitylist(CHANGELING_POWER_INHERENT)

	if(href_list["armor"])
		generate_abilitylist(CHANGELING_POWER_ARMOR)

	if(href_list["weapons"])
		generate_abilitylist(CHANGELING_POWER_WEAPONS)

	if(href_list["stings"])
		generate_abilitylist(CHANGELING_POWER_STINGS)

	if(href_list["shrieks"])
		generate_abilitylist(CHANGELING_POWER_SHRIEKS)

	if(href_list["health"])
		generate_abilitylist(CHANGELING_POWER_HEALTH)

	if(href_list["enhancements"])
		generate_abilitylist(CHANGELING_POWER_ENHANCEMENTS)

	if(href_list["evolve"])
		var/datum/mind/M = my_client.mob.mind
		var/datum/changeling/C = my_client.mob.mind.changeling
		var/datum/power/changeling/Thepower = href_list["evolve"]

		for (var/datum/power/changeling/P in GLOB.powerinstances)
			if(P.name == Thepower)
				Thepower = P
				break

		if(!istype(M))
			return

		if(!Thepower)
			to_chat(M.current, "Purchase failed. Inform a dev of this error.")
			return

		if(Thepower in C.purchased_powers)
			to_chat(M.current, "You already have this ability! Inform a dev of this error.") /// Should not be possible
			return

		if(C.geneticpoints < Thepower.genomecost)
			to_chat(M.current, "We cannot evolve this... yet.  We must acquire more DNA.")
			return

		C.purchased_powers += Thepower /// Set it to purchased
		C.geneticpoints -= Thepower.genomecost
		generate_abilitylist(Thepower.power_category) /// Refresh the UI

		my_client.mob.mind.changeling.purchasePower(M, Thepower)

	if(href_list["tutorial"])
		textbody = "<tr><th><font color='#c72121'><center>What am I?</center></font><br></th></tr>"
		textbody += "<tr><td>"
		textbody += "<font color='#F7F7ED'>You are a changeling, a creature empowered with genetic-based abilities that change your body in bizarre ways."
		textbody += " It's probably best the crew doesn't know about your power -- at least not right away.</font><br><br>"
		textbody += "<font color='#F7F7ED'>What a changeling <i>is</i>, however, is up to you. Are you a strange alien impersonating crew? Are you a"
		textbody += " normal crewmember infected with a parasite? An experiment gone wrong? It's up to you to make the story.</font><br><br>"
		textbody += "<font color='#F7F7ED'>Of course, you need to know how it works to begin with.</font><br><br>"
		textbody += "<font color='#F7F7ED'>Your abilities cost chemicals that your body will slowly regenerate with varying speeds based on enhancements obtained."
		textbody += " There are a set of inherent abilities you will always have while the rest may be purchased through genomes.</font><br><br>"
		textbody += "<font color='#F7F7ED'>You may obtain more genomes if you find another changeling and absorb them, but this is not required. If you've found "
		textbody += "your abilities aren't to your liking, you have up to two re-adapts available, and these may be refilled by absorbing anyone -- including monkeys.</font><br><br>"
		textbody += "<font color='#F7F7ED'>Good luck and remember, killing isn't always the end goal.</font>"
		display()

/datum/managed_browser/changelingevolution/proc/generate_abilitylist(cat)
	var/list/ability_list = list()
	var/info = ""
	var/catname = ""
	for(var/datum/power/changeling/P in GLOB.powerinstances)
		if(P.power_category == cat)
			ability_list[LIST_PRE_INC(ability_list)] = P
	switch(cat)
		if(CHANGELING_POWER_INHERENT)
			catname = "Inherent"
			info = "These powers are inherent to your kind and will always be accessible, provided you have the chemicals to use them."
		if(CHANGELING_POWER_ARMOR)
			catname = "Armor"
			info = "These abilities will provide you with space protection -- and potentially armor."
		if(CHANGELING_POWER_WEAPONS)
			catname = "Weapons"
			info = "These abilities will provide you the means to fight back."
		if(CHANGELING_POWER_STINGS)
			catname = "Stings"
			info = "These abilities provide the means to sting organic beings for various effects -- though you must be close enough, and they must have exposed flesh."
		if(CHANGELING_POWER_SHRIEKS)
			catname = "Shrieks"
			info = "These abilities enhance your vocal chords, empowering your screams."
		if(CHANGELING_POWER_HEALTH)
			catname = "Health"
			info = "These abilities will enhance your health or aid you in mending your wounds."
		if(CHANGELING_POWER_ENHANCEMENTS)
			catname = "Enhancements"
			info = "These abilities enhance you in various ways."
	create_textbody(ability_list, catname, info)

/datum/managed_browser/changelingevolution/proc/create_textbody(ability_list, cat, catinfo)
	textbody = "<tr><th><font color='#c72121'><center>[cat] Skills</font><br></th></tr>"
	textbody += "<tr><td><font color='#F7F7ED'>[catinfo]</center></font><br><hr></td></tr>"
	for(var/A in ability_list)
		var/datum/power/changeling/powerdata = A
		textbody += "<tr><td><center><font color='#c72121'><b>[initial(powerdata.name)]</b></font><br></center>"
		textbody += "<font color='#F7F7ED'>[initial(powerdata.desc)]</font><br><br>"
		textbody += "<font color='#F7F7ED'><i>[powerdata.helptext]</i></font><br>"
		if(powerdata.enhancedtext != "")
			textbody += "<font color='#F7F7ED'><b>WHEN EHANCED: </b><i>[powerdata.enhancedtext]</i></font><br>"
		if(powerdata in my_client.mob.mind.changeling.purchased_powers)
			textbody += "<center><font color='#F7F7ED'><i><b>This ability is already evolved!</b></i></font></center>"
		else if(cat != "Inherent")
			textbody += "<center><a style='background-color:#c72121;' href='?src=\ref[src];evolve=[A]'>Evolve</a></center>"
		textbody += "</td></tr>"
	display()
