// ID 'card'
/obj/item/weapon/card/id/ascent
	name = "alien chip"
	icon = 'icons/obj/ascent.dmi'
	icon_state = "access_card"
	desc = "A slender, complex chip of alien circuitry."
	access = list(access_ascent)

/obj/item/weapon/card/id/ascent/GetAccess()
	var/mob/living/carbon/human/H = loc
	if(istype(H) && !(H.species.name in ALL_ASCENT_SPECIES))
		. = list()
	else
		. = ..()

/obj/item/weapon/card/id/ascent/on_update_icon()
	return

/obj/item/weapon/card/id/ascent/prevent_tracking()
	return TRUE

/obj/item/weapon/card/id/ascent/attack_self(mob/user)
	return

/obj/item/weapon/card/id/ascent/show()
	return

// ID implant/organ/interface device.
/obj/item/organ/internal/controller
	name = "system controller"
	desc = "A fist-sized lump of complex circuitry."
	icon = 'icons/obj/ascent.dmi'
	icon_state = "plant"
	parent_organ = BP_CHEST
	organ_tag = BP_SYSTEM_CONTROLLER
	var/obj/item/weapon/card/id/id_card = /obj/item/weapon/card/id/ascent

/obj/item/organ/internal/controller/Initialize()
	if(ispath(id_card))
		id_card = new id_card(src)
	robotize()
	. = ..()
	if(owner)
		owner.set_id_info(id_card)

/obj/item/organ/internal/controller/GetIdCard()
	//Not using is_broken() because it should be able to function when CUT_AWAY is set
	if(damage < min_broken_damage)
		return id_card

/obj/item/organ/internal/controller/GetAccess()
	if(id_card && damage < min_broken_damage)
		return id_card.GetAccess()
