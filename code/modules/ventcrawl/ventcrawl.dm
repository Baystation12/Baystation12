var/global/list/ventcrawl_machinery = list(
	/obj/machinery/atmospherics/unary/vent_scrubber,
	/obj/machinery/atmospherics/unary/vent_pump
	)

// Vent crawling whitelisted items, whoo
/mob/living/var/list/can_enter_vent_with = list(
	/obj/item/implant,
	/obj/item/device/radio/borg,
	/obj/item/holder,
	/obj/machinery/camera,
	/mob/living/simple_animal/borer,
	/obj/item/clothing/head/culthood,
	/obj/item/clothing/suit/cultrobes,
	/obj/item/book/tome,
	/obj/item/paper,
	/obj/item/melee/cultblade
	)

/mob/living/var/list/icon/pipes_shown = list()
/mob/living/var/last_played_vent
/mob/living/var/is_ventcrawling = 0
/mob/var/next_play_vent = 0

/mob/living/proc/can_ventcrawl()
	if(!client)
		return FALSE
	if(!(/mob/living/proc/ventcrawl in verbs))
		to_chat(src, SPAN_WARNING("You don't possess the ability to ventcrawl!"))
		return FALSE
	if(incapacitated())
		to_chat(src, SPAN_WARNING("You cannot ventcrawl in your current state!"))
		return FALSE
	return ventcrawl_carry()

/mob/living/Login()
	. = ..()
	//login during ventcrawl
	if(is_ventcrawling && istype(loc, /obj/machinery/atmospherics)) //attach us back into the pipes
		remove_ventcrawl()
		add_ventcrawl(loc)

/mob/living/carbon/slime/can_ventcrawl()
	if(Victim)
		to_chat(src, SPAN_WARNING("You cannot ventcrawl while feeding."))
		return FALSE
	. = ..()

/mob/living/proc/is_allowed_vent_crawl_item(obj/item/carried_item)
	if(is_type_in_list(carried_item, can_enter_vent_with))
		return !get_inventory_slot(carried_item)

/mob/living/carbon/is_allowed_vent_crawl_item(obj/item/carried_item)
	return (carried_item in internal_organs) || ..()

/mob/living/carbon/human/is_allowed_vent_crawl_item(obj/item/carried_item)
	var/obj/item/organ/internal/stomach/stomach = internal_organs_by_name[BP_STOMACH]
	if(stomach && (carried_item in stomach.contents))
		return TRUE
	if(carried_item in organs)
		return TRUE
	if(carried_item in list(w_uniform, gloves, glasses, wear_mask, l_ear, r_ear, belt, l_store, r_store))
		return TRUE
	if (IsHolding(carried_item))
		return carried_item.w_class <= ITEM_SIZE_NORMAL
	return ..()

/mob/living/simple_animal/is_allowed_vent_crawl_item(obj/item/carried_item)
	if(get_natural_weapon() == carried_item)
		return TRUE
	return ..()

/mob/living/proc/ventcrawl_carry()
	for(var/atom/A in contents)
		if(!is_allowed_vent_crawl_item(A))
			to_chat(src, SPAN_WARNING("You can't carry \the [A] while ventcrawling!"))
			return FALSE
	return TRUE

/mob/living/AltClickOn(atom/A)
	if(is_type_in_list(A,ventcrawl_machinery))
		handle_ventcrawl(A)
		return 1
	return ..()

/mob/proc/start_ventcrawl()
	var/atom/pipe
	var/list/pipes = list()
	for(var/obj/machinery/atmospherics/unary/U in range(1))
		if(is_type_in_list(U,ventcrawl_machinery) && Adjacent(U) && U.can_crawl_through())
			pipes |= U
	if(!pipes || !length(pipes))
		to_chat(src, "There are no pipes that you can ventcrawl into within range!")
		return
	if(length(pipes) == 1)
		pipe = pipes[1]
	else
		pipe = input("Crawl Through Vent", "Pick a pipe") as null|anything in pipes
	if(!is_physically_disabled() && pipe)
		return pipe

