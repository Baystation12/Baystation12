//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/device/mmi/digital/New()
	src.brainmob = new(src)
	src.brainmob.add_language("Robot Talk")
	src.brainmob.loc = src
	src.brainmob.container = src
	src.brainmob.stat = 0
	src.brainmob.silent = 0
	dead_mob_list -= src.brainmob

/obj/item/device/mmi/digital/transfer_identity(var/mob/living/carbon/H)
	brainmob.dna = H.dna
	brainmob.timeofhostdeath = H.timeofdeath
	brainmob.stat = 0
	if(H.mind)
		H.mind.transfer_to(brainmob)
	return

/obj/item/device/mmi
	name = "man-machine interface"
	desc = "The Warrior's bland acronym, MMI, obscures the true horror of this monstrosity."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "mmi_empty"
	w_class = 3
	origin_tech = list(TECH_BIO = 3)

	var/list/construction_cost = list(DEFAULT_WALL_MATERIAL=1000,"glass"=500)
	var/construction_time = 75
	//these vars are so the mecha fabricator doesn't shit itself anymore. --NEO

	req_access = list(access_robotics)

	//Revised. Brainmob is now contained directly within object of transfer. MMI in this case.

	var/locked = 0
	var/mob/living/carbon/brain/brainmob = null//The current occupant.
	var/obj/item/organ/brain/brainobj = null	//The current brain organ.
	var/obj/mecha = null//This does not appear to be used outside of reference in mecha.dm.

	attackby(var/obj/item/O as obj, var/mob/user as mob)
		if(istype(O,/obj/item/organ/brain) && !brainmob) //Time to stick a brain in it --NEO

			var/obj/item/organ/brain/B = O
			if(B.health <= 0)
				user << "\red That brain is well and truly dead."
				return
			else if(!B.brainmob)
				user << "\red You aren't sure where this brain came from, but you're pretty sure it's a useless brain."
				return

			for(var/mob/V in viewers(src, null))
				V.show_message(text("\blue [user] sticks \a [O] into \the [src]."))

			brainmob = O:brainmob
			O:brainmob = null
			brainmob.loc = src
			brainmob.container = src
			brainmob.stat = 0
			dead_mob_list -= brainmob//Update dem lists
			living_mob_list += brainmob

			user.drop_item()
			brainobj = O
			brainobj.loc = src

			name = "Man-Machine Interface: [brainmob.real_name]"
			icon_state = "mmi_full"

			locked = 1

			feedback_inc("cyborg_mmis_filled",1)

			return

		if((istype(O,/obj/item/weapon/card/id)||istype(O,/obj/item/device/pda)) && brainmob)
			if(allowed(user))
				locked = !locked
				user << "\blue You [locked ? "lock" : "unlock"] the brain holder."
			else
				user << "\red Access denied."
			return
		if(brainmob)
			O.attack(brainmob, user)//Oh noooeeeee
			return
		..()

	//TODO: ORGAN REMOVAL UPDATE. Make the brain remain in the MMI so it doesn't lose organ data.
	attack_self(mob/user as mob)
		if(!brainmob)
			user << "\red You upend the MMI, but there's nothing in it."
		else if(locked)
			user << "\red You upend the MMI, but the brain is clamped into place."
		else
			user << "\blue You upend the MMI, spilling the brain onto the floor."
			var/obj/item/organ/brain/brain
			if (brainobj)	//Pull brain organ out of MMI.
				brainobj.loc = user.loc
				brain = brainobj
				brainobj = null
			else	//Or make a new one if empty.
				brain = new(user.loc)
			brainmob.container = null//Reset brainmob mmi var.
			brainmob.loc = brain//Throw mob into brain.
			living_mob_list -= brainmob//Get outta here
			brain.brainmob = brainmob//Set the brain to use the brainmob
			brainmob = null//Set mmi brainmob var to null

			icon_state = "mmi_empty"
			name = "Man-Machine Interface"

	proc
		transfer_identity(var/mob/living/carbon/human/H)//Same deal as the regular brain proc. Used for human-->robot people.
			brainmob = new(src)
			brainmob.name = H.real_name
			brainmob.real_name = H.real_name
			brainmob.dna = H.dna
			brainmob.container = src

			name = "Man-Machine Interface: [brainmob.real_name]"
			icon_state = "mmi_full"
			locked = 1
			return

/obj/item/device/mmi/relaymove(var/mob/user, var/direction)
	if(user.stat || user.stunned)
		return
	var/obj/item/weapon/rig/rig = src.get_rig()
	if(istype(rig))
		rig.forced_move(direction, user)

/obj/item/device/mmi/Destroy()
	if(isrobot(loc))
		var/mob/living/silicon/robot/borg = loc
		borg.mmi = null
	if(brainmob)
		qdel(brainmob)
		brainmob = null
	..()

/obj/item/device/mmi/radio_enabled
	name = "radio-enabled man-machine interface"
	desc = "The Warrior's bland acronym, MMI, obscures the true horror of this monstrosity. This one comes with a built-in radio."
	origin_tech = list(TECH_BIO = 4)

	var/obj/item/device/radio/radio = null//Let's give it a radio.

	New()
		..()
		radio = new(src)//Spawns a radio inside the MMI.
		radio.broadcasting = 1//So it's broadcasting from the start.

	verb//Allows the brain to toggle the radio functions.
		Toggle_Broadcasting()
			set name = "Toggle Broadcasting"
			set desc = "Toggle broadcasting channel on or off."
			set category = "MMI"
			set src = usr.loc//In user location, or in MMI in this case.
			set popup_menu = 0//Will not appear when right clicking.

			if(brainmob.stat)//Only the brainmob will trigger these so no further check is necessary.
				brainmob << "Can't do that while incapacitated or dead."

			radio.broadcasting = radio.broadcasting==1 ? 0 : 1
			brainmob << "\blue Radio is [radio.broadcasting==1 ? "now" : "no longer"] broadcasting."

		Toggle_Listening()
			set name = "Toggle Listening"
			set desc = "Toggle listening channel on or off."
			set category = "MMI"
			set src = usr.loc
			set popup_menu = 0

			if(brainmob.stat)
				brainmob << "Can't do that while incapacitated or dead."

			radio.listening = radio.listening==1 ? 0 : 1
			brainmob << "\blue Radio is [radio.listening==1 ? "now" : "no longer"] receiving broadcast."

/obj/item/device/mmi/emp_act(severity)
	if(!brainmob)
		return
	else
		switch(severity)
			if(1)
				brainmob.emp_damage += rand(20,30)
			if(2)
				brainmob.emp_damage += rand(10,20)
			if(3)
				brainmob.emp_damage += rand(0,10)
	..()
