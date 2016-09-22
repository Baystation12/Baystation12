//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/device/mmi/digital/New()
	src.brainmob = new(src)
	src.brainmob.stat = CONSCIOUS
	src.brainmob.add_language("Robot Talk")
	src.brainmob.container = src
	src.brainmob.silent = 0
	PickName()
	..()

/obj/item/device/mmi/digital/proc/PickName()
	return

/obj/item/device/mmi/digital/attackby()
	return

/obj/item/device/mmi/digital/attack_self()
	return

/obj/item/device/mmi/digital/transfer_identity(var/mob/living/carbon/H)
	brainmob.dna = H.dna
	brainmob.timeofhostdeath = H.timeofdeath
	brainmob.stat = 0
	if(H.mind)
		H.mind.transfer_to(brainmob)
	return

/obj/item/device/mmi
	name = "man-machine interface"
	desc = "The MMI provides a machine interface to a brain while also supporting its life functions outside of a body."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "mmi_empty"
	w_class = 3
	origin_tech = list(TECH_BIO = 3)

	req_access = list(access_robotics)

	//Revised. Brainmob is now contained directly within object of transfer. MMI in this case.

	var/locked = 0
	var/mob/living/carbon/brain/brainmob = null//The current occupant.
	var/obj/item/organ/internal/brain/brainobj = null	//The current brain organ.
	var/obj/mecha = null//This does not appear to be used outside of reference in mecha.dm.
	var/obj/item/organ/internal/stack/loaded_stack = null // Used if config.use_cortical_stacks is on

/obj/item/device/mmi/examine(mob/user)
	..()
	if(config.use_cortical_stacks && !istype(src, /obj/item/device/mmi/digital)) // Yes, this is ugly
		if(loaded_stack)
			user << "There is \a [loaded_stack] in the neural lace slot."
		else
			user << "The neural lace slot is empty."

/obj/item/device/mmi/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O,/obj/item/organ/internal/brain) && !brainobj)

		var/obj/item/organ/internal/brain/B = O
		if(B.health <= 0)
			user << "<span class='warning'>That brain is well and truly dead.</span>"
			return
		else if(!config.use_cortical_stacks && !B.brainmob)
			user << "<span class='notice'>You aren't sure where this brain came from, but you're pretty sure it's a useless brain.</span>"
			return

		user.visible_message("<span class='notice'>\The [user] sticks \a [O] into \the [src].</span>")


		user.drop_item()
		brainobj = O
		brainobj.loc = src
		icon_state = "mmi_dead"  // brain in, but no sign of life
		
		activate_mind()
		
		return
		
	if(istype(O,/obj/item/organ/internal/stack) && !loaded_stack)
		loaded_stack = O
		user.drop_item()
		loaded_stack.forceMove(src)
		user.visible_message("<span class='notice'>\The [user] slots \a [O] into \the [src].</span>")
		
		activate_mind()
		
		return

	if((istype(O,/obj/item/weapon/card/id)||istype(O,/obj/item/device/pda)) && brainmob)
		if(allowed(user))
			locked = !locked
			user << "<span class='notice'>You [locked ? "lock" : "unlock"] \the [src].</span>"
		else
			user << "<span class='warning'>Access denied.</span>"
		return
	if(brainmob)
		O.attack(brainmob, user)//Oh noooeeeee
		return
	..()

	//TODO: ORGAN REMOVAL UPDATE. Make the brain remain in the MMI so it doesn't lose organ data.
/obj/item/device/mmi/attack_self(mob/user as mob)
	if(!brainobj && !loaded_stack)
		user << "<span class='warning'>The MMI is empty.</span>"
	else if(locked)
		user << "<span class='warning'>The MMI is locked. You will not be able to remove anything.</span>"
	else
		var/list/removables = list()
		if(loaded_stack)
			removables.Add("lace")
		if(brainobj)
			removables.Add("brain")
			
		var/to_remove = input(user, "What do you wish to remove?") as null|anything in removables
		
		if(!to_remove || !(user.l_hand == src || user.r_hand == src))
			return 0
		
		if(to_remove == "brain")
			// prompt can be long-lived, so we need to recheck brain is still there
			if(!brainobj)
				return 0

			deactivate_mind()
			brainobj.forceMove(user.loc)
			
			user.visible_message("<span class='notice'>\The [user] upends \the [src], spilling \the [brainobj] onto the floor.</span>", \
				"<span class='notice'>You upend \the [src], spilling \the [brainobj] onto the floor.</span>", \
				"You hear a squishy thud.")

			brainobj = null
			icon_state = "mmi_empty"
			
			return 1
		
		if(to_remove == "lace")
			if(!loaded_stack)
				return 0
				
			deactivate_mind()
			user.put_in_hands(loaded_stack)
			
			user.visible_message("<span class='notice'>\The [user] removes \the [loaded_stack] from \the [src]</span>", \
				"<span class='notice'>You remove \the [loaded_stack] from \the [src]</span>")
				
			loaded_stack = null
			
			return 1
/**
 *  Transfer the identity of a carbon/human directly to the MMI
 *
 *  This proc is chiefly useful for round start or admin robotizing of human mobs.
 *  The human's actual brain is not involved.
 */
