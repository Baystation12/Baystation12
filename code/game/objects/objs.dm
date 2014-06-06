/obj
	//var/datum/module/mod		//not used
	var/m_amt = 0	// metal
	var/g_amt = 0	// glass
	var/w_amt = 0	// waster amounts
	var/origin_tech = null	//Used by R&D to determine what research bonuses it grants.
	var/reliability = 100	//Used by SOME devices to determine how reliable they are.
	var/crit_fail = 0
	var/unacidable = 0 //universal "unacidabliness" var, here so you can use it in any obj.
	animate_movement = 2
	var/throwforce = 1
	var/list/attack_verb = list() //Used in attackby() to say how something was attacked "[x] has been [z.attack_verb] by [y] with [z]"
	var/sharp = 0 // whether this object cuts
	var/in_use = 0 // If we have a user using us, this will be set on. We will check if the user has stopped using us, and thus stop updating and LAGGING EVERYTHING!
	var/list/mob/_using = list() // All mobs dicking with us.

	var/damtype = "brute"
	var/force = 0

	// What reagents should be logged when transferred TO this object?
	// Reagent ID => friendly name
	var/list/reagents_to_log=list()

/obj/Destroy()
	machines -= src
	processing_objects -= src
	..()
/obj/item/proc/is_used_on(obj/O, mob/user)

/obj/proc/process()
	processing_objects.Remove(src)
	return 0

/obj/assume_air(datum/gas_mixture/giver)
	if(loc)
		return loc.assume_air(giver)
	else
		return null

/obj/remove_air(amount)
	if(loc)
		return loc.remove_air(amount)
	else
		return null

/obj/return_air()
	if(loc)
		return loc.return_air()
	else
		return null

/obj/proc/handle_internal_lifeform(mob/lifeform_inside_me, breath_request)
	//Return: (NONSTANDARD)
	//		null if object handles breathing logic for lifeform
	//		datum/air_group to tell lifeform to process using that breath return
	//DEFAULT: Take air from turf to give to have mob process
	if(breath_request>0)
		return remove_air(breath_request)
	else
		return null

/atom/movable/proc/initialize()
	return

/obj/proc/updateUsrDialog()
	if(in_use)
		var/is_in_use = 0
		if(_using.len)
			var/list/nearby = viewers(1, src)
			for(var/mob/M in _using.Copy()) // Only check things actually messing with us.
				if (!M || !M.client || M.machine != src)
					_using.Remove(M)
					continue

				if(!M in nearby) // NOT NEARBY
					// AIs/Robots can do shit from afar.
					if (isAI(M) || isrobot(M))
						is_in_use = 1
						src.attack_ai(M)

					// check for TK users
					else if (ishuman(M))
						if(istype(M.l_hand, /obj/item/tk_grab) || istype(M.r_hand, /obj/item/tk_grab))
							is_in_use = 1
							src.attack_hand(M)
					else
						// Remove.
						_using.Remove(M)
						continue
				else // EVERYTHING FROM HERE DOWN MUST BE NEARBY
					is_in_use = 1
					attack_hand(M)
		in_use = is_in_use

/obj/proc/updateDialog()
	// Check that people are actually using the machine. If not, don't update anymore.
	if(in_use)
		var/list/nearby = viewers(1, src)
		var/is_in_use = 0
		for(var/mob/M in _using.Copy()) // Only check things actually messing with us.
			// Not actually using the fucking thing?
			if (!M || !M.client || M.machine != src)
				_using.Remove(M)
				continue
			// Not robot or AI, and not nearby?
			if(!isAI(M) && !isrobot(M) && !(M in nearby))
				_using.Remove(M)
				continue
			is_in_use = 1
			src.interact(M)
		in_use = is_in_use

/obj/proc/interact(mob/user)
	return

/obj/proc/update_icon()
	return

/mob/proc/unset_machine()
	if(machine && istype(machine, /obj/machinery))
		machine._using -= src
		machine = null

/mob/proc/set_machine(var/obj/O)
	if(src.machine)
		unset_machine()
	src.machine = O
	if(istype(O))
		O.in_use = 1
		O._using += src

/obj/item/proc/updateSelfDialog()
	var/mob/M = src.loc
	if(istype(M) && M.client && M.machine == src)
		src.attack_self(M)


/obj/proc/alter_health()
	return 1

/obj/proc/hide(h)
	return


/obj/proc/hear_talk(mob/M as mob, text)
/*
	var/mob/mo = locate(/mob) in src
	if(mo)
		var/rendered = "<span class='game say'><span class='name'>[M.name]: </span> <span class='message'>[text]</span></span>"
		mo.show_message(rendered, 2)
		*/
	return
