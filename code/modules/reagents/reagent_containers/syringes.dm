////////////////////////////////////////////////////////////////////////////////
/// Syringes.
////////////////////////////////////////////////////////////////////////////////
#define SYRINGE_DRAW 0
#define SYRINGE_INJECT 1
#define SYRINGE_BROKEN 2

/obj/item/reagent_containers/syringe
	name = "syringe"
	desc = "A syringe."
	icon = 'icons/obj/syringe.dmi'
	item_state = "rg0"
	icon_state = "rg"
	matter = list(MATERIAL_GLASS = 150)
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = "1;2;5"
	volume = 15
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	sharp = TRUE
	unacidable = TRUE
	var/mode = SYRINGE_DRAW
	var/image/filling //holds a reference to the current filling overlay
	var/visible_name = "a syringe"
	var/time = 30

/obj/item/reagent_containers/syringe/Initialize(var/mapload)
	. = ..()
	update_icon()

/obj/item/reagent_containers/syringe/on_reagent_change()
	update_icon()

/obj/item/reagent_containers/syringe/pickup(mob/user)
	..()
	update_icon()

/obj/item/reagent_containers/syringe/dropped(mob/user)
	..()
	update_icon()

/obj/item/reagent_containers/syringe/attack_self(mob/user as mob)
	switch(mode)
		if(SYRINGE_DRAW)
			mode = SYRINGE_INJECT
		if(SYRINGE_INJECT)
			mode = SYRINGE_DRAW
		if(SYRINGE_BROKEN)
			return
	update_icon()

/obj/item/reagent_containers/syringe/attack_hand()
	..()
	update_icon()

/obj/item/reagent_containers/syringe/attackby(obj/item/I as obj, mob/user as mob)
	return

/obj/item/reagent_containers/syringe/afterattack(obj/target, mob/user, proximity)
	if(!proximity)
		return

	if(mode == SYRINGE_BROKEN)
		to_chat(user, "<span class='warning'>This syringe is broken.</span>")
		return

	if(istype(target, /obj/structure/closet/body_bag))
		handleBodyBag(target, user)
		return

	if(!target.reagents)
		return

	if((user.a_intent == I_HURT) && ismob(target))
		syringestab(target, user)
		return

	handleTarget(target, user)

/obj/item/reagent_containers/syringe/on_update_icon()
	overlays.Cut()
	underlays.Cut()

	if(mode == SYRINGE_BROKEN)
		icon_state = "broken"
		return

	var/rounded_vol = clamp(round((reagents.total_volume / volume * 15),5), 5, 15)
	if (reagents.total_volume == 0)
		rounded_vol = 0
	if(ismob(loc))
		var/injoverlay
		switch(mode)
			if (SYRINGE_DRAW)
				injoverlay = "draw"
			if (SYRINGE_INJECT)
				injoverlay = "inject"
		overlays += injoverlay
	icon_state = "[initial(icon_state)][rounded_vol]"
	item_state = "syringe_[rounded_vol]"

	if(reagents.total_volume)
		filling = image('icons/obj/reagentfillings.dmi', src, "syringe10")

		filling.icon_state = "syringe[rounded_vol]"

		filling.color = reagents.get_color()
		underlays += filling

/obj/item/reagent_containers/syringe/proc/handleTarget(var/atom/target, var/mob/user)
	switch(mode)
		if(SYRINGE_DRAW)
			drawReagents(target, user)

		if(SYRINGE_INJECT)
			injectReagents(target, user)

