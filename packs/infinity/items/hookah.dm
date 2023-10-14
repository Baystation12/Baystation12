/obj/item/hookah
	name = "Hookah"
	icon = 'packs/infinity/icons/obj/items.dmi'
	desc = "A hookah with a jar of water at the bottom. AMOUNT tubes come out through it."
	w_class = ITEM_SIZE_LARGE
	icon_state = "hookah"
	randpixel = 0
	matter = list(MATERIAL_IRON = 65)
	var/liquid_level = 0
	var/liquid_type = /datum/reagent/water
	var/max_liquid_level = 120
	var/smoketime = 0
	var/maxsmoketime = 500 SECONDS
	var/chem_volume = 50
	var/lit = FALSE
	var/tubes_amount = 3
	var/list/tubes = list()
	var/list/tubes_archive = list()
	var/genericmes = "USER lights NAME with the FLAME."
	var/matchmes = "USER lights NAME with the FLAME."
	var/lightermes = "USER manages to light NAME with FLAME."
	var/zippomes = "With much care, USER lights NAME with FLAME."
	var/weldermes = "USER recklessly lights NAME with FLAME."
	var/ignitermes = "USER fiddles with FLAME, and manages to light NAME with the power of science."
	var/list/filling
	var/gas_consumption = 0.04
	var/list/coal_status_examine_msg = list("There is very little coal inside", "It's quarter-full of coal", "It's half full of coal", "It's almost full of coal", "It's full of coal")

/obj/item/tube
	name = "Hookah tube"
	desc = "Large tube connected to the hookah"
	icon_state = "hookah_tube"
	icon = 'packs/infinity/icons/obj/items.dmi'
	w_class = ITEM_SIZE_NO_CONTAINER
	throw_range = 0
	var/obj/item/hookah/parent

/obj/item/coal
	name = "Coal"
	desc = "Coal used in hookah's for heat"
	w_class = ITEM_SIZE_SMALL
	icon = 'packs/infinity/icons/obj/items.dmi'
	icon_state = "coal"
	var/volume = 500

/obj/item/storage/box/large/coal
	name = "coal for hookah"
	desc = "A box with coals for a hookah."
	icon_state = "largebox"
	startswith = list(/obj/item/coal = 10)
	can_hold = list(/obj/item/coal)
	w_class = ITEM_SIZE_LARGE
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = DEFAULT_LARGEBOX_STORAGE
	use_sound = 'sound/effects/storage/box.ogg'

/obj/item/hookah/Initialize()
	. = ..()
	atom_flags |= ATOM_FLAG_NO_REACT // so it doesn't react until you light it
	create_reagents(chem_volume) // making the cigarrete a chemical holder with a maximum volume of 100
	desc = replacetext(desc, "AMOUNT", "[tubes_amount]")
	var/obj/item/tube/T
	for(var/i in 1 to tubes_amount)
		T = new(src)
		tubes.Add(T)
		tubes_archive.Add(T)
	for(var/R in filling)
		reagents.add_reagent(R, filling[R])
	update_icon()

/obj/item/tube/New(obj/item/hookah/W)
	parent = W
	. = ..()

/obj/item/hookah/Move()
	. = ..()
	for(var/obj/item/tube/T in tubes_archive)
		T.check_exited()

/obj/item/tube/Move()
	. = ..()
	check_exited()

/obj/item/hookah/dropped(mob/user)
	. = ..()
	for(var/obj/item/tube/T in tubes_archive)
		T.check_exited()

/obj/item/tube/dropped(mob/user)
	GLOB.moved_event.unregister(user, src, /obj/item/tube/proc/check_exited)
	. = ..()
	check_exited()

/obj/item/hookah/throw_impact(atom/hit_atom)
	if(QDELETED(src))
		return
	if(length(reagents.reagent_list) > 0)
		reagents.splash(hit_atom, reagents.total_volume)
	visible_message(
		SPAN_DANGER("\The [src] shatters from the impact!"),
		SPAN_DANGER("You hear the sound of glass shattering!")
	)
	playsound(src.loc, pick(GLOB.shatter_sound), 100)
	new /obj/item/material/shard(src.loc)
	qdel(src)

/obj/item/hookah/on_update_icon()
	icon_state = initial(icon_state)
	if(!liquid_level)
		icon_state += "_empty"
	if(lit)
		icon_state += "_work"
	. = ..()

/obj/item/hookah/examine(mob/user, distance)
	. = ..()
	to_chat(user, lit ? "It looks lit up" : "It looks unlit")
	if(distance <= 1)
		to_chat(user, smoketime < 500 ? SPAN_WARNING("There is no coal inside") : coal_status_examine_msg[round(smoketime/(maxsmoketime/5), 1)])
		to_chat(user, reagents.total_volume > 0 ? "There's tobacco inside" : SPAN_WARNING("There is no tobacco inside"))
		to_chat(user, liquid_level > 0 ? "There's some water inside" : SPAN_WARNING("There is no water inside"))

