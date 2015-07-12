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

	var/list/reagent_ids = list("tricordrazine", "inaprovaline", "spaceacillin")
	var/list/reagent_volumes = list()

/obj/item/weapon/reagent_containers/borghypo/surgeon
	reagent_ids = list("bicaridine", "inaprovaline", "dexalin")

/obj/item/weapon/reagent_containers/borghypo/crisis
	reagent_ids = list("tricordrazine", "inaprovaline", "tramadol")

/obj/item/weapon/reagent_containers/borghypo/New()
	..()

	for(var/R in reagent_ids)
		reagent_volumes[R] = volume

	processing_objects.Add(src)

/obj/item/weapon/reagent_containers/borghypo/Destroy()
	processing_objects.Remove(src)
	..()

/obj/item/weapon/reagent_containers/borghypo/process() //Every [recharge_time] seconds, recharge some reagents for the cyborg+
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

/obj/item/weapon/reagent_containers/borghypo/attack(var/mob/living/M, var/mob/user)
	if(!istype(M))
		return

	if(!reagent_volumes[reagent_ids[mode]])
		user << "<span class='warning'>The injector is empty.</span>"
		return

	if(M.can_inject(user, 1))
		user << "<span class='notice'>You inject [M] with the injector.</span>"
		M << "<span class='notice'>You feel a tiny prick!</span>"

		if(M.reagents)
			var/t = min(amount_per_transfer_from_this, reagent_volumes[reagent_ids[mode]])
			M.reagents.add_reagent(reagent_ids[mode], t)
			reagent_volumes[reagent_ids[mode]] -= t
			user << "<span class='notice'>[t] units injected. [reagent_volumes[reagent_ids[mode]]] units remaining.</span>"
	return

/obj/item/weapon/reagent_containers/borghypo/attack_self(mob/user as mob) //Change the mode
	playsound(loc, 'sound/effects/pop.ogg', 50, 0)
	mode++
	if(mode > reagent_ids.len)
		mode = 1

	var/datum/reagent/R = chemical_reagents_list[reagent_ids[mode]]
	user << "<span class='notice'>Synthesizer is now producing '[R.name]'.</span>"
	return

/obj/item/weapon/reagent_containers/borghypo/examine(mob/user)
	if(!..(user, 2))
		return

	var/datum/reagent/R = chemical_reagents_list[reagent_ids[mode]]

	user << "<span class='notice'>It is currently producing [R.name] and has [reagent_volumes[reagent_ids[mode]]] out of [volume] units left.</span>"

/obj/item/weapon/reagent_containers/borghypo/service
	name = "cyborg drink synthesizer"
	desc = "A portable drink dispencer."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "shaker"
	charge_cost = 20
	recharge_time = 3
	volume = 60
	possible_transfer_amounts = list(5, 10, 20, 30)
	reagent_ids = list("beer", "kahlua", "whiskey", "wine", "vodka", "gin", "rum", "tequilla", "vermouth", "cognac", "ale", "mead", "water", "sugar", "ice", "tea", "icetea", "cola", "spacemountainwind", "dr_gibb", "space_up", "tonic", "sodawater", "lemon_lime", "orangejuice", "limejuice", "watermelonjuice")
	var/list/reagent_names = list()

/obj/item/weapon/reagent_containers/borghypo/service/New()
	..()
	for(var/T in reagent_ids)
		var/datum/reagent/R = chemical_reagents_list[T]
		reagent_names += R.name

/obj/item/weapon/reagent_containers/borghypo/service/attack_self(var/mob/user)
	var/t = input(user, "Choose a reagent to dispence", "Reagent", reagent_names[mode]) in reagent_names

	playsound(loc, 'sound/effects/pop.ogg', 50, 0)

	mode = reagent_names.Find(t)
	user << "<span class='notice'>Synthesizer is now producing '[t]'.</span>"
	return

/obj/item/weapon/reagent_containers/borghypo/service/attack(var/mob/M, var/mob/user)
	return

/obj/item/weapon/reagent_containers/borghypo/service/afterattack(var/obj/target, var/mob/user, var/proximity)
	if(!proximity)
		return

	if(!target.is_open_container() || !target.reagents)
		return

	if(!reagent_volumes[reagent_ids[mode]])
		user << "<span class='notice'>[src] is out of this reagent, give it some time to refill.</span>"
		return

	if(!target.reagents.get_free_space())
		user << "<span class='notice'>[target] is full.</span>"
		return

	var/t = min(amount_per_transfer_from_this, reagent_volumes[reagent_ids[mode]])
	target.reagents.add_reagent(reagent_ids[mode], t)
	reagent_volumes[reagent_ids[mode]] -= t
	user << "<span class='notice'>You transfer [t] units of the solution to [target].</span>"
	return
