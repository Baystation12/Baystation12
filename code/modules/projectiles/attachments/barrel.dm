/obj/item/weapon_attachment/barrel
	name = "Suppressor"
	desc = "An attachment designed to be attached to your weapon's barrel, with varying effects."
	icon = 'code/modules/halo/icons/attachments/barrel.dmi'
	icon_state = "suppressor"
	weapon_slot = "barrel"

/obj/item/weapon_attachment/barrel/suppressor
	name = "Suppressor"
	desc = "An attachment designed to dampen the firing sound of your weapon, with a minimal impact on shot-grouping."
	icon = 'code/modules/halo/icons/attachments/barrel.dmi'
	icon_state = "suppressor"
	weapon_slot = "barrel"

/obj/item/weapon_attachment/barrel/suppressor/apply_attachment_effects(var/obj/item/weapon/gun/gun)
	. = ..()
	gun.silenced = 1

/obj/item/weapon_attachment/barrel/suppressor/remove_attachment_effects(var/obj/item/weapon/gun/gun)
	. = ..()
	gun.silenced = initial(gun.silenced)