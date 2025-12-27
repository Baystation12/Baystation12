/obj/structure/ore_box
	icon = 'icons/obj/ore_boxes.dmi'
	icon_state = "orebox0"
	name = "ore box"
	desc = "A heavy box used for storing ore."
	density = TRUE
	material = MATERIAL_WOOD
	health_max = 200
	var/last_update = 0
	var/list/stored_ore = list()


/obj/structure/ore_box/use_tool(obj/item/tool, mob/user, list/click_params)
	// Ore - Insert ore
	if (istype(tool, /obj/item/ore))
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		update_ore_count()
		user.visible_message(
			SPAN_NOTICE("\The [user] puts \a [tool] in \the [src]."),
			SPAN_NOTICE("You put \the [tool] in \the [src].")
		)
		return TRUE

	// Storage - Bulk insert ore
	if (istype(tool, /obj/item/storage))
		var/obj/item/storage/storage = tool
		storage.hide_from(user)
		for (var/obj/item/ore/ore in storage.contents)
			storage.remove_from_storage(ore, src, TRUE)
		storage.finish_bulk_removal()
		update_ore_count()
		user.visible_message(
			SPAN_NOTICE("\The [user] empties \a [tool] into \the [src]."),
			SPAN_NOTICE("You empty \the [tool] into \the [src].")
		)
		return TRUE

	return ..()

/obj/structure/ore_box/proc/update_ore_count()
	stored_ore = list()
	for(var/obj/item/ore/O in contents)
		if(stored_ore[O.name])
			stored_ore[O.name]++
		else
			stored_ore[O.name] = 1

	last_update = world.time


/obj/structure/ore_box/attack_hand(mob/user)
	if(user.a_intent == I_HURT)
		return ..()

	if(length(contents))
		var/i = rand(1, length(contents))
		var/ore = contents[i]
		contents.Remove(i)
		update_ore_count()
		user.put_in_hands(ore)
		user.visible_message(
			SPAN_NOTICE("\The [user] takes something from \the [src]."),
			SPAN_NOTICE("You take \a [ore] from \the [src].")
		)
	else
		to_chat(user, "\The [src] is empty.")

	add_fingerprint(user)


/obj/structure/ore_box/on_death()
	visible_message(SPAN_DANGER("\The [src] is smashed apart!"))
	dismantle()


/obj/structure/ore_box/proc/dismantle()
	var/material/M = SSmaterials.get_material_by_name(material)
	if(M)
		M.place_dismantled_product(get_turf(src))
	var/i = 0
	for (var/obj/item/ore/O in contents)
		O.dropInto(loc)
		if(i++ >= 99)
			break
	qdel(src)


/obj/structure/ore_box/examine(mob/user)
	. = ..()

	// Borgs can now check contents too.
	if((!istype(user, /mob/living/carbon/human)) && (!istype(user, /mob/living/silicon/robot)))
		return

	if(!Adjacent(user)) //Can only check the contents of ore boxes if you can physically reach them.
		return

	add_fingerprint(user)

	if(!length(contents))
		to_chat(user, "It is empty.")
		return

	if(world.time > last_update + 10)
		update_ore_count()

	to_chat(user, "It holds:")
	for(var/ore in stored_ore)
		to_chat(user, "- [stored_ore[ore]] [ore]")
	return


/obj/structure/ore_box/verb/empty_box()
	set name = "Empty Ore Box"
	set category = "Object"
	set src in view(1)

	if(!istype(usr, /mob/living/carbon/human)) //Only living, intelligent creatures with hands can empty ore boxes.
		to_chat(usr, SPAN_WARNING("You are physically incapable of emptying the ore box."))
		return

	if( usr.stat || usr.restrained() )
		return

	if(!Adjacent(usr)) //You can only empty the box if you can physically reach it
		to_chat(usr, "You cannot reach the ore box.")
		return

	add_fingerprint(usr)

	if(length(contents) < 1)
		to_chat(usr, SPAN_WARNING("The ore box is empty"))
		return

	visible_message(SPAN_NOTICE("[usr] begins emptying [src]"))
	if (do_after(usr, 3 SECONDS, src, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS))
		var/i = 0
		for (var/obj/item/ore/O in contents)
			O.dropInto(loc)
			if(i++ >= 19)
				break
		if(length(contents))
			to_chat(usr, SPAN_NOTICE("You removed [i] ore from the box, but more remain."))
		else
			to_chat(usr, SPAN_NOTICE("You empty \the [src] completely."))

	update_ore_count()


/obj/structure/ore_box/ex_act(severity)
	if(severity == EX_ACT_DEVASTATING || (severity < EX_ACT_LIGHT && prob(50)))
		for (var/obj/item/ore/O in contents)
			O.ex_act(severity++)
			if(severity > EX_ACT_LIGHT)
				break
		dismantle()


/obj/structure/ore_box/flatpack
	icon_state = "orebox2"


/obj/item/flatpack/ore_box
	name = "packed ore box"
	w_class = ITEM_SIZE_NORMAL
	icon = 'icons/obj/ore_boxes.dmi'
	icon_state = "orebox2stored"
	deploy_path = /obj/structure/ore_box/flatpack
	matter = list(MATERIAL_STEEL = 15000)
