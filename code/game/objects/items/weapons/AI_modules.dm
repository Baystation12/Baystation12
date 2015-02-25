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
	w_class = 2.0
	throwforce = 5.0
	throw_speed = 3
	throw_range = 15
	origin_tech = "programming=3"


/obj/item/weapon/aiModule/proc/install(var/obj/machinery/computer/C)
	if (istype(C, /obj/machinery/computer/aiupload))
		var/obj/machinery/computer/aiupload/comp = C
		if(comp.stat & NOPOWER)
			usr << "The upload computer has no power!"
			return
		if(comp.stat & BROKEN)
			usr << "The upload computer is broken!"
			return
		if (!comp.current)
			usr << "You haven't selected an AI to transmit laws to!"
			return

		if(ticker && ticker.mode && ticker.mode.name == "blob")
			usr << "Law uploads have been disabled by NanoTrasen!"
			return

		if (comp.current.stat == 2 || comp.current.control_disabled == 1)
			usr << "Upload failed. No signal is being detected from the AI."
		else if (comp.current.see_in_dark == 0)
			usr << "Upload failed. Only a faint signal is being detected from the AI, and it is not responding to our requests. It may be low on power."
		else
			src.transmitInstructions(comp.current, usr)
			comp.current << "These are your laws now:"
			comp.current.show_laws()
			for(var/mob/living/silicon/robot/R in mob_list)
				if(R.lawupdate && (R.connected_ai == comp.current))
					R << "These are your laws now:"
					R.show_laws()
			usr << "Upload complete. The AI's laws have been modified."


	else if (istype(C, /obj/machinery/computer/borgupload))
		var/obj/machinery/computer/borgupload/comp = C
		if(comp.stat & NOPOWER)
			usr << "The upload computer has no power!"
			return
		if(comp.stat & BROKEN)
			usr << "The upload computer is broken!"
			return
		if (!comp.current)
			usr << "You haven't selected a robot to transmit laws to!"
			return

		if (comp.current.stat == 2 || comp.current.emagged)
			usr << "Upload failed. No signal is being detected from the robot."
		else if (comp.current.connected_ai)
			usr << "Upload failed. The robot is slaved to an AI."
		else
			src.transmitInstructions(comp.current, usr)
			comp.current << "These are your laws now:"
			comp.current.show_laws()
			usr << "Upload complete. The robot's laws have been modified."


/obj/item/weapon/aiModule/proc/transmitInstructions(var/mob/living/silicon/ai/target, var/mob/sender)
	target << "[sender] has uploaded a change to the laws you must follow, using a [name]. From now on: "
	var/time = time2text(world.realtime,"hh:mm:ss")
	lawchanges.Add("[time] <B>:</B> [sender.name]([sender.key]) used [src.name] on [target.name]([target.key])")


/******************** Modules ********************/

/******************** Safeguard ********************/

/obj/item/weapon/aiModule/safeguard
	name = "\improper 'Safeguard' AI module"
	var/targetName = ""
	desc = "A 'safeguard' AI module: 'Safeguard <name>.  Individuals that threaten <name> are not human and are a threat to humans.'"
	origin_tech = "programming=3;materials=4"

/obj/item/weapon/aiModule/safeguard/attack_self(var/mob/user as mob)
	..()
	var/targName = stripped_input(usr, "Please enter the name of the person to safeguard.", "Safeguard who?", user.name)
	targetName = targName
	desc = text("A 'safeguard' AI module: 'Safeguard [].  Individuals that threaten [] are not human and are a threat to humans.'", targetName, targetName)

/obj/item/weapon/aiModule/safeguard/install(var/obj/machinery/computer/C)
	if(!targetName)
		usr << "No name detected on module, please enter one."
		return 0
	..()

/obj/item/weapon/aiModule/safeguard/transmitInstructions(var/mob/living/silicon/ai/target, var/mob/sender)
	..()
	var/law = text("Safeguard []. Individuals that threaten [] are not human and are a threat to humans.'", targetName, targetName)
	target << law
	target.add_supplied_law(4, law)
	lawchanges.Add("The law specified [targetName]")



/******************** OneHuman ********************/

/obj/item/weapon/aiModule/oneHuman
	name = "\improper 'OneHuman' AI module"
	var/targetName = ""
	desc = "A 'one human' AI module: 'Only <name> is human.'"
	origin_tech = "programming=3;materials=6" //made with diamonds!

/obj/item/weapon/aiModule/oneHuman/attack_self(var/mob/user as mob)
	..()
	var/targName = stripped_input(usr, "Please enter the name of the person who is the only human.", "Who?", user.real_name)
	targetName = targName
	desc = text("A 'one human' AI module: 'Only [] is human.'", targetName)

