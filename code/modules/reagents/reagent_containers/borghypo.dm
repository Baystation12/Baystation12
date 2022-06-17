/obj/item/reagent_containers/borghypo
	name = "robot hypospray"
	desc = "An advanced chemical synthesizer and injection system, designed for heavy-duty medical equipment."
	icon = 'icons/obj/syringe.dmi'
	item_state = "hypo"
	icon_state = "borghypo"
	amount_per_transfer_from_this = 5
	volume = 30
	possible_transfer_amounts = null
	canremove = FALSE

	/// Numeric index of the synthesizer in use, or 0 if dispensing from an external container
	var/mode = 1
	var/weakref/dispense = null
	var/charge_cost = 50
	var/charge_tick = 0
	var/recharge_time = 5 //Time it takes for shots to recharge (in seconds)

	var/list/reagent_ids = list(/datum/reagent/tricordrazine, /datum/reagent/inaprovaline, /datum/reagent/spaceacillin)
	var/list/reagent_volumes = list()
	var/list/reagent_names = list()

/obj/item/reagent_containers/borghypo/surgeon
	reagent_ids = list(/datum/reagent/inaprovaline, /datum/reagent/bicaridine, /datum/reagent/dexalin, /datum/reagent/tramadol)

/obj/item/reagent_containers/borghypo/crisis
	reagent_ids = list(/datum/reagent/inaprovaline, /datum/reagent/dylovene, /datum/reagent/dexalin, /datum/reagent/tramadol, /datum/reagent/adrenaline)

/obj/item/reagent_containers/borghypo/Initialize()
	. = ..()

	for(var/T in reagent_ids)
		reagent_volumes[T] = volume
		var/datum/reagent/R = T
		reagent_names += initial(R.name)

/obj/item/reagent_containers/borghypo/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/reagent_containers/borghypo/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/reagent_containers/borghypo/Process() //Every [recharge_time] seconds, recharge some reagents for the cyborg+
	if(++charge_tick < recharge_time)
		return 0
	charge_tick = 0

	if(isrobot(loc))
		var/mob/living/silicon/robot/R = loc
		if(R && R.cell)
			for(var/T in reagent_ids)
				if(reagent_volumes[T] < volume)
					R.cell.use(charge_cost)
					reagent_volumes[T] = min(reagent_volumes[T] + 5, volume)
	return 1

/obj/item/reagent_containers/borghypo/attack(var/mob/living/M, var/mob/user, var/target_zone)
	if(!istype(M))
		return

	if(mode && !reagent_volumes[reagent_ids[mode]])
		to_chat(user, SPAN_WARNING("\The [src] is empty."))
		return
	var/obj/item/reagent_containers/container = null
	if (!mode)
		container = dispense.resolve()
		if (!valid_container(user, container))
			to_chat(user, SPAN_WARNING("Can't find the container to dispense from."))
			return
		if (!container.reagents?.total_volume)
			to_chat(user, SPAN_WARNING("\The [container] is empty."))

	var/allow = M.can_inject(user, target_zone)
	if (allow)
		if (allow == INJECTION_PORT)
			user.visible_message(SPAN_WARNING("\The [user] begins hunting for an injection port on \the [M]'s suit!"))
			if(!user.do_skilled(INJECTION_PORT_DELAY, SKILL_MEDICAL, M, do_flags = DO_MEDICAL))
				return
		to_chat(user, SPAN_NOTICE("You inject [M] with the injector."))
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			H.custom_pain(SPAN_WARNING("You feel a tiny prick!"), 1, TRUE, H.get_organ(user.zone_sel.selecting))

		if(M.reagents)
			if (mode)
				var/datum/reagent/R = reagent_ids[mode]
				var/should_admin_log = initial(R.should_admin_log)
				var/transferred = min(amount_per_transfer_from_this, reagent_volumes[R])
				M.reagents.add_reagent(R, transferred)
				reagent_volumes[R] -= transferred
				if (should_admin_log)
					admin_inject_log(user, M, src, R, transferred)
				to_chat(user, SPAN_NOTICE("[transferred] units injected. [reagent_volumes[R]] units remaining."))
			else
				var/datum/reagents/R = container.reagents
				var/should_admin_log = R.should_admin_log()
				var/contained = R.get_reagents()
				var/transferred = R.trans_to_mob(M, amount_per_transfer_from_this, CHEM_BLOOD)
				if (should_admin_log)
					admin_inject_log(user, M, src, contained, transferred)
				to_chat(user, SPAN_NOTICE("[transferred] units injected. [R.total_volume] units remaining in \the [container]."))
	return

