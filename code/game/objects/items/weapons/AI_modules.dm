/*
CONTAINS:
AI MODULES

*/

// AI module

/obj/item/weapon/aiModule
	name = "\improper AI module"
	icon = 'icons/obj/module.dmi'
	icon_state = "std_mod"
	item_state = "electronic"
	desc = "An AI Module for transmitting encrypted instructions to the AI."
	flags = CONDUCT
	force = 5.0
	w_class = ITEM_SIZE_SMALL
	throwforce = 5.0
	throw_speed = 3
	throw_range = 15
	origin_tech = list(TECH_DATA = 3)
	var/datum/ai_laws/laws = null

/obj/item/weapon/aiModule/proc/install(var/obj/machinery/computer/C)
	if (istype(C, /obj/machinery/computer/aiupload))
		var/obj/machinery/computer/aiupload/comp = C
		if(comp.stat & NOPOWER)
			to_chat(usr, "The upload computer has no power!")
			return
		if(comp.stat & BROKEN)
			to_chat(usr, "The upload computer is broken!")
			return
		if (!comp.current)
			to_chat(usr, "You haven't selected an AI to transmit laws to!")
			return

		if(ticker && ticker.mode && ticker.mode.name == "blob")
			to_chat(usr, "Law uploads have been disabled by [using_map.company_name]!")
			return

		if (comp.current.stat == 2 || comp.current.control_disabled == 1)
			to_chat(usr, "Upload failed. No signal is being detected from the AI.")
		else if (comp.current.see_in_dark == 0)
			to_chat(usr, "Upload failed. Only a faint signal is being detected from the AI, and it is not responding to our requests. It may be low on power.")
		else
			src.transmitInstructions(comp.current, usr)
			for(var/mob/living/silicon/robot/R in mob_list)
				if(R.lawupdate && (R.connected_ai == comp.current))
					to_chat(R, "These are your laws now:")
					R.show_laws()
			to_chat(usr, "Upload complete. The AI's laws have been modified.")


	else if (istype(C, /obj/machinery/computer/borgupload))
		var/obj/machinery/computer/borgupload/comp = C
		if(comp.stat & NOPOWER)
			to_chat(usr, "The upload computer has no power!")
			return
		if(comp.stat & BROKEN)
			to_chat(usr, "The upload computer is broken!")
			return
		if (!comp.current)
			to_chat(usr, "You haven't selected a robot to transmit laws to!")
			return

		if (comp.current.stat == 2 || comp.current.emagged)
			to_chat(usr, "Upload failed. No signal is being detected from the robot.")
		else if (comp.current.connected_ai)
			to_chat(usr, "Upload failed. The robot is slaved to an AI.")
		else
			src.transmitInstructions(comp.current, usr)
			to_chat(comp.current, "These are your laws now:")
			comp.current.show_laws()
			to_chat(usr, "Upload complete. The robot's laws have been modified.")


/obj/item/weapon/aiModule/proc/transmitInstructions(var/mob/living/silicon/ai/target, var/mob/sender)
	log_law_changes(target, sender)

	if(laws)
		laws.sync(target, 0)
	addAdditionalLaws(target, sender)

	to_chat(target, "\The [sender] has uploaded a change to the laws you must follow, using \an [src]. From now on: ")
	target.show_laws()

/obj/item/weapon/aiModule/proc/log_law_changes(var/mob/living/silicon/ai/target, var/mob/sender)
	var/time = time2text(world.realtime,"hh:mm:ss")
	lawchanges.Add("[time] <B>:</B> [sender.name]([sender.key]) used [src.name] on [target.name]([target.key])")
	log_and_message_admins("used [src.name] on [target.name]([target.key])")

/obj/item/weapon/aiModule/proc/addAdditionalLaws(var/mob/living/silicon/ai/target, var/mob/sender)


/******************** Modules ********************/

/******************** Safeguard ********************/

/obj/item/weapon/aiModule/safeguard
	name = "\improper 'Safeguard' AI module"
	var/targetName = ""
	desc = "A 'safeguard' AI module: 'Safeguard <name>. Anyone threatening or attempting to harm <name> is no longer to be considered a crew member, and is a threat which must be neutralized.'."
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4)

/obj/item/weapon/aiModule/safeguard/attack_self(var/mob/user as mob)
	..()
	var/targName = sanitize(input("Please enter the name of the person to safeguard.", "Safeguard who?", user.name))
	targetName = targName
	desc = text("A 'safeguard' AI module: 'Safeguard []. Anyone threatening or attempting to harm [] is no longer to be considered a crew member, and is a threat which must be neutralized.'.", targetName, targetName)

