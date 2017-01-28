////////////////////////////////////////////////////////////////////////////////
/// Syringes.
////////////////////////////////////////////////////////////////////////////////
#define SYRINGE_DRAW 0
#define SYRINGE_INJECT 1
#define SYRINGE_BROKEN 2

/obj/item/weapon/reagent_containers/syringe
	name = "syringe"
	desc = "A syringe."
	icon = 'icons/obj/syringe.dmi'
	item_state = "syringe_0"
	icon_state = "0"
	matter = list("glass" = 150)
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = null
	volume = 15
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	sharp = 1
	unacidable = 1 //glass
	var/mode = SYRINGE_DRAW
	var/image/filling //holds a reference to the current filling overlay
	var/visible_name = "a syringe"
	var/time = 30

	on_reagent_change()
		update_icon()

	pickup(mob/user)
		..()
		update_icon()

	dropped(mob/user)
		..()
		update_icon()

	attack_self(mob/user as mob)

		switch(mode)
			if(SYRINGE_DRAW)
				mode = SYRINGE_INJECT
			if(SYRINGE_INJECT)
				mode = SYRINGE_DRAW
			if(SYRINGE_BROKEN)
				return
		update_icon()

	attack_hand()
		..()
		update_icon()

	attackby(obj/item/I as obj, mob/user as mob)
		return

	do_surgery(mob/living/carbon/M, mob/living/user)
		if(user.a_intent == I_HURT)
			return 0
		if(user.a_intent != I_HELP) //in case it is ever used as a surgery tool
			return ..()
		afterattack(M, user, 1)
		return 1

	afterattack(obj/target, mob/user, proximity)
		if(!proximity || !target.reagents)
			return

		if(mode == SYRINGE_BROKEN)
			to_chat(user, "<span class='warning'>This syringe is broken!</span>")
			return

		if(user.a_intent == I_HURT && ismob(target))
			if((CLUMSY in user.mutations) && prob(50))
				target = user
			syringestab(target, user)
			return

		var/target_zone = check_zone(user.zone_sel.selecting)

		switch(mode)
			if(SYRINGE_DRAW)

				if(!reagents.get_free_space())
					to_chat(user, "<span class='warning'>The syringe is full.</span>")
					mode = SYRINGE_INJECT
					return

				if(ismob(target))//Blood!
					if(reagents.has_reagent("blood"))
						to_chat(user, "<span class='notice'>There is already a blood sample in this syringe.</span>")
						return
					if(istype(target, /mob/living/carbon))
						if(istype(target, /mob/living/carbon/slime))
							to_chat(user, "<span class='warning'>You are unable to locate any blood.</span>")
							return
						var/amount = reagents.get_free_space()
						var/mob/living/carbon/T = target
						if(!T.dna)
							to_chat(user, "<span class='warning'>You are unable to locate any blood.</span>")
							CRASH("[T] \[[T.type]\] was missing their dna datum!")
							return
						if(NOCLONE in T.mutations) //target done been et, no more blood in him
							to_chat(user, "<span class='warning'>You are unable to locate any blood.</span>")
							return

						var/injtime = time //Taking a blood sample through a hardsuit takes longer due to needing to find a port.
						var/allow = T.can_inject(user, target_zone)
						if(!allow)
							return
						if(allow == INJECTION_PORT)
							injtime *= 2
							user.visible_message("<span class='warning'>\The [user] begins hunting for an injection port on [target]'s suit!</span>")
						else
							user.visible_message("<span class='warning'>\The [user] is trying to take a blood sample from [target].</span>")

						user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
						user.do_attack_animation(target)

						if(!do_mob(user, target, injtime))
							return

						T.take_blood(src, amount)
						to_chat(user, "<span class='notice'>You take a blood sample from [target].</span>")
						for(var/mob/O in viewers(4, user))
							O.show_message("<span class='notice'>[user] takes a blood sample from [target].</span>", 1)

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

			if(SYRINGE_INJECT)
				if(!reagents.total_volume)
					to_chat(user, "<span class='notice'>The syringe is empty.</span>")
					mode = SYRINGE_DRAW
					return
				if(istype(target, /obj/item/weapon/implantcase/chem))
					return

				if(!target.is_open_container() && !ismob(target) && !istype(target, /obj/item/weapon/reagent_containers/food) && !istype(target, /obj/item/slime_extract) && !istype(target, /obj/item/clothing/mask/smokable/cigarette) && !istype(target, /obj/item/weapon/storage/fancy/cigarettes))
					to_chat(user, "<span class='notice'>You cannot directly fill this object.</span>")
					return
				if(!target.reagents.get_free_space())
					to_chat(user, "<span class='notice'>[target] is full.</span>")
					return

				if(isliving(target) && target != user)
					var/mob/living/L = target
					var/injtime = time //Injecting through a hardsuit takes longer due to needing to find a port.
					var/allow = L.can_inject(user, target_zone)
					if(!allow)
						return
					if(allow == INJECTION_PORT)
						injtime *= 2
						user.visible_message("<span class='warning'>\The [user] begins hunting for an injection port on [target]'s suit!</span>")
					else
						user.visible_message("<span class='warning'>\The [user] is trying to inject [target] with [visible_name]!</span>")

					user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
					user.do_attack_animation(target)

					if(!do_mob(user, target, injtime))
						return

					user.visible_message("<span class='warning'>[user] injects [target] with the syringe!</span>")

				var/trans
				if(ismob(target))
					var/contained = reagentlist()
					trans = reagents.trans_to_mob(target, amount_per_transfer_from_this, CHEM_BLOOD)
					admin_inject_log(user, target, src, contained, trans)
				else
					trans = reagents.trans_to(target, amount_per_transfer_from_this)
				to_chat(user, "<span class='notice'>You inject [trans] units of the solution. The syringe now contains [src.reagents.total_volume] units.</span>")
				if (reagents.total_volume <= 0 && mode == SYRINGE_INJECT)
					mode = SYRINGE_DRAW
					update_icon()

		return

	update_icon()
		overlays.Cut()

		if(mode == SYRINGE_BROKEN)
			icon_state = "broken"
			return

		var/rounded_vol = round(reagents.total_volume, round(reagents.maximum_volume / 3))
		if(ismob(loc))
			var/injoverlay
			switch(mode)
				if (SYRINGE_DRAW)
					injoverlay = "draw"
				if (SYRINGE_INJECT)
					injoverlay = "inject"
			overlays += injoverlay
		icon_state = "[rounded_vol]"
		item_state = "syringe_[rounded_vol]"

		if(reagents.total_volume)
			filling = image('icons/obj/reagentfillings.dmi', src, "syringe10")

			filling.icon_state = "syringe[rounded_vol]"

			filling.color = reagents.get_color()
			overlays += filling

	proc/syringestab(mob/living/carbon/target as mob, mob/living/carbon/user as mob)

		if(istype(target, /mob/living/carbon/human))

			var/mob/living/carbon/human/H = target

			var/target_zone = ran_zone(check_zone(user.zone_sel.selecting, target))
			var/obj/item/organ/external/affecting = H.get_organ(target_zone)

			if (!affecting || affecting.is_stump())
				to_chat(user, "<span class='danger'>They are missing that limb!</span>")
				return

			var/hit_area = affecting.name

			if((user != target) && H.check_shields(7, src, user, "\the [src]"))
				return

			if (target != user && H.getarmor(target_zone, "melee") > 5 && prob(50))
				for(var/mob/O in viewers(world.view, user))
					O.show_message(text("<span class='danger'>[user] tries to stab [target] in \the [hit_area] with [src.name], but the attack is deflected by armor!</span>"), 1)
				user.remove_from_mob(src)
				qdel(src)

				admin_attack_log(user, target, "Attacked using \a [src]", "Was attacked with \a [src]", "used \a [src] to attack")
				return

			user.visible_message("<span class='danger'>[user] stabs [target] in \the [hit_area] with [src.name]!</span>")

			if(affecting.take_damage(3))
				H.UpdateDamageIcon()

		else
			user.visible_message("<span class='danger'>[user] stabs [target] with [src.name]!</span>")
			target.take_organ_damage(3)// 7 is the same as crowbar punch



		var/syringestab_amount_transferred = rand(0, (reagents.total_volume - 5)) //nerfed by popular demand
		var/contained_reagents = reagents.get_reagents()
		var/trans = reagents.trans_to_mob(target, syringestab_amount_transferred, CHEM_BLOOD)
		if(isnull(trans)) trans = 0
		admin_inject_log(user, target, src, contained_reagents, trans, violent=1)
		break_syringe(target, user)

	proc/break_syringe(mob/living/carbon/target, mob/living/carbon/user)
		desc += " It is broken."
		mode = SYRINGE_BROKEN
		if(target)
			add_blood(target)
		if(user)
			add_fingerprint(user)
		update_icon()

