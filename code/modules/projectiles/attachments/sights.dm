
/obj/item/weapon_attachment/sight
	name = "sight attachment"
	desc = "An attachment designed to replace or augment your gun's sight."
	icon = 'code/modules/halo/icons/attachments/sights.dmi'
	icon_state = "sight"
	weapon_slot = "sight"
	var/zoom_amount = 1

/obj/item/weapon_attachment/sight/apply_attachment_effects(var/obj/item/weapon/gun/gun)
	. = ..()
	gun.verbs += /obj/item/weapon/gun/proc/use_scope

/obj/item/weapon_attachment/sight/remove_attachment_effects(var/obj/item/weapon/gun/gun)
	. = ..()
	gun.verbs -= /obj/item/weapon/gun/proc/use_scope
/*
/obj/item/weapon_attachment/sight/rds
	name = "Red Dot Sight"
	desc = "A red dot sight which provides an increase in accuracy, resulting in a tighter grouping of consecutive shots."
*/
/obj/item/weapon_attachment/sight/ma5_scope
	name = "MA5B scope"
	desc = "A scope which provides slight magnification and an increase in accuracy."
	icon_state = "MA5-Scope"

	zoom_amount = 1.1

/obj/item/weapon_attachment/sight/br55_scope
	name = "BR55 scope"
	desc = "A scope specific to the BR55 that allows 2x magnification."
	icon_state = "BR55-CarryHandle-Scope"
	zoom_amount = 1.3