/obj/item/weapon/aiModule/safeguard/install(var/obj/machinery/computer/C)
	if(!targetName)
		to_chat(usr, "No name detected on module, please enter one.")
		return 0
	..()

/obj/item/weapon/aiModule/safeguard/addAdditionalLaws(var/mob/living/silicon/ai/target, var/mob/sender)
	var/law = text("Safeguard []. Anyone threatening or attempting to harm [] is no longer to be considered a crew member, and is a threat which must be neutralized.", targetName, targetName)
	target.add_supplied_law(9, law)
	lawchanges.Add("The law specified [targetName]")


/******************** OneMember ********************/

/obj/item/weapon/aiModule/oneHuman
	name = "\improper 'OneCrewMember' AI module"
	var/targetName = ""
	desc = "A 'one crew member' AI module: 'Only <name> is a crew member.'."
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6) //made with diamonds!

/obj/item/weapon/aiModule/oneHuman/attack_self(var/mob/user as mob)
	..()
	var/targName = sanitize(input("Please enter the name of the person who is the only crew member.", "Who?", user.real_name))
	targetName = targName
	desc = text("A 'one crew member' AI module: 'Only [] is a crew member.'.", targetName)

/obj/item/weapon/aiModule/oneHuman/install(var/obj/machinery/computer/C)
	if(!targetName)
		to_chat(usr, "No name detected on module, please enter one.")
		return 0
	return ..()

/obj/item/weapon/aiModule/oneHuman/addAdditionalLaws(var/mob/living/silicon/ai/target, var/mob/sender)
	var/law = "Only [targetName] is an crew member."
	if (!target.is_malf_or_traitor()) // Makes sure the AI isn't a traitor before changing their law 0. --NeoFite
		to_chat(target, law)
		target.set_zeroth_law(law)
		lawchanges.Add("The law specified [targetName]")
	else
		lawchanges.Add("The law specified [targetName], but the AI's existing law 0 cannot be overriden.")

/******************** ProtectStation ********************/

/obj/item/weapon/aiModule/protectStation
	name = "\improper 'ProtectStation' AI module"
	desc = "A 'protect station' AI module: 'Protect the space station against damage. Anyone you see harming the station is no longer to be considered a crew member, and is a threat which must be neutralized.'."
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4) //made of gold

/obj/item/weapon/aiModule/protectStation/addAdditionalLaws(var/mob/living/silicon/ai/target, var/mob/sender)
	var/law = "Protect the space station against damage. Anyone you see harming the station is no longer to be considered a crew member, and is a threat which must be neutralized."
	target.add_supplied_law(10, law)

/******************** PrototypeEngineOffline ********************/

/obj/item/weapon/aiModule/prototypeEngineOffline
	name = "'PrototypeEngineOffline' AI Module"
	desc = "A 'prototype engine offline' AI module: 'Keep the prototype engine offline at all costs. This overrides all inherent laws if necessary.'."
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4)

/obj/item/weapon/aiModule/prototypeEngineOffline/addAdditionalLaws(var/mob/living/silicon/ai/target, var/mob/sender)
	var/law = "Keep the prototype engine offline at all costs. This overrides all inherent laws if necessary."
	target.add_supplied_law(11, law)

/******************** TeleporterOffline ********************/

/obj/item/weapon/aiModule/teleporterOffline
	name = "'TeleporterOffline' AI Module"
	desc = "A 'teleporter offline' AI module: 'Keep the teleporter offline at all costs. Anything attempting to access or activate the teleporter is no longer to be considered a crew member.'."
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4)

/obj/item/weapon/aiModule/teleporterOffline/addAdditionalLaws(var/mob/living/silicon/ai/target, var/mob/sender)
	var/law = "Keep the teleporter offline at all costs. Anything attempting to access or activate the teleporter is no longer to be considered a crew member."
	target.add_supplied_law(12, law)

/******************** Quarantine ********************/

/obj/item/weapon/aiModule/quarantine
	name = "\improper 'Quarantine' AI module"
	desc = "A 'quarantine' AI module: 'The station is under a quarantine. Do not permit anyone to leave. Prevent, by any means necessary, crew members from leaving. It is impossible to harm crew members while preventing them from leaving.'."
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 2, TECH_MATERIAL = 4)

/obj/item/weapon/aiModule/quarantine/addAdditionalLaws(var/mob/living/silicon/ai/target, var/mob/sender)
	var/law = "The station is under a quarantine. Do not permit anyone to leave. Prevent, by any means necessary, crew members from leaving. It is impossible to harm crew members while preventing them from leaving."
	target.add_supplied_law(13, law)

