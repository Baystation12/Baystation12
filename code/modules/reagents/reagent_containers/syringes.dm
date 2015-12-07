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
	w_class = 1
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

	afterattack(obj/target, mob/user, proximity)
		if(!proximity || !target.reagents)
			return

		if(mode == SYRINGE_BROKEN)
			user << "<span class='warning'>This syringe is broken!</span>"
			return

		if(user.a_intent == I_HURT && ismob(target))
			if((CLUMSY in user.mutations) && prob(50))
				target = user
			syringestab(target, user)
			return


		switch(mode)
			if(SYRINGE_DRAW)

				if(!reagents.get_free_space())
					user << "<span class='warning'>The syringe is full.</span>"
					mode = SYRINGE_INJECT
					return

				if(ismob(target))//Blood!
					if(reagents.has_reagent("blood"))
						user << "<span class='notice'>There is already a blood sample in this syringe.</span>"
						return
					if(istype(target, /mob/living/carbon))
						if(istype(target, /mob/living/carbon/slime))
							user << "<span class='warning'>You are unable to locate any blood.</span>"
							return
						var/amount = reagents.get_free_space()
						var/mob/living/carbon/T = target
						if(!T.dna)
							user << "<span class='warning'>You are unable to locate any blood. (To be specific, your target seems to be missing their DNA datum).</span>"
							return
						if(NOCLONE in T.mutations) //target done been et, no more blood in him
							user << "<span class='warning'>You are unable to locate any blood.</span>"
							return

						var/datum/reagent/B
						if(istype(T, /mob/living/carbon/human))
							var/mob/living/carbon/human/H = T
							if(H.species && H.species.flags & NO_BLOOD)
								H.reagents.trans_to_obj(src, amount)
							else
								B = T.take_blood(src, amount)
						else
							B = T.take_blood(src,amount)

						if (B)
							reagents.reagent_list += B
							reagents.update_total()
							on_reagent_change()
							reagents.handle_reactions()
						user << "<span class='notice'>You take a blood sample from [target].</span>"
						for(var/mob/O in viewers(4, user))
							O.show_message("<span class='notice'>[user] takes a blood sample from [target].</span>", 1)

				else //if not mob
					if(!target.reagents.total_volume)
						user << "<span class='notice'>[target] is empty.</span>"
						return

					if(!target.is_open_container() && !istype(target, /obj/structure/reagent_dispensers) && !istype(target, /obj/item/slime_extract))
						user << "<span class='notice'>You cannot directly remove reagents from this object.</span>"
						return

					var/trans = target.reagents.trans_to_obj(src, amount_per_transfer_from_this)
					user << "<span class='notice'>You fill the syringe with [trans] units of the solution.</span>"
					update_icon()

				if(!reagents.get_free_space())
					mode = SYRINGE_INJECT
					update_icon()

			if(SYRINGE_INJECT)
				if(!reagents.total_volume)
					user << "<span class='notice'>The syringe is empty.</span>"
					mode = SYRINGE_DRAW
					return
				if(istype(target, /obj/item/weapon/implantcase/chem))
					return

				if(!target.is_open_container() && !ismob(target) && !istype(target, /obj/item/weapon/reagent_containers/food) && !istype(target, /obj/item/slime_extract) && !istype(target, /obj/item/clothing/mask/smokable/cigarette) && !istype(target, /obj/item/weapon/storage/fancy/cigarettes))
					user << "<span class='notice'>You cannot directly fill this object.</span>"
					return
				if(!target.reagents.get_free_space())
					user << "<span class='notice'>[target] is full.</span>"
					return

				if(ismob(target) && target != user)

					var/injtime = time //Injecting through a hardsuit takes longer due to needing to find a port.

					if(istype(target, /mob/living/carbon/human))

						var/mob/living/carbon/human/H = target
						if(H.wear_suit)
							if(istype(H.wear_suit, /obj/item/clothing/suit/space))
								injtime = injtime * 2
							else if(!H.can_inject(user, 1))
								return

					else if(isliving(target))

						var/mob/living/M = target
						if(!M.can_inject(user, 1))
							return

					if(injtime == time)
						user.visible_message("<span class='warning'>[user] is trying to inject [target] with [visible_name]!</span>")
					else
						user.visible_message("<span class='warning'>[user] begins hunting for an injection port on [target]'s suit!</span>")

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
				user << "<span class='notice'>You inject [trans] units of the solution. The syringe now contains [src.reagents.total_volume] units.</span>"
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
				user << "<span class='danger'>They are missing that limb!</span>"
				return

			var/hit_area = affecting.name

			if((user != target) && H.check_shields(7, "the [src.name]"))
				return

			if (target != user && H.getarmor(target_zone, "melee") > 5 && prob(50))
				for(var/mob/O in viewers(world.view, user))
					O.show_message(text("\red <B>[user] tries to stab [target] in \the [hit_area] with [src.name], but the attack is deflected by armor!</B>"), 1)
				user.remove_from_mob(src)
				qdel(src)

				user.attack_log += "\[[time_stamp()]\]<font color='red'> Attacked [target.name] ([target.ckey]) with \the [src] (INTENT: HARM).</font>"
				target.attack_log += "\[[time_stamp()]\]<font color='orange'> Attacked by [user.name] ([user.ckey]) with [src.name] (INTENT: HARM).</font>"
				msg_admin_attack("[key_name_admin(user)] attacked [key_name_admin(target)] with [src.name] (INTENT: HARM) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

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
	amount_per_transfer_from_this = 50
	volume = 50
	visible_name = "a giant syringe"
	time = 300

	afterattack(obj/target, mob/user, flag)
		if(mode == SYRINGE_DRAW && ismob(target)) // No drawing 50 units of blood at once
			user << "<span class='notice'>This needle isn't designed for drawing blood.</span>"
			return
		if(user.a_intent == "hurt" && ismob(target)) // No instant injecting
			user << "<span class='notice'>This syringe is too big to stab someone with it.</span>"
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
		reagents.add_reagent("chloralhydrate", 50)
		mode = SYRINGE_INJECT
		update_icon()
