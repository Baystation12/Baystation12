/obj/item/gun/launcher/money
	name = "money cannon"
	desc = "A blocky, plastic novelty launcher that claims to be able to shoot money at considerable velocities."
	icon_state = "money_launcher"
	item_state = "money_launcher"
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_SMALL
	release_force = 80
	fire_sound_text = "a whoosh and a crisp, papery rustle"
	fire_delay = 1
	fire_sound = 'sound/weapons/gunshot/money_launcher.ogg'
	var/emagged = FALSE
	var/max_capacity = 2000

	var/receptacle_value = 0
	var/dispensing = 20

/obj/item/gun/launcher/money/hacked
	emagged = TRUE

/obj/item/gun/launcher/money/proc/vomit_cash(mob/vomit_onto, projectile_vomit)
	var/bundle_worth = Floor(receptacle_value / 10)
	if(bundle_worth > max_capacity / 10)
		bundle_worth = max_capacity / 10
		log_warning("[src] has more than [max_capacity] currency loaded!")
	var/turf/T = get_turf(vomit_onto)
	for(var/i = 1 to 10)
		var/nv = bundle_worth
		if (i <= (receptacle_value - 10 * bundle_worth))
			nv++
		if (!nv)
			break
		var/obj/item/spacecash/bundle/bling = new(T)
		bling.worth = nv
		bling.update_icon()
		if(projectile_vomit)
			for(var/j = 1, j <= rand(2, 4), j++)
				step(bling, pick(GLOB.cardinal))

	if(projectile_vomit)
		vomit_onto.AdjustStunned(3)
		vomit_onto.AdjustWeakened(3)
		vomit_onto.visible_message(SPAN_DANGER("\The [vomit_onto] blasts themselves full in the face with \the [src]!"))
		playsound(T, "sound/weapons/gunshot/money_launcher_jackpot.ogg", 100, 1)
	else
		vomit_onto.visible_message(SPAN_DANGER("\The [vomit_onto] ejects a few [GLOB.using_map.local_currency_name] into their face."))
		playsound(T, 'sound/weapons/gunshot/money_launcher.ogg', 100, 1)

	receptacle_value = 0

/obj/item/gun/launcher/money/proc/make_it_rain(mob/user)
	vomit_cash(user, receptacle_value >= 10)

/obj/item/gun/launcher/money/update_release_force()
	if(!emagged)
		release_force = 0
		return

	// Must launch at least 100 thaler to incur damage.
	release_force = dispensing / 100

/obj/item/gun/launcher/money/proc/unload_receptacle(mob/user)
	if(receptacle_value < 1)
		to_chat(user, SPAN_WARNING("There's no money in [src]."))
		return

	var/obj/item/spacecash/bling = new /obj/item/spacecash/bundle()
	bling.worth = receptacle_value
	bling.update_icon()
	user.put_in_hands(bling)
	to_chat(user, SPAN_NOTICE("You eject [receptacle_value] [GLOB.using_map.local_currency_name_singular] from [src]'s receptacle."))
	receptacle_value = 0

/obj/item/gun/launcher/money/proc/absorb_cash(obj/item/spacecash/bling, mob/user)
	if(!istype(bling) || !bling.worth || bling.worth < 1)
		to_chat(user, SPAN_WARNING("[src] refuses to pick up [bling]."))
		return
	if(receptacle_value >= max_capacity)
		to_chat(user, SPAN_WARNING("There's no space in the receptacle for [bling]."))
		return
	else if (receptacle_value && receptacle_value + bling.worth >= max_capacity) //If we have enough money to fill it to capacity
		bling.worth -= max_capacity - receptacle_value
		receptacle_value = max_capacity
		to_chat(user, SPAN_NOTICE("You load [src] to capacity with [bling]."))
		if(!bling.worth)
			qdel(bling)
		else
			bling.update_icon()
		return
	receptacle_value += bling.worth
	to_chat(user, SPAN_NOTICE("You load [bling] into [src]."))
	qdel(bling)

