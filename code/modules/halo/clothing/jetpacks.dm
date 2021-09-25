
/obj/item/flight_item
	name = "Jetpack Item"
	desc = "A pack that jets. Allows you limited timeframe flight, as well as maintaining altitude, although it is not strong enough to allow in-atmosphere z-level changing."

	slot_flags = SLOT_BACK

	var/flight_ticks_max = 65
	var/flight_ticks_curr = 0
	var/takeoff_msg = "takes off!"
	var/land_msg = "lands"
	var/mob/living/cached_user
	var/active = FALSE
	var/flight_sound = 'code/modules/halo/sounds/jetpack_move.ogg'
	var/datum/progressbar/flight_bar

	slowdown_general = 0.1
	action_button_name = "Activate Jump-Jet"

/obj/item/flight_item/New()
	. = ..()
	flight_ticks_curr = flight_ticks_max

/obj/item/flight_item/proc/on_drop()
	if(istype(cached_user))
		if(cached_user.flight_item == src)
			cached_user.flight_item = null
			deactivate(cached_user,0)

/obj/item/flight_item/dropped()
	on_drop()
	. = ..()

/obj/item/flight_item/equipped()
	on_drop()
	. = ..()

/obj/item/flight_item/examine(var/examiner)
	. = ..()
	if(!active)
		to_chat(examiner,"<span class = 'notice'>It has [flight_ticks_curr] power units left.</span>")
	else
		to_chat(examiner,"<span class = 'notice'>It is currently in use and is draining power.[cached_user ? " [cached_user.flight_ticks_remain] power units remain" : "" ]</span>")

/obj/item/flight_item/update_icon()
	if(active)
		icon_state = "[initial(icon_state)]-active"
		item_state = "[initial(item_state)]-active"
	else
		icon_state = initial(icon_state)
		item_state = initial(item_state)
	. = ..()

/obj/item/flight_item/proc/activate(var/mob/living/user)
	if(!istype(user))
		return
	cached_user = user
	active = TRUE
	user.flight_ticks_remain = flight_ticks_curr
	user.flight_item = src
	user.take_flight(flight_ticks_curr,"<span class = 'warning'>[user.name][takeoff_msg]</span>","<span class = 'warning'>[user.name][land_msg]</span>")
	GLOB.processing_objects -= src
	update_icon()
	user.update_inv_back(1)
	if(!flight_bar)
		flight_bar = new(user,flight_ticks_max,src)

/obj/item/flight_item/proc/deactivate(var/mob/living/user,var/output_msg = 1)
	if(!istype(user))
		return
	active = FALSE
	cached_user = null
	flight_ticks_curr = user.flight_ticks_remain
	user.flight_item = null
	if(user.elevation > 0)
		user.take_flight(0,(output_msg ? "<span class = 'warning'>[user.name][takeoff_msg]</span>" : null),(output_msg ? "<span class = 'warning'>[user.name][land_msg]</span>" : null))
	GLOB.processing_objects += src
	update_icon()
	user.update_inv_back(1)

/obj/item/flight_item/ui_action_click()
	if(usr != loc)
		return
	var/mob/living/carbon/human/h = usr
	if(istype(h) && h.back != src)
		to_chat(h,"<span class = 'notice'>[src] needs to be on your back to be activated.</span>")
		return
	if(flight_ticks_curr == 0)
		to_chat(usr,"<span class = 'notice'>[src] needs to replenish itself...</span>")
		return
	if(active)
		deactivate(usr)
	else
		activate(usr)

/obj/item/flight_item/process()
	flight_ticks_curr = min(flight_ticks_max, flight_ticks_curr + flight_ticks_max /20)
	flight_bar.update(flight_ticks_curr)
	if(flight_ticks_curr == flight_ticks_max)
		GLOB.processing_objects -= src

/obj/item/flight_item/bullfrog_pack
	name = "\improper Series 8 Single Operator Lift Apparatus"
	desc = "Provides thrust capable of raising your altitude significantly, or maintaining an elevated altitude."
	icon = 'code/modules/halo/clothing/jetpack.dmi'
	icon_state = "bullfrog_item"
	item_state = "bullfrog"
	item_icons = list(
		slot_back_str = 'code/modules/halo/clothing/jetpack.dmi',
	)

	takeoff_msg = "\'s S8 SOLA roars as it lifts off the ground!"
	land_msg = "\'s S8 SOLA automatically packs up as it deactivates."

/obj/item/flight_item/covenant_pack
	name = "\improper Thruster Pack"
	desc = "Provides thrust capable of raising your altitude somewhat, or maintaining an elevated altitude."
	icon = 'code/modules/halo/clothing/jetpack.dmi'
	icon_state = "notbullfrog_item"
	item_state = "notbullfrog"
	item_icons = list(
		slot_back_str = 'code/modules/halo/clothing/jetpack.dmi',
	)

	takeoff_msg = "\'s thruster pack roars as it lifts off the ground!"
	land_msg = "\'s thruster pack automatically packs up as it deactivates."