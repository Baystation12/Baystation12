/mob
	var/bloody_hands = null
	var/mob/living/carbon/human/bloody_hands_mob
	var/track_blood = 0
	var/list/feet_blood_DNA
	var/track_blood_type
	var/feet_blood_color

/obj/item/clothing/gloves
	var/transfer_blood = 0
	var/mob/living/carbon/human/bloody_hands_mob

/obj/item/clothing/shoes/
	var/track_blood = 0

/obj/item/reagent_containers/glass/rag
	name = "rag"
	desc = "For cleaning up messes, you suppose."
	w_class = ITEM_SIZE_TINY
	icon = 'icons/obj/toy.dmi'
	icon_state = "rag"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = "5"
	volume = 10
	can_be_placed_into = null
	item_flags = ITEM_FLAG_NO_BLUDGEON
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	unacidable = FALSE

	var/on_fire = 0
	var/burn_time = 20 //if the rag burns for too long it turns to ashes

/obj/item/reagent_containers/glass/rag/New()
	..()
	update_name()

/obj/item/reagent_containers/glass/rag/Destroy()
	STOP_PROCESSING(SSobj, src) //so we don't continue turning to ash while gc'd
	. = ..()

/obj/item/reagent_containers/glass/rag/attack_self(mob/user as mob)
	if(on_fire && user.unEquip(src))
		user.visible_message("<span class='warning'>\The [user] stamps out [src].</span>", "<span class='warning'>You stamp out [src].</span>")
		extinguish()
	else
		remove_contents(user)

/obj/item/reagent_containers/glass/rag/attackby(obj/item/W, mob/user)
	if(!on_fire && isflamesource(W))
		ignite()
		if(on_fire)
			user.visible_message(
				SPAN_WARNING("\The [user] lights \the [src] with \the [W]!"),
				SPAN_DANGER("You light \the [src]!")
			)
		else
			to_chat(user, SPAN_WARNING("You manage to singe \the [src], but it won't burn on its own.")) // Give a hint about needing fuel

	. = ..()
	update_name()

/obj/item/reagent_containers/glass/rag/proc/update_name()
	if(on_fire)
		SetName("burning [initial(name)]")
	else if(reagents.total_volume)
		SetName("damp [initial(name)]")
	else
		SetName("dry [initial(name)]")

/obj/item/reagent_containers/glass/rag/on_update_icon()
	if(on_fire)
		icon_state = "raglit"
	else
		icon_state = "rag"

	var/obj/item/reagent_containers/food/drinks/bottle/B = loc
	if(istype(B))
		B.update_icon()

/obj/item/reagent_containers/glass/rag/proc/remove_contents(mob/user, atom/trans_dest = null)
	if(!trans_dest && !user.loc)
		return

	if(reagents.total_volume)
		var/target_text = trans_dest? "\the [trans_dest]" : "\the [user.loc]"
		user.visible_message("<span class='danger'>\The [user] begins to wring out [src] over [target_text].</span>", "<span class='notice'>You begin to wring out [src] over [target_text].</span>")

		if(do_after(user, reagents.total_volume*5, do_flags = DO_DEFAULT & ~DO_SHOW_PROGRESS)) //50 for a fully soaked rag
			if(trans_dest)
				reagents.trans_to(trans_dest, reagents.total_volume)
			else
				reagents.splash(user.loc, reagents.total_volume)
			user.visible_message("<span class='danger'>\The [user] wrings out [src] over [target_text].</span>", "<span class='notice'>You finish to wringing out [src].</span>")
			update_name()

/obj/item/reagent_containers/glass/rag/proc/wipe_down(atom/A, mob/user)
	if(!reagents.total_volume)
		to_chat(user, "<span class='warning'>The [initial(name)] is dry!</span>")
	else
		user.visible_message("\The [user] starts to wipe down [A] with [src]!")
		reagents.splash(A, 1) //get a small amount of liquid on the thing we're wiping.
		update_name()
		if(do_after(user,30))
			user.visible_message("\The [user] finishes wiping off the [A]!")
			if(isturf(A))
				var/turf/T = A
				T.clean(src, user)
			else
				A.clean_blood()