/obj/item/device/mmi/proc/transfer_identity(var/mob/living/carbon/human/H)
	brainmob = new(src)
	brainmob.name = H.real_name
	brainmob.real_name = H.real_name
	brainmob.dna = H.dna
	brainmob.container = src
	
	// These aren't used by MMIs, but will be used if we put the mob elsewhere
	brainmob.languages = H.languages.Copy()
	brainmob.default_language = H.default_language
	
	brainobj = new(src)
	
	if(config.use_cortical_stacks)
		loaded_stack = new(src)
		// won't pass the attach_organ surgery step without being CUT_AWAY
		loaded_stack.status |= ORGAN_CUT_AWAY  
		backup_to_stack()

	name = "man-machine Interface: [brainmob.real_name]"
	icon_state = "mmi_full"
	locked = 1
	return

	
/**
 *  Move the appropriate mind into the MMI proper
 *
 *  This checks for config.use_cortical_stacks, and moves a player either from
 *  the loaded brain, or from the stack into the MMI. Returns 1 on success. 
 */
/obj/item/device/mmi/proc/activate_mind()
	if(brainmob)
		return 0
	
	if(config.use_cortical_stacks && brainobj && loaded_stack && !loaded_stack.backup_inviable(brainmob))
		var/mob/asked_mob = find_dead_player(loaded_stack.ownerckey, 1)
		if(!asked_mob)
			return 0
			
		var/asked_stack = loaded_stack
		
		var/response = input(asked_mob, "Your neural backup is being loaded into an MMI. Do you wish to return to life?", "Resleeving") as anything in list("Yes", "No")
		
		// prompt can be long-lived, so we check that the stack is still there
		if(response == "No" || asked_stack != loaded_stack || !brainobj)
			return 0
		
		brainmob = new(src)
		brainmob.container = src
		brainmob.stat = 0
		
		loaded_stack.backup.active = 1
		loaded_stack.backup.transfer_to(brainmob)
		if(loaded_stack.default_language)
			brainmob.default_language = loaded_stack.default_language
		brainmob.languages = loaded_stack.languages.Copy()
		brainmob.name = loaded_stack.backup.name
		brainmob.real_name = brainmob.name
		
		if(brainobj.brainmob)
			// Active MMIs shouldn't have occupied brains. With stacks, we don't
			// move the brain's occupant, so instead we just get rid of them. 
			// If they were to come back, they'd have to use a stack anyway
			brainobj.brainmob.ghostize(0)
			brainobj.brainmob = null
			
		
		feedback_inc("cyborg_mmis_filled",1)
		brainmob << "<span class='notice'>Consciousness creeps over you, with the MMI reporting a successful transfer.</span>"
		
		locked = 1
		icon_state = "mmi_full"
		name = "man-machine interface: [brainmob.real_name]"
		
		return 1
			
	else if(!config.use_cortical_stacks && brainobj && brainobj.brainmob)
		brainmob = brainobj.brainmob
		brainobj.brainmob = null
		
		brainmob.forceMove(src)
		brainmob.container = src
		brainmob.stat = 0
		brainmob.switch_from_dead_to_living_mob_list() //Update dem lists
		
		feedback_inc("cyborg_mmis_filled",1)
		brainmob << "<span class='notice'>You regain consciosuness and find yourself inside an MMI.</span>"
		
		icon_state = "mmi_full"
		name = "man-machine interface: [brainmob.real_name]"
		locked = 1
		
		return 1
	
/**
 *  Transfer mind out from the MMI to the appropriate places
 * 
 *  This backups the mind to the onboard stack if needed, and then transfers it
 *  to the onboard brain, allowing either to be ejected. 
 */
/obj/item/device/mmi/proc/deactivate_mind()

	if(!brainmob)
		return 

	if(config.use_cortical_stacks)
		backup_to_stack()
		loaded_stack.backup.active = 0

	// the ghost always resides in the brain, even if the stack is how we bring people back
	brainmob.forceMove(brainobj)
	brainmob.container = null
	brainobj.brainmob = brainmob
		
	brainmob.death()
	
	brainmob = null
	
	icon_state = "mmi_dead"
	name = "man-machine interface"
	
	
/**
 *  Perform a backup to the onboard stack
 * 
 *  This is essentially an MMI version of the stack backup the stack organ does
 *  on organics.
 */
/obj/item/device/mmi/proc/backup_to_stack()
	if(!loaded_stack)
		return
	
	loaded_stack.backup = brainmob.mind
	loaded_stack.languages = brainmob.languages.Copy()
	loaded_stack.default_language = brainmob.default_language
	if(brainmob.ckey)
		loaded_stack.ownerckey = brainmob.ckey
		
	
/obj/item/device/mmi/relaymove(var/mob/user, var/direction)
	if(user.stat || user.stunned)
		return
	var/obj/item/weapon/rig/rig = src.get_rig()
	if(rig)
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
	desc = "The MMI provides a machine interface to a brain while also supporting its life functions outside of a body. This one comes with a built-in radio."
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
			brainmob << "<span class='notice'>Radio is [radio.broadcasting==1 ? "now" : "no longer"] broadcasting.</span>"

		Toggle_Listening()
			set name = "Toggle Listening"
			set desc = "Toggle listening channel on or off."
			set category = "MMI"
			set src = usr.loc
			set popup_menu = 0

			if(brainmob.stat)
				brainmob << "Can't do that while incapacitated or dead."

			radio.listening = radio.listening==1 ? 0 : 1
			brainmob << "<span class='notice'>Radio is [radio.listening==1 ? "now" : "no longer"] receiving broadcast.</span>"

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
