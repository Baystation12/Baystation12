/obj/machinery/beehive
	name = "apiary"
	icon = 'icons/obj/beekeeping.dmi'
	icon_state = "beehive-0"
	desc = "A wooden box designed specifically to house our buzzling buddies. Far more efficient than traditional hives. Just insert a frame and a queen, close it up, and you're good to go!"
	density = TRUE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER

	var/closed = 0
	var/bee_count = 0 // Percent
	var/smoked = 0 // Timer
	var/honeycombs = 0 // Percent
	var/frames = 0
	var/maxFrames = 5

/obj/machinery/beehive/Initialize()
	. = ..()
	update_icon()

/obj/machinery/beehive/on_update_icon()
	overlays.Cut()
	icon_state = "beehive-[closed]"
	if(closed)
		overlays += "lid"
	if(frames)
		overlays += "empty[frames]"
	if(honeycombs >= 100)
		overlays += "full[round(honeycombs / 100)]"
	if(!smoked)
		switch(bee_count)
			if(1 to 20)
				overlays += "bees1"
			if(21 to 40)
				overlays += "bees2"
			if(41 to 60)
				overlays += "bees3"
			if(61 to 80)
				overlays += "bees4"
			if(81 to 100)
				overlays += "bees5"

/obj/machinery/beehive/examine(mob/user)
	. = ..()
	if(!closed)
		to_chat(user, "The lid is open.")

/obj/machinery/beehive/attackby(obj/item/I, mob/user)
	if(isCrowbar(I))
		closed = !closed
		user.visible_message(
			SPAN_NOTICE("\The [user] [closed ? "closes" : "opens"] \the [src]."),
			SPAN_NOTICE("You [closed ? "close" : "open"] \the [src].")
		)
		update_icon()
		return
	else if(isWrench(I))
		anchored = !anchored
		user.visible_message(
			SPAN_NOTICE("\The [user] [anchored ? "wrenches" : "unwrenches"] \the [src]."),
			SPAN_NOTICE("You [anchored ? "wrench" : "unwrench"] \the [src].")
		)
		return
	else if(istype(I, /obj/item/bee_smoker))
		if(closed)
			to_chat(user, SPAN_NOTICE("You need to open \the [src] with a crowbar before smoking the bees."))
			return
		user.visible_message(SPAN_NOTICE("\The [user] smokes the bees in \the [src]."), SPAN_NOTICE("You smoke the bees in \the [src]."))
		smoked = 30
		update_icon()
		return
	else if(istype(I, /obj/item/honey_frame))
		if(closed)
			to_chat(user, SPAN_NOTICE("You need to open \the [src] with a crowbar before inserting \the [I]."))
			return
		if(frames >= maxFrames)
			to_chat(user, SPAN_NOTICE("There is no place for an another frame."))
			return
		var/obj/item/honey_frame/H = I
		if(H.honey)
			to_chat(user, SPAN_NOTICE("\The [I] is full with beeswax and honey, empty it in the extractor first."))
			return
		++frames
		user.visible_message(SPAN_NOTICE("\The [user] loads \the [I] into \the [src]."), SPAN_NOTICE("You load \the [I] into \the [src]."))
		update_icon()
		qdel(I)
		return
	else if(istype(I, /obj/item/bee_pack))
		var/obj/item/bee_pack/B = I
		if(B.full && bee_count)
			to_chat(user, SPAN_NOTICE("\The [src] already has bees inside."))
			return
		if(!B.full && bee_count < 90)
			to_chat(user, SPAN_NOTICE("\The [src] is not ready to split."))
			return
		if(!B.full && !smoked)
			to_chat(user, SPAN_NOTICE("Smoke \the [src] first!"))
			return
		if(closed)
			to_chat(user, SPAN_NOTICE("You need to open \the [src] with a crowbar before moving the bees."))
			return
		if(B.full)
			user.visible_message(SPAN_NOTICE("\The [user] puts the queen and the bees from \the [I] into \the [src]."), SPAN_NOTICE("You put the queen and the bees from \the [I] into \the [src]."))
			bee_count = 20
			B.empty()
		else
			user.visible_message(SPAN_NOTICE("\The [user] puts bees and larvae from \the [src] into \the [I]."), SPAN_NOTICE("You put bees and larvae from \the [src] into \the [I]."))
			bee_count /= 2
			B.fill()
		update_icon()
		return
	else if(istype(I, /obj/item/device/scanner/plant))
		to_chat(user, SPAN_NOTICE("Scan result of \the [src]..."))
		to_chat(user, "Beehive is [bee_count ? "[round(bee_count)]% full" : "empty"].[bee_count > 90 ? " Colony is ready to split." : ""]")
		if(frames)
			to_chat(user, "[frames] frames installed, [round(honeycombs / 100)] filled.")
			if(honeycombs < frames * 100)
				to_chat(user, "Next frame is [round(honeycombs % 100)]% full.")
		else
			to_chat(user, "No frames installed.")
		if(smoked)
			to_chat(user, "The hive is smoked.")
		return 1
	else if(isScrewdriver(I))
		if(bee_count)
			to_chat(user, SPAN_NOTICE("You can't dismantle \the [src] with these bees inside."))
			return
		to_chat(user, SPAN_NOTICE("You start dismantling \the [src]..."))
		playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
		if (do_after(user, (I.toolspeed * 3) SECONDS, src, DO_PUBLIC_UNIQUE))
			user.visible_message(SPAN_NOTICE("\The [user] dismantles \the [src]."), SPAN_NOTICE("You dismantle \the [src]."))
			new /obj/item/beehive_assembly(loc)
			qdel(src)
		return

