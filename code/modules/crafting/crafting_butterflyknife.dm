/obj/item/material/butterflyblade
	name = "knife blade"
	desc = "A knife blade. Unusable as a weapon without a grip."
	icon = 'icons/obj/buildingobject.dmi'
	icon_state = "butterfly2"
	force_multiplier = 0.1
	thrown_force_multiplier = 0.1

/obj/item/material/butterflyhandle
	name = "concealed knife grip"
	desc = "A plasteel grip with screw fittings for a blade."
	icon = 'icons/obj/buildingobject.dmi'
	icon_state = "butterfly1"
	force_multiplier = 0.1
	thrown_force_multiplier = 0.1

/decl/crafting_stage/balisong_blade
	begins_with_object_type = /obj/item/material/butterflyhandle
	item_desc = "It's an unfinished balisong with some loose screws."
	item_icon_state = "butterfly"
	consume_completion_trigger = TRUE
	completion_trigger_type = /obj/item/material/butterflyblade
	progress_message = "You attach the knife blade to the handle."
	next_stages = list(/decl/crafting_stage/screwdriver/balisong)

/decl/crafting_stage/screwdriver/balisong
	progress_message = "You secure the handle and the blade together."
	product = /obj/item/material/knife/folding/combat/balisong

/decl/crafting_stage/screwdriver/balisong/get_product(var/obj/item/work)
	var/obj/item/material/butterflyblade/blade = locate() in work
	. = ispath(product, /obj/item/material) && new product(get_turf(work), blade && blade.material && blade.material.name)