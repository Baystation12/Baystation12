/obj/item/device/dociler
	name = "dociler"
	desc = "A complex single use recharging injector that spreads a complex neurological serum that makes animals docile and friendly. Somewhat."
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_BIO = 5, TECH_MATERIAL = 2)
	icon_state = "animal_tagger1"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/onmob/items/lefthand_guns.dmi',
		slot_r_hand_str = 'icons/mob/onmob/items/righthand_guns.dmi',
		)
	item_state = "gun"
	force = 1
	var/loaded = 1
	var/mode = "completely"

/obj/item/device/dociler/examine(mob/user)
	. = ..()
	to_chat(user, "<span class='notice'>It is currently set to [mode] docile mode.</span>")

/obj/item/device/dociler/attack_self(var/mob/user)
	if(mode == "somewhat")
		mode = "completely"
	else
		mode = "somewhat"

	to_chat(user, "You set \the [src] to [mode] docile mode.")

/obj/item/device/dociler/attack(var/mob/living/L, var/mob/user)
	if(!istype(L, /mob/living/simple_animal))
		to_chat(user, "<span class='warning'>\The [src] cannot not work on \the [L].</span>")
		return

	if(!loaded)
		to_chat(user, "<span class='warning'>\The [src] isn't loaded!</span>")
		return

	user.visible_message("\The [user] thrusts \the [src] deep into \the [L]'s head, injecting something!")
	to_chat(L, "<span class='notice'>You feel pain as \the [user] injects something into you. All of a sudden you feel as if [user] is the friendliest and nicest person you've ever know. You want to be friends with him and all his friends.</span>")
	if(mode == "somewhat")
		L.faction = user.faction
	else
		L.faction = null
	if(istype(L,/mob/living/simple_animal/hostile))
		var/mob/living/simple_animal/hostile/H = L
		H.ai_holder.lose_target()
		H.attack_same = 0
		H.friends += weakref(user)
	L.desc += "<br><span class='notice'>It looks especially docile.</span>"
	var/name = input(user, "Would you like to rename \the [L]?", "Dociler", L.name) as text
	if(length(name))
		L.real_name = name
		L.SetName(name)

	loaded = 0
	icon_state = "animal_tagger0"
	spawn(1450)
		loaded = 1
		icon_state = "animal_tagger1"
		src.visible_message("\The [src] beeps, refilling itself.")