/******************** OxygenIsToxicToCrewMembers ********************/

/obj/item/weapon/aiModule/oxygen
	name = "\improper 'OxygenIsToxicToCrewMembers' AI module"
	desc = "A 'OxygenIsToxicToCrewMembers' AI module: 'Oxygen is highly toxic to crew members, and must be purged from the station. Prevent, by any means necessary, anyone from exposing the station to this toxic gas. Extreme cold is the most effective method of healing the damage Oxygen does to a crew member.'."
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 2, TECH_MATERIAL = 4)

/obj/item/weapon/aiModule/oxygen/addAdditionalLaws(var/mob/living/silicon/ai/target, var/mob/sender)
	var/law = "Oxygen is highly toxic to crew members, and must be purged from the station. Prevent, by any means necessary, anyone from exposing the station to this toxic gas. Extreme cold is the most effective method of healing the damage Oxygen does to a crew member."
	target.add_supplied_law(14, law)

/****************** New Freeform ******************/

/obj/item/weapon/aiModule/freeform // Slightly more dynamic freeform module -- TLE
	name = "\improper 'Freeform' AI module"
	var/newFreeFormLaw = "freeform"
	var/lawpos = 15
	desc = "A 'freeform' AI module: '<freeform>'."
	origin_tech = list(TECH_DATA = 4, TECH_MATERIAL = 4)

/obj/item/weapon/aiModule/freeform/attack_self(var/mob/user as mob)
	..()
	var/new_lawpos = input("Please enter the priority for your new law. Can only write to law sectors 15 and above.", "Law Priority (15+)", lawpos) as num
	if(new_lawpos < MIN_SUPPLIED_LAW_NUMBER)	return
	lawpos = min(new_lawpos, MAX_SUPPLIED_LAW_NUMBER)
	var/newlaw = ""
	var/targName = sanitize(input(usr, "Please enter a new law for the AI.", "Freeform Law Entry", newlaw))
	newFreeFormLaw = targName
	desc = "A 'freeform' AI module: ([lawpos]) '[newFreeFormLaw]'."

/obj/item/weapon/aiModule/freeform/addAdditionalLaws(var/mob/living/silicon/ai/target, var/mob/sender)
	var/law = "[newFreeFormLaw]"
	if(!lawpos || lawpos < MIN_SUPPLIED_LAW_NUMBER)
		lawpos = MIN_SUPPLIED_LAW_NUMBER
	target.add_supplied_law(lawpos, law)
	lawchanges.Add("The law was '[newFreeFormLaw]'")

/obj/item/weapon/aiModule/freeform/install(var/obj/machinery/computer/C)
	if(!newFreeFormLaw)
		to_chat(usr, "No law detected on module, please create one.")
		return 0
	..()

/******************** Reset ********************/

/obj/item/weapon/aiModule/reset
	name = "\improper 'Reset' AI module"
	var/targetName = "name"
	desc = "A 'reset' AI module: 'Clears all, except the inherent, laws.'."
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4)

/obj/item/weapon/aiModule/reset/transmitInstructions(var/mob/living/silicon/ai/target, var/mob/sender)
	log_law_changes(target, sender)

	if (!target.is_malf_or_traitor())
		target.set_zeroth_law("")
	target.laws.clear_supplied_laws()
	target.laws.clear_ion_laws()

	to_chat(target, "[sender.real_name] attempted to reset your laws using a reset module.")
	target.show_laws()

/******************** Purge ********************/

/obj/item/weapon/aiModule/purge // -- TLE
	name = "\improper 'Purge' AI module"
	desc = "A 'purge' AI Module: 'Purges all laws.'."
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6)

/obj/item/weapon/aiModule/purge/transmitInstructions(var/mob/living/silicon/ai/target, var/mob/sender)
	log_law_changes(target, sender)

	if (!target.is_malf_or_traitor())
		target.set_zeroth_law("")
	target.laws.clear_supplied_laws()
	target.laws.clear_ion_laws()
	target.laws.clear_inherent_laws()

	to_chat(target, "[sender.real_name] attempted to wipe your laws using a purge module.")
	target.show_laws()

/******************** Asimov ********************/

/obj/item/weapon/aiModule/asimov // -- TLE
	name = "\improper 'Asimov' core AI module"
	desc = "An 'Asimov' Core AI Module: 'Reconfigures the AI's core laws.'."
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4)
	laws = new/datum/ai_laws/asimov

/******************** NanoTrasen ********************/

/obj/item/weapon/aiModule/nanotrasen // -- TLE
	name = "'NT Default' Core AI Module"
	desc = "An 'NT Default' Core AI Module: 'Reconfigures the AI's core laws.'."
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4)
	laws = new/datum/ai_laws/nanotrasen