/obj/item/reagent_containers/glass/rag/attack(atom/target as obj|turf|area, mob/user as mob , flag)
	if(isliving(target))
		var/mob/living/M = target
		if(on_fire)
			if (user.a_intent == I_HELP)
				return FALSE
			user.visible_message(
				SPAN_DANGER("\The [user] hits \the [target] with \the [src]!"),
				SPAN_DANGER("You hit \the [target] with \the [src]!")
			)
			user.do_attack_animation(src)
			admin_attack_log(user, M, "used \the [src] (ignited) to attack", "was attacked using \the [src] (ignited)", "attacked with \the [src] (ignited)")
			M.IgniteMob()
		else if (reagents.total_volume)
			if (iscarbon(target) && user.a_intent == I_HELP && flag == BP_HEAD)
				var/mob/living/carbon/C = target
				var/obj/item/organ/external/head/H = C.organs_by_name[BP_HEAD]
				if (istype(H) && H.forehead_graffiti)
					var/datum/reagent/R = /datum/reagent/acetone
					var/wash_amount = 5
					if (reagents.has_reagent(R, wash_amount))
						H.forehead_graffiti = null
						reagents.remove_reagent(R, wash_amount)
						if (user == target)
							var/datum/gender/G = gender_datums[M.get_gender()]
							user.visible_message(SPAN_NOTICE("\The [user] scrubs the ink off [G.his] forehead."), SPAN_NOTICE("You scrub the ink off your forehead."))
						else
							user.visible_message(SPAN_NOTICE("\The [user] scrubs the ink off \the [M]'s forehead."), SPAN_NOTICE("You scrub the ink off \the [M]'s forehead."))
					else
						to_chat(user, SPAN_WARNING("You need to wet the rag with [wash_amount] units of [initial(R.name)] to get the ink off!"))
					return

			if(user.zone_sel.selecting == BP_MOUTH)
				if (!M.has_danger_grab(user))
					to_chat(user, SPAN_WARNING("You need to have a firm grip on \the [target] before you can use \the [src] on them!"))
					return

				user.do_attack_animation(src)
				user.visible_message(
					SPAN_DANGER("\The [user] brings \the [src] up to \the [target]'s mouth!"),
					SPAN_DANGER("You bring \the [src] up to \the [target]'s mouth!"),
					SPAN_WARNING("You hear some struggling and muffled cries of surprise")
				)

				var/grab_time = 6 SECONDS
				if (user.skill_check(SKILL_COMBAT, SKILL_ADEPT))
					grab_time = 3 SECONDS

				if (do_after(user, grab_time, target, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS))
					user.visible_message(
						SPAN_DANGER("\The [user] smothers \the [target] with \the [src]!"),
						SPAN_DANGER("You smother \the [target] with \the [src]!")
					)
					//it's inhaled, so... maybe CHEM_BLOOD doesn't make a whole lot of sense but it's the best we can do for now
					var/trans_amt = reagents.trans_to_mob(target, amount_per_transfer_from_this, CHEM_BLOOD)
					if (reagents.should_admin_log())
						var/contained_reagents = reagents.get_reagents()
						admin_inject_log(user, M, src, contained_reagents, trans_amt)
					update_name()
			else
				wipe_down(target, user)
		else if (user.zone_sel.selecting == BP_MOUTH)
			to_chat(user, SPAN_WARNING("\The [src] is too dry to use on \the [target]!"))
			return
		return

	return ..()

/obj/item/reagent_containers/glass/rag/afterattack(atom/A as obj|turf|area, mob/user as mob, proximity)
	if(!proximity)
		return

	if(istype(A, /obj/structure/reagent_dispensers))
		if(!reagents.get_free_space())
			to_chat(user, "<span class='warning'>\The [src] is already soaked.</span>")
			return

		if(A.reagents && A.reagents.trans_to_obj(src, reagents.maximum_volume))
			user.visible_message("<span class='notice'>\The [user] soaks [src] using [A].</span>", "<span class='notice'>You soak [src] using [A].</span>")
			update_name()
		return

	if(!on_fire && istype(A) && (src in user))
		if(A.is_open_container() && !(A in user))
			remove_contents(user, A)
		else if(!ismob(A)) //mobs are handled in attack() - this prevents us from wiping down people while smothering them.
			wipe_down(A, user)
		return

/obj/item/reagent_containers/glass/rag/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature >= 50 + T0C)
		ignite()
	if(exposed_temperature >= 900 + T0C)
		new /obj/effect/decal/cleanable/ash(get_turf(src))
		qdel(src)


/obj/item/reagent_containers/glass/rag/proc/can_ignite()
	var/fuel = 0
	for (var/datum/reagent/R as anything in reagents?.reagent_list)
		if (R.gas_flags & XGM_GAS_FUEL)
			fuel += R.volume
	return (fuel >= 2 && fuel >= reagents?.total_volume * 0.8)


/obj/item/reagent_containers/glass/rag/proc/ignite()
	if(on_fire)
		return
	if(!can_ignite())
		return

	//also copied from matches
	if(reagents.get_reagent_amount(/datum/reagent/toxin/phoron)) // the phoron explodes when exposed to fire
		visible_message("<span class='danger'>\The [src] conflagrates violently!</span>")
		var/datum/effect/effect/system/reagents_explosion/e = new()
		e.set_up(round(reagents.get_reagent_amount(/datum/reagent/toxin/phoron) / 2.5, 1), get_turf(src), 0, 0)
		e.start()
		qdel(src)
		return

	START_PROCESSING(SSobj, src)
	set_light(0.5, 0.1, 2, 2, "#e38f46")
	on_fire = 1
	update_name()
	update_icon()

/obj/item/reagent_containers/glass/rag/proc/extinguish()
	STOP_PROCESSING(SSobj, src)
	set_light(0)
	on_fire = 0

	//rags sitting around with 1 second of burn time left is dumb.
	//ensures players always have a few seconds of burn time left when they light their rag
	if(burn_time <= 5)
		visible_message("<span class='warning'>\The [src] falls apart!</span>")
		new /obj/effect/decal/cleanable/ash(get_turf(src))
		qdel(src)
	update_name()
	update_icon()

/obj/item/reagent_containers/glass/rag/Process()
	if(!can_ignite())
		visible_message("<span class='warning'>\The [src] burns out.</span>")
		extinguish()

	//copied from matches
	if(isliving(loc))
		var/mob/living/M = loc
		M.IgniteMob()
	var/turf/location = get_turf(src)
	if(location)
		location.hotspot_expose(700, 5)

	if(burn_time <= 0)
		STOP_PROCESSING(SSobj, src)
		new /obj/effect/decal/cleanable/ash(location)
		qdel(src)
		return

	reagents.remove_reagent(/datum/reagent/fuel, reagents.maximum_volume/25)
	update_name()
	burn_time--
