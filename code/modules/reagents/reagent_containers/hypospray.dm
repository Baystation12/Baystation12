////////////////////////////////////////////////////////////////////////////////
/// HYPOSPRAY
////////////////////////////////////////////////////////////////////////////////

/obj/item/reagent_containers/hypospray //obsolete, use hypospray/vial for the actual hypospray item
	name = "hypospray"
	desc = "The DeForest Medical Corporation, a subsidiary of Zeng-Hu Pharmaceuticals, hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients."
	icon = 'icons/obj/syringe.dmi'
	item_state = "hypo"
	icon_state = "hypo"
	origin_tech = list(TECH_MATERIAL = 4, TECH_BIO = 5)
	amount_per_transfer_from_this = 5
	unacidable = TRUE
	volume = 30
	possible_transfer_amounts = null
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	slot_flags = SLOT_BELT

	// autoinjectors takes less time than a normal syringe (overriden for hypospray).
	// This delay is only applied when injecting concious mobs, and is not applied for self-injection
	// The 1.9 factor scales it so it takes the following number of seconds:
	// NONE   1.47
	// BASIC  1.00
	// ADEPT  0.68
	// EXPERT 0.53
	// PROF   0.39
	var/time = (1 SECONDS) / 1.9
	var/single_use = TRUE // autoinjectors are not refillable (overriden for hypospray)

/obj/item/reagent_containers/hypospray/attack(mob/living/M, mob/user)
	if(!reagents.total_volume)
		to_chat(user, "<span class='warning'>[src] is empty.</span>")
		return
	if (!istype(M))
		return

	var/allow = M.can_inject(user, check_zone(user.zone_sel.selecting))
	if(!allow)
		return

	if (allow == INJECTION_PORT)
		if(M != user)
			user.visible_message(SPAN_WARNING("\The [user] begins hunting for an injection port on \the [M]'s suit!"))
		else
			to_chat(user, SPAN_NOTICE("You begin hunting for an injection port on your suit."))
		if(!user.do_skilled(INJECTION_PORT_DELAY, SKILL_MEDICAL, M, do_flags = DO_MEDICAL))
			return

	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user.do_attack_animation(M)

	if(user != M && !M.incapacitated() && time) // you're injecting someone else who is concious, so apply the device's intrisic delay
		to_chat(user, SPAN_WARNING("\The [user] is trying to inject \the [M] with \the [name]."))
		if(!user.do_skilled(time, SKILL_MEDICAL, M, do_flags = DO_MEDICAL))
			return

	if(single_use && reagents.total_volume <= 0) // currently only applies to autoinjectors
		atom_flags &= ~ATOM_FLAG_OPEN_CONTAINER // Prevents autoinjectors to be refilled.

	to_chat(user, SPAN_NOTICE("You inject [M] with [src]."))
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.custom_pain(SPAN_WARNING("You feel a tiny prick!"), 1, TRUE, H.get_organ(user.zone_sel.selecting))

	playsound(src, 'sound/effects/hypospray.ogg',25)
	user.visible_message("<span class='warning'>[user] injects [M] with [src].</span>")

	if(M.reagents)
		var/should_admin_log = reagents.should_admin_log()
		var/contained = reagentlist()
		var/trans = reagents.trans_to_mob(M, amount_per_transfer_from_this, CHEM_BLOOD)
		if (should_admin_log)
			admin_inject_log(user, M, src, contained, trans)
		to_chat(user, "<span class='notice'>[trans] units injected. [reagents.total_volume] units remaining in \the [src].</span>")

	return

/obj/item/reagent_containers/hypospray/vial
	name = "hypospray"
	item_state = "autoinjector"
	desc = "The DeForest Medical Corporation, a subsidiary of Zeng-Hu Pharmaceuticals, hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients. Uses a replacable 30u vial."
	var/obj/item/reagent_containers/glass/beaker/vial/loaded_vial
	possible_transfer_amounts = "1;2;5;10;15;20;30"
	amount_per_transfer_from_this = 5
	volume = 0
	time = 0 // hyposprays are instant for conscious people
	single_use = FALSE

