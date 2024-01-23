//todo: toothbrushes, and some sort of "toilet-filthinator" for the hos
/obj/structure/hygiene
	var/next_gurgle = 0
	var/clogged = 0 // -1 = never clog
	var/can_drain = 0
	var/drainage = 0.5
	var/last_gurgle = 0

/obj/structure/hygiene/New()
	..()
	SSfluids.hygiene_props += src
	START_PROCESSING(SSobj, src)

/obj/structure/hygiene/Destroy()
	SSfluids.hygiene_props -= src
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/structure/hygiene/proc/clog(severity)
	if(clogged) //We can only clog if our state is zero, aka completely unclogged and cloggable
		return FALSE
	clogged = severity
	return TRUE

/obj/structure/hygiene/proc/unclog()
	clogged = 0


/obj/structure/hygiene/use_tool(obj/item/tool, mob/user, list/click_params)
	// Plunger - Unclog
	if (isplunger(tool))
		if (!clogged)
			USE_FEEDBACK_FAILURE("\The [src] isn't clogged.")
			return TRUE
		spawn // TODO: Replace this with a single combined sound effect.
			playsound(loc, 'sound/effects/plunger.ogg', 75, 1)
			sleep(5)
			playsound(loc, 'sound/effects/plunger.ogg', 75, 1)
			sleep(5)
			playsound(loc, 'sound/effects/plunger.ogg', 75, 1)
			sleep(5)
			playsound(loc, 'sound/effects/plunger.ogg', 75, 1)
			sleep(5)
			playsound(loc, 'sound/effects/plunger.ogg', 75, 1)
		user.visible_message(
			SPAN_NOTICE("\The [user] strives valiantly to unclog \the [src] with \a [tool]!"),
			SPAN_NOTICE("You attempt to unclog \the [src] with \the [tool].")
		)
		if (!do_after(user, (tool.toolspeed * 4.5) SECONDS, src, DO_PUBLIC_UNIQUE) || !user.use_sanity_check(src, tool))
			return TRUE
		if (!clogged)
			USE_FEEDBACK_FAILURE("\The [src] isn't clogged.")
			return TRUE
		visible_message(SPAN_NOTICE("With a loud gurgle, \the [src] begins flowing more freely."))
		playsound(src, pick(SSfluids.gurgles), 100, TRUE)
		clogged--
		if (clogged <= 0)
			unclog()
		return TRUE

	return ..()


/obj/structure/hygiene/examine(mob/user)
	. = ..()
	if(clogged > 0)
		to_chat(user, SPAN_WARNING("It seems to be badly clogged."))

/obj/structure/hygiene/Process()
	if(clogged <= 0)
		drain()
	var/flood_amt
	switch(clogged)
		if(1)
			flood_amt = FLUID_SHALLOW
		if(2)
			flood_amt = FLUID_OVER_MOB_HEAD
		if(3)
			flood_amt = FLUID_DEEP
	if(flood_amt)
		var/turf/T = loc
		if(istype(T))
			var/obj/fluid/F = locate() in T
			if(!F) F = new(loc)
			T.show_bubbles()
			if(world.time > next_gurgle)
				visible_message("\The [src] gurgles and overflows!")
				next_gurgle = world.time + 80
				playsound(T, pick(SSfluids.gurgles), 50, 1)
			SET_FLUID_DEPTH(F, min(F.fluid_amount + (rand(30,50)*clogged), flood_amt))

/obj/structure/hygiene/proc/drain()
	if(!can_drain) return
	var/turf/T = get_turf(src)
	if(!istype(T)) return
	var/fluid_here = T.get_fluid_depth()
	if(fluid_here <= 0)
		return

	T.remove_fluid(ceil(fluid_here*drainage))
	T.show_bubbles()
	if(world.time > last_gurgle + 80)
		last_gurgle = world.time
		playsound(T, pick(SSfluids.gurgles), 50, 1)

