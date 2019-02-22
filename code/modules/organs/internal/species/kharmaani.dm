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

/obj/item/weapon/card/id/ascent
	access = list(access_ascent)

/obj/item/weapon/card/id/ascent/prevent_tracking()
	return TRUE