/obj/item/reagent_containers/borghypo/attack_self(mob/user as mob)
	ui_interact(user)

/obj/item/reagent_containers/borghypo/examine(mob/user, distance)
	. = ..()
	if(distance > 2)
		return

	if (mode)
		var/datum/reagent/R = reagent_ids[mode]
		to_chat(user, SPAN_NOTICE("It is currently producing [initial(R.name)] and has [reagent_volumes[R]] out of [volume] units left."))
	else
		var/obj/item/reagent_containers/container = dispense.resolve()
		if (istype(container))
			var/datum/reagents/R = container.reagents
			if (istype(R))
				to_chat(user, SPAN_NOTICE("It is currently dispensing from \the [container] which has [R.total_volume] out of [R.maximum_volume] units left."))
				return
		to_chat(user, SPAN_WARNING("It is currently empty."))

/obj/item/reagent_containers/borghypo/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = TRUE)
	var/data = list()
	data["selected"] = mode ? reagent_names[mode] : dispense.ref
	data["synthReagents"] = reagent_names
	data["bottles"] = list()

	var/list/bottles = list()

	var/mob/living/silicon/robot/robot = loc
	if (istype(robot))
		var/list/equipment = robot.module.equipment
		for (var/obj/item/reagent_containers/glass/container in equipment)
			// Will pick up on any containers directly in the loadout, like buckets and legacy robot bottles
			bottles += container
		for (var/obj/item/robot_rack/bottle/rack in equipment)
			// Append contents
			bottles += rack.held
		for (var/obj/item/gripper/gripper in equipment)
			// If the gripper's holding a container, add it in
			if (istype(gripper.wrapped, /obj/item/reagent_containers/glass))
				bottles += gripper.wrapped

	for (var/obj/item/reagent_containers/bottle in bottles)
		var/iconPath = "bottle-\ref[bottle].png"
		var/icon/flatIcon = getFlatIcon(bottle)
		flatIcon.Scale(64, 64) // Scale to avoid blurring in the browser
		send_rsc(user, flatIcon, iconPath)
		data["bottles"] += list(list( // It's completely ridiculous that this double list thing is necessary
			"id" = ref(bottle),
			"icon" = iconPath,
			"name" = bottle.label_text || bottle.name,
			"total_volume" = bottle.reagents ? bottle.reagents.total_volume : 0,
			"maximum_volume" = bottle.reagents ? bottle.reagents.maximum_volume : 0
		))

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		var/nbottles = length(bottles)
		var/width = max(330, nbottles * 165)
		var/height = min(600, 240 + 10 * length(reagent_ids))
		ui = new(user, src, ui_key, "borghypo.tmpl", name, width, height)
		ui.set_initial_data(data)
		ui.open()
		ui.auto_update_layout = TRUE
		ui.set_auto_update(TRUE)

/obj/item/reagent_containers/borghypo/OnTopic(mob/user, list/href_list, datum/topic_state/state)
	var/selection = href_list["selected"]

	var/obj/item/reagent_containers/bottle = locate(selection)
	if (istype(bottle))
		if (valid_container(user, bottle))
			mode = 0
			dispense = weakref(bottle)
			to_chat(user, SPAN_NOTICE("Dispensing from \the [bottle]."))
		return TOPIC_REFRESH

	var/index = list_find(reagent_names, selection)
	if (index)
		mode = index
		dispense = null
		to_chat(user, SPAN_NOTICE("Synthesizer is now producing [selection]."))
		return TOPIC_REFRESH

	return TOPIC_NOACTION

/**
* Check the bottle is still accessible.
* Valid places the bottle could be:
* * in the robot's active modules (loc == user)
* * in the robot's inactive modules (loc == user.module)
* * in a rack or gripper in either of these places
*/
/obj/item/reagent_containers/borghypo/proc/valid_container(mob/user, obj/item/reagent_containers/container)
	var/mob/living/silicon/robot/robot = user
	return istype(container) && (container.loc == user || container.loc.loc == user || istype(robot) && container.loc.loc == robot.module)