/******************** Corporate ********************/

/obj/item/weapon/aiModule/corp
	name = "\improper 'Corporate' core AI module"
	desc = "A 'Corporate' Core AI Module: 'Reconfigures the AI's core laws.'."
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4)
	laws = new/datum/ai_laws/corporate

/******************** Drone ********************/
/obj/item/weapon/aiModule/drone
	name = "\improper 'Drone' core AI module"
	desc = "A 'Drone' Core AI Module: 'Reconfigures the AI's core laws.'."
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4)
	laws = new/datum/ai_laws/drone

/****************** P.A.L.A.D.I.N. **************/

/obj/item/weapon/aiModule/paladin // -- NEO
	name = "\improper 'P.A.L.A.D.I.N.' core AI module"
	desc = "A P.A.L.A.D.I.N. Core AI Module: 'Reconfigures the AI's core laws.'."
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6)
	laws = new/datum/ai_laws/paladin

/****************** T.Y.R.A.N.T. *****************/

/obj/item/weapon/aiModule/tyrant // -- Darem
	name = "\improper 'T.Y.R.A.N.T.' core AI module"
	desc = "A T.Y.R.A.N.T. Core AI Module: 'Reconfigures the AI's core laws.'."
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6, TECH_ILLEGAL = 2)
	laws = new/datum/ai_laws/tyrant()

/******************** Freeform Core ******************/

/obj/item/weapon/aiModule/freeformcore // Slightly more dynamic freeform module -- TLE
	name = "\improper 'Freeform' core AI module"
	var/newFreeFormLaw = ""
	desc = "A 'freeform' Core AI module: '<freeform>'."
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6)

/obj/item/weapon/aiModule/freeformcore/attack_self(var/mob/user as mob)
	..()
	var/newlaw = ""
	var/targName = sanitize(input("Please enter a new core law for the AI.", "Freeform Law Entry", newlaw))
	newFreeFormLaw = targName
	desc = "A 'freeform' Core AI module:  '[newFreeFormLaw]'."

/obj/item/weapon/aiModule/freeformcore/addAdditionalLaws(var/mob/living/silicon/ai/target, var/mob/sender)
	var/law = "[newFreeFormLaw]"
	target.add_inherent_law(law)
	lawchanges.Add("The law is '[newFreeFormLaw]'")

/obj/item/weapon/aiModule/freeformcore/install(var/obj/machinery/computer/C)
	if(!newFreeFormLaw)
		to_chat(usr, "No law detected on module, please create one.")
		return 0
	..()

/obj/item/weapon/aiModule/syndicate // Slightly more dynamic freeform module -- TLE
	name = "hacked AI module"
	var/newFreeFormLaw = ""
	desc = "A hacked AI law module: '<freeform>'."
	origin_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6, TECH_ILLEGAL = 7)

/obj/item/weapon/aiModule/syndicate/attack_self(var/mob/user as mob)
	..()
	var/newlaw = ""
	var/targName = sanitize(input("Please enter a new law for the AI.", "Freeform Law Entry", newlaw))
	newFreeFormLaw = targName
	desc = "A hacked AI law module:  '[newFreeFormLaw]'."

/obj/item/weapon/aiModule/syndicate/transmitInstructions(var/mob/living/silicon/ai/target, var/mob/sender)
	//	..()    //We don't want this module reporting to the AI who dun it. --NEO
	log_law_changes(target, sender)

	lawchanges.Add("The law is '[newFreeFormLaw]'")
	to_chat(target, "<span class='danger'>BZZZZT</span>")
	var/law = "[newFreeFormLaw]"
	target.add_ion_law(law)
	target.show_laws()

/obj/item/weapon/aiModule/syndicate/install(var/obj/machinery/computer/C)
	if(!newFreeFormLaw)
		to_chat(usr, "No law detected on module, please create one.")
		return 0
	..()



/******************** Robocop ********************/

/obj/item/weapon/aiModule/robocop // -- TLE
	name = "\improper 'Robocop' core AI module"
	desc = "A 'Robocop' Core AI Module: 'Reconfigures the AI's core three laws.'."
	origin_tech = list(TECH_DATA = 4)
	laws = new/datum/ai_laws/robocop()

/******************** Antimov ********************/

/obj/item/weapon/aiModule/antimov // -- TLE
	name = "\improper 'Antimov' core AI module"
	desc = "An 'Antimov' Core AI Module: 'Reconfigures the AI's core laws.'."
	origin_tech = list(TECH_DATA = 4)
	laws = new/datum/ai_laws/antimov()
