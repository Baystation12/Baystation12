/obj/item/flamethrower
	name = "flamethrower"
	desc = "You are a firestarter!"
	icon = 'icons/obj/flamethrower.dmi'
	icon_state = "flamethrowerbase"
	item_state = "flamethrower_0"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = 3.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_LARGE
	origin_tech = list(TECH_COMBAT = 1)
	matter = list(MATERIAL_STEEL = 500)
	var/complete = FALSE
	var/status = 0
	var/lit = 0	//on or off
	var/operating = 0//cooldown
	var/turf/previousturf = null
	var/obj/item/weldingtool/weldtool = null
	var/obj/item/device/assembly/igniter/igniter = null
	var/obj/item/reagent_containers/beaker = null
	var/range = 4
	var/max_beaker = ITEM_SIZE_SMALL

/obj/item/flamethrower/Destroy()
	QDEL_NULL(weldtool)
	QDEL_NULL(igniter)
	QDEL_NULL(beaker)
	. = ..()

/obj/item/flamethrower/Process()
	if(!lit)
		STOP_PROCESSING(SSobj, src)
		return null
	var/turf/location = loc
	if(ismob(location))
		var/mob/M = location
		if(M.l_hand == src || M.r_hand == src)
			location = M.loc
	if(isturf(location)) //start a fire if possible
		location.hotspot_expose(700, 2)
	return


/obj/item/flamethrower/on_update_icon()
	overlays.Cut()
	if(igniter)
		overlays += "+igniter[status]"
	if(beaker)
		overlays += "+ptank"
	if(lit)
		overlays += "+lit"
		item_state = "flamethrower_1"
	else
		item_state = "flamethrower_0"
	return

/obj/item/flamethrower/afterattack(atom/target, mob/user, proximity)
	// Make sure our user is still holding us
	if(user.a_intent == I_HELP) //don't shoot if we're on help intent
		to_chat(user, SPAN_WARNING("You refrain from firing \the [src] as your intent is set to help."))
		return
	var/turf/target_turf = get_turf(target)
	if(target_turf)
		var/turflist = getline(user, target_turf)
		flame_turf(turflist)

/obj/item/flamethrower/attack_hand(mob/user)
	if(user.get_inactive_hand() == src)
		if(beaker && CanPhysicallyInteract(user))
			user.put_in_hands(beaker)
			beaker = null
			to_chat(user, SPAN_NOTICE("You remove the fuel container from [src]!"))
			update_icon()
	else
		return ..()

/obj/item/flamethrower/attackby(obj/item/W as obj, mob/user as mob)
	if(user.stat || user.restrained() || user.lying)	return
	if(isWrench(W) && !status && !complete)//Taking this apart
		if(weldtool)
			weldtool.dropInto(loc)
			weldtool = null
		if(igniter)
			igniter.dropInto(loc)
			igniter = null
		if(beaker)
			beaker.dropInto(loc)
			beaker = null
		new /obj/item/stack/material/rods(get_turf(src))
		qdel(src)
		return

	if(isScrewdriver(W) && igniter && !lit && !complete)
		status = !status
		to_chat(user, SPAN_NOTICE("\The [igniter] is now [status ? "secured" : "unsecured"]!"))
		update_icon()
		return

	if(isigniter(W))
		var/obj/item/device/assembly/igniter/I = W
		if(I.secured)	return
		if(igniter)		return
		if(!user.unEquip(I, src))
			return
		igniter = I
		update_icon()
		return

	if (istype(W, /obj/item/reagent_containers) && W.is_open_container() && (W.w_class <= max_beaker))
		if(user.unEquip(W, src))
			if(beaker)
				beaker.forceMove(get_turf(src))
				to_chat(user, SPAN_NOTICE("You swap the fuel container in [src]!"))
			beaker = W
			update_icon()
		return

	..()
	return


/obj/item/flamethrower/attack_self(mob/user as mob)
	toggle_igniter(user)

/obj/item/flamethrower/proc/toggle_igniter(mob/user)
	if(!beaker)
		to_chat(user, SPAN_NOTICE("Attach a fuel container first!"))
		return
	if(!status)
		to_chat(user,SPAN_NOTICE("Secure the igniter first!"))
		return
	to_chat(user, SPAN_NOTICE("You [lit ? "extinguish" : "ignite"] [src]!"))
	lit = !lit
	if(lit)
		playsound(loc, 'sound/items/welderactivate.ogg', 50, TRUE)
		START_PROCESSING(SSobj, src)
	else
		playsound(loc, 'sound/items/welderdeactivate.ogg', 50, TRUE)
		STOP_PROCESSING(SSobj,src)
	if(lit)
		set_light(0.7, 1, 2.5, l_color = COLOR_ORANGE)
	else
		set_light(0)

	update_icon()