/obj/item/gun/launcher/money/consume_next_projectile(mob/user=null)
	if(!receptacle_value || receptacle_value < 1)
		return null

	var/obj/item/spacecash/bling = new /obj/item/spacecash/bundle()
	if(receptacle_value >= dispensing)
		bling.worth = dispensing
		receptacle_value -= dispensing
	else
		bling.worth = receptacle_value
		receptacle_value = 0

	bling.update_icon()
	update_release_force(bling.worth)
	if(release_force >= 1)
		var/datum/effect/effect/system/spark_spread/s = new()
		s.set_up(3, 1, src)
		s.start()

	return bling

/obj/item/gun/launcher/money/attack_self(mob/user as mob)
	var/disp_amount = min(input(user, "How many [GLOB.using_map.local_currency_name_singular] do you want to dispense at a time? (0 to [src.receptacle_value])", "Money Cannon Settings", 20) as num, receptacle_value)

	if (disp_amount < 1)
		to_chat(user, SPAN_WARNING("You have to dispense at least one [GLOB.using_map.local_currency_name_singular] at a time!"))
		return

	src.dispensing = disp_amount
	to_chat(user, SPAN_NOTICE("You set [src] to dispense [dispensing] [GLOB.using_map.local_currency_name_singular] at a time."))

/obj/item/gun/launcher/money/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		unload_receptacle(user)
	else
		return ..()


/obj/item/gun/launcher/money/get_interactions_info()
	. = ..()
	.["Thalers"] = "<p>Loads the money into the launcher as ammo. The launcher can hold up to [initial(max_capacity)] thaler\s.</p>"


/obj/item/gun/launcher/money/use_tool(obj/item/tool, mob/user, list/click_params)
	// Thalers - Load ammo
	if (istype(tool, /obj/item/spacecash))
		var/obj/item/spacecash/thalers = tool
		if (receptacle_value >= max_capacity)
			to_chat(user, SPAN_WARNING("\The [src] can't hold anymore money."))
			return TRUE
		if (!user.canUnEquip(tool))
			to_chat(user, SPAN_WARNING("You can't drop \the [tool]."))
			return TRUE
		var/transfer_amount = min(max_capacity - receptacle_value, thalers.worth)
		thalers.worth -= transfer_amount
		if (thalers.worth <= 0)
			qdel(thalers)
		receptacle_value += transfer_amount
		user.visible_message(
			SPAN_NOTICE("\The [user] loads [thalers.name] into \the [src]."),
			SPAN_NOTICE("You load [thalers.name] into \the [src].")
		)
		return TRUE

	return ..()


/obj/item/gun/launcher/money/examine(mob/user)
	. = ..(user)
	to_chat(user, "It is configured to dispense [dispensing] [GLOB.using_map.local_currency_name_singular] at a time.")

	if(receptacle_value >= 1)
		to_chat(user, "The receptacle is loaded with [receptacle_value] [GLOB.using_map.local_currency_name_singular].")

	else
		to_chat(user, "The receptacle is empty.")

	if(emagged)
		to_chat(user, SPAN_NOTICE("Its motors are severely overloaded."))

/obj/item/gun/launcher/money/handle_suicide(mob/living/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/M = user
	M.visible_message(SPAN_DANGER("[user] sticks [src] in their mouth, ready to pull the trigger..."))

	if(!do_after(user, 4 SECONDS, do_flags = DO_DEFAULT | DO_USER_UNIQUE_ACT))
		M.visible_message(SPAN_NOTICE("[user] decided life was worth living."))
		return

	src.make_it_rain(user)

/obj/item/gun/launcher/money/emag_act(remaining_charges, mob/user)
	// Overloads the motors, causing it to shoot money harder and do harm.
	if(!emagged)
		emagged = TRUE
		to_chat(user, SPAN_NOTICE("You slide the sequencer into [src]... only for it to spit it back out and emit a motorized squeal!"))
		var/datum/effect/effect/system/spark_spread/s = new()
		s.set_up(3, 1, src)
		s.start()
	else
		to_chat(user, SPAN_NOTICE("[src] seems to have been tampered with already."))