/obj/item/reagent_containers/hypospray/vial/New()
	..()
	loaded_vial = new /obj/item/reagent_containers/glass/beaker/vial(src)
	volume = loaded_vial.volume
	reagents.maximum_volume = loaded_vial.reagents.maximum_volume

/obj/item/reagent_containers/hypospray/vial/proc/remove_vial(mob/user, swap_mode)
	if(!loaded_vial)
		return
	reagents.trans_to_holder(loaded_vial.reagents,volume)
	reagents.maximum_volume = 0
	loaded_vial.update_icon()
	user.put_in_hands(loaded_vial)
	loaded_vial = null
	if (swap_mode != "swap") // if swapping vials, we will print a different message in another proc
		to_chat(user, "You remove the vial from the [src].")

/obj/item/reagent_containers/hypospray/vial/attack_hand(mob/user)
	if(user.get_inactive_hand() == src)
		if(!loaded_vial)
			to_chat(user, "<span class='notice'>There is no vial loaded in the [src].</span>")
			return
		remove_vial(user)
		update_icon()
		playsound(loc, 'sound/weapons/flipblade.ogg', 50, 1)
		return
	return ..()

/obj/item/reagent_containers/hypospray/vial/attackby(obj/item/W, mob/user)
	var/usermessage = ""
	if(istype(W, /obj/item/reagent_containers/glass/beaker/vial))
		if(!do_after(user, 1 SECOND, src, DO_PUBLIC_UNIQUE) || !(W in user))
			return 0
		if(!user.unEquip(W, src))
			return
		if(loaded_vial)
			remove_vial(user, "swap")
			usermessage = "You load \the [W] into \the [src] as you remove the old one."
		else
			usermessage = "You load \the [W] into \the [src]."
		if(W.is_open_container())
			W.atom_flags ^= ATOM_FLAG_OPEN_CONTAINER
			W.update_icon()
		loaded_vial = W
		reagents.maximum_volume = loaded_vial.reagents.maximum_volume
		loaded_vial.reagents.trans_to_holder(reagents,volume)
		user.visible_message("<span class='notice'>[user] has loaded [W] into \the [src].</span>","<span class='notice'>[usermessage]</span>")
		update_icon()
		playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)
		return
	..()

/obj/item/reagent_containers/hypospray/vial/afterattack(obj/target, mob/user, proximity) // hyposprays can be dumped into, why not out? uses standard_pour_into helper checks.
	if(!proximity)
		return
	if (!reagents.total_volume && istype(target, /obj/item/reagent_containers/glass))
		var/good_target = is_type_in_list(target, list(
			/obj/item/reagent_containers/glass/beaker,
			/obj/item/reagent_containers/glass/bottle
		))
		if (!good_target)
			return
		if (!target.is_open_container())
			to_chat(user, SPAN_ITALIC("\The [target] is closed."))
			return
		if (!target.reagents?.total_volume)
			to_chat(user, SPAN_ITALIC("\The [target] is empty."))
			return
		var/trans = target.reagents.trans_to_obj(src, amount_per_transfer_from_this)
		to_chat(user, SPAN_NOTICE("You fill \the [src] with [trans] units of the solution."))
		return
	standard_pour_into(user, target)

/obj/item/reagent_containers/hypospray/autoinjector
	name = "autoinjector"
	desc = "A rapid and safe way to administer small amounts of drugs by untrained or trained personnel."
	icon_state = "injector"
	item_state = "autoinjector"
	amount_per_transfer_from_this = 5
	volume = 5
	origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2)
	slot_flags = SLOT_BELT | SLOT_EARS
	w_class = ITEM_SIZE_TINY
	matter = list(MATERIAL_PLASTIC = 150, MATERIAL_GLASS = 50)
	var/list/starts_with = list()
	/// Color. If set, forces the autoinjectors window color to instead be a solid band color matching the provided color. If not set, the band color instead matches the contained reagent color.
	var/band_color