/obj/item/reagent_containers/borghypo/service
	name = "cyborg drink synthesizer"
	desc = "A portable drink dispencer."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "shaker"
	charge_cost = 5
	recharge_time = 3
	volume = 60
	possible_transfer_amounts = "5;10;20;30"
	reagent_ids = list(
		/datum/reagent/ethanol/beer,
		/datum/reagent/ethanol/coffee/kahlua,
		/datum/reagent/ethanol/whiskey,
		/datum/reagent/ethanol/wine,
		/datum/reagent/ethanol/vodka,
		/datum/reagent/ethanol/gin,
		/datum/reagent/ethanol/rum,
		/datum/reagent/ethanol/tequilla,
		/datum/reagent/ethanol/vermouth,
		/datum/reagent/ethanol/cognac,
		/datum/reagent/ethanol/ale,
		/datum/reagent/ethanol/mead,
		/datum/reagent/water,
		/datum/reagent/sugar,
		/datum/reagent/drink/ice,
		/datum/reagent/drink/tea,
		/datum/reagent/drink/tea/icetea,
		/datum/reagent/drink/space_cola,
		/datum/reagent/drink/spacemountainwind,
		/datum/reagent/drink/dr_gibb,
		/datum/reagent/drink/space_up,
		/datum/reagent/drink/tonic,
		/datum/reagent/drink/sodawater,
		/datum/reagent/drink/lemon_lime,
		/datum/reagent/drink/juice/orange,
		/datum/reagent/drink/juice/lime,
		/datum/reagent/drink/juice/watermelon,
		/datum/reagent/drink/coffee,
		/datum/reagent/drink/hot_coco,
		/datum/reagent/drink/tea/green,
		/datum/reagent/drink/spacemountainwind,
		/datum/reagent/ethanol/beer,
		/datum/reagent/ethanol/coffee/kahlua
		)

/obj/item/reagent_containers/borghypo/service/attack(var/mob/M, var/mob/user)
	return

/obj/item/reagent_containers/borghypo/service/afterattack(var/obj/target, var/mob/user, var/proximity)
	if(!proximity)
		return

	if(!target.is_open_container() || !target.reagents)
		return

	if(!target.reagents.get_free_space())
		to_chat(user, SPAN_WARNING("[target] is full."))
		return

	if (mode)
		var/datum/reagent/R = reagent_ids[mode]
		if(!reagent_volumes[R])
			to_chat(user, SPAN_WARNING("[src] is out of this reagent, give it some time to refill."))
			return
		var/transferred = min(amount_per_transfer_from_this, reagent_volumes[R])
		target.reagents.add_reagent(R, transferred)
		reagent_volumes[R] -= transferred
		to_chat(user, SPAN_NOTICE("You transfer [transferred] units of the solution to [target]."))
	else
		var/obj/item/reagent_containers/container = dispense.resolve()
		if (!valid_container(user, container))
			to_chat(user, SPAN_WARNING("Can't find the container to dispense from."))
			return
		var/datum/reagents/R = container.reagents
		if (!R || !R.total_volume)
			to_chat(user, SPAN_WARNING("\The [container] is empty."))
		var/transferred = R.trans_to_holder(target.reagents, amount_per_transfer_from_this)
		to_chat(user, "You transfer [transferred] units of the solution to [target].")


/obj/item/robot_rack/bottle
	name = "bottle rack"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-1"
	object_type = /obj/item/reagent_containers/glass/bottle
	capacity = 4
	attack_self_on_deploy = FALSE // Don't open/close bottles on deploy

// Hint that the hypo can use the bottle rack's contents
/obj/item/robot_rack/bottle/examine(mob/user)
	. = ..()
	var/mob/living/silicon/robot/R = user
	if (istype(R))
		var/obj/item/reagent_containers/borghypo/hypo = locate() in R.module.equipment
		if (istype(hypo))
			to_chat(user, "Its contents are available to \the [hypo].")

// Extra message for if you try to pick up beakers
/obj/item/robot_rack/bottle/resolve_attackby(obj/O, mob/user, click_params)
	if (!istype(O, object_type) && istype(O, /obj/item/reagent_containers/glass))
		to_chat(user, SPAN_WARNING("\The [O] is the wrong shape for \the [src]."))
		return
	. = ..()