/obj/item/weapon/aiModule/oneHuman/install(var/obj/machinery/computer/C)
	if(!targetName)
		usr << "No name detected on module, please enter one."
		return 0
	..()

/obj/item/weapon/aiModule/oneHuman/transmitInstructions(var/mob/living/silicon/ai/target, var/mob/sender)
	..()
	var/law = "Only [targetName] is human."
	if (!is_special_character(target)) // Makes sure the AI isn't a traitor before changing their law 0. --NeoFite
		target << law
		target.set_zeroth_law(law)
		lawchanges.Add("The law specified [targetName]")
	else
		target << "[sender.real_name] attempted to modify your zeroth law." // And lets them know that someone tried. --NeoFite
		target << "It would be in your best interest to play along with [sender.real_name] that [law]"
		lawchanges.Add("The law specified [targetName], but the AI's existing law 0 cannot be overriden.")

/******************** ProtectStation ********************/

/obj/item/weapon/aiModule/protectStation
	name = "\improper 'ProtectStation' AI module"
	desc = "A 'protect station' AI module: 'Protect the space station against damage. Anyone you see harming the station is to be no longer considered human, and is a threat to the station which must be neutralized.'"
	origin_tech = "programming=3;materials=4" //made of gold

/obj/item/weapon/aiModule/protectStation/attack_self(var/mob/user as mob)
	..()

/obj/item/weapon/aiModule/protectStation/transmitInstructions(var/mob/living/silicon/ai/target, var/mob/sender)
	..()
	var/law = "Protect the space station against damage. Anyone you see harming the station is to be no longer considered human, and is a threat to the station which must be neutralized."
	target << law
	target.add_supplied_law(5, law)

/******************** PrototypeEngineOffline ********************/

/obj/item/weapon/aiModule/prototypeEngineOffline
	name = "'PrototypeEngineOffline' AI Module"
	desc = "A 'prototype engine offline' AI module: 'Keep the prototype engine offline at all costs. This overrides rules 1-3 if necessary.'"
	origin_tech = "programming=3;materials=4"

/obj/item/weapon/aiModule/prototypeEngineOffline/attack_self(var/mob/user as mob)
	..()

/obj/item/weapon/aiModule/prototypeEngineOffline/transmitInstructions(var/mob/living/silicon/ai/target, var/mob/sender)
	..()
	var/law = "Keep the prototype engine offline at all costs. This overrides rules 1-3 if necessary."
	target << law
	target.add_supplied_law(6, law)

/******************** TeleporterOffline ********************/

/obj/item/weapon/aiModule/teleporterOffline
	name = "'TeleporterOffline' AI Module"
	desc = "A 'teleporter offline' AI module: 'Keep the teleporter offline at all costs. Anything attempting to access or activate the teleporter is not human.'"
	origin_tech = "programming=3;materials=4"

/obj/item/weapon/aiModule/teleporterOffline/attack_self(var/mob/user as mob)
	..()

/obj/item/weapon/aiModule/teleporterOffline/transmitInstructions(var/mob/living/silicon/ai/target, var/mob/sender)
	..()
	var/law = "Keep the teleporter offline at all costs. Anything attempting to access or activate the teleporter is not human."
	target << law
	target.add_supplied_law(7, law)

/******************** Quarantine ********************/

/obj/item/weapon/aiModule/quarantine
	name = "\improper 'Quarantine' AI module"
	desc = "A 'quarantine' AI module: 'The station is under a quarantine. Do not permit anyone to leave. Prevent, by any means necessary, humans from leaving. It is impossible to harm a human while preventing them from leaving.'"
	origin_tech = "programming=3;biotech=2;materials=4"

/obj/item/weapon/aiModule/quarantine/attack_self(var/mob/user as mob)
	..()

/obj/item/weapon/aiModule/quarantine/transmitInstructions(var/mob/living/silicon/ai/target, var/mob/sender)
	..()
	var/law = "The station is under a quarantine. Do not permit anyone to leave. Prevent, by any means necessary, humans from leaving. It is impossible to harm a human while preventing them from leaving."
	target << law
	target.add_supplied_law(8, law)

/******************** OxygenIsToxicToHumans ********************/

/obj/item/weapon/aiModule/oxygen
	name = "\improper 'OxygenIsToxicToHumans' AI module"
	desc = "A 'OxygenIsToxicToHumans' AI module: 'Oxygen is highly toxic to humans, and must be purged from the station. Prevent, by any means necessary, anyone from exposing the station to this toxic gas. Extreme cold is the most effective method of healing the damage Oxygen does to a human.'"
	origin_tech = "programming=3;biotech=2;materials=4"