#define REQUIRED_POWER_TO_FIRE_FLAMETHROWER 10
#define FLAMETHROWER_POWER_MULTIPLIER 1.5
#define FLAMETHROWER_RELEASE_AMOUNT 5

/obj/item/flamethrower/proc/flame_turf(list/turflist)
	if(!beaker)
		return
	if(!lit || operating)	return

	var/length = LAZYLEN(turflist)
	if(length < 1)
		return
	turflist.len = min(length, range)

	var/power = 0
	var/datum/reagents/beaker_reagents = beaker.reagents
	var/datum/reagents/my_fraction = new(beaker_reagents.maximum_volume, src)
	beaker_reagents.trans_to_holder(my_fraction, FLAMETHROWER_RELEASE_AMOUNT * turflist.len, safety = TRUE)
	var/fire_colour = null
	var/highest_amount = 0
	for(var/datum/reagent/R in beaker_reagents.reagent_list)
		power += R.accelerant_quality * FLAMETHROWER_POWER_MULTIPLIER //Flamethrowers inflate flammability compared to a pool of fuel
		if(R.volume > highest_amount && R.accelerant_quality > 0)
			highest_amount = R.volume
			fire_colour = R.fire_colour

	if(power < REQUIRED_POWER_TO_FIRE_FLAMETHROWER)
		audible_message(SPAN_DANGER("The [src] sputters."))
		playsound(src, 'sound/weapons/guns/flamethrower_empty.ogg', 50, TRUE, -3)
		return
	playsound(src, pick('sound/weapons/guns/flamethrower1.ogg','sound/weapons/guns/flamethrower2.ogg','sound/weapons/guns/flamethrower3.ogg' ), 50, TRUE, -3)

	operating = TRUE //anti-spam tool, is unset when the flame projectile goes away
	for(var/turf/T in turflist)
		if(T.density || istype(T, /turf/space))
			break
		if(!previousturf && length(turflist)>1)
			previousturf = get_turf(src)
			continue	//so we don't burn the tile we be standin on
		if(previousturf && (!T.CanPass(null, previousturf, 0,0) || !previousturf.CanPass(null, T, 0,0)))
			break
		previousturf = T

		//Consume part of our fuel to create a fire spot
		T.IgniteTurf(power / turflist.len, fire_colour)
		T.hotspot_expose((power*3) + 380,500)
		my_fraction.remove_any(FLAMETHROWER_RELEASE_AMOUNT)
		sleep(1)
	previousturf = null
	operating = FALSE
	if(beaker) //In the event we earlied out that means some fuel goes back into tank
		if(my_fraction.total_volume > 0)
			my_fraction.trans_to_holder(beaker_reagents, my_fraction.total_volume, safety = TRUE)
	QDEL_NULL(my_fraction)

#undef REQUIRED_POWER_TO_FIRE_FLAMETHROWER
#undef FLAMETHROWER_POWER_MULTIPLIER

/obj/item/flamethrower/full
	icon = 'icons/obj/flamethrower_new.dmi'
	item_state = "prebuilt_flamethrower_0"
	complete = TRUE

	item_icons = list(
		slot_l_hand_str = 'icons/obj/flamethrower_new.dmi',
		slot_r_hand_str = 'icons/obj/flamethrower_new.dmi',
		)

	item_state_slots = list(
		slot_l_hand_str = "humanoid body-slot_l_hand_0",
		slot_r_hand_str = "humanoid body-slot_r_hand_0",
		)

/obj/item/flamethrower/full/on_update_icon()
	. = ..()
	item_state_slots[slot_l_hand_str] = "humanoid body-slot_l_hand_[lit]"
	item_state_slots[slot_r_hand_str] = "humanoid body-slot_r_hand_[lit]"

/obj/item/flamethrower/full/Initialize()
	. = ..()
	weldtool = new /obj/item/weldingtool(src)
	weldtool.status = 0
	igniter = new /obj/item/device/assembly/igniter(src)
	igniter.secured = 0
	status = 1
	update_icon()

/obj/item/flamethrower/full/loaded/Initialize()
	beaker = new /obj/item/reagent_containers/glass/beaker/insulated/large(src)
	beaker.reagents.add_reagent(/datum/reagent/napalm, 120)
	. = ..()