/obj/machinery/beehive/physical_attack_hand(mob/user)
	if(!closed)
		. = TRUE
		if(honeycombs < 100)
			to_chat(user, SPAN_NOTICE("There are no filled honeycombs."))
			return
		if(!smoked && bee_count)
			to_chat(user, SPAN_NOTICE("The bees won't let you take the honeycombs out like this, smoke them first."))
			return
		user.visible_message(SPAN_NOTICE("\The [user] starts taking the honeycombs out of \the [src]."), SPAN_NOTICE("You start taking the honeycombs out of \the [src]..."))
		while (honeycombs >= 100 && do_after(user, 3 SECONDS, src, DO_PUBLIC_UNIQUE))
			new /obj/item/honey_frame/filled(loc)
			honeycombs -= 100
			--frames
		update_icon()
		if(honeycombs < 100)
			to_chat(user, SPAN_NOTICE("You take all filled honeycombs out."))

/obj/machinery/beehive/Process()
	if(closed && !smoked && bee_count)
		pollinate_flowers()
		update_icon()
	smoked = max(0, smoked - 1)
	if(!smoked && bee_count)
		bee_count = min(bee_count * 1.005, 100)
		update_icon()

/obj/machinery/beehive/proc/pollinate_flowers()
	var/coef = bee_count / 100
	var/trays = 0
	for(var/obj/machinery/portable_atmospherics/hydroponics/H in view(7, src))
		if(H.seed && !H.dead)
			H.health += 0.05 * coef
			++trays
	honeycombs = min(honeycombs + 0.1 * coef * min(trays, 5), frames * 100)

/obj/machinery/honey_extractor
	name = "honey extractor"
	desc = "A machine used to extract honey and wax from a beehive frame."
	icon = 'icons/obj/virology.dmi'
	icon_state = "centrifuge"
	anchored = TRUE
	density = TRUE
	construct_state = /singleton/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0

	machine_name = "honey extractor"
	machine_desc = "Extracts liquid honey and solid blocks of wax from filled beehive frames. Requires an attached reagent container to operate."

	var/processing = 0
	var/honey = 0

/obj/machinery/honey_extractor/components_are_accessible(path)
	return !processing && ..()

/obj/machinery/honey_extractor/cannot_transition_to(state_path, mob/user)
	if(processing)
		return SPAN_NOTICE("You must wait for \the [src] to finish first!")
	return ..()