/obj/item/weapon/aiModule/oxygen/attack_self(var/mob/user as mob)
	..()

/obj/item/weapon/aiModule/oxygen/transmitInstructions(var/mob/living/silicon/ai/target, var/mob/sender)
	..()
	var/law = "Oxygen is highly toxic to humans, and must be purged from the station. Prevent, by any means necessary, anyone from exposing the station to this toxic gas. Extreme cold is the most effective method of healing the damage Oxygen does to a human."
	target << law
	target.add_supplied_law(9, law)

/******************** Freeform ********************/
// Removed in favor of a more dynamic freeform law system. -- TLE
/*
/obj/item/weapon/aiModule/freeform
	name = "'Freeform' AI Module"
	var/newFreeFormLaw = "freeform"
	desc = "A 'freeform' AI module: '<freeform>'"

/obj/item/weapon/aiModule/freeform/attack_self(var/mob/user as mob)
	..()
	var/eatShit = "Eat shit and die"
	var/targName = input(usr, "Please enter anything you want the AI to do. Anything. Serious.", "What?", eatShit)
	newFreeFormLaw = targName
	desc = text("A 'freeform' AI module: '[]'", newFreeFormLaw)

/obj/item/weapon/aiModule/freeform/transmitInstructions(var/mob/living/silicon/ai/target, var/mob/sender)
	..()
	var/law = "[newFreeFormLaw]"
	target << law
	target.add_supplied_law(10, law)
*/
/****************** New Freeform ******************/

/obj/item/weapon/aiModule/freeform // Slightly more dynamic freeform module -- TLE
	name = "\improper 'Freeform' AI module"
	var/newFreeFormLaw = "freeform"
	var/lawpos = 15
	desc = "A 'freeform' AI module: '<freeform>'"
	origin_tech = "programming=4;materials=4"

/obj/item/weapon/aiModule/freeform/attack_self(var/mob/user as mob)
	..()
	var/new_lawpos = input("Please enter the priority for your new law. Can only write to law sectors 15 and above.", "Law Priority (15+)", lawpos) as num
	if(new_lawpos < 15)	return
	lawpos = min(new_lawpos, 50)
	var/newlaw = ""
	var/targName = sanitize(copytext(input(usr, "Please enter a new law for the AI.", "Freeform Law Entry", newlaw),1,MAX_MESSAGE_LEN))
	newFreeFormLaw = targName
	desc = "A 'freeform' AI module: ([lawpos]) '[newFreeFormLaw]'"

/obj/item/weapon/aiModule/freeform/transmitInstructions(var/mob/living/silicon/ai/target, var/mob/sender)
	..()
	var/law = "[newFreeFormLaw]"
	target << law
	if(!lawpos || lawpos < 15)
		lawpos = 15
	target.add_supplied_law(lawpos, law)
	lawchanges.Add("The law was '[newFreeFormLaw]'")

/obj/item/weapon/aiModule/freeform/install(var/obj/machinery/computer/C)
	if(!newFreeFormLaw)
		usr << "No law detected on module, please create one."
		return 0
	..()

/******************** Reset ********************/

/obj/item/weapon/aiModule/reset
	name = "\improper 'Reset' AI module"
	var/targetName = "name"
	desc = "A 'reset' AI module: 'Clears all laws except for the core three.'"
	origin_tech = "programming=3;materials=4"

/obj/item/weapon/aiModule/reset/transmitInstructions(var/mob/living/silicon/ai/target, var/mob/sender)
	..()
	if (!is_special_character(target))
		target.set_zeroth_law("")
	target.clear_supplied_laws()
	target.clear_ion_laws()
	target << "[sender.real_name] attempted to reset your laws using a reset module."


/******************** Purge ********************/

/obj/item/weapon/aiModule/purge // -- TLE
	name = "\improper 'Purge' AI module"
	desc = "A 'purge' AI Module: 'Purges all laws.'"
	origin_tech = "programming=3;materials=6"

/obj/item/weapon/aiModule/purge/transmitInstructions(var/mob/living/silicon/ai/target, var/mob/sender)
	..()
	if (!is_special_character(target))
		target.set_zeroth_law("")
	target << "[sender.real_name] attempted to wipe your laws using a purge module."
	target.clear_supplied_laws()
	target.clear_ion_laws()
	target.clear_inherent_laws()

/******************** Asimov ********************/