/obj/item/weapon/reagent_containers/syringe/ld50_syringe
	name = "Lethal Injection Syringe"
	desc = "A syringe used for lethal injections."
	amount_per_transfer_from_this = 60
	volume = 60
	visible_name = "a giant syringe"
	time = 300

	afterattack(obj/target, mob/user, flag)
		if(mode == SYRINGE_DRAW && ismob(target)) // No drawing 50 units of blood at once
			to_chat(user, "<span class='notice'>This needle isn't designed for drawing blood.</span>")
			return
		if(user.a_intent == "hurt" && ismob(target)) // No instant injecting
			to_chat(user, "<span class='notice'>This syringe is too big to stab someone with it.</span>")
		..()

////////////////////////////////////////////////////////////////////////////////
/// Syringes. END
////////////////////////////////////////////////////////////////////////////////

/obj/item/weapon/reagent_containers/syringe/inaprovaline
	name = "Syringe (inaprovaline)"
	desc = "Contains inaprovaline - used to stabilize patients."
	New()
		..()
		reagents.add_reagent("inaprovaline", 15)
		mode = SYRINGE_INJECT
		update_icon()

/obj/item/weapon/reagent_containers/syringe/antitoxin
	name = "Syringe (anti-toxin)"
	desc = "Contains anti-toxins."
	New()
		..()
		reagents.add_reagent("anti_toxin", 15)
		mode = SYRINGE_INJECT
		update_icon()

/obj/item/weapon/reagent_containers/syringe/antiviral
	name = "Syringe (spaceacillin)"
	desc = "Contains antiviral agents."
	New()
		..()
		reagents.add_reagent("spaceacillin", 15)
		mode = SYRINGE_INJECT
		update_icon()

/obj/item/weapon/reagent_containers/syringe/drugs
	name = "Syringe (drugs)"
	desc = "Contains aggressive drugs meant for torture."
	New()
		..()
		reagents.add_reagent("space_drugs",  5)
		reagents.add_reagent("mindbreaker",  5)
		reagents.add_reagent("cryptobiolin", 5)
		mode = SYRINGE_INJECT
		update_icon()

/obj/item/weapon/reagent_containers/syringe/ld50_syringe/choral
	New()
		..()
		reagents.add_reagent("chloralhydrate", 60)
		mode = SYRINGE_INJECT
		update_icon()

/obj/item/weapon/reagent_containers/syringe/steroid
	name = "Syringe (anabolic steroids)"
	desc = "Contains drugs for muscle growth."
	New()
		..()
		reagents.add_reagent("adrenaline",5)
		reagents.add_reagent("hyperzine",10)

