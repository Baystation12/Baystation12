/obj/item/weapon_attachment/barrel
	name = "barrel attachment"
	desc = "An attachment designed to be attached to your weapon's barrel, with varying effects."
	icon = 'code/modules/halo/icons/attachments/barrel.dmi'
	icon_state = "barrel"
	weapon_slot = "barrel"

/obj/item/weapon_attachment/barrel/M395
	name = "M395 barrel attachment"
	desc = "An attachment designed to be attached to your weapon's barrel, with varying effects."
	weapon_slot = "barrel"
	can_remove = 0

/obj/item/weapon_attachment/barrel/br55
	name = "BR55 barrel attachment"
	desc = "An attachment designed to be attached to your weapon's barrel, with varying effects."
	weapon_slot = "barrel"
	can_remove = 0

/obj/item/weapon_attachment/barrel/suppressor
	name = "suppressor"
	desc = "An attachment designed to dampen the firing sound of your weapon, with a minimal impact on shot-grouping."
	icon_state = "suppressor-obj"
	weapon_slot = "barrel"

/obj/item/weapon_attachment/barrel/suppressor/apply_attachment_effects(var/obj/item/weapon/gun/gun)
	. = ..()
	gun.silenced = 1

/obj/item/weapon_attachment/barrel/suppressor/remove_attachment_effects(var/obj/item/weapon/gun/gun)
	. = ..()
	gun.silenced = initial(gun.silenced)
