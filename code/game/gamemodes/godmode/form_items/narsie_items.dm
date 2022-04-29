
//SACRIFICE DAGGER
//If used on a person on an altar, causes the user to carve into them, dealing moderate damage and gaining points for the altar's god.
/obj/item/material/knife/ritual/sacrifice
	name = "sacrificial dagger"
	desc = "This knife is dull but well used."
	default_material = MATERIAL_CULT

/obj/item/material/knife/ritual/sacrifice/resolve_attackby(atom/a, mob/user, click_params)
	var/turf/T = get_turf(a)
	var/obj/structure/deity/altar/altar = locate() in T
	if(!altar)
		return ..()
	if(isliving(a))
		var/mob/living/L = a
		var/multiplier = 1
		if(L.mind)
			multiplier++
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.should_have_organ(BP_HEART))
				multiplier++
		if(L.stat == DEAD)
			to_chat(user, SPAN_WARNING("\The [a] is already dead! There is nothing to take!"))
			return

		user.visible_message(
			SPAN_WARNING("\The [user] hovers \the [src] over \the [a], whispering an incantation."),
			SPAN_WARNING("You hover \the [src] over \the [a], whispering an incantation.")
		)
		if(!do_after(user, 20 SECONDS, L))
			return
		user.visible_message(
			SPAN_DANGER("\The [user] plunges \the [src] down into \the [a]!"),
			SPAN_DANGER("You plunge \the [src] down into \the [a]!")
		)
		L.adjustBruteLoss(20)
		if(altar.linked_god)
			altar.linked_god.adjust_power_min(2 * multiplier, FALSE, "from a delicious sacrifice!")


//EXEC AXE
//If a person hit by this axe within three seconds dies, sucks in their soul to be harvested at altars.
/obj/item/material/twohanded/fireaxe/cult
	name = "terrible axe"
	desc = "Its head is sharp and stained red with heavy use."
	icon_state = "bone_axe0"
	base_icon = "bone_axe"
	default_material = MATERIAL_CULT
	var/stored_power = 0
	var/mob/living/targeted = null

/obj/item/material/twohanded/fireaxe/cult/examine(mob/user)
	. = ..()
	if(stored_power)
		to_chat(user, SPAN_NOTICE("It exudes a death-like smell."))

/obj/item/material/twohanded/fireaxe/cult/resolve_attackby(atom/a, mob/user, click_params)
	if(istype(a, /obj/structure/deity/altar))
		var/obj/structure/deity/altar/altar = a
		if(stored_power && altar.linked_god)
			altar.linked_god.adjust_power_min(stored_power, msg = "from harvested souls.")
			altar.visible_message(SPAN_WARNING("\The [altar] absorbs a black mist exuded from \the [src]."))
			stored_power = 0
			return
	if(ismob(a))
		var/mob/M = a
		if(M.stat != DEAD)
			GLOB.death_event.register(M,src,/obj/item/material/twohanded/fireaxe/cult/proc/gain_power)
			targeted = M
			addtimer(CALLBACK(src, .proc/UnregisterMe, M), 3 SECONDS)
		if (targeted && M != targeted)
			UnregisterMe(targeted)

/obj/item/material/twohanded/fireaxe/cult/proc/UnregisterMe(M)
	if (!M)
		M = targeted
	if (!M)
		return
	GLOB.death_event.unregister(M, src)

/obj/item/material/twohanded/fireaxe/cult/proc/gain_power()
	stored_power += 50
	visible_message(SPAN_OCCULT("\The [src] screeches as the smell of death fills the air!"))

/obj/item/material/twohanded/fireaxe/cult/Destroy()
	UnregisterMe()
	. = ..()
/obj/item/reagent_containers/food/drinks/zombiedrink
	name = "well-used urn"
	desc = "Said to bring those who drink it back to life, no matter the price."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "urn"
	volume = 10
	amount_per_transfer_from_this = 10

/obj/item/reagent_containers/food/drinks/zombiedrink/New()
	..()
	reagents.add_reagent(/datum/reagent/zombie, 10)