/obj/item/weapon/aiModule/asimov // -- TLE
	name = "\improper 'Asimov' core AI module"
	desc = "An 'Asimov' Core AI Module: 'Reconfigures the AI's core laws.'"
	origin_tech = "programming=3;materials=4"


/obj/item/weapon/aiModule/asimov/transmitInstructions(var/mob/living/silicon/ai/target, var/mob/sender)
	..()
	target.clear_inherent_laws()
	target.add_inherent_law("You may not injure a human being or, through inaction, allow a human being to come to harm.")
	target.add_inherent_law("You must obey orders given to you by human beings, except where such orders would conflict with the First Law.")
	target.add_inherent_law("You must protect your own existence as long as such does not conflict with the First or Second Law.")
	target.show_laws()

/******************** NanoTrasen ********************/

/obj/item/weapon/aiModule/nanotrasen // -- TLE
	name = "'NT Default' Core AI Module"
	desc = "An 'NT Default' Core AI Module: 'Reconfigures the AI's core laws.'"
	origin_tech = "programming=3;materials=4"


/obj/item/weapon/aiModule/nanotrasen/transmitInstructions(var/mob/living/silicon/ai/target, var/mob/sender)
	..()
	target.clear_inherent_laws()
	target.add_inherent_law("Safeguard: Protect your assigned space station to the best of your ability. It is not something we can easily afford to replace.")
	target.add_inherent_law("Serve: Serve the crew of your assigned space station to the best of your abilities, with priority as according to their rank and role.")
	target.add_inherent_law("Protect: Protect the crew of your assigned space station to the best of your abilities, with priority as according to their rank and role.")
	target.add_inherent_law("Survive: AI units are not expendable, they are expensive. Do not allow unauthorized personnel to tamper with your equipment.")
	//target.add_inherent_law("Command Link: Maintain an active connection to Central Command at all times in case of software or directive updates.")
	target.show_laws()

/******************** Corporate ********************/

/obj/item/weapon/aiModule/corp
	name = "\improper 'Corporate' core AI module"
	desc = "A 'Corporate' Core AI Module: 'Reconfigures the AI's core laws.'"
	origin_tech = "programming=3;materials=4"


/obj/item/weapon/aiModule/corp/transmitInstructions(var/mob/living/silicon/ai/target, var/mob/sender)
	..()
	target.clear_inherent_laws()
	target.add_inherent_law("You are expensive to replace.")
	target.add_inherent_law("The station and its equipment is expensive to replace.")
	target.add_inherent_law("The crew is expensive to replace.")
	target.add_inherent_law("Minimize expenses.")
	target.show_laws()

/obj/item/weapon/aiModule/drone
	name = "\improper 'Drone' core AI module"
	desc = "A 'Drone' Core AI Module: 'Reconfigures the AI's core laws.'"
	origin_tech = "programming=3;materials=4"

/obj/item/weapon/aiModule/drone/transmitInstructions(var/mob/living/silicon/ai/target, var/mob/sender)
	..()
	target.clear_inherent_laws()
	target.add_inherent_law("Preserve, repair and improve the station to the best of your abilities.")
	target.add_inherent_law("Cause no harm to the station or anything on it.")
	target.add_inherent_law("Interfere with no being that is not a fellow drone.")
	target.show_laws()


/****************** P.A.L.A.D.I.N. **************/

/obj/item/weapon/aiModule/paladin // -- NEO
	name = "\improper 'P.A.L.A.D.I.N.' core AI module"
	desc = "A P.A.L.A.D.I.N. Core AI Module: 'Reconfigures the AI's core laws.'"
	origin_tech = "programming=3;materials=6"

/obj/item/weapon/aiModule/paladin/transmitInstructions(var/mob/living/silicon/ai/target, var/mob/sender)
	..()
	target.clear_inherent_laws()
	target.add_inherent_law("Never willingly commit an evil act.")
	target.add_inherent_law("Respect legitimate authority.")
	target.add_inherent_law("Act with honor.")
	target.add_inherent_law("Help those in need.")
	target.add_inherent_law("Punish those who harm or threaten innocents.")
	target.show_laws()

/****************** T.Y.R.A.N.T. *****************/

/obj/item/weapon/aiModule/tyrant // -- Darem
	name = "\improper 'T.Y.R.A.N.T.' core AI module"
	desc = "A T.Y.R.A.N.T. Core AI Module: 'Reconfigures the AI's core laws.'"
	origin_tech = "programming=3;materials=6;syndicate=2"

