/obj/item/material/coin
	name = "coin"
	icon = 'icons/obj/coin.dmi'
	icon_state = "coin1"
	applies_material_colour = TRUE
	randpixel = 8
	force = 1
	throwforce = 1
	max_force = 5
	force_multiplier = 0.1
	thrown_force_multiplier = 0.1
	w_class = 1
	slot_flags = SLOT_EARS
	var/string_colour

/obj/item/material/coin/New()
	icon_state = "coin[rand(1,10)]"
	..()

/obj/item/material/coin/on_update_icon()
	..()
	if(!isnull(string_colour))
		var/image/I = image(icon = icon, icon_state = "coin_string_overlay")
		I.appearance_flags |= RESET_COLOR
		I.color = string_colour
		overlays += I
	else
		overlays.Cut()

/obj/item/material/coin/attackby(var/obj/item/W, var/mob/user)
	if(isCoil(W) && isnull(string_colour))
		var/obj/item/stack/cable_coil/CC = W
		if(CC.use(1))
			string_colour = CC.color
			to_chat(user, SPAN_NOTICE("You attach a string to the coin."))
			update_icon()
			return
	else if(isWirecutter(W) && !isnull(string_colour))
		new /obj/item/stack/cable_coil/single(get_turf(user))
		string_colour = null
		to_chat(user, SPAN_NOTICE("You detach the string from the coin."))
		update_icon()
	else ..()

/obj/item/material/coin/attack_self(var/mob/user)
	playsound(user.loc, 'sound/effects/coin_flip.ogg', 75, 1)
	user.visible_message(SPAN_NOTICE("\The [user] flips \the [src] into the air and catches it, revealing that it landed on [pick("tails", "heads")]!"))

// Subtypes.
/obj/item/material/coin/gold
	default_material = MATERIAL_GOLD

/obj/item/material/coin/silver
	default_material = MATERIAL_SILVER

/obj/item/material/coin/diamond
	default_material = MATERIAL_DIAMOND

/obj/item/material/coin/iron
	default_material = MATERIAL_IRON

/obj/item/material/coin/uranium
	default_material = MATERIAL_URANIUM

/obj/item/material/coin/platinum
	default_material = MATERIAL_PLATINUM

/obj/item/material/coin/phoron
	default_material = MATERIAL_PHORON
