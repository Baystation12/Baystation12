/obj/item/material/coin
	name = "coin"
	icon = 'icons/obj/materials/coin.dmi'
	icon_state = "coin1"
	applies_material_colour = TRUE
	randpixel = 8
	throwforce = 1
	max_force = 5
	force_multiplier = 0.1
	thrown_force_multiplier = 0.1
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS

	/// The smallest interval allowed between coin flips.
	var/const/FLIP_COOLDOWN = 5 SECONDS

	/// The next time this coin can be flipped.
	var/next_flip = 0

	/// The color of wire used on this coin, if any.
	var/string_color


/obj/item/material/coin/Initialize()
	if (icon_state == "coin1")
		icon_state = "coin[rand(1, 10)]"
	return ..()


/obj/item/material/coin/on_update_icon()
	..()
	if (!isnull(string_color))
		var/image/image = image(icon = icon, icon_state = "coin_string_overlay")
		image.appearance_flags |= RESET_COLOR
		image.color = string_color
		AddOverlays(image)
	else
		ClearOverlays()


/obj/item/material/coin/use_after(atom/target, mob/living/user)

	if (target == user)
		attack_self(user)
		return TRUE
	if (ismob(target))
		if (user.a_intent == I_HURT)
			user.visible_message(
				SPAN_WARNING("\The [user] menaces \the [target] with \a [src]."),
				SPAN_WARNING("You menace \the [target] with \the [src]."),
				range = 5
			)
			return TRUE
		user.visible_message(
			SPAN_ITALIC("\The [user] presents \a [src] to \the [target]."),
			SPAN_ITALIC("You present \the [src] to \the [target]."),
			range = 5
		)
		return TRUE
	if (isobj(target) && user.a_intent == I_HURT)
		playsound(user.loc, 'sound/effects/coin_flip.ogg', 75, TRUE)
		user.visible_message(
			SPAN_ITALIC("\The [user] taps \a [src] against \a [target]."),
			SPAN_ITALIC("You tap \the [src] against \the [target]."),
			range = 5
		)
		return TRUE


/obj/item/material/coin/attack_self(mob/living/user)
	if (world.time < next_flip)
		return
	next_flip = world.time + FLIP_COOLDOWN
	playsound(user.loc, 'sound/effects/coin_flip.ogg', 75, 1)
	var/result = pick("front", "back")
	user.visible_message(
		SPAN_ITALIC("\The [user] flips \a [src], landing [result] side up."),
		SPAN_ITALIC("You flip \the [src], landing [result] side up."),
		range = 5
	)


/obj/item/material/coin/use_tool(obj/item/item, mob/living/user, list/click_params)
	if (isCoil(item) && isnull(string_color))
		var/obj/item/stack/cable_coil/coil = item
		if (!coil.use(1))
			to_chat(user, SPAN_WARNING("Your cable coil is a bug. Your action fails."))
			return TRUE
		user.visible_message(
			SPAN_ITALIC("\The [user] attaches some wire to \a [src]."),
			SPAN_ITALIC("You attach some wire to \the [src]."),
			range = 5
		)
		string_color = coil.color
		update_icon()
		return TRUE

	if (isWirecutter(item) && !isnull(string_color))
		new /obj/item/stack/cable_coil (get_turf(user), 1, string_color)
		user.visible_message(
			SPAN_ITALIC("\The [user] removes a wire from \a [src]."),
			SPAN_ITALIC("You remove the wire from \the [src]."),
			range = 5
		)
		string_color = null
		update_icon()
		return TRUE
	return ..()

/// Non-craftable coins intented to display specific imagery.
/obj/item/material/coin/challenge
	abstract_type = /obj/item/material/coin/challenge
	applies_material_colour = FALSE


/obj/item/material/coin/challenge/on_update_icon()
	ClearOverlays()
	if (isnull(string_color))
		return
	var/image/image = image(icon = icon, icon_state = "coin_string_overlay")
	image.appearance_flags |= RESET_COLOR
	image.color = string_color
	AddOverlays(image)

/obj/item/material/coin/challenge/throw_impact()
	..()
	if (QDELETED(src))
		return
	playsound(loc, 'sound/effects/coin_flip.ogg', 75, 1)
	visible_message(
		SPAN_WARNING("\The [src] clatters to \the [get_turf(src)]!")
	)