/obj/structure/hygiene/toilet
	name = "toilet"
	desc = "The HT-451, a torque rotation-based, waste disposal unit for small matter. This one seems remarkably clean."
	icon = 'icons/obj/structures/toilets.dmi'
	icon_state = "toilet00"
	density = FALSE
	anchored = TRUE
	var/open = 0			//if the lid is up
	var/cistern = 0			//if the cistern bit is open
	var/w_items = 0			//the combined w_class of all the items in the cistern
	var/mob/living/swirlie = null	//the mob being given a swirlie

/obj/structure/hygiene/toilet/Initialize()
	. = ..()
	open = round(rand(0, 1))
	update_icon()

/obj/structure/hygiene/toilet/attack_hand(mob/living/user)
	if(swirlie)
		usr.visible_message(SPAN_DANGER("[user] slams the toilet seat onto [swirlie.name]'s head!"), SPAN_NOTICE("You slam the toilet seat onto [swirlie.name]'s head!"), "You hear reverberating porcelain.")
		swirlie.adjustBruteLoss(8)
		return

	if(cistern && !open)
		if(!length(contents))
			to_chat(user, SPAN_NOTICE("The cistern is empty."))
			return
		else
			var/obj/item/I = pick(contents)
			if(ishuman(user))
				user.put_in_hands(I)
			else
				I.dropInto(loc)
			to_chat(user, SPAN_NOTICE("You find \an [I] in the cistern."))
			w_items -= I.w_class
			return

	open = !open
	update_icon()

/obj/structure/hygiene/toilet/on_update_icon()
	icon_state = "toilet[open][cistern]"


/obj/structure/hygiene/toilet/use_grab(obj/item/grab/grab, list/click_params)
	// Harm intent - Slam into toilet
	if (grab.assailant.a_intent == I_HURT)
		if (!Adjacent(grab.affecting))
			USE_FEEDBACK_GRAB_FAILURE("\The [grab.affecting] must be next \the [src] to bash them with it.")
			return TRUE
		grab.assailant.setClickCooldown(grab.assailant.get_attack_speed(grab))
		grab.affecting.adjustBruteLoss(8)
		playsound(src, 'sound/weapons/tablehit1.ogg', 50, TRUE)
		grab.assailant.visible_message(
			SPAN_WARNING("\The [grab.assailant] slams \the [grab.affecting] into \the [src]!"),
			SPAN_DANGER("You slam \the [grab.affecting] into \the [src]!"),
			exclude_mobs = list(grab.affecting)
		)
		grab.affecting.show_message(
			SPAN_DANGER("\The [grab.assailant] slams you into \the [src]!"),
			VISIBLE_MESSAGE,
			SPAN_DANGER("You feel yourself being slammed against something hard!")
		)
		return TRUE

	// Other intent - Give swirlie
	if (!open)
		USE_FEEDBACK_GRAB_FAILURE("\The [src] needs to be open before you can give \the [grab.affecting] a swirlie.")
		return TRUE
	if (!Adjacent(grab.affecting))
		USE_FEEDBACK_GRAB_FAILURE("\The [grab.affecting] must be next \the [src] to give them a swirlie.")
		return TRUE
	grab.assailant.visible_message(
		SPAN_WARNING("\The [grab.assailant] starts jamming \the [grab.affecting]'s face into \the [src]!"),
		SPAN_DANGER("You start jamming \the [grab.affecting]'s face into \the [src]!"),
		exclude_mobs = list(grab.affecting)
	)
	grab.affecting.show_message(
		SPAN_DANGER("\The [grab.assailant] starts jamming your face into \the [src]!"),
		VISIBLE_MESSAGE,
		SPAN_DANGER("You feel your head being dunked in cold water!")
	)
	if (!do_after(grab.assailant, 3 SECONDS, src, DO_PUBLIC_UNIQUE) || !grab.use_sanity_check(src))
		return TRUE
	grab.assailant.visible_message(
		SPAN_WARNING("\The [grab.assailant] gives \the [grab.affecting] a swirlie in \the [src]!"),
		SPAN_DANGER("You give \the [grab.affecting] a swirlie in \the [src]!"),
		exclude_mobs = list(grab.affecting)
	)
	grab.affecting.show_message(
		SPAN_DANGER("\The [grab.assailant] gives you a swirlie in \the [src]!"),
		VISIBLE_MESSAGE,
		SPAN_DANGER("You hear the sound of flushing and feel water and air being sucked out around you!")
	)
	grab.affecting.adjustOxyLoss(5)
	return TRUE


