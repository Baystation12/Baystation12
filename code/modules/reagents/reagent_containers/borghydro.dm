/obj/item/weapon/reagent_containers/borghypo
	name = "cyborg hypospray"
	desc = "An advanced chemical synthesizer and injection system, designed for heavy-duty medical equipment."
	icon = 'icons/obj/syringe.dmi'
	item_state = "hypo"
	icon_state = "borghypo"
	amount_per_transfer_from_this = 5
	volume = 30
	possible_transfer_amounts = null

	var/mode = 1
	var/charge_cost = 50
	var/charge_tick = 0
	var/recharge_time = 5 //Time it takes for shots to recharge (in seconds)

	var/list/reagent_ids = list(/datum/reagent/tricordrazine, /datum/reagent/inaprovaline, /datum/reagent/spaceacillin)
	var/list/reagent_volumes = list()
	var/list/reagent_names = list()

/obj/item/weapon/reagent_containers/borghypo/surgeon
	reagent_ids = list(/datum/reagent/bicaridine, /datum/reagent/dexalin, /datum/reagent/tramadol)

/obj/item/weapon/reagent_containers/borghypo/crisis
	reagent_ids = list(/datum/reagent/tricordrazine, /datum/reagent/inaprovaline, /datum/reagent/tramadol)

/obj/item/weapon/reagent_containers/borghypo/Initialize()
	. = ..()

	for(var/T in reagent_ids)
		reagent_volumes[T] = volume
		var/datum/reagent/R = T
		reagent_names += initial(R.name)

/obj/item/weapon/reagent_containers/borghypo/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/weapon/reagent_containers/borghypo/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/weapon/reagent_containers/borghypo/Process() //Every [recharge_time] seconds, recharge some reagents for the cyborg+
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

/obj/item/weapon/reagent_containers/borghypo/attack(var/mob/living/M, var/mob/user, var/target_zone)
	if(!istype(M))
		return

	if(!reagent_volumes[reagent_ids[mode]])
		to_chat(user, "<span class='warning'>The injector is empty.</span>")
		return

	var/allow = M.can_inject(user, target_zone)
	if (allow)
		if (allow == INJECTION_PORT)
			user.visible_message(SPAN_WARNING("\The [user] begins hunting for an injection port on \the [M]'s suit!"))
			if(!user.do_skilled(INJECTION_PORT_DELAY, SKILL_MEDICAL, M))
				return
		to_chat(user, "<span class='notice'>You inject [M] with the injector.</span>")
		to_chat(M, "<span class='notice'>You feel a tiny prick!</span>")

		if(M.reagents)
			var/t = min(amount_per_transfer_from_this, reagent_volumes[reagent_ids[mode]])
			M.reagents.add_reagent(reagent_ids[mode], t)
			reagent_volumes[reagent_ids[mode]] -= t
			admin_inject_log(user, M, src, reagent_ids[mode], t)
			to_chat(user, "<span class='notice'>[t] units injected. [reagent_volumes[reagent_ids[mode]]] units remaining.</span>")
	return

/obj/item/weapon/reagent_containers/borghypo/attack_self(mob/user as mob) //Change the mode
	var/t = ""
	for(var/i = 1 to reagent_ids.len)
		if(t)
			t += ", "
		if(mode == i)
			t += "<b>[reagent_names[i]]</b>"
		else
			t += "<a href='?src=\ref[src];reagent_index=[i]'>[reagent_names[i]]</a>"
	t = "Available reagents: [t]."
	to_chat(user, t)

	return

/obj/item/weapon/reagent_containers/borghypo/OnTopic(var/href, var/list/href_list)
	if(href_list["reagent_index"])
		var/index = text2num(href_list["reagent_index"])
		if(index > 0 && index <= reagent_ids.len)
			playsound(loc, 'sound/effects/pop.ogg', 50, 0)
			mode = index
			var/datum/reagent/R = reagent_ids[mode]
			to_chat(usr, "<span class='notice'>Synthesizer is now producing '[initial(R.name)]'.</span>")
		return TOPIC_REFRESH

/obj/item/weapon/reagent_containers/borghypo/examine(mob/user, distance)
	. = ..()
	if(distance > 2)
		return

	var/datum/reagent/R = reagent_ids[mode]
	to_chat(user, "<span class='notice'>It is currently producing [initial(R.name)] and has [reagent_volumes[reagent_ids[mode]]] out of [volume] units left.</span>")

/obj/item/weapon/reagent_containers/borghypo/service
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

/obj/item/weapon/reagent_containers/borghypo/service/attack(var/mob/M, var/mob/user)
	return

/obj/item/weapon/reagent_containers/borghypo/service/afterattack(var/obj/target, var/mob/user, var/proximity)
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