/mob/living/carbon/alien/ventcrawl_carry()
	return 1

/mob/living/proc/handle_ventcrawl(atom/clicked_on)
	if(!can_ventcrawl())
		return

	var/obj/machinery/atmospherics/unary/vent_found
	if(clicked_on && Adjacent(clicked_on))
		vent_found = clicked_on
		if(!istype(vent_found) || !vent_found.can_crawl_through())
			vent_found = null

	if(!vent_found)
		for(var/obj/machinery/atmospherics/machine in range(1,src))
			if(is_type_in_list(machine, ventcrawl_machinery))
				vent_found = machine

			if(!vent_found || !vent_found.can_crawl_through())
				vent_found = null

			if(vent_found)
				break

	if(vent_found)
		if(vent_found.network && (length(vent_found.network.normal_members) || length(vent_found.network.line_members)))

			to_chat(src, "You begin climbing into the ventilation system...")
			if(vent_found.air_contents && !issilicon(src))

				switch(vent_found.air_contents.temperature)
					if(0 to BODYTEMP_COLD_DAMAGE_LIMIT)
						to_chat(src, SPAN_DANGER("You feel a painful freeze coming from the vent!"))
					if(BODYTEMP_COLD_DAMAGE_LIMIT to T0C)
						to_chat(src, SPAN_WARNING("You feel an icy chill coming from the vent."))
					if(T0C + 40 to BODYTEMP_HEAT_DAMAGE_LIMIT)
						to_chat(src, SPAN_WARNING("You feel a hot wash coming from the vent."))
					if(BODYTEMP_HEAT_DAMAGE_LIMIT to INFINITY)
						to_chat(src, SPAN_DANGER("You feel a searing heat coming from the vent!"))
				switch(vent_found.air_contents.return_pressure())
					if(0 to HAZARD_LOW_PRESSURE)
						to_chat(src, SPAN_DANGER("You feel a rushing draw pulling you into the vent!"))
					if(HAZARD_LOW_PRESSURE to WARNING_LOW_PRESSURE)
						to_chat(src, SPAN_WARNING("You feel a strong drag pulling you into the vent."))
					if(WARNING_HIGH_PRESSURE to HAZARD_HIGH_PRESSURE)
						to_chat(src, SPAN_WARNING("You feel a strong current pushing you away from the vent."))
					if(HAZARD_HIGH_PRESSURE to INFINITY)
						to_chat(src, SPAN_DANGER("You feel a roaring wind pushing you away from the vent!"))
			if(!do_after(src, 4.5 SECONDS, vent_found, DO_PUBLIC_UNIQUE))
				return
			if(!can_ventcrawl())
				return

			visible_message("<B>[src] scrambles into the ventilation ducts!</B>", "You climb into the ventilation system.")

			forceMove(vent_found)
			add_ventcrawl(vent_found)

		else
			to_chat(src, "This vent is not connected to anything.")
	else
		to_chat(src, "You must be standing on or beside an air vent to enter it.")
/mob/living/proc/add_ventcrawl(obj/machinery/atmospherics/starting_machine)
	is_ventcrawling = 1
	//candrop = 0
	var/datum/pipe_network/network = starting_machine.return_network(starting_machine)
	if(!network)
		return
	for(var/datum/pipeline/pipeline in network.line_members)
		for(var/obj/machinery/atmospherics/A in (pipeline.members || pipeline.edges))
			if(!A.pipe_image)
				A.pipe_image = image(A, A.loc, dir = A.dir)
			A.pipe_image.layer = ABOVE_LIGHTING_LAYER
			A.pipe_image.plane = EFFECTS_ABOVE_LIGHTING_PLANE
			pipes_shown += A.pipe_image
			client.images += A.pipe_image

/mob/living/proc/remove_ventcrawl()
	is_ventcrawling = 0
	//candrop = 1
	if(client)
		for(var/image/current_image in pipes_shown)
			client.images -= current_image
		client.eye = src

	pipes_shown.Cut()
