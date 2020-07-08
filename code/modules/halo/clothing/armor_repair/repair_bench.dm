/obj/structure/repair_bench
	name = "\improper Armor Repair Bench"
	desc = "An armor repair bench outfitted with the tools and materials to repair armor, leaving in a fully combat-ready state."
	icon = 'code/modules/halo/clothing/armor_repair/armor_repair_sprites.dmi'
	icon_state = "repair_bench"
	density = 1
	anchored = 1

/obj/structure/repair_bench/proc/repair_armor(var/obj/item/clothing/c,var/mob/user)
	user.visible_message("[user] starts repairing [c] using [src]'s tools and materials.")
	if(!do_after(user,ITEM_REPAIR_DELAY/2,src,1,1,,1))
		return
	user.visible_message("[user] fully repairs [c].")
	c.armor_thickness = c.armor_thickness_max
	c.update_damage_description()

/obj/structure/repair_bench/attackby(obj/item/I, mob/user)
	if(istype(I,/obj/item/clothing))
		repair_armor(I,user)
	else
		. = ..()

/obj/structure/repair_bench/cov
	icon_state = "repair_bench_cov"

#undef ITEM_REPAIR_DELAY