/obj/item/hookah/proc/extinguish(mob/user, no_message = FALSE)
	if(!no_message && !user)
		visible_message(SPAN_INFO("Hookah stops smoking."))
	else if (!no_message)
		user.visible_message(SPAN_INFO("[user] extinguishes the hookah"))
	lit = FALSE
	update_icon()
	remove_extension(src, /datum/extension/scent)
	STOP_PROCESSING(SSobj, src)

/obj/item/hookah/verb/turnoff()
	set src in view(1)
	set category = "Object"
	set name = "Extinguish"
	set desc = "Extinguish the hookah"
	if(!lit)
		to_chat(usr, SPAN_WARNING("You can't put out what's not lit."))
		return TRUE
	extinguish(usr)

/obj/item/hookah/Process()
	if(smoketime < 1)
		extinguish()
		return TRUE
	smoketime -= 1

/obj/item/hookah/use_tool(obj/item/tool, mob/user)
	if(isFlameOrHeatSource(tool))
		var/text = matchmes
		if(istype(tool, /obj/item/flame/match))
			text = matchmes
		else if(istype(tool, /obj/item/flame/lighter/zippo))
			text = zippomes
		else if(istype(tool, /obj/item/flame/lighter))
			text = lightermes
		else if(isWelder(tool))
			text = weldermes
		else if(istype(tool, /obj/item/device/assembly/igniter))
			text = ignitermes
		else
			text = genericmes
		text = replacetext(text, "USER", "[user]")
		text = replacetext(text, "NAME", "[name]")
		text = replacetext(text, "FLAME", "[tool.name]")
		light(text)
		return TRUE

	else if(istype(tool, /obj/item/tube))
		var/obj/item/tube/T = tool
		if(T.parent != src)
			to_chat(user, SPAN_WARNING("This tube is not from this hookah."))
			return TRUE
		tubes.Add(T)
		user.unEquip(T, src)
		GLOB.moved_event.unregister(user, T, /obj/item/tube/proc/check_exited)
		to_chat(user, SPAN_INFO("You put the tube back in the hookah."))
		return TRUE

	else if(istype(tool, /obj/item/coal))
		var/obj/item/coal/M = tool
		if(smoketime + M.volume > maxsmoketime)
			to_chat(user, SPAN_WARNING("The hookah is already full of coal."))
			return TRUE
		smoketime += M.volume
		qdel(M)
		user.visible_message(SPAN_INFO("[user] adds some coal to the hookah."), SPAN_INFO("You added coal to the hookah."))
		return TRUE

	else if(istype(tool, /obj/item/reagent_containers/food/snacks/grown/dried_tobacco))
		if(tool.reagents)
			tool.reagents.trans_to_obj(src, tool.reagents.total_volume)
			user.unEquip(tool, src)
			user.visible_message(SPAN_INFO("[user] put tobacco in the hookah."), SPAN_INFO("You put tobacco in the hookah."))
			qdel(tool)
			return TRUE

