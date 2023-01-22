// glass spear: A classic, but brittle.

/decl/crafting_stage/spear_blade_shard
	completion_trigger_type = /obj/item/material/shard
	progress_message = "You fasten the shard to the top of the rod with the cable."
	product = /obj/item/material/twohanded/spear

/decl/crafting_stage/spear_blade_shard/get_product(var/obj/item/work)
	var/obj/item/material/shard/blade = locate() in work
	. = ispath(product, /obj/item/material) && new product(get_turf(work), blade && blade.material && blade.material.name)

// Bladed spear: a more efficient, but expensive version.

/decl/crafting_stage/spear_blade_blade
	completion_trigger_type = /obj/item/material/small_blade
	progress_message = "You fasten the blade to the top of the rod with the cable."
	product = /obj/item/material/twohanded/spear

/decl/crafting_stage/spear_blade_blade/get_product(var/obj/item/work)
	var/obj/item/material/small_blade/blade = locate() in work
	. = ispath(product, /obj/item/material) && new product(get_turf(work), blade && blade.material && blade.material.name)

// Stunprod: a makeshift stunning tool.

/decl/crafting_stage/stunprod_wirecutters
	completion_trigger_type = /obj/item/wirecutters
	progress_message = "You fasten the wirecutters to the top of the rod with the cable, prongs outward."
	product = /obj/item/melee/baton/cattleprod
