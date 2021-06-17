/decl/crafting_stage/material/stunprod_rod
	begins_with_object_type = /obj/item/handcuffs/cable
	item_icon_state = "wiredrod"
	progress_message = "You wind the cable cuffs around the top of the steel rod."
	completion_trigger_type = /obj/item/stack/material/rods
	stack_consume_amount = 1
	next_stages = list(
		/decl/crafting_stage/spear_blade_shard, 
		/decl/crafting_stage/spear_blade_blade, 
		/decl/crafting_stage/stunprod_wirecutters
	)

/decl/crafting_stage/spear_blade_shard
	completion_trigger_type = /obj/item/material/shard
	progress_message = "You fasten the shard to the top of the rod with the cable."
	product = /obj/item/material/twohanded/spear

/decl/crafting_stage/spear_blade_shard/get_product(var/obj/item/work)
	var/obj/item/material/shard/blade = locate() in work
	. = ispath(product, /obj/item/material) && new product(get_turf(work), blade && blade.material && blade.material.name)

/decl/crafting_stage/spear_blade_blade
	completion_trigger_type = /obj/item/material/butterflyblade
	progress_message = "You fasten the blade to the top of the rod with the cable."
	product = /obj/item/material/twohanded/spear

/decl/crafting_stage/spear_blade_blade/get_product(var/obj/item/work)
	var/obj/item/material/butterflyblade/blade = locate() in work
	. = ispath(product, /obj/item/material) && new product(get_turf(work), blade && blade.material && blade.material.name)

/decl/crafting_stage/stunprod_wirecutters
	completion_trigger_type = /obj/item/wirecutters
	progress_message = "You fasten the wirecutters to the top of the rod with the cable, prongs outward."
	product = /obj/item/melee/baton/cattleprod
