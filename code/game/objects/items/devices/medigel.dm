/obj/item/device/medigel
	name = "medigel spray"
	desc = "Created by VeyMed in late 2311, the VMXS-103 'Aceso' is a handheld medigel spray used to seal wounds through rapid synthesis of aerosolised clotting and salving agents."
	icon = 'icons/obj/medical.dmi'
	icon_state = "medigel"
	item_state = "hypo"
	w_class = ITEM_SIZE_SMALL
	item_flags = ITEM_FLAG_NO_BLUDGEON
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_BIO = 5, TECH_ENGINEERING = 4)

	var/uses = 30
	var/max_uses = 30
	var/list/apply_sounds = list('sound/effects/spray.ogg', 'sound/effects/spray2.ogg', 'sound/effects/spray3.ogg')

/obj/item/device/medigel/attack_self(mob/living/carbon/user as mob)
	if(uses)
		to_chat (user, "\The [src] has [uses] uses remaining.")
	else
		to_chat (user, "\The [src] is empty.")

/obj/item/device/medigel/use_after(atom/target, mob/living/user, click_parameters)
	. = ..()
	if (istype(target, /mob/living/carbon/human))
		if (uses)
			var/mob/living/carbon/human/H = target
			var/treated = 0
			for (var/obj/item/organ/external/organ in H.organs)
				if (BP_IS_ROBOTIC(organ))
					continue
				for (var/datum/wound/W as anything in organ.wounds)
					if (W.bandaged && W.disinfected && W.salved)
						continue
					if (!do_after(user, W.damage / 5, H, DO_MEDICAL))
						break
					if (uses)
						uses -= 1
						treated = 1
						W.bandage()
						W.disinfect()
						W.salve()
						organ.update_damages()
						H.update_bandages(TRUE)
						playsound(user, pick(apply_sounds), 20)
						visible_message(SPAN_NOTICE("\The [user] covers \a [W.desc] on \the [H]'s [organ.name] with a fine layer of medigel."))
						update_icon()
					else
						to_chat(user, SPAN_WARNING("\The [src] is out of medigel!"))
						return
			if (treated == 0)
				to_chat(user, SPAN_NOTICE("\The [H] has no injuries in need of medigel."))
		else
			to_chat(user, SPAN_WARNING("\The [src] is out of medigel! Restock it with advanced trauma or burn kits."))
			return

/obj/item/device/medigel/use_tool(obj/item/W, mob/living/user, list/click_params)
	if (istype(W, /obj/item/stack/medical/advanced))
		var/obj/item/stack/medical/advanced/stack = W
		if (uses == max_uses)
			to_chat(user, SPAN_NOTICE("\The [src] is already fully stocked with medigel."))
		else
			var/gained_uses = 0
			if (stack.amount <= (max_uses - uses))
				gained_uses = stack.amount
				uses += gained_uses
				stack.amount -= gained_uses
				if (stack.amount == 0)
					qdel(stack)
			else
				gained_uses = (max_uses - uses)
				uses += gained_uses
				stack.amount -= gained_uses
			to_chat(user, SPAN_NOTICE("You insert \the [W] into \the [src] and convert it to [gained_uses] [gained_uses > 1 ? "doses" : "dose"] of medigel. Current doses: [uses]."))
			update_icon()
		return
	else if (istype(W, /obj/item/stack/medical))
		to_chat(user, SPAN_NOTICE("\The [src] only accepts advanced medical kits."))
		return
	else
		return ..()

/obj/item/device/medigel/on_update_icon()
	if (uses == 0)
		icon_state = "medigel-0"
	else if (uses <= 10)
		icon_state = "medigel-33"
	else if (uses <= 20)
		icon_state = "medigel-66"
	else
		icon_state = "medigel-100"
	update_held_icon()