/obj/structure/hygiene/toilet/use_tool(obj/item/tool, mob/user, list/click_params)
	// Crowbar - Toggle lid
	if (isCrowbar(tool))
		playsound(loc, 'sound/effects/stonedoor_openclose.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] starts to [cistern ? "lift" : "replace"] \the [src]'s cistern with \a [tool]."),
			SPAN_NOTICE("You start to [cistern ? "lift" : "replace"] \the [src]'s cistern with \the [tool].")
		)
		if (!do_after(user, (tool.toolspeed * 3) SECONDS, src, DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		playsound(loc, 'sound/effects/stonedoor_openclose.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] [cistern ? "lifts" : "replaces"] \the [src]'s cistern with \a [tool]."),
			SPAN_NOTICE("You [cistern ? "lift" : "replace"] \the [src]'s cistern with \the [tool].")
		)
		cistern = !cistern
		update_icon()
		return TRUE

	// Anything else - Put item in cistern
	if (cistern)
		if (tool.w_class > ITEM_SIZE_NORMAL)
			USE_FEEDBACK_FAILURE("\The [tool] is too large for \the [src]'s cistern.")
			return TRUE
		if (w_items + tool.w_class > 5)
			USE_FEEDBACK_FAILURE("\The [src]'s cistern is too full to hold \the [tool].")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		w_items += tool.w_class
		user.visible_message(
			SPAN_NOTICE("\The [user] slips \a [tool] into \the [src]'s cistern."),
			SPAN_NOTICE("You carefully place \the [tool] into \the [src]'s cistern."),
			range = 2
		)
		return TRUE

	return ..()


/obj/structure/hygiene/urinal
	name = "urinal"
	desc = "The HU-452, an experimental urinal."
	icon = 'icons/obj/structures/toilets.dmi'
	icon_state = "urinal"
	density = FALSE
	anchored = TRUE


/obj/structure/hygiene/urinal/use_grab(obj/item/grab/grab, list/click_params)
	// Harm intent - Slam into urinal
	if (grab.assailant.a_intent == I_HURT)
		if (!Adjacent(grab.affecting))
			USE_FEEDBACK_GRAB_FAILURE("\The [grab.affecting] must be next \the [src] to bash them with it.")
			return TRUE
		grab.assailant.setClickCooldown(grab.assailant.get_attack_speed(grab))
		grab.affecting.adjustBruteLoss(8)
		playsound(src, 'sound/weapons/tablehit1.ogg', 50, TRUE)
		grab.assailant.visible_message(
			SPAN_WARNING("\The [grab.assailant] slams \the [grab.affecting] into \the [src]!"),
			SPAN_DANGER("You slam \the [grab.affecting] into \the [src]!"),
			exclude_mobs = list(grab.affecting)
		)
		to_chat(grab.affecting, SPAN_DANGER("\The [grab.assailant] slams you into \the [src]!"))
		return TRUE

	return ..()


/obj/structure/hygiene/shower
	name = "shower"
	desc = "The HS-451. Installed in the 2200s by the Hygiene Division."
	icon = 'icons/obj/showers.dmi'
	icon_state = "shower"
	density = FALSE
	anchored = TRUE
	clogged = -1
	can_drain = 1
	drainage = 0.2 			//showers are tiny, drain a little slower

	var/on = 0
	var/obj/mist/mymist = null
	var/ismist = 0				//needs a var so we can make it linger~
	var/watertemp = "normal"	//freezing, normal, or boiling
	var/is_washing = 0
	var/list/temperature_settings = list("normal" = 310, "boiling" = T0C+100, "freezing" = T0C)
	var/working_sound = 'sound/machines/shower.ogg'
	var/datum/sound_token/sound_token
	var/sound_id

/obj/structure/hygiene/shower/New()
	..()
	create_reagents(50)

/obj/structure/hygiene/shower/proc/update_sound()
	if(!working_sound)
		return
	if(!sound_id)
		sound_id = "[type]_[sequential_id(/obj/structure/hygiene/shower)]"
	if(on)
		var/volume = 20
		if(!sound_token)
			sound_token = GLOB.sound_player.PlayLoopingSound(src, sound_id, working_sound, volume = volume, range = 10)
		sound_token.SetVolume(volume)
	else if(sound_token)
		QDEL_NULL(sound_token)
//add heat controls? when emagged, you can freeze to death in it?

/obj/mist
	name = "mist"
	icon = 'icons/obj/showers.dmi'
	icon_state = "mist"
	layer = MOB_LAYER + 1
	anchored = TRUE
	mouse_opacity = 0

/obj/structure/hygiene/shower/attack_hand(mob/M)
	on = !on
	update_icon()
	update_sound()
	if(on)
		if (M.loc == loc)
			wash(M)
			process_heat(M)
		for (var/atom/movable/G in src.loc)
			G.clean_blood()


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
		if (!do_after(user, (tool.toolspeed * 5) SECONDS, src, DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		watertemp = input
		playsound(src, 'sound/items/Ratchet.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] adjusts \the [src]'s temperature with \a [tool]."),
			SPAN_NOTICE("You set \the [src]'s temperature to [watertemp] with \the [tool].")
		)
		return TRUE

	return ..()


/obj/structure/hygiene/shower/on_update_icon()	//this is terribly unreadable, but basically it makes the shower mist up
	ClearOverlays()					//once it's been on for a while, in addition to handling the water overlay.
	if(mymist)
		qdel(mymist)
		mymist = null

	if(on)
		AddOverlays(image('icons/obj/showers.dmi', src, "water", MOB_LAYER + 1, dir))
		if(temperature_settings[watertemp] < T20C)
			return //no mist for cold water
		if(!ismist)
			spawn(50)
				if(src && on)
					ismist = 1
					mymist = new /obj/mist(loc)
		else
			ismist = 1
			mymist = new /obj/mist(loc)
	else if(ismist)
		ismist = 1
		mymist = new /obj/mist(loc)
		spawn(250)
			if(src && !on)
				qdel(mymist)
				mymist = null
				ismist = 0

//Yes, showers are super powerful as far as washing goes.
/obj/structure/hygiene/shower/proc/wash(atom/movable/washing)
	if(on)
		wash_mob(washing)
		if(isturf(loc))
			var/turf/tile = loc
			for(var/obj/E in tile)
				if(istype(E,/obj/decal/cleanable) || istype(E,/obj/overlay))
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
	is_washing = 1
	var/turf/T = get_turf(src)
	reagents.splash(T, reagents.total_volume)
	T.clean(src)
	spawn(100)
		is_washing = 0

/obj/structure/hygiene/shower/proc/process_heat(mob/living/M)
	if(!on || !istype(M)) return

	var/water_temperature = temperature_settings[watertemp]
	var/temp_adj = clamp(water_temperature - M.bodytemperature, BODYTEMP_COOLING_MAX, BODYTEMP_HEATING_MAX)
	M.bodytemperature += temp_adj

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(water_temperature >= H.species.heat_level_1)
			to_chat(H, SPAN_DANGER("The water is searing hot!"))
		else if(water_temperature <= H.species.cold_level_1)
			to_chat(H, SPAN_WARNING("The water is freezing cold!"))

/obj/item/bikehorn/rubberducky
	name = "rubber ducky"
	desc = "Rubber ducky you're so fine, you make bathtime lots of fuuun. Rubber ducky I'm awfully fooooond of yooooouuuu~"	//thanks doohl
	icon = 'icons/obj/toy.dmi'
	icon_state = "rubberducky"
	item_state = "rubberducky"

/obj/structure/hygiene/sink
	name = "sink"
	icon = 'icons/obj/sinks.dmi'
	icon_state = "sink"
	desc = "A sink used for washing one's hands and face."
	anchored = TRUE
	var/busy = 0 	//Something's being washed at the moment

/obj/structure/hygiene/sink/MouseDrop_T(obj/item/thing, mob/user)
	..()
	if(!istype(thing) || !thing.is_open_container())
		return ..()
	if(!usr.Adjacent(src))
		return ..()
	if(!thing.reagents || thing.reagents.total_volume == 0)
		to_chat(usr, SPAN_WARNING("\The [thing] is empty."))
		return
	// Clear the vessel.
	visible_message(SPAN_NOTICE("\The [usr] tips the contents of \the [thing] into \the [src]."))
	thing.reagents.clear_reagents()
	thing.update_icon()

/obj/structure/hygiene/sink/attack_hand(mob/user)
	if (ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = H.organs_by_name[BP_R_HAND]
		if (user.hand)
			temp = H.organs_by_name[BP_L_HAND]
		if(temp && !temp.is_usable())
			to_chat(user,SPAN_NOTICE("You try to move your [temp.name], but cannot!"))
			return

	if(isrobot(user) || isAI(user))
		return

	if(!Adjacent(user))
		return

	if(busy)
		to_chat(user, SPAN_WARNING("Someone's already washing here."))
		return

	to_chat(usr, SPAN_NOTICE("You start washing your hands."))
	playsound(loc, 'sound/effects/sink_long.ogg', 75, 1)

	busy = 1
	if(!do_after(user, 4 SECONDS, src, DO_PUBLIC_UNIQUE))
		busy = 0
		return TRUE
	busy = 0

	user.clean_blood()
	user.visible_message( \
		SPAN_NOTICE("[user] washes their hands using \the [src]."), \
		SPAN_NOTICE("You wash your hands using \the [src]."))


/obj/structure/hygiene/sink/use_tool(obj/item/tool, mob/user, list/click_params)
	SHOULD_CALL_PARENT(FALSE)

	// Plunger - Passthrough to parent if clogged
	if (isplunger(tool) && clogged)
		return ..()

	// Reagent Container - Fill container
	if (istype(tool, /obj/item/reagent_containers))
		if (!tool.reagents)
			return ..()
		var/obj/item/reagent_containers/container = tool
		if (!container.is_open_container())
			USE_FEEDBACK_FAILURE("\The [tool] needs to be open before you can fill it with \the [src].")
			return TRUE
		playsound(src, 'sound/effects/sink.ogg', 50, TRUE)
		container.reagents.add_reagent(/datum/reagent/water, container.amount_per_transfer_from_this)
		user.visible_message(
			SPAN_NOTICE("\The [user] fills \a [tool] with some water from \the [src]."),
			SPAN_NOTICE("You fill \the [tool] with some water from \the [src]."),
			SPAN_ITALIC("You hear running water.")
		)
		return TRUE

	// Mop - Wet mop
	if (istype(tool, /obj/item/mop))
		tool.reagents.add_reagent(/datum/reagent/water, 5)
		playsound(src, 'sound/effects/slosh.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] wets \a [tool] with \the [src]."),
			SPAN_NOTICE("You wet \the [tool] with \the [src]."),
			SPAN_ITALIC("You hear running water.")
		)
		return TRUE

	// Everything else - Wash
	playsound(src, 'sound/effects/sink_long.ogg', 50, TRUE)
	user.visible_message(
		SPAN_NOTICE("\The [user] starts washing \a [tool] in \the [src]."),
		SPAN_NOTICE("You start washing \the [tool] in \the [src]."),
		SPAN_ITALIC("You hear running water.")
	)
	if (!do_after(user, 4 SECONDS, src, DO_PUBLIC_UNIQUE) || !user.use_sanity_check(src, tool))
		return TRUE
	tool.clean_blood()
	user.visible_message(
		SPAN_NOTICE("\The [user] washes \a [tool] in \the [src]."),
		SPAN_NOTICE("You wash \the [tool] in \the [src].")
	)
	return TRUE


/obj/structure/hygiene/sink/kitchen
	name = "kitchen sink"
	icon_state = "sink_alt"

/obj/structure/hygiene/sink/puddle	//splishy splashy ^_^
	name = "puddle"
	icon_state = "puddle"
	clogged = -1 // how do you clog a puddle

/obj/structure/hygiene/sink/puddle/attack_hand(mob/M)
	icon_state = "puddle-splash"
	..()
	icon_state = "puddle"


/obj/structure/hygiene/sink/puddle/post_use_item(obj/item/tool, mob/user, interaction_handled, use_call, click_params)
	..()
	if (interaction_handled)
		flick("puddle-splash", src)


/obj/structure/hygiene/use_tool(obj/item/tool, mob/user, list/click_params)
	// Toilet Paper - Clog drain
	if (istype(tool, /obj/item/taperoll/bog))
		if (clogged == -1)
			USE_FEEDBACK_FAILURE("Try as you might, you can not clog \the [src] with \the [tool].")
			return TRUE
		if (clogged)
			USE_FEEDBACK_FAILURE("\The [src] is already clogged.")
			return TRUE
		if (!user.canUnEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		user.visible_message(
			SPAN_WARNING("\The [user] starts stuffing \the [src] with \a [tool]!"),
			SPAN_WARNING("You start stuffing \the [src] with \the [tool]!")
		)
		if (!do_after(user, 3 SECONDS, src, DO_PUBLIC_UNIQUE) || !user.use_sanity_check(src, tool))
			return TRUE
		if (clogged == -1)
			USE_FEEDBACK_FAILURE("Try as you might, you can not clog \the [src] with \the [tool].")
			return TRUE
		if (clogged)
			USE_FEEDBACK_FAILURE("\The [src] is already clogged.")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		user.visible_message(
			SPAN_WARNING("\The [user] unceremoniously jams \the [src] with \a [tool]. What a rebel."),
			SPAN_WARNING("You unceremoniously jam \the [src] with \the [tool]. What a rebel.")
		)
		clog(1)
		qdel(tool)
		return TRUE

	return ..()


/obj/item/taperoll/bog
	name = "toilet paper roll"
	icon = 'icons/obj/bog.dmi'
	desc = "A unbranded roll of standard issue two ply toilet paper. Refined from carefully rendered down sea shells due to SolGov's 'Abuse Of The Trees Act'."
	tape_type = /obj/item/tape/bog
	icon_state = "bogroll"
	item_state = "mummy_poor"
	slot_flags = SLOT_HEAD | SLOT_OCLOTHING
	var/sheets = 30

/obj/item/taperoll/bog/equipped(mob/user, slot)
	switch(slot)
		if(slot_wear_suit)
			sprite_sheets = list(
				SPECIES_VOX = 'icons/mob/species/vox/onmob_suit_vox.dmi',
				SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_suit_unathi.dmi'
				)
		if(slot_head)
			sprite_sheets = list(
				SPECIES_VOX = 'icons/mob/species/vox/onmob_head_vox.dmi',
				SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_head_unathi.dmi'
				)
	return ..()


/obj/item/tape/bog
	name = "toilet paper"
	desc = "A length of toilet paper. Seems like custodia is marking their territory again."
	icon_base = "stripetape"
	color = COLOR_WHITE
	detail_overlay = "stripes"
	detail_color = COLOR_WHITE

/obj/item/taperoll/bog/verb/tear_sheet()
	set category = "Object"
	set name = "Tear Sheet"
	set desc = "Tear a sheet of toilet paper."
	if (usr.incapacitated())
		return
	if(sheets > 0)
		visible_message("\The [usr] tears a sheet from \the [src].", "You tear a sheet from \the [src].")
		var/obj/item/paper/crumpled/bog/C =  new(loc)
		usr.put_in_hands(C)
		sheets--
	if (sheets < 1)
		to_chat(usr, "\The [src] is depleted.")
		qdel(src)

/obj/item/paper/crumpled/bog
	name = "sheet of toilet paper"
	desc = "A single sheet of toilet paper. Two ply."
	icon = 'icons/obj/bog.dmi'
	icon_state = "bogroll_sheet"

/obj/structure/hygiene/faucet
	name = "faucet"
	icon = 'icons/obj/structures/faucets.dmi'
	icon_state = "faucet"
	desc = "An outlet for liquids. Water you waiting for?"
	anchored = TRUE
	drainage = 0
	clogged = -1
	var/fill_level = 500
	var/open = FALSE


/obj/structure/hygiene/faucet/use_tool(obj/item/tool, mob/user, list/click_params)
	// Wrench - Disconnect faucet
	if (isWrench(tool))
		playsound(src, 'sound/items/Ratchet.ogg', 50, TRUE)
		var/obj/item/faucet/faucet = new(loc)
		transfer_fingerprints_to(faucet)
		user.visible_message(
			SPAN_NOTICE("\The [user] detaches \the [src] from the floor with \a [tool]."),
			SPAN_NOTICE("You detach \the [src] from the floor with \the [tool].")
		)
		qdel_self()
		return TRUE

	return ..()


/obj/structure/hygiene/faucet/attack_hand(mob/user)
	. = ..()
	open = !open
	if(open)
		playsound(loc, 'sound/effects/closet_open.ogg', 20, 1)
	else
		playsound(loc, 'sound/effects/closet_close.ogg', 20, 1)

	user.visible_message(
		SPAN_NOTICE("\The [user] has [open ? "opened" : "closed"] \the [src]."),
		SPAN_NOTICE("You [open ? "open" : "close"] \the [src].")
	)
	update_icon()

/obj/structure/hygiene/faucet/on_update_icon()
	. = ..()
	icon_state = icon_state = "[initial(icon_state)][open ? "-on" : ""]"

/obj/item/faucet
	name = "faucet"
	desc = "An outlet for liquids. Water you waiting for?"
	icon = 'icons/obj/structures/faucets.dmi'
	icon_state = "faucet-item"
	obj_flags = OBJ_FLAG_ROTATABLE
	var/constructed_type = /obj/structure/hygiene/faucet

/obj/item/faucet/use_tool(obj/item/thing, mob/living/user, list/click_params)
	if(isWrench(thing))
		var/turf/simulated/floor/F = loc
		if (istype(F) && istype(F.flooring, /singleton/flooring/pool))
			var/obj/O = new constructed_type (loc)
			O.dir = dir
			playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
			user.visible_message(
				SPAN_WARNING("\The [user] wrenches \the [src] down."),
				SPAN_WARNING("You wrench \the [src] down.")
			)
			qdel(src)
		else
			to_chat(user, SPAN_WARNING("\The [src] can only be secured to pool tiles!"))
		return TRUE
	return ..()

/obj/structure/hygiene/faucet/proc/water_flow()
	if(!isturf(src.loc))
		return

	// Check for depth first, and pass if the water's too high. I know players will find a way to just submerge entire ship if I do not.
	var/turf/T = get_turf(src)

	if(!T || T.get_fluid_depth() > fill_level)
		return

	if(world.time > next_gurgle)
		next_gurgle = world.time + 80
		playsound(T, pick(SSfluids.gurgles), 50, 1)

	T.add_fluid(min(75, fill_level - T.get_fluid_depth()), /datum/reagent/water)

/obj/structure/hygiene/faucet/Process()
	..()
	if(open)
		water_flow()

/obj/structure/hygiene/faucet/examine(mob/user)
	. = ..()
	to_chat(user, "It is turned [open ? "on" : "off"]")
