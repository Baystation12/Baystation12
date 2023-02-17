/obj/machinery/pile_ripper
	name = "pile ripper"
	desc = "This machine rips everything in front of it apart."
	icon = 'recycling.dmi'
	icon_state = "grinder-o0"
	layer = MOB_LAYER+1 // Overhead
	anchored = TRUE
	density = TRUE
	use_power = 1
	idle_power_usage = 300

	var/safety_mode = 0 // Temporality stops the machine if it detects a mob
	var/icon_name = "grinder-o"
	var/blood = 0
	var/rating = 1
	var/last_ripped = 0
	construct_state = /singleton/machine_construction/default/panel_closed
	uncreated_component_parts = list(
		/obj/item/stock_parts/radio/receiver,
		/obj/item/stock_parts/power/apc
	)

/obj/machinery/pile_ripper/Initialize()
	. = ..()
	RefreshParts()
	update_icon()

/obj/machinery/pile_ripper/Process()
	if(last_ripped >= world.time)
		return
	last_ripped = world.time
	if(safety_mode)
		playsound(src.loc, 'sound/machines/ping.ogg', 50, 0)
		safety_mode = 0
		update_icon()
	var/turf/ripped_turf = get_turf(get_step(src, 8))
	for(var/mob/living/poor_soul in ripped_turf)
		if(emagged || prob(25))
			eat(poor_soul)
		else
			stop(poor_soul)
	var/count = 0
	for(var/obj/ripped_item in ripped_turf)
		if(count >= rating)
			break
		if(istype(ripped_item, /obj/structure/rubble))
			var/obj/structure/rubble/pile = ripped_item
			pile.crush_act()
			count++
		else if(istype(ripped_item, /obj/item))
			ripped_item.forceMove(src.loc)
			if(prob(20))
				qdel(ripped_item)
		else if(istype(ripped_item, /obj/structure/scrap_cube))
			var/obj/structure/scrap_cube/cube = ripped_item
			cube.make_pile()

/obj/machinery/pile_ripper/RefreshParts()
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		rating = M.rating

/obj/machinery/pile_ripper/examine(mob/user)
	..()
	to_chat(user, "The power light is [(stat & MACHINE_STAT_NOPOWER) ? "off" : "on"].")
	to_chat(user, "The safety-mode light is [safety_mode ? "on" : "off"].")
	to_chat(user, "The safety-sensors status light is [emagged ? "off" : "on"].")

/obj/machinery/pile_ripper/power_change()
	..()
	update_icon()

/obj/machinery/pile_ripper/proc/stop(mob/living/L)
	playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
	safety_mode = 1
	update_icon()
	L.forceMove(src.loc)

	last_ripped += SAFETY_COOLDOWN
	update_icon()

/obj/machinery/pile_ripper/attackby(obj/item/I, mob/user, params)
	add_fingerprint(user)
	if (istype(I, /obj/item/card/emag))
		emag_act(user)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	return ..()

/obj/machinery/pile_ripper/emag_act(mob/user)
	if(!emagged)
		emagged = TRUE
		if(safety_mode)
			safety_mode = 0
			update_icon()
		playsound(src.loc, "sparks", 75, 1, -1)
		to_chat(user, SPAN_NOTICE ("You use the cryptographic sequencer on the [src.name]."))

/obj/machinery/pile_ripper/on_update_icon()
	..()
	var/is_powered = !(stat & (MACHINE_BROKEN_GENERIC|MACHINE_STAT_NOPOWER))
	if(safety_mode)
		is_powered = 0
	icon_state = icon_name + "[is_powered]" + "[(blood ? "bld" : "")]" // add the blood tag at the end


/obj/machinery/pile_ripper/proc/eat(mob/living/L)
	if(issilicon(L))
		playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
	else
		playsound(src.loc, 'sound/effects/splat.ogg', 50, 1)

	var/gib = 1
	// By default, the emagged pile_ripper will gib all non-carbons. (human simple animal mobs don't count)
	if(iscarbon(L))
		var/mob/living/carbon/C = L
		gib = 0
		if(C.can_feel_pain())
			C.emote("scream")
		add_blood(L)
	if(!blood && !issilicon(L))
		blood = 1
		update_icon()
	if(gib)
		L.gib()

	// Instantly lie down, also go unconscious from the pain, before you die.
	L.Paralyse(5)
	// Strip some clothing

	for(var/obj/item/I in L.get_equipped_items())
		if(L.unEquip(I))
			I.forceMove(loc)
			if(prob(15)) //saved by ripped cloth
				return

	// Start shredding meat

	var/slab_name = L.name
	var/slab_type = /obj/item/reagent_containers/food/snacks/meat

	if(iscarbon(L))
		if(istype(L,/mob/living/carbon/human))
			slab_type = /obj/item/reagent_containers/food/snacks/meat/human
			if(L.is_species(SPECIES_MONKEY))
				slab_type = /obj/item/reagent_containers/food/snacks/meat/monkey
		var/obj/item/reagent_containers/food/snacks/meat/new_meat = new slab_type(get_turf(get_step(src, 4)))
		new_meat.name = "[slab_name] [new_meat.name]"
		new_meat.reagents.add_reagent(/datum/reagent/nutriment, 10)
	if(iscarbon(L))
		var/mob/living/carbon/C = L
		C.nutrition -= 100
		if(C.nutrition > 0)
			C.adjustBruteLoss(45)
		else
			C.gib()
