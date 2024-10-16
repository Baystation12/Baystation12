/datum/power/changeling/electric_lockpick
	name = "Electric Lockpick"
	desc = "We discreetly evolve a finger to be able to send a small electric charge.  \
	We can open most electrical locks, but it will be obvious when we do so."
	helptext = "Use the ability, then touch something that utilizes an electrical locking system, to open it.  Each use costs 10 chemicals."
	ability_icon_state = "ling_electric_lockpick"
	genomecost = 3
	verbpath = /mob/proc/changeling_electric_lockpick

//Emag-lite
/mob/proc/changeling_electric_lockpick()
	set category = "Changeling"
	set name = "Electric Lockpick (5 + 10/use)"
	set desc = "Bruteforces open most electrical locking systems, at 10 chemicals per use."



	var/obj/held_item = get_active_hand()
	if (istype(held_item, /obj/item/weapon/finger_lockpick))
		//to_chat(src,SPAN_WARNING("We cease charging our hand with electricity"))
		//playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
		qdel(held_item)
		return 0
	var/datum/changeling/changeling = changeling_power(5,0,100,CONSCIOUS)
	if(!changeling)
		return FALSE

	if(!held_item)
		if(changeling_generic_weapon(/obj/item/weapon/finger_lockpick,0,5))  //Chemical cost is handled in the equip proc.
			return TRUE
		return FALSE

/obj/item/weapon/finger_lockpick
	name = "finger lockpick"
	desc = "This finger appears to be an organic datajack."
	icon = 'icons/obj/weapons/melee_energy.dmi'
	icon_state = "electric_lockpick"
	canremove = FALSE
/obj/item/weapon/finger_lockpick/Initialize()
	. = ..()
	if(ismob(loc))
		to_chat(loc, "<span class='notice'>We shape our finger to fit inside electronics, and are ready to force them open.</span>")
/obj/item/weapon/finger_lockpick/use_before(atom/target, mob/living/user, click_parameters)

	if(!target)
		return
	if(!target.Adjacent(user))
		return
	if(!user.mind.changeling)
		return

	var/datum/changeling/ling_datum = user.mind.changeling
	var/breach_secure = TRUE
	if(ling_datum.chem_charges < 10)
		to_chat(user, "<span class='warning'>We require at least 10 chem charges to do that.</span>")
		return

	//Airlocks require an ugly block of code, but we don't want to just call emag_act(), since we don't want to break airlocks forever.
	if(istype(target,/obj/machinery/door))
		if(istype(target,/obj/machinery/door/airlock/highsecurity) || istype(target,/obj/machinery/door/airlock/vault))
			to_chat(user, SPAN_WARNING("This door's security is complex. It will take us longer to determine the charge needed to breach it."))
			breach_secure = do_after(user, (15 SECONDS + rand(0, 5 SECONDS) + rand(0, 5 SECONDS)), target, do_flags = (DO_DEFAULT | DO_BOTH_UNIQUE_ACT) & ~DO_SHOW_PROGRESS)
		var/obj/machinery/door/door = target
		to_chat(user, "<span class='notice'>We send an electrical pulse up our finger, and into \the [target], attempting to open it.</span>")

		if(door.density && door.operable() && breach_secure)
			door.do_animate("spark")
			sleep(6)
			//More typechecks, because windoors can't be locked.  Fun.
			if(istype(target,/obj/machinery/door/airlock))

				var/obj/machinery/door/airlock/airlock = target

				if(airlock.locked) //Check if we're bolted.
					airlock.unlock()
					to_chat(user, "<span class='notice'>We've unlocked \the [airlock].  Another pulse is requried to open it.</span>")
				else	//We're not bolted, so open the door already.
					airlock.open()
					to_chat(user, "<span class='notice'>We've opened \the [airlock].</span>")
			else
				door.open() //If we're a windoor, open the windoor.
				to_chat(user, "<span class='notice'>We've opened \the [door].</span>")
		else //Probably broken or no power.
			to_chat(user, "<span class='warning'>The door does not respond to the pulse.</span>")
		door.add_fingerprint(user)
		log_and_message_admins("finger-lockpicked \an [door].")
		ling_datum.chem_charges -= 10
		return TRUE

	else if(istype(target,/obj/structure/closet/secure_closet)) //This should catch everything else we might miss, without a million typechecks.
		var/obj/O = target
		to_chat(user, "<span class='notice'>We send an electrical pulse up our finger, and into \the [O].</span>")
		O.add_fingerprint(user)
		O.emag_act(1,user,src)
		log_and_message_admins("finger-lockpicked \an [O].")
		ling_datum.chem_charges -= 10

		return TRUE
	return FALSE
