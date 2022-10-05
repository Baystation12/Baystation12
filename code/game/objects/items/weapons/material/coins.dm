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

/obj/item/material/coin/attackby(obj/item/W, mob/user)
	if(isCoil(W) && isnull(string_colour))
		var/obj/item/stack/cable_coil/CC = W
		if(CC.use(1))
			string_colour = CC.color
			to_chat(user, SPAN_NOTICE("You attach a string to \the [src]."))
			update_icon()
			return
	else if(isWirecutter(W) && !isnull(string_colour))
		new /obj/item/stack/cable_coil/single(get_turf(user))
		string_colour = null
		to_chat(user, SPAN_NOTICE("You detach the string from \the [src]."))
		update_icon()
	else ..()

/obj/item/material/coin/attack_self(mob/user)
	playsound(user.loc, 'sound/effects/coin_flip.ogg', 75, 1)
	user.visible_message(SPAN_NOTICE("\The [user] flips \the [src] into the air and catches it, revealing that it landed on [pick("tails", "heads")]!"))

// Subtypes
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

//Challenge coins
/obj/item/challenge_coin
	name = "challenge coin"
	desc = "You probably should not be seeing this"
	abstract_type = /obj/item/challenge_coin
	icon = 'icons/obj/coin.dmi'
	icon_state = "coin1"
	randpixel = 8
	force = 1
	throwforce = 1
	w_class = 1

	//borrowed from /obj/item/reagent_containers/glass, not the best solution
	var/list/can_be_placed_into = list(
		/obj/item/storage,
		/obj/structure/table,
		/obj/structure/closet,
		/obj/machinery/disposal
	)

/obj/item/challenge_coin/afterattack(obj/target, mob/user, proximity)
	for(var/type in can_be_placed_into)
		if(istype(target, type))
			return

	if(!proximity || (target == user))
		return
	else if(istype(target, /mob/living) && (user.a_intent != I_HURT))
		user.visible_message(
			SPAN_NOTICE("\The [user] presents \the [src] to \the [target]."),
			SPAN_NOTICE("You present \the [src] to \the [target]."),
			range = 3
		)
	else
		playsound(user.loc, 'sound/effects/coin_flip.ogg', 100, 1)
		user.visible_message(
			SPAN_NOTICE("\The [user] raps \the [src] against \the [target]."),
			SPAN_NOTICE("You rap \the [src] against \the [target].")
		)

/obj/item/challenge_coin/attack_self(mob/user)
	playsound(user.loc, 'sound/effects/coin_flip.ogg', 75, 1)
	var/result = pick("front", "reverse")
	user.visible_message(
		SPAN_NOTICE("\The [user] flips \the [src] into the air and catches it, revealing that it landed on its [result] side."),
		SPAN_NOTICE("You flip \the [src] into the air and catch it, revealing that it landed on its [result] side.")
	)

//For some RP stuff
/obj/item/challenge_coin/verb/drop_challenge_coin()
	set src in usr
	set category = "Object"
	set name = "Drop Challenge Coin"
	if(usr == loc && istype(usr.loc, /turf) && usr.unEquip(src, usr.loc))
		playsound(usr.loc, 'sound/effects/coin_flip.ogg', 100, 1)
		usr.visible_message(
			SPAN_WARNING("\The [usr] flicks \the [src] into the air, and it lands clattering on the ground!"),
			SPAN_WARNING("You flick \the [src] into the air, and it lands clattering on the ground!")
		)

/obj/item/challenge_coin/throw_impact()
	..()
	if (QDELETED(src))
		return
	else
		playsound(src.loc, 'sound/effects/coin_flip.ogg', 75, 1)
		src.visible_message(SPAN_WARNING("\The [src] lands clattering on the ground!"))

//SCG challenge coins
/obj/item/challenge_coin/scg_fleet
	name = "\improper SCG Fleet challenge coin"
	icon_state = "coin_challenge_fleet"
	desc = "A bronze challenge coin distributed by the SCG Fleet. On the front is the insignia of the Fleet, and on the back is the emblem of the SCG inscribed with various dates."

/obj/item/challenge_coin/scg_army
	name = "\improper SCG Army challenge coin"
	icon_state = "coin_challenge_army"
	desc = "A bronze challenge coin distributed by the SCG Army. On the front is the insignia of the Army, and on the back is the emblem of the SCG inscribed with various dates."