/obj/machinery/honey_extractor/attackby(obj/item/I, mob/user)
	if(processing)
		to_chat(user, SPAN_NOTICE("\The [src] is currently spinning, wait until it's finished."))
		return
	if((. = component_attackby(I, user)))
		return
	if(istype(I, /obj/item/honey_frame))
		var/obj/item/honey_frame/H = I
		if(!H.honey)
			to_chat(user, SPAN_NOTICE("\The [H] is empty, put it into a beehive."))
			return
		user.visible_message(SPAN_NOTICE("\The [user] loads \the [H] into \the [src] and turns it on."), SPAN_NOTICE("You load \the [H] into \the [src] and turn it on."))
		processing = H.honey
		icon_state = "centrifuge_moving"
		qdel(H)
		spawn(50)
			new /obj/item/honey_frame(loc)
			new /obj/item/stack/wax(loc)
			honey += processing
			processing = 0
			icon_state = "centrifuge"
	else if(istype(I, /obj/item/reagent_containers/glass))
		if(!honey)
			to_chat(user, SPAN_NOTICE("There is no honey in \the [src]."))
			return
		var/obj/item/reagent_containers/glass/G = I
		var/transferred = min(G.reagents.maximum_volume - G.reagents.total_volume, honey)
		G.reagents.add_reagent(/datum/reagent/nutriment/honey, transferred)
		honey -= transferred
		user.visible_message(SPAN_NOTICE("\The [user] collects honey from \the [src] into \the [G]."), SPAN_NOTICE("You collect [transferred] units of honey from \the [src] into \the [G]."))
		return 1

/obj/item/bee_smoker
	name = "bee smoker"
	desc = "A device used to calm down bees before harvesting honey."
	icon = 'icons/obj/batterer.dmi'
	icon_state = "batterer"
	w_class = ITEM_SIZE_SMALL

/obj/item/honey_frame
	name = "beehive frame"
	desc = "A frame for the beehive that the bees will fill with honeycombs."
	icon = 'icons/obj/beekeeping.dmi'
	icon_state = "honeyframe"
	w_class = ITEM_SIZE_SMALL

	var/honey = 0

/obj/item/honey_frame/filled
	name = "filled beehive frame"
	desc = "A frame for the beehive that the bees have filled with honeycombs."
	honey = 20

/obj/item/honey_frame/filled/New()
	..()
	overlays += "honeycomb"

/obj/item/beehive_assembly
	name = "beehive assembly"
	desc = "Contains everything you need to build a beehive."
	icon = 'icons/obj/apiary_bees_etc.dmi'
	icon_state = "apiary"

/obj/item/beehive_assembly/attack_self(mob/user)
	to_chat(user, SPAN_NOTICE("You start assembling \the [src]..."))
	if (do_after(user, 3 SECONDS, src, DO_PUBLIC_UNIQUE))
		user.visible_message(SPAN_NOTICE("\The [user] constructs a beehive."), SPAN_NOTICE("You construct a beehive."))
		new /obj/machinery/beehive(get_turf(user))
		qdel(src)

/obj/item/stack/wax
	name = "wax"
	singular_name = "wax piece"
	desc = "Soft substance produced by bees. Used to make candles."
	icon = 'icons/obj/beekeeping.dmi'
	icon_state = "wax"

/obj/item/stack/wax/New()
	..()
	recipes = wax_recipes

var/global/list/datum/stack_recipe/wax_recipes = list(
	new/datum/stack_recipe/candle
)

/obj/item/bee_pack
	name = "bee pack"
	desc = "Contains a queen bee and some worker bees. Everything you'll need to start a hive!"
	icon = 'icons/obj/beekeeping.dmi'
	icon_state = "beepack"
	var/full = 1

/obj/item/bee_pack/New()
	..()
	overlays += "beepack-full"

/obj/item/bee_pack/proc/empty()
	full = 0
	name = "empty bee pack"
	desc = "A stasis pack for moving bees. It's empty."
	overlays.Cut()
	overlays += "beepack-empty"

/obj/item/bee_pack/proc/fill()
	full = initial(full)
	SetName(initial(name))
	desc = initial(desc)
	overlays.Cut()
	overlays += "beepack-full"

/obj/structure/closet/crate/hydroponics/beekeeping
	name = "beekeeping crate"
	desc = "All you need to set up your own beehive."

/obj/structure/closet/crate/hydroponics/beekeeping/New()
	..()
	new /obj/item/beehive_assembly(src)
	new /obj/item/bee_smoker(src)
	new /obj/item/honey_frame(src)
	new /obj/item/honey_frame(src)
	new /obj/item/honey_frame(src)
	new /obj/item/honey_frame(src)
	new /obj/item/honey_frame(src)
	new /obj/item/bee_pack(src)
	new /obj/item/crowbar(src)
