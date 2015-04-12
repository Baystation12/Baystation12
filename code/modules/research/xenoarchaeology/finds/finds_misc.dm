
/obj/item/weapon/shard/phoron
	name = "phoron shard"
	desc = "A shard of phoron glass. Considerably tougher then normal glass shards. Apparently not tough enough to be a window."
	force = 8.0
	throwforce = 15.0
	icon_state = "phoronlarge"
	sharp = 1
	edge = 1

/obj/item/weapon/shard/phoron/New()

	src.icon_state = pick("phoronlarge", "phoronmedium", "phoronsmall")
	switch(src.icon_state)
		if("phoronsmall")
			src.pixel_x = rand(-12, 12)
			src.pixel_y = rand(-12, 12)
		if("phoronmedium")
			src.pixel_x = rand(-8, 8)
			src.pixel_y = rand(-8, 8)
		if("phoronlarge")
			src.pixel_x = rand(-5, 5)
			src.pixel_y = rand(-5, 5)
		else
	return

/obj/item/weapon/shard/phoron/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if ( istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.remove_fuel(0, user))
			var/obj/item/stack/sheet/glass/phoronglass/NG = new (user.loc)
			for (var/obj/item/stack/sheet/glass/phoronglass/G in user.loc)
				if(G==NG)
					continue
				if(G.amount>=G.max_amount)
					continue
				G.attackby(NG, user)
				usr << "You add the newly-formed phoron glass to the stack. It now contains [NG.amount] sheets."
			//SN src = null
			del(src)
			return
	return ..()

//legacy crystal
/obj/machinery/crystal
	name = "Crystal"
	icon = 'icons/obj/mining.dmi'
	icon_state = "crystal"

/obj/machinery/crystal/New()
	if(prob(50))
		icon_state = "crystal2"

//large finds
				/*
				/obj/machinery/syndicate_beacon
				/obj/machinery/wish_granter
			if(18)
				item_type = "jagged green crystal"
				additional_desc = pick("It shines faintly as it catches the light.","It appears to have a faint inner glow.","It seems to draw you inward as you look it at.","Something twinkles faintly as you look at it.","It's mesmerizing to behold.")
				icon_state = "crystal"
				apply_material_decorations = 0
				if(prob(10))
					apply_image_decorations = 1
			if(19)
				item_type = "jagged pink crystal"
				additional_desc = pick("It shines faintly as it catches the light.","It appears to have a faint inner glow.","It seems to draw you inward as you look it at.","Something twinkles faintly as you look at it.","It's mesmerizing to behold.")
				icon_state = "crystal2"
				apply_material_decorations = 0
				if(prob(10))
					apply_image_decorations = 1
				*/
			//machinery type artifacts?