/*	else if(istype(tool, /obj/item/storage/box/large/coal))			// Я заметил, что в оригинальном коде при нажатии коробкой с углём по калику последний заполнялся до максимума вне зависимости от кол-ва угля в коробке.
		var/obj/item/storage/box/large/coal/box = tool				// Я попытался это исправить. Теперь при нажатии коробкой по калику сервер взрывается. Отныне коробка с углём будет просто контейнером.
		for(var/obj/i in box.contents)								// Я хочу умереть.
			qdel(box.contents[i])									// Не повторяйте моих ошибок.
			smoketime += 500
		src.visible_message(SPAN_INFO("[user] puts coal in the hookah"), SPAN_INFO("You put coal in the hookah"))
		return TRUE	*/

	else if(istype(tool, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/container_obj = tool
		var/datum/reagents/container = container_obj.reagents
		if(!container_obj.is_open_container())
			return TRUE
		if(!container.has_reagent(liquid_type))
			to_chat(user, SPAN_WARNING("This liquid is not appropriate for use in hookahs."))
			return TRUE
		var/transfer_value = min(min(container.get_reagent_amount(liquid_type), container_obj.amount_per_transfer_from_this), max_liquid_level-liquid_level)
		if(transfer_value<=0)
			to_chat(user, SPAN_WARNING("You can't pour any more water in the hpokah."))
			return TRUE
		container.remove_reagent(liquid_type, transfer_value)
		liquid_level += transfer_value
		playsound(src.loc,'sound/effects/pour.ogg',50,-1)
		src.visible_message(SPAN_INFO("[user] filled a hookah from a [container_obj]."))
		update_icon()
		return TRUE

	return ..()

/obj/item/hookah/attack_hand(mob/user)
	if(user.a_intent == I_GRAB)
		return ..()
	if(length(tubes) <= 0)
		to_chat(user, SPAN_WARNING("There are no tubes left to take."))
		return TRUE
	var/obj/item/tube/T = tubes[1]
	if(!user.put_in_active_hand(T))
		to_chat(user, SPAN_WARNING("Your active hand must be empty!"))
		return TRUE
	GLOB.moved_event.register(user, T, /obj/item/tube/proc/check_exited)
	tubes.Remove(T)
	to_chat(user, SPAN_INFO("You take the smoking tube."))

/obj/item/tube/attack_hand(mob/user)
	. = ..()
	if(!check_exited())
		GLOB.moved_event.register(user, src, /obj/item/tube/proc/check_exited)

/obj/item/tube/attack(mob/living/carbon/human/H, mob/user, def_zone)
	if(!parent.lit)
		to_chat(user, SPAN_WARNING("You try to take a drag from the tube but nothing happens. Looks like the hookah isn't lit."))
		return FALSE
	if(H == user && istype(H) && H.check_has_mouth())
		var/obj/item/blocked = H.check_mouth_coverage()
		if(blocked)
			to_chat(H, SPAN_WARNING("\The [blocked] is in the way!"))
			return TRUE
		to_chat(H, SPAN_INFO("You take a drag on your [name]."))
		if(parent.liquid_level <= 0)
			to_chat(user, SPAN_WARNING("It looks like the water has run out."))
			return FALSE
		playsound(H.loc, pick('packs/infinity/sound/effects/hookah.ogg', 'packs/infinity/sound/effects/hookah1.ogg'), 50, 0, -1)
		smoke(5, user)
		return TRUE
	return ..()

/obj/item/hookah/proc/light(flavor_text)
	if(lit || !smoketime)
		return TRUE
	if(submerged())
		to_chat(usr, SPAN_WARNING("You cannot light \the [src] underwater."))
		return TRUE
	lit = TRUE
	damtype = "burn"
	var/turf/T = get_turf(src)
	if (flavor_text)
		T.visible_message(SPAN_INFO(flavor_text))
	update_icon()
	START_PROCESSING(SSobj, src)
	set_scent_by_reagents(src)
	playsound(src.loc, 'packs/infinity/sound/effects/hookah_lit.ogg',50, 0, -1)

/obj/item/hookah/Destroy()
	. = ..()
	if(lit)
		STOP_PROCESSING(SSobj, src)
	for(var/obj/item/tube/T as anything in tubes_archive)
		qdel(T)

/obj/item/tube/Destroy()
	if(istype(loc, /mob/living))
		GLOB.moved_event.unregister(loc, src, /obj/item/tube/proc/check_exited)
	. = ..()

/obj/item/hookah/water_act(depth)
	..()
	if(!waterproof && lit)
		if(submerged(depth))
			extinguish(no_message = TRUE)

/obj/item/tube/proc/check_exited()
	var/turf/hookah_pos = get_turf(parent)
	var/turf/mover_pos = get_turf(src)
	if((hookah_pos != mover_pos && get_dist(mover_pos, hookah_pos) > 1) || (!isturf(parent.loc) && (parent.loc != src.loc) && !(src in parent.tubes)))
		if(iscarbon(loc))
			var/mob/living/carbon/M = loc
			visible_message(SPAN_WARNING("The tube was placed back to the hookah by [loc] as they were walking away."))
			M.unEquip(src, parent)
			GLOB.moved_event.unregister(loc, src, /obj/item/tube/proc/check_exited)
		else
			visible_message(SPAN_WARNING("The tube magically flies back to the hookah. Woah."))
			parent.contents.Add(src)
		parent.tubes.Add(src)
		return TRUE
	return FALSE

/obj/item/tube/proc/smoke(amount, mob/user)
	parent.smoketime -= amount
	parent.liquid_level = max(parent.liquid_level-1, 0)
	if(parent.liquid_level <= 0)
		parent.update_icon()
	if(parent.reagents.total_volume) // check if it has any reagents at all
		parent.reagents.trans_to_mob(user, REM, CHEM_INGEST, 0.2)
		add_trace_DNA(user)
	else
		to_chat(usr, SPAN_WARNING("The tobacco is gone and all you can feel in your mouth is plain smoke."))
		return TRUE
	var/turf/T = get_turf(src)
	if(T)
		var/datum/gas_mixture/environment = T.return_air()
		if(environment.get_by_flag(XGM_GAS_OXIDIZER) < parent.gas_consumption)
			parent.extinguish()
		else
			environment.remove_by_flag(XGM_GAS_OXIDIZER, parent.gas_consumption)
			environment.adjust_gas(GAS_CO2, 0.5*parent.gas_consumption, 0)
			environment.adjust_gas(GAS_STEAM, 0.5*parent.gas_consumption, 0)
			var/datum/effect/steam_spread/steam = new /datum/effect/steam_spread()
			steam.set_up(3, usr.dir, usr.loc)
			steam.start()