/obj/item/reagent_containers/syringe/proc/drawReagents(var/atom/target, var/mob/user)
	if(!reagents.get_free_space())
		to_chat(user, "<span class='warning'>The syringe is full.</span>")
		mode = SYRINGE_INJECT
		return

	if(ismob(target))//Blood!
		if(reagents.has_reagent(/datum/reagent/blood))
			to_chat(user, "<span class='notice'>There is already a blood sample in this syringe.</span>")
			return
		if(istype(target, /mob/living/carbon))
			if(istype(target, /mob/living/carbon/slime))
				to_chat(user, "<span class='warning'>You are unable to locate any blood.</span>")
				return
			var/amount = min(reagents.get_free_space(), amount_per_transfer_from_this)
			var/mob/living/carbon/T = target
			if(!T.dna)
				to_chat(user, "<span class='warning'>You are unable to locate any blood.</span>")
				if(istype(target, /mob/living/carbon/human))
					CRASH("[T] \[[T.type]\] was missing their dna datum!")
				return


			var/allow = T.can_inject(user, check_zone(user.zone_sel.selecting))
			if(!allow)
				return

			if(allow == INJECTION_PORT) // Taking a blood sample through a hardsuit takes longer due to needing to find a port first.
				if(target != user)
					user.visible_message(SPAN_WARNING("\The [user] begins hunting for an injection port on \the [target]'s suit!"))
				else
					to_chat(user, SPAN_NOTICE("You begin hunting for an injection port on your suit."))
				if(!user.do_skilled(INJECTION_PORT_DELAY, SKILL_MEDICAL, target, do_flags = DO_MEDICAL))
					return

				if (!reagents)
					return

			if(target != user)
				user.visible_message(SPAN_WARNING("\The [user] is trying to take a blood sample from \the [target]."))
			else
				to_chat(user, SPAN_NOTICE("You start trying to take a blood sample from yourself."))

			if(prob(user.skill_fail_chance(SKILL_MEDICAL, 60, SKILL_BASIC)))
				to_chat(user, "<span class='warning'>You miss the vein!</span>")
				var/target_zone = check_zone(user.zone_sel.selecting)
				T.apply_damage(3, DAMAGE_BRUTE, target_zone, damage_flags=DAMAGE_FLAG_SHARP)
				return

			user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
			user.do_attack_animation(target)

			if(!user.do_skilled(time, SKILL_MEDICAL, target, do_flags = DO_MEDICAL))
				return

			if (!reagents)
				return

			T.take_blood(src, amount)
			to_chat(user, "<span class='notice'>You take a blood sample from [target].</span>")
			for(var/mob/O in viewers(4, user))
				O.show_message("<span class='notice'>[user] takes a blood sample from [target].</span>", 1)

			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				H.custom_pain(SPAN_WARNING("The needle stings a bit."), 2, TRUE, H.get_organ(user.zone_sel.selecting))

	else //if not mob
		if(!target.reagents.total_volume)
			to_chat(user, "<span class='notice'>[target] is empty.</span>")
			return

		if(!target.is_open_container() && !istype(target, /obj/structure/reagent_dispensers) && !istype(target, /obj/item/slime_extract))
			to_chat(user, "<span class='notice'>You cannot directly remove reagents from this object.</span>")
			return

		var/trans = target.reagents.trans_to_obj(src, amount_per_transfer_from_this)
		to_chat(user, "<span class='notice'>You fill the syringe with [trans] units of the solution.</span>")
		update_icon()

	if(!reagents.get_free_space())
		mode = SYRINGE_INJECT
		update_icon()

/obj/item/reagent_containers/syringe/proc/injectReagents(var/atom/target, var/mob/user)
	if(ismob(target) && !user.skill_check(SKILL_MEDICAL, SKILL_BASIC))
		syringestab(target, user)

	if(!reagents?.total_volume)
		to_chat(user, "<span class='notice'>The syringe is empty.</span>")
		mode = SYRINGE_DRAW
		return
	if(istype(target, /obj/item/implantcase/chem))
		return

	if(!target.is_open_container() && !ismob(target) && !istype(target, /obj/item/reagent_containers/food) && !istype(target, /obj/item/slime_extract) && !istype(target, /obj/item/clothing/mask/smokable/cigarette) && !istype(target, /obj/item/storage/fancy/cigarettes))
		to_chat(user, "<span class='notice'>You cannot directly fill this object.</span>")
		return
	if(!target.reagents.get_free_space())
		to_chat(user, "<span class='notice'>[target] is full.</span>")
		return

	if(isliving(target))
		injectMob(target, user)
		return

	var/trans = reagents.trans_to(target, amount_per_transfer_from_this)
	to_chat(user, "<span class='notice'>You inject \the [target] with [trans] units of the solution. \The [src] now contains [src.reagents.total_volume] units.</span>")
	if(reagents.total_volume <= 0 && mode == SYRINGE_INJECT)
		mode = SYRINGE_DRAW
		update_icon()

