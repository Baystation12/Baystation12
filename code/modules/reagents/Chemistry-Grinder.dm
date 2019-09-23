/obj/machinery/reagentgrinder
	name = "reagent grinder"
	desc = "An industrial reagent grinder with heavy carbide cutting blades."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "rgrinder"
	layer = BELOW_OBJ_LAYER
	density = TRUE
	anchored = TRUE
	idle_power_usage = 5
	active_power_usage = 100
	obj_flags = OBJ_FLAG_ANCHORABLE

	var/inuse = 0
	var/obj/item/weapon/reagent_containers/beaker = null
	var/limit = 10
	var/list/holdingitems = list()

	var/list/bag_whitelist = list(
		/obj/item/weapon/storage/pill_bottle,
		/obj/item/weapon/storage/plants)
	var/blacklisted_types = list()
	var/item_size_limit = ITEM_SIZE_HUGE
	var/skill_to_check = SKILL_CHEMISTRY
	var/grind_sound = 'sound/machines/grinder.ogg'

/obj/machinery/reagentgrinder/New()
	..()
	beaker = new /obj/item/weapon/reagent_containers/glass/beaker/large(src)
	update_icon()

/obj/machinery/reagentgrinder/on_update_icon()
	if(inuse)
		icon_state = "[initial(icon_state)]_grinding"
		return
	if(beaker)
		icon_state = "[initial(icon_state)]_beaker"
	else
		icon_state = "[initial(icon_state)]"

/obj/machinery/reagentgrinder/attackby(var/obj/item/O as obj, var/mob/user as mob)

	if (istype(O,/obj/item/weapon/reagent_containers/glass) || \
		istype(O,/obj/item/weapon/reagent_containers/food/drinks/glass2) || \
		istype(O,/obj/item/weapon/reagent_containers/food/drinks/shaker))

		if (beaker)
			return 1
		else
			if(!user.unEquip(O, src))
				return
			src.beaker =  O
			update_icon()
			src.updateUsrDialog()
			return 0

	if(is_type_in_list(O, blacklisted_types))
		to_chat(user, SPAN_NOTICE("\The [src] cannot grind \the [O]."))
		return

	if(is_type_in_list(O, bag_whitelist))
		var/obj/item/weapon/storage/bag = O
		var/failed = 1
		for(var/obj/item/G in O)
			if(!G.reagents || !G.reagents.total_volume)
				continue
			failed = 0
			bag.remove_from_storage(G, src, 1)
			holdingitems += G
			if(holdingitems && holdingitems.len >= limit)
				break

		if(failed)
			to_chat(user, SPAN_NOTICE("Nothing in \the [O] is usable."))
			return 1
		bag.finish_bulk_removal()

		if(!O.contents.len)
			to_chat(user, "You empty \the [O] into \the [src].")
		else
			to_chat(user, "You fill \the [src] from \the [O].")

		src.updateUsrDialog()
		return 0
	
	if(O.w_class > item_size_limit)
		to_chat(user, SPAN_NOTICE("\The [src] cannot fit \the [O]."))
		return

	if(holdingitems && holdingitems.len >= limit)
		to_chat(user, SPAN_NOTICE("\The [src] cannot hold any additional items."))
		return 1

	if(!istype(O))
		return

	if(istype(O,/obj/item/stack/material))
		var/obj/item/stack/material/stack = O
		var/material/material = stack.material
		if(!length(material.chem_products))
			to_chat(user, SPAN_NOTICE("\The [material.name] is unable to produce any usable reagents."))
			return 1

	else if(!O.reagents || !O.reagents.total_volume)
		to_chat(user, SPAN_NOTICE("\The [O] is not suitable for grinding."))
		return 1

	if(!user.unEquip(O, src))
		return
	holdingitems += O
	src.updateUsrDialog()
	return 0

/obj/machinery/reagentgrinder/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/reagentgrinder/DefaultTopicState()
	return GLOB.physical_state

