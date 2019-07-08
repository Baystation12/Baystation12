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

/obj/item/weapon/card/id/ascent
	access = list(access_ascent)

/obj/item/weapon/card/id/ascent/prevent_tracking()
	return TRUE