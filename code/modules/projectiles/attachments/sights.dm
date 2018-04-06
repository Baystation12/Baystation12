
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

/obj/item/weapon_attachment/sight/rds
	name = "Red Dot Sight"
	desc = "A red dot sight which provides an increase in accuracy, resulting in a tighter grouping of consecutive shots."

/obj/item/weapon_attachment/sight/acog
	name = "ACOG Sight"
	desc = "A ACOG sight which provides slight magnification and an increase in accuracy."
	icon_state = "acog"

	zoom_amount = 1.1
