/obj/structure/rubble
	name = "pile of rubble"
	desc = "One man's garbage is another man's treasure."
	icon = 'icons/obj/rubble.dmi'
	icon_state = "base"
	appearance_flags = DEFAULT_APPEARANCE_FLAGS | PIXEL_SCALE
	opacity = 1
	density = TRUE
	anchored = TRUE
	health_max = 40

	var/list/loot = list(/obj/item/cell,/obj/item/stack/material/iron,/obj/item/stack/material/rods)
	var/lootleft = 1
	var/emptyprob = 95
	var/is_rummaging = 0

/obj/structure/rubble/New()
	if(prob(emptyprob))
		lootleft = 0
	..()

/obj/structure/rubble/Initialize()
	. = ..()
	update_icon()

/obj/structure/rubble/on_update_icon()
	overlays.Cut()
	var/list/parts = list()
	for(var/i = 1 to 7)
		var/image/I = image(icon,"rubble[rand(1,15)]")
		if(prob(10))
			var/atom/A = pick(loot)
			if(initial(A.icon) && initial(A.icon_state))
				I.icon = initial(A.icon)
				I.icon_state = initial(A.icon_state)
				I.color = initial(A.color)
			if(!lootleft)
				I.color = "#54362e"
		I.appearance_flags = DEFAULT_APPEARANCE_FLAGS | PIXEL_SCALE
		I.pixel_x = rand(-16,16)
		I.pixel_y = rand(-16,16)
		I.SetTransform(rotation = rand(0,360))
		parts += I
	overlays = parts
	if(lootleft)
		overlays += image(icon,"twinkle[rand(1,3)]")

/obj/structure/rubble/attack_hand(mob/user)
	if(!is_rummaging)
		if(!lootleft)
			to_chat(user, "<span class='warning'>There's nothing left in this one but unusable garbage...</span>")
			return
		visible_message("[user] starts rummaging through \the [src].")
		is_rummaging = 1
		if(do_after(user, 3 SECONDS, src, DO_PUBLIC_UNIQUE))
			var/obj/item/booty = pickweight(loot)
			booty = new booty(loc)
			lootleft--
			update_icon()
			to_chat(user, "<span class='notice'>You find \a [booty] and pull it carefully out of \the [src].</span>")
		is_rummaging = 0
	else
		to_chat(user, "<span class='warning'>Someone is already rummaging here!</span>")

/obj/structure/rubble/attackby(var/obj/item/I, var/mob/user)
	if (user.a_intent == I_HURT)
		..()
		return

	if (istype(I, /obj/item/pickaxe))
		var/obj/item/pickaxe/P = I
		visible_message("[user] starts clearing away \the [src].")
		if(do_after(user, P.digspeed, src, DO_PUBLIC_UNIQUE))
			visible_message("[user] clears away \the [src].")
			if(lootleft && prob(1))
				var/obj/item/booty = pickweight(loot)
				booty = new booty(loc)
			qdel(src)
		return

	..()

/obj/structure/rubble/house
	loot = list(/obj/item/archaeological_find/bowl,
	/obj/item/archaeological_find/remains,
	/obj/item/archaeological_find/bowl/urn,
	/obj/item/archaeological_find/cutlery,
	/obj/item/archaeological_find/statuette,
	/obj/item/archaeological_find/instrument,
	/obj/item/archaeological_find/container,
	/obj/item/archaeological_find/mask,
	/obj/item/archaeological_find/coin,
	/obj/item/archaeological_find,
	/obj/item/archaeological_find/material = 5,
	/obj/item/archaeological_find/material/exotic = 2,
	/obj/item/archaeological_find/parts = 3
	)

/obj/structure/rubble/lab
	emptyprob = 30
	loot = list(
	/obj/item/archaeological_find/statuette,
	/obj/item/archaeological_find/instrument,
	/obj/item/archaeological_find/mask,
	/obj/item/archaeological_find,
	/obj/item/archaeological_find/material = 10,
	/obj/item/archaeological_find/material/exotic = 10,
	/obj/item/archaeological_find/parts = 10
	)

/obj/structure/rubble/war
	emptyprob = 95 //can't have piles upon piles of guns
	loot = list(/obj/item/archaeological_find/knife,
	/obj/item/archaeological_find/gun,
	/obj/item/archaeological_find/laser,
	/obj/item/archaeological_find/sword,
	/obj/item/archaeological_find/katana)
