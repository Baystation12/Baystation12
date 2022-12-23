/obj/structure/ironing_board
	name = "ironing board"
	desc = "An ironing board to unwrinkle your wrinkled clothing."
	icon = 'icons/obj/ironing.dmi'
	icon_state = "basic-down"
	can_buckle = TRUE
	buckle_dir = SOUTH
	buckle_stance = BUCKLE_FORCE_PRONE

	var/static/list/ironing_board_buckle_pixel_shift = list(0, 0, 6)

	var/static/list/move_sounds = list(
		'sound/effects/metalscrape1.ogg',
		'sound/effects/metalscrape2.ogg',
		'sound/effects/metalscrape3.ogg'
	)

	var/base_state = "basic"

	var/obj/item/ironing_board/item_type = /obj/item/ironing_board

	var/obj/item/clothing/clothing

	var/obj/item/ironing_iron/iron

	var/deployed


/obj/structure/ironing_board/Destroy()
	buckle_pixel_shift = null
	QDEL_NULL(clothing)
	QDEL_NULL(iron)
	return ..()


/obj/structure/ironing_board/Initialize()
	. = ..()
	buckle_pixel_shift = ironing_board_buckle_pixel_shift


/obj/structure/ironing_board/Move()
	. = ..()
	if (!isturf(loc))
		return
	var/turf/turf = loc
	if (isspace(turf) || istype(turf, /turf/simulated/floor/carpet))
		return
	playsound(src, pick(move_sounds), 75, TRUE)


/obj/structure/ironing_board/on_update_icon()
	overlays.Cut()
	if (deployed)
		if (clothing)
			overlays += clothing.appearance
		if (iron)
			icon_state = "[base_state]-up-iron"
		else
			icon_state = "[base_state]-up"
	else if (iron)
		icon_state = "[base_state]-down-iron"
	else
		icon_state = "[base_state]-down"


/obj/structure/ironing_board/attack_hand(mob/living/user)
	if (iron)
		user.visible_message(
			SPAN_ITALIC("\The [user] removes \a [iron] from \a [src]."),
			SPAN_ITALIC("You remove \the [iron] from \the [src]."),
			range = 5
		)
		user.put_in_hands(iron)
		iron = null
		update_icon()
		return
	if (buckled_mob)
		user_unbuckle_mob(user)
		return
	if (clothing)
		user.visible_message(
			SPAN_ITALIC("\The [user] removes \a [clothing] from \a [src]."),
			SPAN_ITALIC("You remove \the [clothing] from \the [src]."),
			range = 5
		)
		user.put_in_hands(clothing)
		deployed = FALSE
		clothing = null
		update_icon()
		return
	if (!density)
		user.visible_message(
			SPAN_ITALIC("\The [user] begins folding \a [src]."),
			SPAN_ITALIC("You begin folding \the [src]."),
			range = 5
		)
		if (!do_after(user, 2 SECONDS, src, DO_PUBLIC_UNIQUE | DO_BAR_OVER_USER) || density)
			return
		playsound(src, pick(move_sounds), 75, TRUE)
		new item_type (loc)
		qdel(src)


/obj/structure/ironing_board/post_buckle_mob(mob/living/target)
	..()
	if (buckled_mob)
		set_density(TRUE)
		mouse_opacity = XMOUSE_OPACITY_ALWAYS
		deployed = TRUE
	else
		set_density(FALSE)
		mouse_opacity = XMOUSE_OPACITY_DEFAULT
		deployed = FALSE
	update_icon()


/obj/structure/ironing_board/examine(mob/user, distance)
	. = ..()
	if (distance > 5 && !isghost(user))
		return
	if (iron)
		to_chat(user, "It has \a [iron] resting on it.")
	if (clothing)
		to_chat(user, "\A [clothing] is spread out across it.")


