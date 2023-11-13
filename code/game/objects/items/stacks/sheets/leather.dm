/obj/item/stack/animalhide/human
	name = "human skin"
	desc = "The by-product of human farming."
	singular_name = "human skin piece"
	icon_state = "sheet-hide"
	icon = 'icons/obj/materials/hides.dmi'

/obj/item/stack/animalhide/corgi
	name = "corgi hide"
	desc = "The by-product of corgi farming."
	singular_name = "corgi hide piece"
	icon_state = "sheet-corgi"
	icon = 'icons/obj/materials/hides.dmi'

/obj/item/stack/animalhide/cat
	name = "cat hide"
	desc = "The by-product of cat farming."
	singular_name = "cat hide piece"
	icon_state = "sheet-cat"
	icon = 'icons/obj/materials/hides.dmi'

/obj/item/stack/animalhide/monkey
	name = "monkey hide"
	desc = "The by-product of monkey farming."
	singular_name = "monkey hide piece"
	icon_state = "sheet-monkey"
	icon = 'icons/obj/materials/hides.dmi'

/obj/item/stack/animalhide/lizard
	name = "lizard skin"
	desc = "Sssssss..."
	singular_name = "lizard skin piece"
	icon_state = "sheet-lizard"
	icon = 'icons/obj/materials/hides.dmi'

/obj/item/stack/animalhide/xeno
	name = "alien hide"
	desc = "The skin of a terrible creature."
	singular_name = "alien hide piece"
	icon_state = "sheet-xeno"
	icon = 'icons/obj/materials/hides.dmi'

//don't see anywhere else to put these, maybe together they could be used to make the xenos suit?
/obj/item/stack/xenochitin
	name = "alien chitin"
	desc = "A piece of the hide of a terrible creature."
	singular_name = "alien hide piece"
	icon = 'icons/obj/alien.dmi'
	icon_state = "chitin"

/obj/item/xenos_claw
	name = "alien claw"
	desc = "The claw of a terrible creature."
	icon = 'icons/obj/alien.dmi'
	icon_state = "claw"

/obj/item/weed_extract
	name = "weed extract"
	desc = "A piece of slimy, purplish weed."
	icon = 'icons/obj/alien.dmi'
	icon_state = "weed_extract"

/obj/item/stack/hairlesshide
	name = "hairless hide"
	desc = "This hide was stripped of it's hair, but still needs tanning."
	singular_name = "hairless hide piece"
	icon_state = "sheet-hairlesshide"
	icon = 'icons/obj/materials/hides.dmi'

/obj/item/stack/wetleather
	name = "wet leather"
	desc = "This leather has been cleaned but still needs to be dried."
	singular_name = "wet leather piece"
	icon_state = "sheet-wetleather"
	icon = 'icons/obj/materials/hides.dmi'
	var/wetness = 30 //Reduced when exposed to high temperautres
	var/drying_threshold_temperature = 500 //Kelvin to start drying

//Step one - dehairing.
/obj/item/stack/animalhide/use_tool(obj/item/W, mob/living/user, list/click_params)
	if (is_sharp(W))
		visible_message(
			SPAN_NOTICE("\The [user] starts cutting hair off \the [src]"),
			SPAN_NOTICE("You start cutting the hair off \the [src]"),
			SPAN_NOTICE("You hear the sound of a knife rubbing against flesh.")
			)
		if (do_after(user, 5 SECONDS, src, DO_REPAIR_CONSTRUCT))
			to_chat(user, SPAN_NOTICE("You cut the hair from \the [get_exact_name(1)]"))
			for (var/obj/item/stack/hairlesshide/HS in user.loc)
				if(HS.amount < 50)
					HS.amount++
					src.use(1)
					return TRUE
			var/obj/item/stack/hairlesshide/HS = new(usr.loc)
			HS.amount = 1
			use(1)
		return TRUE
	else
		return ..()


//Step two - washing..... it's actually in washing machine code.

//Step three - drying
/obj/item/stack/wetleather/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	..()
	if(exposed_temperature >= drying_threshold_temperature)
		wetness--
		if(wetness == 0)
			//Try locating an exisitng stack on the tile and add to there if possible
			for(var/obj/item/stack/material/leather/HS in src.loc)
				if(HS.amount < 50)
					HS.amount++
					src.use(1)
					wetness = initial(wetness)
					break
			//If it gets to here it means it did not find a suitable stack on the tile.
			var/obj/item/stack/material/leather/HS = new(src.loc)
			HS.amount = 1
			wetness = initial(wetness)
			src.use(1)