/obj/machinery/reagentgrinder/interact(mob/user as mob) // The microwave Menu
	if(inoperable())
		return
	user.set_machine(src)
	var/is_chamber_empty = 0
	var/is_beaker_ready = 0
	var/processing_chamber = ""
	var/beaker_contents = ""
	var/dat = list()

	if(!inuse)
		for (var/obj/item/O in holdingitems)
			processing_chamber += "\A [O.name]<BR>"

		if (!processing_chamber)
			is_chamber_empty = 1
			processing_chamber = "Nothing."
		if (!beaker)
			beaker_contents = "<B>No beaker attached.</B><br>"
		else
			is_beaker_ready = 1
			beaker_contents = "<B>The beaker contains:</B><br>"
			var/anything = 0
			for(var/datum/reagent/R in beaker.reagents.reagent_list)
				anything = 1
				beaker_contents += "[R.volume] - [R.name]<br>"
			if(!anything)
				beaker_contents += "Nothing<br>"


		dat += {"
	<b>Processing chamber contains:</b><br>
	[processing_chamber]<br>
	[beaker_contents]<hr>
	"}
		if (is_beaker_ready && !is_chamber_empty && !(stat & (NOPOWER|BROKEN)))
			dat += "<A href='?src=\ref[src];action=grind'>Process the reagents</a><BR>"
		if(holdingitems && holdingitems.len > 0)
			dat += "<A href='?src=\ref[src];action=eject'>Eject the reagents</a><BR>"
		if (beaker)
			dat += "<A href='?src=\ref[src];action=detach'>Detach the beaker</a><BR>"
	else
		dat += "Please wait..."
	dat = "<HEAD><TITLE>[name]</TITLE></HEAD><TT>[JOINTEXT(dat)]</TT>"
	show_browser(user, strip_improper(dat), "window=reagentgrinder")
	onclose(user, "reagentgrinder")

/obj/machinery/reagentgrinder/OnTopic(user, href_list)
	if(href_list["action"])
		switch(href_list["action"])
			if ("grind")
				grind(user)
			if("eject")
				eject()
			if ("detach")
				detach()
		interact(user)
		return TOPIC_REFRESH

/obj/machinery/reagentgrinder/proc/detach()
	if (!beaker)
		return
	beaker.dropInto(loc)
	beaker = null
	update_icon()

/obj/machinery/reagentgrinder/proc/eject()
	if (!holdingitems || holdingitems.len == 0)
		return

	for(var/obj/item/O in holdingitems)
		O.dropInto(loc)
		holdingitems -= O
	holdingitems.Cut()

/obj/machinery/reagentgrinder/proc/grind(mob/user)

	power_change()
	if(stat & (NOPOWER|BROKEN))
		return

	// Sanity check.
	if (!beaker || (beaker && beaker.reagents.total_volume >= beaker.reagents.maximum_volume))
		return

	attempt_skill_effect(user)
	playsound(src.loc, grind_sound, 75, 1)
	inuse = 1
	update_icon()

	// Reset the machine.
	spawn(60)
		inuse = 0
		interact(user)

	var/skill_factor = CLAMP01(1 + 0.3*(user.get_skill_value(skill_to_check) - SKILL_EXPERT)/(SKILL_EXPERT - SKILL_MIN))
	// Process.
	for (var/obj/item/O in holdingitems)

		var/remaining_volume = beaker.reagents.maximum_volume - beaker.reagents.total_volume
		if(remaining_volume <= 0)
			break

		var/obj/item/stack/material/stack = O
		if(istype(stack))
			var/material/material = stack.material
			if(!material.chem_products.len)
				break

			var/list/chem_products = material.chem_products
			var/sheet_volume = 0
			for(var/chem in chem_products)
				sheet_volume += chem_products[chem]

			var/amount_to_take = max(0,min(stack.amount,round(remaining_volume/sheet_volume)))
			if(amount_to_take)
				stack.use(amount_to_take)
				if(QDELETED(stack))
					holdingitems -= stack
				for(var/chem in chem_products)
					beaker.reagents.add_reagent(chem, (amount_to_take*chem_products[chem]*skill_factor))
				continue

		if(O.reagents)
			O.reagents.trans_to(beaker, O.reagents.total_volume, skill_factor)
			if(O.reagents.total_volume == 0)
				holdingitems -= O
				qdel(O)
			if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
				break

/obj/machinery/reagentgrinder/proc/attempt_skill_effect(mob/living/carbon/human/user)
	if(!istype(user) || !prob(user.skill_fail_chance(skill_to_check, 50, SKILL_BASIC)))
		return
	var/hand = pick(BP_L_HAND, BP_R_HAND)
	var/obj/item/organ/external/hand_organ = user.get_organ(hand)
	if(!hand_organ)
		return

	var/dam = rand(10, 15)
	user.visible_message("<span class='danger'>\The [user]'s hand gets caught in \the [src]!</span>", "<span class='danger'>Your hand gets caught in \the [src]!</span>")
	user.apply_damage(dam, BRUTE, hand, damage_flags = DAM_SHARP, used_weapon = "grinder")
	if(BP_IS_ROBOTIC(hand_organ))
		beaker.reagents.add_reagent(/datum/reagent/iron, dam)
	else
		user.take_blood(beaker, dam)
	user.Stun(2)
	addtimer(CALLBACK(src, .proc/shake, user, 40), 0)

/obj/machinery/reagentgrinder/proc/shake(mob/user, duration)
	for(var/i = 1, i<=duration, i++)
		sleep(1)
		if(!user || !Adjacent(user))
			break
		if(user.is_jittery)
			continue
		user.do_jitter(4)

	if(user && !user.is_jittery)
		user.do_jitter(0) //resets the icon.

/obj/machinery/reagentgrinder/juicer
	name = "blender"
	desc = "A high-speed combination blender/juicer."
	icon_state = "juicer"
	density = FALSE
	anchored = FALSE
	obj_flags = null
	grind_sound = 'sound/machines/juicer.ogg'
	blacklisted_types = list(/obj/item/stack/material)
	bag_whitelist = list(/obj/item/weapon/storage/plants)
	item_size_limit = ITEM_SIZE_SMALL
	skill_to_check = SKILL_COOKING

/obj/machinery/reagentgrinder/juicer/attempt_skill_effect(mob/living/carbon/human/user)
	if(!istype(user) || !prob(user.skill_fail_chance(skill_to_check, 50, SKILL_BASIC)))
		return
	visible_message(SPAN_NOTICE("\The [src] whirrs violently and spills its contents all over \the [user]!"))
	if(beaker && beaker.reagents)
		beaker.reagents.splash(user, beaker.reagents.total_volume)