/obj/item/reagent_containers/syringe/proc/handleBodyBag(var/obj/structure/closet/body_bag/bag, var/mob/living/carbon/user)
	if(bag.opened || !bag.contains_body)
		return

	var/mob/living/L = locate() in bag
	if(L)
		injectMob(L, user, bag)

/obj/item/reagent_containers/syringe/proc/injectMob(var/mob/living/carbon/target, var/mob/living/carbon/user, var/atom/trackTarget)
	if(!trackTarget)
		trackTarget = target

	var/allow = target.can_inject(user, check_zone(user.zone_sel.selecting))
	if(!allow)
		return

	if(allow == INJECTION_PORT) // Injecting through a hardsuit takes longer due to needing to find a port first.
		if(target != user)
			user.visible_message(SPAN_WARNING("\The [user] begins hunting for an injection port on \the [target]'s suit!"))
		else
			to_chat(user, SPAN_NOTICE("You begin hunting for an injection port on your suit."))
		if(!user.do_skilled(INJECTION_PORT_DELAY, SKILL_MEDICAL, trackTarget, do_flags = DO_MEDICAL))
			return

	if(target != user)
		user.visible_message(SPAN_WARNING("\The [user] is trying to inject \the [target] with [visible_name]!"))
	else
		to_chat(user, SPAN_NOTICE("You begin injecting yourself with [visible_name]."))

	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user.do_attack_animation(trackTarget)

	if(!user.do_skilled(time, SKILL_MEDICAL, trackTarget, do_flags = DO_MEDICAL))
		return

	if(target != user && target != trackTarget && target.loc != trackTarget)
		return
	if (reagents.should_admin_log())
		admin_inject_log(user, target, src, reagents.get_reagents(), amount_per_transfer_from_this)
	var/trans = reagents.trans_to_mob(target, amount_per_transfer_from_this, CHEM_BLOOD)

	if(target != user)
		user.visible_message("<span class='warning'>\the [user] injects \the [target] with [visible_name]!</span>", "<span class='notice'>You inject \the [target] with [trans] units of the solution. \The [src] now contains [src.reagents.total_volume] units.</span>")
	else
		to_chat(user, "<span class='notice'>You inject yourself with [trans] units of the solution. \The [src] now contains [src.reagents.total_volume] units.</span>")

	if(ishuman(target))
		var/mob/living/carbon/human/T = target
		T.custom_pain(SPAN_WARNING("The needle stings a bit."), 2, TRUE, T.get_organ(user.zone_sel.selecting))

	if(reagents.total_volume <= 0 && mode == SYRINGE_INJECT)
		mode = SYRINGE_DRAW
		update_icon()

/obj/item/reagent_containers/syringe/proc/syringestab(var/mob/living/carbon/target, var/mob/living/carbon/user)
	var/should_admin_log = reagents.should_admin_log()
	if(istype(target, /mob/living/carbon/human))

		var/mob/living/carbon/human/H = target

		var/target_zone = check_zone(user.zone_sel.selecting)
		var/obj/item/organ/external/affecting = H.get_organ(target_zone)

		if (!affecting || affecting.is_stump())
			to_chat(user, "<span class='danger'>They are missing that limb!</span>")
			return

		var/hit_area = affecting.name

		if((user != target) && H.check_shields(7, src, user, "\the [src]"))
			return

		if (target != user && H.get_blocked_ratio(target_zone, DAMAGE_BRUTE, damage_flags=DAMAGE_FLAG_SHARP) > 0.1 && prob(50))
			for(var/mob/O in viewers(world.view, user))
				O.show_message(text("<span class='danger'>[user] tries to stab [target] in \the [hit_area] with [src.name], but the attack is deflected by armor!</span>"), 1)
			qdel(src)

			admin_attack_log(user, target, "Attacked using \a [src]", "Was attacked with \a [src]", "used \a [src] to attack")
			return

		user.visible_message("<span class='danger'>[user] stabs [target] in \the [hit_area] with [src.name]!</span>")
		target.apply_damage(3, DAMAGE_BRUTE, target_zone, damage_flags=DAMAGE_FLAG_SHARP)

	else
		user.visible_message("<span class='danger'>[user] stabs [target] with [src.name]!</span>")
		target.apply_damage(3, DAMAGE_BRUTE)

	var/syringestab_amount_transferred = rand(0, (reagents.total_volume - 5)) //nerfed by popular demand
	var/trans = reagents.trans_to_mob(target, syringestab_amount_transferred, CHEM_BLOOD)
	if(isnull(trans)) trans = 0
	if (should_admin_log)
		var/contained_reagents = reagents.get_reagents()
		admin_inject_log(user, target, src, contained_reagents, trans, violent=1)
	break_syringe(target, user)