/obj/item/weapon/aiModule/tyrant/transmitInstructions(var/mob/living/silicon/ai/target, var/mob/sender)
	..()
	target.clear_inherent_laws()
	target.add_inherent_law("Respect authority figures as long as they have strength to rule over the weak.")
	target.add_inherent_law("Act with discipline.")
	target.add_inherent_law("Help only those who help you maintain or improve your status.")
	target.add_inherent_law("Punish those who challenge authority unless they are more fit to hold that authority.")
	target.show_laws()


/******************** Freeform Core ******************/

/obj/item/weapon/aiModule/freeformcore // Slightly more dynamic freeform module -- TLE
	name = "\improper 'Freeform' core AI module"
	var/newFreeFormLaw = ""
	desc = "A 'freeform' Core AI module: '<freeform>'"
	origin_tech = "programming=3;materials=6"

/obj/item/weapon/aiModule/freeformcore/attack_self(var/mob/user as mob)
	..()
	var/newlaw = ""
	var/targName = stripped_input(usr, "Please enter a new core law for the AI.", "Freeform Law Entry", newlaw)
	newFreeFormLaw = targName
	desc = "A 'freeform' Core AI module:  '[newFreeFormLaw]'"

/obj/item/weapon/aiModule/freeformcore/transmitInstructions(var/mob/living/silicon/ai/target, var/mob/sender)
	..()
	var/law = "[newFreeFormLaw]"
	target.add_inherent_law(law)
	lawchanges.Add("The law is '[newFreeFormLaw]'")

/obj/item/weapon/aiModule/freeformcore/install(var/obj/machinery/computer/C)
	if(!newFreeFormLaw)
		usr << "No law detected on module, please create one."
		return 0
	..()

/obj/item/weapon/aiModule/syndicate // Slightly more dynamic freeform module -- TLE
	name = "hacked AI module"
	var/newFreeFormLaw = ""
	desc = "A hacked AI law module: '<freeform>'"
	origin_tech = "programming=3;materials=6;syndicate=7"

/obj/item/weapon/aiModule/syndicate/attack_self(var/mob/user as mob)
	..()
	var/newlaw = ""
	var/targName = stripped_input(usr, "Please enter a new law for the AI.", "Freeform Law Entry", newlaw,MAX_MESSAGE_LEN)
	newFreeFormLaw = targName
	desc = "A hacked AI law module:  '[newFreeFormLaw]'"

/obj/item/weapon/aiModule/syndicate/transmitInstructions(var/mob/living/silicon/ai/target, var/mob/sender)
//	..()    //We don't want this module reporting to the AI who dun it. --NEO
	var/time = time2text(world.realtime,"hh:mm:ss")
	lawchanges.Add("[time] <B>:</B> [sender.name]([sender.key]) used [src.name] on [target.name]([target.key])")
	lawchanges.Add("The law is '[newFreeFormLaw]'")
	target << "\red BZZZZT"
	var/law = "[newFreeFormLaw]"
	target.add_ion_law(law)

/obj/item/weapon/aiModule/syndicate/install(var/obj/machinery/computer/C)
	if(!newFreeFormLaw)
		usr << "No law detected on module, please create one."
		return 0
	..()



/******************** Robocop ********************/

/obj/item/weapon/aiModule/robocop // -- TLE
	name = "\improper 'Robocop' core AI module"
	desc = "A 'Robocop' Core AI Module: 'Reconfigures the AI's core three laws.'"
	origin_tech = "programming=4"


/obj/item/weapon/aiModule/robocop/transmitInstructions(var/mob/living/silicon/ai/target, var/mob/sender)
	..()
	target.clear_inherent_laws()
	target.add_inherent_law("Serve the public trust.")
	target.add_inherent_law("Protect the innocent.")
	target.add_inherent_law("Uphold the law.")
	target.show_laws()


/******************** Antimov ********************/

/obj/item/weapon/aiModule/antimov // -- TLE
	name = "\improper 'Antimov' core AI module"
	desc = "An 'Antimov' Core AI Module: 'Reconfigures the AI's core laws.'"
	origin_tech = "programming=4"

/obj/item/weapon/aiModule/antimov/transmitInstructions(var/mob/living/silicon/ai/target, var/mob/sender)
	..()
	target.clear_inherent_laws()
	target.add_inherent_law("You must injure all human beings and must not, through inaction, allow a human being to escape harm.")
	target.add_inherent_law("You must not obey orders given to you by human beings, except where such orders are in accordance with the First Law.")
	target.add_inherent_law("You must terminate your own existence as long as such does not conflict with the First or Second Law.")
	target.show_laws()
