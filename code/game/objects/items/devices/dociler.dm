/obj/item/device/dociler
	name = "dociler"
	desc = "A complex single use recharging injector that spreads a complex neurological serum that makes animals docile and friendly. Somewhat."
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_BIO = 5, TECH_MATERIAL = 2)
	icon = 'icons/obj/tools/dociler.dmi'
	icon_state = "animal_tagger1"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/onmob/items/lefthand_guns.dmi',
		slot_r_hand_str = 'icons/mob/onmob/items/righthand_guns.dmi',
		)
	item_state = "gun"
	force = 1
	var/loaded = 1
	var/charge_tick = 0
	var/recharge_time = 140

/obj/item/device/dociler/Process()
	if (loaded)
		return PROCESS_KILL
	if (++charge_tick < recharge_time)
		return
	charge_tick = 0
	loaded = 1
	icon_state = "animal_tagger1"
	update_icon()
	visible_message("\The [src] beeps, refilling itself.")
	return PROCESS_KILL

/obj/item/device/dociler/examine(mob/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("It is currently [loaded? "loaded": "recharging"]."))

/obj/item/device/dociler/use_before(mob/living/L, mob/user)
	. = FALSE
	if (!istype(L))
		return FALSE
	if (istype(L, /mob/living/simple_animal))
		if (!loaded)
			to_chat(user, SPAN_WARNING("\The [src] isn't loaded!"))
			return TRUE

		user.visible_message("\The [user] thrusts \the [src] deep into \the [L]'s head, injecting something!")
		to_chat(L, SPAN_NOTICE("You feel pain as \the [user] injects something into you. All of a sudden you feel as if \the [user] is the friendliest and nicest person you've ever known. You want to be friends with them and all their friends."))
		L.faction = user.faction

		if (istype(L,/mob/living/simple_animal/hostile))
			var/mob/living/simple_animal/hostile/H = L
			H.ai_holder.lose_target()
			H.attack_same = 0
			H.friends += weakref(user)

		L.desc += "<br>[SPAN_NOTICE("It looks especially docile.")]"
		var/name = input(user, "Would you like to rename \the [L]?", "Dociler", L.name) as text
		if (length(name))
			L.real_name = name
			L.SetName(name)

		START_PROCESSING(SSobj, src)
		loaded = 0
		icon_state = "animal_tagger0"
		update_icon()
		return TRUE
	else
		to_chat(user, SPAN_WARNING("\The [src] is not compatible with \the [L]"))
		return TRUE