/obj/item/challenge_coin/scg_naval_armsmen
	name = "\improper SCGF Naval Armsmen challenge coin"
	icon_state = "coin_challenge_naval_armsmen"
	desc = "A bronze challenge coin distributed by the SCGF Naval Armsmen. On the front is an austere emblem of the Naval Armsmen, and on the back is a saluting naval armsman with the text, \"WE GO WHERE WE'RE NEEDED.\""

/obj/item/challenge_coin/scg_gaia
	name = "\improper SCGDF Gaia Conflict challenge coin"
	icon_state = "coin_challenge_gaia"
	desc = "A bronze challenge coin distributed by the SCG Defense Forces to commemorate the Gaia Conflict. On the front is the roman numeral IV in front of a roundel of Gaian national colors, and on the back is a dove with an olive branch."

/obj/item/challenge_coin/expeditionary_corps_observatory
	name = "\improper SCG Expeditionary Corps Observatory challenge coin"
	icon_state = "coin_challenge_ec_observatory"
	desc = "A silver challenge coin distributed by the Expeditionary Corps for members of the Observatory Branch. On the front is a field of stars, and on the back is the insignia of the Expeditionary Corps on a large starship."

/obj/item/challenge_coin/expeditionary_corps_field_ops
	name = "\improper SCG Expeditionary Corps Field Operations challenge coin"
	icon_state = "coin_challenge_ec_field_ops"
	desc = "A silver challenge coin distributed by the Expeditionary Corps for members of the Field Operations Branch. On the front is a compass above an alien planet, and on the back is the insignia of the Expeditionary Corps on a large starship."

/obj/item/challenge_coin/expeditionary_corps_torch
	name = "\improper SEV Torch challenge coin"
	icon_state = "coin_challenge_ec_torch"
	desc = "A dark-colored gold challenge coin distributed by the Expeditionary Corps for those partaking in the Torch mission. On the front is the insignia of the SEV Torch, and on the back is a folksy frontiersman with the text, \"PUSHING THE BOUNDARIES.\""

//ICCG challenge coins
/obj/item/challenge_coin/iccg_navy
	name = "\improper Independent Navy challenge coin"
	icon_state = "coin_challenge_iccg_navy"
	desc = "An iron challenge coin issued by the Independent Navy. On the front is the insignia of the Independent Navy, and on the back is a rendering of the late Admiral Yevgeny Novikov."

//For away sites or whatever
/obj/item/challenge_coin/iccg_navy_old
	name = "\improper old Independent Navy challenge coin"
	icon_state = "coin_challenge_iccg_navy_old"
	desc = "A rusted and tarnished iron challenge coin once issued by the Independent Navy. On the front is the insignia of the Independent Navy, and on the back is an Independent battlecruiser with Pan-Slavic text written around it."

/obj/item/challenge_coin/iccg_swc
	name = "\improper Independent Surface Warfare Corps challenge coin"
	icon_state = "coin_challenge_iccg_swc"
	desc = "An iron challenge coin issued by the Independent Surface Warfare Corps. On the front is a mace against the Corps's parade colors, and on the back is an emboss of a bearded Independent soldier giving a thumbs-up."

/obj/item/challenge_coin/iccg_naval_infantry
	name = "\improper Independent Naval Infantry challenge coin"
	icon_state = "coin_challenge_iccg_naval_infantry"
	desc = "An iron challenge coin issued by the Independent Naval Infantry. On the front is the insignia of the Naval Infantry, and on the back is a smiling Independent marine in his dress uniform holding an ancient ceremonial rifle."

//Miscellaneous
/obj/item/challenge_coin/pcrc
	name = "\improper PCRC challenge coin"
	icon_state = "coin_challenge_pcrc"
	desc = "A gold challenge coin issued by Proxima Centauri Risk Control to its operatives. On the front are the letters \"PC\" in the Greek alphabet against the PCRC corporate color scheme, and on the back is a Spartan shield with the motto, \"IF NOT US, THEN WHO?\""

/obj/item/challenge_coin/saare
	name = "\improper SAARE challenge coin"
	icon_state = "coin_challenge_saare"
	desc = "A silver challenge coin issued by SAARE to its operatives. On the front is a golden scale of justice, and on the back is a stalwart SAARE operative standing guard."