/obj/item/reagent_containers/hypospray/autoinjector/New()
	..()
	for(var/T in starts_with)
		reagents.add_reagent(T, starts_with[T])
	update_icon()
	return

/obj/item/reagent_containers/hypospray/autoinjector/attack(mob/M as mob, mob/user as mob)
	..()
	update_icon()

/obj/item/reagent_containers/hypospray/autoinjector/on_reagent_change()
	update_icon()

/obj/item/reagent_containers/hypospray/autoinjector/on_update_icon()
	overlays.Cut()
	if(reagents.total_volume > 0)
		icon_state = "[initial(icon_state)]1"
	else
		icon_state = "[initial(icon_state)]0"
	var/overlay_color = band_color
	if (isnull(overlay_color))
		if (reagents.total_volume)
			overlay_color = reagents.get_color()
		else
			overlay_color = COLOR_GRAY
	overlays += overlay_image(icon, "injector_band", overlay_color, RESET_COLOR)

/obj/item/reagent_containers/hypospray/autoinjector/examine(mob/user)
	. = ..(user)
	if(reagents && reagents.reagent_list.len)
		to_chat(user, "<span class='notice'>It is currently loaded.</span>")
	else
		to_chat(user, "<span class='notice'>It is spent.</span>")

/obj/item/reagent_containers/hypospray/autoinjector/detox
	name = "autoinjector (antitox)"
	starts_with = list(/datum/reagent/dylovene = 5)

/obj/item/reagent_containers/hypospray/autoinjector/pain
	name = "autoinjector (painkiller)"
	starts_with = list(/datum/reagent/tramadol = 5)

//from infinity
/obj/item/reagent_containers/hypospray/autoinjector/brute
	name = "autoinjector (anti-injury)"
	band_color = COLOR_RED
	starts_with = list(/datum/reagent/bicaridine = 5)

/obj/item/reagent_containers/hypospray/autoinjector/burn
	name = "autoinjector (anti-burn)"
	band_color = COLOR_DARK_ORANGE
	starts_with = list(/datum/reagent/kelotane = 5)

/obj/item/reagent_containers/hypospray/autoinjector/inaprovaline
	name = "autoinjector (inaprovaline)"
	band_color = COLOR_CYAN
	starts_with = list(/datum/reagent/inaprovaline = 5)
//end from infinity

/obj/item/reagent_containers/hypospray/autoinjector/combatpain
	name = "autoinjector (oxycodone)"
	starts_with = list(/datum/reagent/tramadol/oxycodone = 5)

/obj/item/reagent_containers/hypospray/autoinjector/antirad
	name = "autoinjector (anti-rad)"
	starts_with = list(/datum/reagent/hyronalin = 5)

/obj/item/reagent_containers/hypospray/autoinjector/mindbreaker
	name = "autoinjector"
	starts_with = list(/datum/reagent/mindbreaker = 5)

/obj/item/reagent_containers/hypospray/autoinjector/combatstim
	name ="autoinjector (combat Stimulants)"
	volume = 15
	amount_per_transfer_from_this = 15
	starts_with = list(/datum/reagent/inaprovaline = 10, /datum/reagent/hyperzine = 3, /datum/reagent/synaptizine = 1)

/obj/item/reagent_containers/hypospray/autoinjector/coagulant
	name ="autoinjector (coagulant)"
	starts_with = list(/datum/reagent/coagulant = 1, /datum/reagent/nanoblood = 4)

/obj/item/reagent_containers/hypospray/autoinjector/dexalin_plus
	name ="autoinjector (dexalin plus)"
	starts_with = list(/datum/reagent/dexalinp = 5)

/obj/item/reagent_containers/hypospray/autoinjector/inaprovaline
	name = "autoinjector (inaprovaline)"
	starts_with = list(/datum/reagent/inaprovaline = 5)
