////////////////////////////////////////////////////////////////////////////////
/// HYPOSPRAY
////////////////////////////////////////////////////////////////////////////////

/obj/item/weapon/reagent_containers/hypospray //obsolete, use hypospray/vial for the actual hypospray item
	name = "hypospray"
	desc = "The DeForest Medical Corporation, a subsidiary of Zeng-Hu Pharmaceuticals, hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients."
	icon = 'icons/obj/syringe.dmi'
	item_state = "hypo"
	icon_state = "hypo"
	origin_tech = list(TECH_MATERIAL = 4, TECH_BIO = 5)
	amount_per_transfer_from_this = 5
	unacidable = 1
	volume = 30
	possible_transfer_amounts = null
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	slot_flags = SLOT_BELT

/obj/item/weapon/reagent_containers/hypospray/attack(mob/living/M, mob/user)
	if(!reagents.total_volume)
		to_chat(user, "<span class='warning'>[src] is empty.</span>")
		return
	if (!istype(M))
		return

	var/mob/living/carbon/human/H = M
	if(istype(H))
		var/obj/item/organ/external/affected = H.get_organ(user.zone_sel.selecting)
		if(!affected)
			to_chat(user, "<span class='danger'>\The [H] is missing that limb!</span>")
			return
		else if(BP_IS_ROBOTIC(affected))
			to_chat(user, "<span class='danger'>You cannot inject a robotic limb.</span>")
			return

	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user.do_attack_animation(M)
	to_chat(user, "<span class='notice'>You inject [M] with [src].</span>")
	to_chat(M, "<span class='notice'>You feel a tiny prick!</span>")
	playsound(src, 'sound/effects/hypospray.ogg',25)
	user.visible_message("<span class='warning'>[user] injects [M] with [src].</span>")

	if(M.reagents)
		var/contained = reagentlist()
		var/trans = reagents.trans_to_mob(M, amount_per_transfer_from_this, CHEM_BLOOD)
		admin_inject_log(user, M, src, contained, trans)
		to_chat(user, "<span class='notice'>[trans] units injected. [reagents.total_volume] units remaining in \the [src].</span>")

	return

/obj/item/weapon/reagent_containers/hypospray/vial
	name = "hypospray"
	item_state = "autoinjector"
	desc = "The DeForest Medical Corporation, a subsidiary of Zeng-Hu Pharmaceuticals, hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients. Uses a replacable 30u vial."
	var/obj/item/weapon/reagent_containers/glass/beaker/vial/loaded_vial
	possible_transfer_amounts = "1;2;5;10;15;20;30"
	amount_per_transfer_from_this = 5
	volume = 0

/obj/item/weapon/reagent_containers/hypospray/vial/New()
	..()
	loaded_vial = new /obj/item/weapon/reagent_containers/glass/beaker/vial(src)
	volume = loaded_vial.volume
	reagents.maximum_volume = loaded_vial.reagents.maximum_volume

/obj/item/weapon/reagent_containers/hypospray/vial/proc/remove_vial(mob/user, swap_mode)
	if(!loaded_vial)
		return
	reagents.trans_to_holder(loaded_vial.reagents,volume)
	reagents.maximum_volume = 0
	loaded_vial.update_icon()
	user.put_in_hands(loaded_vial)
	loaded_vial = null
	if (swap_mode != "swap") // if swapping vials, we will print a different message in another proc
		to_chat(user, "You remove the vial from the [src].")

/obj/item/weapon/reagent_containers/hypospray/vial/attack_hand(mob/user)
	if(user.get_inactive_hand() == src)
		if(!loaded_vial)
			to_chat(user, "<span class='notice'>There is no vial loaded in the [src].</span>")
			return
		remove_vial(user)
		update_icon()
		playsound(loc, 'sound/weapons/flipblade.ogg', 50, 1)
		return
	return ..()

/obj/item/weapon/reagent_containers/hypospray/vial/attackby(obj/item/weapon/W, mob/user)
	var/usermessage = ""
	if(istype(W, /obj/item/weapon/reagent_containers/glass/beaker/vial))
		if(!do_after(user,10) || !(W in user))
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

/obj/item/weapon/reagent_containers/hypospray/vial/afterattack(obj/target, mob/user, proximity) // hyposprays can be dumped into, why not out? uses standard_pour_into helper checks.
	if(!proximity)
		return
	standard_pour_into(user, target)

/obj/item/weapon/reagent_containers/hypospray/autoinjector
	name = "autoinjector"
	desc = "A rapid and safe way to administer small amounts of drugs by untrained or trained personnel."
	icon_state = "injector"
	item_state = "autoinjector"
	amount_per_transfer_from_this = 5
	volume = 5
	origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2)
	slot_flags = SLOT_BELT | SLOT_EARS
	w_class = ITEM_SIZE_TINY
	var/list/starts_with = list(/datum/reagent/inaprovaline = 5)
	var/band_color = COLOR_CYAN
	var/time = 1 SECONDS // takes less time than a normal syringe

/obj/item/weapon/reagent_containers/hypospray/autoinjector/New()
	..()
	for(var/T in starts_with)
		reagents.add_reagent(T, starts_with[T])
	update_icon()
	return

/obj/item/weapon/reagent_containers/hypospray/autoinjector/attack(mob/M as mob, mob/user as mob)
	if(user != M && !M.incapacitated())
		to_chat(user, SPAN_WARNING("\The [user] is trying to inject \the [M] with \the [name]."))
		if(!do_mob(user, M, time))
			return
	..()
	if(reagents.total_volume <= 0) //Prevents autoinjectors to be refilled.
		atom_flags &= ~ATOM_FLAG_OPEN_CONTAINER
	update_icon()
	return

/obj/item/weapon/reagent_containers/hypospray/autoinjector/on_update_icon()
	overlays.Cut()
	if(reagents.total_volume > 0)
		icon_state = "[initial(icon_state)]1"
	else
		icon_state = "[initial(icon_state)]0"
	overlays+= overlay_image(icon,"injector_band",band_color,RESET_COLOR)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/examine(mob/user)
	. = ..(user)
	if(reagents && reagents.reagent_list.len)
		to_chat(user, "<span class='notice'>It is currently loaded.</span>")
	else
		to_chat(user, "<span class='notice'>It is spent.</span>")

/obj/item/weapon/reagent_containers/hypospray/autoinjector/detox
	name = "autoinjector (antitox)"
	band_color = COLOR_GREEN
	starts_with = list(/datum/reagent/dylovene = 5)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/pain
	name = "autoinjector (painkiller)"
	band_color = COLOR_PURPLE
	starts_with = list(/datum/reagent/tramadol = 5)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/combatpain
	name = "autoinjector (oxycodone)"
	band_color = COLOR_DARK_GRAY
	starts_with = list(/datum/reagent/tramadol/oxycodone = 5)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/antirad
	name = "autoinjector (anti-rad)"
	band_color = COLOR_AMBER
	starts_with = list(/datum/reagent/hyronalin = 5)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/mindbreaker
	name = "autoinjector"
	band_color = COLOR_DARK_GRAY
	starts_with = list(/datum/reagent/mindbreaker = 5)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/empty
	name = "autoinjector"
	band_color = COLOR_WHITE
	starts_with = list()
	matter = list(MATERIAL_PLASTIC = 150, MATERIAL_GLASS = 50)