/obj/structure/ironing_board/attackby(obj/item/item, mob/living/user)
	. = TRUE
	if (istype(item, /obj/item/clothing))
		if (deployed)
			if (buckled_mob)
				to_chat(user, SPAN_WARNING("\The [src] already has \the [buckled_mob] on it."))
			if (clothing)
				to_chat(user, SPAN_WARNING("\The [src] already has \a [clothing] on it."))
			return
		if (!user.unEquip(item, src))
			return
		clothing = item
		deployed = TRUE
		update_icon()
		return
	if (istype(item, /obj/item/ironing_iron))
		var/obj/item/ironing_iron/active_iron = item
		if (clothing)
			user.visible_message(
				SPAN_ITALIC("\The [user] starts ironing \a [clothing]."),
				SPAN_ITALIC("You start ironing \the [clothing]."),
				range = 5
			)
			if (!do_after(user, 5 SECONDS, src, DO_PUBLIC_UNIQUE))
				return
			if (!active_iron.iron_enabled)
				to_chat(user, SPAN_WARNING("Whoops. The iron was not turned on."))
				return
			clothing.ironed_state = WRINKLES_NONE
			return
		if (buckled_mob)
			if (user.a_intent != I_HURT)
				to_chat(user, SPAN_WARNING("You refrain from touching \the [active_iron] to \the [buckled_mob]."))
				return
			var/zone = user.zone_sel.selecting
			if (!active_iron.iron_enabled)
				active_iron.attack(buckled_mob, user, zone, TRUE)
				return
			var/mob/living/carbon/human/human
			var/obj/item/organ/external/organ
			if (ishuman(buckled_mob))
				human = buckled_mob
				organ = human.get_organ(zone)
				if (!organ)
					to_chat(user, SPAN_WARNING("\The [buckled_mob] has no [parse_zone(zone)] to iron."))
					return
			var/message = "ironing \the [buckled_mob][human ? "'s [parse_zone(zone)]" : ""]!"
			user.visible_message(
				SPAN_DANGER("\The [user] starts [message]"),
				SPAN_DANGER("You start [message]")
			)
			var/sound_token = GLOB.sound_player.PlayLoopingSound(src, "\ref[src]", 'sound/effects/iron_sizzle.ogg', 80)
			for (var/i = 1 to 5)
				if (!do_after(user, 1 SECOND, buckled_mob, DO_PUBLIC_UNIQUE))
					break
				if (organ)
					organ.take_external_damage(0, rand(3, 5), used_weapon = "Hot metal")
				else
					buckled_mob.take_overall_damage(0, rand(3, 5), "Hot metal")
			qdel(sound_token)
			return
		if (iron)
			to_chat(user, SPAN_WARNING("\The [src] already has \a [iron] on it."))
			return
		if (!user.unEquip(item, src))
			return
		iron = item
		update_icon()
		return
	if (istype(item, /obj/item/grab))
		if (buckled_mob)
			to_chat(user, SPAN_WARNING("\The [src] is occupied. Remove \the [buckled_mob] first."))
			return
		if (clothing)
			to_chat(user, SPAN_WARNING("\The [src] is occupied. Remove \the [clothing] first."))
			return
		var/obj/item/grab/grab = item
		user.visible_message(
			SPAN_ITALIC("\The [user] starts buckling \the [grab.affecting] to \a [src]."),
			SPAN_ITALIC("You start buckling \the [grab.affecting] to \the [src]."),
			range = 5
		)
		if (!do_after(user, 3 SECONDS, src, DO_PUBLIC_UNIQUE))
			return
		if (QDELETED(grab) || !user_buckle_mob(grab.affecting, user))
			return
		qdel(grab)
		return
	return ..()


/obj/structure/ironing_board/fancy
	icon_state = "fancy-down"
	base_state = "fancy"
	item_type = /obj/item/ironing_board/fancy


/obj/item/ironing_board
	name = "ironing board"
	desc = "A collapsed ironing board that can be carried around."
	icon = 'icons/obj/ironing.dmi'
	icon_state = "basic-item"
	item_state = "rbed"
	slot_flags = SLOT_BACK
	w_class = ITEM_SIZE_LARGE

	var/structure_type = /obj/structure/ironing_board


/obj/item/ironing_board/attack_self(mob/living/user)
	if (!isturf(user.loc))
		to_chat(user, SPAN_WARNING("You don't have enough space to set up \the [src]."))
		return
	user.visible_message(
		SPAN_ITALIC("\The [user] starts setting up \a [src]."),
		SPAN_ITALIC("You start setting up \the [src]."),
		range = 5
	)
	if (!do_after(user, 2 SECONDS, src, do_flags = DO_PUBLIC_UNIQUE | DO_BAR_OVER_USER))
		return
	var/obj/structure/ironing_board/board = new structure_type (user.loc)
	board.add_fingerprint(user)
	user.drop_from_inventory(src)
	qdel(src)


/obj/item/ironing_board/fancy
	icon_state = "fancy-item"
	structure_type = /obj/structure/ironing_board/fancy


/obj/item/ironing_iron
	name = "iron"
	desc = "An ironing iron for ironing your iro- err... clothes."
	icon = 'icons/obj/ironing.dmi'
	icon_state = "iron"
	item_state = "ironingiron"
	slot_flags = SLOT_BELT
	throwforce = 10
	throw_range = 6
	force = 8
	attack_verb = list("slammed", "whacked", "bashed", "thunked", "battered", "bludgeoned", "thrashed")

	var/iron_enabled

/obj/item/ironing_iron/attack_self(mob/living/user)
	iron_enabled = !iron_enabled
	user.visible_message(
		SPAN_ITALIC("\The [user] turns \a [name] [iron_enabled ? "on" : "off"]."),
		SPAN_ITALIC("You turn \the [name] [iron_enabled ? "on" : "off"]."),
		range = 3
	)


/obj/random/ironing_board_structure
	name = "random deployed ironing board"
	icon = 'icons/obj/ironing.dmi'
	icon_state = "basic-down"


/obj/random/ironing_board_structure/spawn_choices()
	return list(
		/obj/structure/ironing_board,
		/obj/structure/ironing_board/fancy
	)


/obj/random/ironing_board_item
	name = "random collapsed ironing board"
	icon = 'icons/obj/ironing.dmi'
	icon_state = "basic-item"


/obj/random/ironing_board_item/spawn_choices()
	return list(
		/obj/item/ironing_board,
		/obj/item/ironing_board/fancy
	)