/obj/item/material/coin/challenge/verb/drop_coin()
	set src in usr
	set category = "Object"
	set name = "Drop Challenge Coin"
	var/turf/turf = usr.loc
	if (!isturf(turf))
		return
	if (!usr.IsHolding(src))
		to_chat(usr, SPAN_WARNING("You must hold \the [src] in your hands."))
		return
	if (!usr.unEquip(src, turf))
		return
	playsound(turf, 'sound/effects/coin_flip.ogg', 75, 1)
	usr.visible_message(
		SPAN_WARNING("\The [usr] flicks \a [src] onto the ground!"),
		SPAN_WARNING("You flick \the [src] onto the ground!")
	)

///Antag challenge coins, used to hack vendors.
/obj/item/material/coin/challenge/syndie
	name = "Syndicate Challenge Coin"
	desc = "A heavy coin emblazoned with a shiny, red skull. The rim of the coin shows words in a language you do not understand."
	icon = 'icons/obj/materials/coin.dmi'
	icon_state = "syndie"

/obj/item/material/coin/aluminium
	default_material = MATERIAL_ALUMINIUM


/obj/item/material/coin/bronze
	default_material = MATERIAL_BRONZE


/obj/item/material/coin/copper
	default_material = MATERIAL_COPPER


/obj/item/material/coin/electrum
	default_material = MATERIAL_ELECTRUM


/obj/item/material/coin/gold
	default_material = MATERIAL_GOLD


/obj/item/material/coin/iron
	default_material = MATERIAL_IRON


/obj/item/material/coin/plastic
	default_material = MATERIAL_PLASTIC


/obj/item/material/coin/platinum
	default_material = MATERIAL_PLATINUM


/obj/item/material/coin/silver
	default_material = MATERIAL_SILVER


/obj/item/material/coin/steel
	default_material = MATERIAL_STEEL


/obj/item/material/coin/wood
	default_material = MATERIAL_WOOD


/obj/random/coin
	name = "random coin"
	desc = "This is a random coin."
	icon = 'icons/obj/materials/coin.dmi'
	icon_state = "coin1"


/obj/random/coin/spawn_choices()
	return list(
		/obj/item/material/coin/aluminium = 2,
		/obj/item/material/coin/bronze = 3,
		/obj/item/material/coin/copper = 2,
		/obj/item/material/coin/electrum = 2,
		/obj/item/material/coin/gold = 1,
		/obj/item/material/coin/iron = 3,
		/obj/item/material/coin/plastic = 2,
		/obj/item/material/coin/platinum = 1,
		/obj/item/material/coin/silver = 1,
		/obj/item/material/coin/steel = 2,
		/obj/item/material/coin/wood = 2
	)


/datum/gear/trinket/coin
	display_name = "coin selection"
	path = /obj/item/material/coin
	cost = 2


/datum/gear/trinket/coin/New()
	..()
	var/list/options = list()
	options["coin, aluminium"] = /obj/item/material/coin/aluminium
	options["coin, bronze"] = /obj/item/material/coin/bronze
	options["coin, copper"] = /obj/item/material/coin/copper
	options["coin, electrum"] = /obj/item/material/coin/electrum
	options["coin, gold"] = /obj/item/material/coin/gold
	options["coin, iron"] = /obj/item/material/coin/iron
	options["coin, plastic"] = /obj/item/material/coin/plastic
	options["coin, platinum"] = /obj/item/material/coin/platinum
	options["coin, silver"] = /obj/item/material/coin/silver
	options["coin, steel"] = /obj/item/material/coin/steel
	options["coin, wood"] = /obj/item/material/coin/wood
	gear_tweaks += new /datum/gear_tweak/path (options)


/// Create a new random simple coin at loc and return it.
/proc/new_simple_coin(loc)
	RETURN_TYPE(/obj/item/material/coin)
	var/static/list/simple_coins = subtypesof(/obj/item/material/coin) - typesof(/obj/item/material/coin/challenge)
	var/obj/item/material/coin = pick(simple_coins)
	coin = new coin (loc)
	return coin
