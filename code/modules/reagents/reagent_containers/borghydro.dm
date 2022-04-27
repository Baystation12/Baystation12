/obj/item/reagent_containers/borghypo
	name = "cyborg hypospray"
	desc = "An advanced chemical synthesizer and injection system, designed for heavy-duty medical equipment."
	icon = 'icons/obj/syringe.dmi'
	item_state = "hypo"
	icon_state = "borghypo"
	amount_per_transfer_from_this = 5
	volume = 30
	possible_transfer_amounts = null
	canremove = FALSE

	var/mode = 1
	var/charge_cost = 50
	var/charge_tick = 0
	var/recharge_time = 5 //Time it takes for shots to recharge (in seconds)

	var/list/reagent_ids = list(/datum/reagent/tricordrazine, /datum/reagent/inaprovaline, /datum/reagent/spaceacillin)
	var/list/reagent_volumes = list()
	var/list/reagent_names = list()

/obj/item/reagent_containers/borghypo/surgeon
	reagent_ids = list(/datum/reagent/bicaridine, /datum/reagent/dexalin, /datum/reagent/tramadol)

/obj/item/reagent_containers/borghypo/crisis
	reagent_ids = list(/datum/reagent/tricordrazine, /datum/reagent/inaprovaline, /datum/reagent/tramadol, /datum/reagent/adrenaline)

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

	if(!reagent_volumes[reagent_ids[mode]])
		to_chat(user, "<span class='warning'>The injector is empty.</span>")
		return

	var/allow = M.can_inject(user, target_zone)
	if (allow)
		if (allow == INJECTION_PORT)
			user.visible_message(SPAN_WARNING("\The [user] begins hunting for an injection port on \the [M]'s suit!"))
			if(!user.do_skilled(INJECTION_PORT_DELAY, SKILL_MEDICAL, M, do_flags = DO_MEDICAL))
				return
		to_chat(user, "<span class='notice'>You inject [M] with the injector.</span>")
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			H.custom_pain(SPAN_WARNING("You feel a tiny prick!"), 1, TRUE, H.get_organ(user.zone_sel.selecting))

		if(M.reagents)
			var/datum/reagent/R = reagent_ids[mode]
			var/should_admin_log = initial(R.should_admin_log)
			var/t = min(amount_per_transfer_from_this, reagent_volumes[reagent_ids[mode]])
			M.reagents.add_reagent(reagent_ids[mode], t)
			reagent_volumes[reagent_ids[mode]] -= t
			if (should_admin_log)
				admin_inject_log(user, M, src, reagent_ids[mode], t)
			to_chat(user, "<span class='notice'>[t] units injected. [reagent_volumes[reagent_ids[mode]]] units remaining.</span>")
	return

/obj/item/reagent_containers/borghypo/attack_self(mob/user as mob)
	var/selection = input(user, "What reagent would you like to synthesize?", name, reagent_names[mode]) as null | anything in reagent_names
	if (!selection || selection == reagent_names[mode])
		return

	for (var/i = 1 to reagent_ids.len)
		if (reagent_names[i] == selection)
			mode = i
			to_chat(user, SPAN_NOTICE("Synthesizer is now producing [selection]."))
			return

/obj/item/reagent_containers/borghypo/examine(mob/user, distance)
	. = ..()
	if(distance > 2)
		return

	var/datum/reagent/R = reagent_ids[mode]
	to_chat(user, "<span class='notice'>It is currently producing [initial(R.name)] and has [reagent_volumes[reagent_ids[mode]]] out of [volume] units left.</span>")

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

	if(!reagent_volumes[reagent_ids[mode]])
		to_chat(user, "<span class='notice'>[src] is out of this reagent, give it some time to refill.</span>")
		return

	if(!target.reagents.get_free_space())
		to_chat(user, "<span class='notice'>[target] is full.</span>")
		return

	var/t = min(amount_per_transfer_from_this, reagent_volumes[reagent_ids[mode]])
	target.reagents.add_reagent(reagent_ids[mode], t)
	reagent_volumes[reagent_ids[mode]] -= t
	to_chat(user, "<span class='notice'>You transfer [t] units of the solution to [target].</span>")
	return
