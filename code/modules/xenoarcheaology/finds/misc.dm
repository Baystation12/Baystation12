
// Phoron shards have been moved to code/game/objects/items/weapons/shards.dm

//legacy crystal
/obj/machinery/crystal
	name = "Crystal"
	icon = 'icons/obj/mining.dmi'
	icon_state = "crystal"


//Variant crystals, in case you want to spawn those directly.

/obj/machinery/crystal/pink
	name = "Crystal"
	icon_state = "crystal2"

/obj/machinery/crystal/orange
	name = "Crystal"
	icon_state = "crystal3"

/obj/machinery/crystal/New()
	..()
	icon_state = pick("crystal", "crystal2", "crystal3")

//large finds
				/*
				obj/machinery/syndicate_beacon
				obj/machinery/wish_granter
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
