mob/spirit/mask


mob/spirit/mask/New()
	..()
	spell_list += new /obj/effect/proc_holder/spell/aoe_turf/conjure/create_talisman(src)
	spell_list += new /obj/effect/proc_holder/spell/aoe_turf/blood_speech(src)
	

mob/spirit/mask/verb/go_to_follower()
	set category = "Mask"
	set name = "Go to follower"
	set desc = "Select who you would like to go too."
	
	var/obj/cult_viewpoint/cultist = pick_cultist()
	if (cultist)
		follow_cultist(cultist.owner)
		src << "You start following [cultist.get_display_name()]."
	
	
mob/spirit/mask/verb/set_specific_urge()
	set category = "Mask"
	set name = "Set urge on cultist"
	set desc = "Set urge on target"
	
	var/obj/cult_viewpoint/cultist = pick_cultist()
	if (cultist)
		var/newUrge = stripped_input(usr, "", "Set Urge", "")
		cultist.set_urge(newUrge)
		src << "You urge [cultist.owner.name] to [newUrge]."

mob/spirit/mask/verb/set_cult_name()
	set category = "Mask"
	set name = "Set Cult Name"
	set desc = "Grant a cultist a name."
	
	var/obj/cult_viewpoint/cultist = pick_cultist()
	if (cultist)
		var/newName = stripped_input(usr, "", "Set Cult Name", "")
		if (!newName)
			return
		cultist.set_cult_name(newName)
		src << "You grant [cultist.owner.name] the secret name of [newName]."
		
		
mob/spirit/mask/verb/set_global_urge()
	set category = "Mask"
	set name = "Set global urge"
	set desc = "Set urge on the entire cult."
	
	var/newUrge = stripped_input(usr, "Please choose an urge.", "Set Urge", "")
	for(var/obj/cult_viewpoint/viewpoint in cult_viewpoints)
		viewpoint.set_urge(newUrge)
	src << "You urge the entire cult to [newUrge]."
			
			
mob/spirit/mask/verb/set_favor_for_cultist()
	set category = "Mask"
	set name = "Show your favor"
	set desc = "Set the favor for a cultist"
	
	var/obj/cult_viewpoint/cultist = pick_cultist()
	if (cultist)
		var/list/favor = list("Pleased", "Displeased", "Indifference")
		var/emotion = input("Pick your emotion", "Mask", null, null) in favor
		switch(emotion)
			if("Pleased")
				cultist.set_favor(1)
			if("Displeased")
				cultist.set_favor(-1)
			if("Indifference")
				cultist.set_favor(0)
	
	
mob/spirit/mask/proc/set_name()
	var/newName = stripped_input(usr, "Please pick a name.", "Pick Name for Mask", "")
	name = newName ? newName : "Mask of Nar'sie"
	
	
mob/spirit/mask/proc/pick_cultist()
	var/list/cultists = list()
	for(var/obj/cult_viewpoint/viewpoint in cult_viewpoints)
		cultists[viewpoint.get_display_name()]=viewpoint
	var/input = input("Please, select a cultist!", "Cult", null, null) as null|anything in cultists
	var/obj/cult_viewpoint/result = cultists[input]
	return result
	

// SPELLS
/obj/effect/proc_holder/spell/aoe_turf/blood_speech
	name = "Speak to your Acolytes"
	desc = "This spell allows you to speak to your flock."
	school = "unknown evil"
	charge_type = "recharge"
	charge_max = 300
	clothes_req = 0
	invocation = "none"
	invocation_type = "none"
	range = 0
	
/obj/effect/proc_holder/spell/aoe_turf/blood_speech/cast(list/targets)
	var/input = stripped_input(usr, "Please choose a message to tell your acolytes.", "Voice of Blood", "")
	if(!input)
		revert_cast(usr)
	for(var/datum/mind/H in ticker.mode.cult)
		if (H.current)
			H.current << "<span class='cultspeech'><font size=3><span class='name'>[usr.name]: </span><span class='message'>[input]</span></font></span>"	
	for(var/mob/spirit/spirit in spirits)
		spirit << "<span class='cultspeech'><font size=3><span class='name'>[usr.name]: </span><span class='message'>[input]</span></font></span>"	

			
/obj/effect/proc_holder/spell/aoe_turf/conjure/create_talisman
	name = "Create Talisman"
	desc = "This spell conjures a talisman"

	school = "conjuration"
	charge_type = "recharge"
	charge_max = 300
	clothes_req = 0
	invocation = "none"
	invocation_type = "none"
	range = 0
	summon_type = list(/obj/item/weapon/paper/talisman)
	
	var/list/talismans = list(	"Armor"="armor",
								"Blind"="blind",
								"Conceal"="conceal",
								"Communicate"="communicate",
								"Deafen"="deafen",
								"EMP"="emp", 
								"Teleport"="teleport", 
								"Tome"="newtome", 
								"Reveal Runes",
								"Stun"="runestun",
								"Soul Stone"="soulstone",
								"Construct"="construct")
								
	
/obj/effect/proc_holder/spell/aoe_turf/conjure/create_talisman/cast(list/targets)
	
	var/talisman = input("Pick a talisman type", "Talisman", null, null) as null|anything in talismans
	var/imbue_value = talismans[talisman]
	if (!talisman)
		usr << "You choose not to create a talisman."
		revert_cast(usr)
		return
	
	switch(talisman)
		
		if ("Teleport")
			var/target_rune = input("Pick a teleport target", "Teleport Rune", null, null) as null|anything in engwords
			if (!target_rune)
				usr << "You choose not to create a talisman."
				revert_cast(usr)
				return
			summon_type = list(/obj/item/weapon/paper/talisman)
			newVars = list("imbue" = "[target_rune]", "info" = "[target_rune]")
		
		if ("Soul Stone")
			summon_type = list(/obj/item/device/soulstone)
			newVars = list()
			
		if ("Construct")
			summon_type = list(/obj/structure/constructshell)
			newVars = list()
		
		else
			summon_type = list(/obj/item/weapon/paper/talisman)
			newVars = list("imbue" = "[imbue_value]")
			
	..()