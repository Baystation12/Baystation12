#define SHOWER_FREEZING "freezing"
#define SHOWER_NORMAL "normal"
#define SHOWER_BOILING "boiling"


/obj/structure/hygiene/shower
	name = "shower"
	desc = "The HS-451. Installed in the 2200s by the Hygiene Division."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "shower"
	density = FALSE
	anchored = TRUE
	clogged = -1
	can_drain = 1
	drainage = 0.2 			//showers are tiny, drain a little slower

	var/image/shower_water
	var/on = FALSE
	var/ismist = FALSE
	var/obj/effect/mist/mist
	var/watertemp = SHOWER_NORMAL	///can be freezing, normal, or boiling
	var/is_washing = FALSE
	var/list/temperature_settings = list( SHOWER_FREEZING = T0C, SHOWER_NORMAL = 310, SHOWER_BOILING = T0C+100,)
	var/datum/composite_sound/shower/soundloop

/obj/structure/hygiene/shower/Initialize()
	. = ..()
	create_reagents(50)
	soundloop = new(list(src), FALSE)
	shower_water = image(icon, src, "water", ABOVE_HUMAN_LAYER, dir)

/obj/structure/hygiene/shower/Destroy()
	QDEL_NULL(soundloop)
	QDEL_NULL(reagents)
	QDEL_NULL(mist)
	. = ..()

//add heat controls? when emagged, you can freeze to death in it?

/obj/structure/hygiene/shower/attack_hand(mob/M)
	on = !on
	update_icon()
	handle_mist()
	if(on)
		soundloop.start()
		if (M.loc == loc)
			wash(M)
			process_heat(M)
		for (var/atom/movable/G in src.loc)
			G.clean_blood()
	else
		soundloop.stop()

/obj/structure/hygiene/shower/use_tool(obj/item/tool, mob/user, list/click_params)
	// Gas Scanner - Fetch temperature
	if (istype(tool, /obj/item/device/scanner/gas))
		user.visible_message(
			SPAN_NOTICE("\The [user] scans \the [src] with \a [tool]."),
			SPAN_NOTICE("You scan \the [src] with \the [tool]. The water temperature seems to be [watertemp].")
		)
		return TRUE

	// Wrench - Set temperature
	if (isWrench(tool))
		var/input = input(user, "What setting would you like to set the temperature valve to?", "[name] Water Temperature Valve") as null|anything in temperature_settings
		if (!input || !user.use_sanity_check(src, tool))
			return TRUE
		playsound(src, 'sound/items/Ratchet.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] starts adjusting \the [src]'s temperature with \a [tool]."),
			SPAN_NOTICE("You start adjusting \the [src]'s temperature with \the [tool].")
		)
		if (!do_after(user, 5 SECONDS, src, DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		watertemp = input
		playsound(src, 'sound/items/Ratchet.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] adjusts \the [src]'s temperature with \a [tool]."),
			SPAN_NOTICE("You set \the [src]'s temperature to [watertemp] with \the [tool].")
		)
		return TRUE

	return ..()

/obj/structure/hygiene/shower/on_update_icon()
	cut_overlays()

	if(on)
		add_overlay(shower_water)


/obj/structure/hygiene/shower/proc/handle_mist()
	// If there is no mist, and the shower was turned on (on a non-freezing temp): make mist in 5 seconds
	if(!mist && on && temperature_settings != SHOWER_FREEZING)
		addtimer(new Callback(src, .proc/make_mist), 5 SECONDS)

	// If there was already mist, and the shower was turned off (or made cold): remove the existing mist in 25 sec
	if(mist && (!on || temperature_settings == SHOWER_FREEZING))
		addtimer(new Callback(src, .proc/clear_mist), 25 SECONDS)


/obj/structure/hygiene/shower/proc/clear_mist()
	if(mist && (!on || temperature_settings == SHOWER_FREEZING))
		qdel(mist)

/obj/structure/hygiene/shower/proc/make_mist()
	if(!mist && on && temperature_settings != SHOWER_FREEZING)
		mist = new(loc)

//Yes, showers are super powerful as far as washing goes.
/obj/structure/hygiene/shower/proc/wash(atom/movable/washing)
	if(on)
		wash_mob(washing)
		if(isturf(loc))
			var/turf/tile = loc
			for(var/obj/effect/E in tile)
				if(istype(E,/obj/effect/decal/cleanable) || istype(E,/obj/effect/overlay))
					qdel(E)
		reagents.splash(washing, 10)

/obj/structure/hygiene/shower/Process()
	..()
	if(!on) return

	for(var/thing in loc)
		var/atom/movable/AM = thing
		var/mob/living/L = thing
		if(istype(AM) && AM.simulated)
			wash(AM)
			if(istype(L))
				process_heat(L)
	wash_floor()
	reagents.add_reagent(/datum/reagent/water, reagents.get_free_space())

/obj/structure/hygiene/shower/proc/wash_floor()
	if(!ismist && is_washing)
		return
	is_washing = TRUE
	var/turf/T = get_turf(src)
	reagents.splash(T, reagents.total_volume)
	T.clean(src)
	spawn(100)
		is_washing = FALSE

/obj/structure/hygiene/shower/proc/process_heat(mob/living/M)
	if(!on || !istype(M)) return

	var/water_temperature = temperature_settings[watertemp]
	var/temp_adj = clamp(water_temperature - M.bodytemperature, BODYTEMP_COOLING_MAX, BODYTEMP_HEATING_MAX)
	M.bodytemperature += temp_adj

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(water_temperature >= H.species.heat_level_1)
			to_chat(H, SPAN_DANGER("The water is searing hot!"))
			M.adjustFireLoss(5)
		else if(water_temperature <= H.species.cold_level_1)
			to_chat(H, SPAN_WARNING("The water is freezing cold!"))

/obj/effect/mist
	name = "mist"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mist"
	layer = ABOVE_HUMAN_LAYER
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE


/datum/composite_sound/shower
	start_sound = 'sound/effects/shower/shower_start.ogg'
	start_length = 2
	mid_sounds = list('sound/effects/shower/shower_mid1.ogg' = 1, 'sound/effects/shower/shower_mid2.ogg' = 1, 'sound/effects/shower/shower_mid3.ogg' = 1)
	mid_length = 10
	end_sound = 'sound/effects/shower/shower_end.ogg'
	volume = 10


#undef SHOWER_FREEZING
#undef SHOWER_NORMAL
#undef SHOWER_BOILING