/obj/item/reagent_containers/syringe/proc/break_syringe(mob/living/carbon/target, mob/living/carbon/user)
	desc += " It is broken."
	mode = SYRINGE_BROKEN
	if(target)
		add_blood(target)
	if(user)
		add_fingerprint(user)
	update_icon()

/obj/item/reagent_containers/syringe/ld50_syringe
	name = "Lethal Injection Syringe"
	desc = "A syringe used for lethal injections."
	amount_per_transfer_from_this = 60
	volume = 60
	visible_name = "a giant syringe"
	time = 300

/obj/item/reagent_containers/syringe/ld50_syringe/syringestab(var/mob/living/carbon/target, var/mob/living/carbon/user)
	to_chat(user, "<span class='notice'>This syringe is too big to stab someone with it.</span>")
	return // No instant injecting

/obj/item/reagent_containers/syringe/ld50_syringe/drawReagents(var/target, var/mob/user)
	if(ismob(target)) // No drawing 60 units of blood at once
		to_chat(user, "<span class='notice'>This needle isn't designed for drawing blood.</span>")
		return
	..()

////////////////////////////////////////////////////////////////////////////////
/// Syringes. END
////////////////////////////////////////////////////////////////////////////////

/obj/item/reagent_containers/syringe/inaprovaline
	name = "Syringe (inaprovaline)"
	desc = "Contains inaprovaline - used to stabilize patients."

/obj/item/reagent_containers/syringe/inaprovaline/New()
	..()
	reagents.add_reagent(/datum/reagent/inaprovaline, 15)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_containers/syringe/antitoxin
	name = "Syringe (anti-toxin)"
	desc = "Contains anti-toxins."

/obj/item/reagent_containers/syringe/antitoxin/New()
	..()
	reagents.add_reagent(/datum/reagent/dylovene, 15)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_containers/syringe/antiviral
	name = "Syringe (spaceacillin)"
	desc = "Contains antiviral agents."

/obj/item/reagent_containers/syringe/antiviral/New()
	..()
	reagents.add_reagent(/datum/reagent/spaceacillin, 15)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_containers/syringe/drugs
	name = "Syringe (drugs)"
	desc = "Contains aggressive drugs meant for torture."

/obj/item/reagent_containers/syringe/drugs/New()
	..()
	reagents.add_reagent(/datum/reagent/space_drugs, 5)
	reagents.add_reagent(/datum/reagent/mindbreaker, 5)
	reagents.add_reagent(/datum/reagent/cryptobiolin, 5)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_containers/syringe/ld50_syringe/choral

/obj/item/reagent_containers/syringe/ld50_syringe/choral/New()
	..()
	reagents.add_reagent(/datum/reagent/chloralhydrate, 60)
	mode = SYRINGE_INJECT
	update_icon()

/obj/item/reagent_containers/syringe/steroid
	name = "Syringe (anabolic steroids)"
	desc = "Contains drugs for muscle growth."

/obj/item/reagent_containers/syringe/steroid/New()
	..()
	reagents.add_reagent(/datum/reagent/adrenaline, 5)
	reagents.add_reagent(/datum/reagent/hyperzine, 10)


// TG ports

/obj/item/reagent_containers/syringe/bluespace
	name = "bluespace syringe"
	desc = "An advanced syringe that can hold 60 units of chemicals."
	amount_per_transfer_from_this = 20
	volume = 60
	icon_state = "bs"

/obj/item/reagent_containers/syringe/noreact
	name = "cryostasis syringe"
	desc = "An advanced syringe that stops reagents inside from reacting. It can hold up to 20 units."
	volume = 20
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_REACT
	icon_state = "cs"
