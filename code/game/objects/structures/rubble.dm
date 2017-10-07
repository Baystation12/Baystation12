/obj/structure/rubble
	name = "pile of rubble"
	desc = "One man's garbage is another man's treasure."
	icon = 'icons/obj/rubble.dmi'
	icon_state = "base"
	appearance_flags = PIXEL_SCALE
	opacity = 1
	density = 1
	anchored = 1

	var/list/loot = list(/obj/item/weapon/cell,/obj/item/stack/material/iron,/obj/item/stack/rods)
	var/lootleft = 2
	var/emptyprob = 30
	var/health = 40

/obj/structure/rubble/New()
	..()
	if(prob(emptyprob)) 
		lootleft = 0

/obj/structure/rubble/Initialize()
	. = ..()
	update_icon()

/obj/structure/rubble/update_icon()
	overlays.Cut()
	var/list/parts = list()
	for(var/i = 1 to 7)
		var/image/I = image(icon,"rubble[rand(1,9)]")
		if(prob(10))
			var/atom/A = pick(loot)
			if(initial(A.icon) && initial(A.icon_state))
				I.icon = initial(A.icon)
				I.icon_state = initial(A.icon_state)
				I.color = initial(A.color)
			if(!lootleft)
				I.color = "#54362e"
		I.appearance_flags = PIXEL_SCALE
		I.pixel_x = rand(-16,16)
		I.pixel_y = rand(-16,16)
		var/matrix/M = matrix()
		M.Turn(rand(0,360))
		I.transform = M
		parts += I
	overlays = parts

/obj/structure/rubble/attack_hand(mob/user)
	if(!lootleft)
		to_chat(user, "<span class='warning'>There's nothing left in this one but unusable garbage...</span>")
		return
	visible_message("[user] starts rummaging through \the [src].")
	if(do_after(user, 30))
		var/obj/item/booty = pick(loot)
		booty = new booty(loc)
		lootleft--
		update_icon()
		to_chat(user, "<span class='notice'>You find \a [booty] and pull it carefully out of \the [src].</span>")
		
/obj/structure/rubble/attackby(var/obj/item/I, var/mob/user)
	if (istype(I, /obj/item/weapon/pickaxe))
		var/obj/item/weapon/pickaxe/P = I
		visible_message("[user] starts clearing away \the [src].")
		if(do_after(user,P.digspeed, src))
			visible_message("[user] clears away \the [src].")
			if(lootleft && prob(1))
				var/obj/item/booty = pick(loot)
				booty = new booty(loc)
			qdel(src)
	else 
		..()
		health -= I.force
		if(health < 1)
			visible_message("[user] clears away \the [src].")
			qdel(src)

/obj/structure/rubble/house
	loot = list(/obj/item/weapon/archaeological_find/bowl,
	/obj/item/weapon/archaeological_find/remains/,
	/obj/item/weapon/archaeological_find/bowl/urn,
	/obj/item/weapon/archaeological_find/cutlery,
	/obj/item/weapon/archaeological_find/statuette,
	/obj/item/weapon/archaeological_find/instrument,
	/obj/item/weapon/archaeological_find/container,
	/obj/item/weapon/archaeological_find/mask,
	/obj/item/weapon/archaeological_find/coin,
	/obj/item/weapon/archaeological_find/,
	/obj/item/weapon/archaeological_find/material)

/obj/structure/rubble/war
	emptyprob = 70 //can't have piles upon piles of guns
	loot = list(/obj/item/weapon/archaeological_find/knife,
	/obj/item/weapon/archaeological_find/remains/xeno,
	/obj/item/weapon/archaeological_find/remains/robot,
	/obj/item/weapon/archaeological_find/remains/,
	/obj/item/weapon/archaeological_find/gun,
	/obj/item/weapon/archaeological_find/laser,
	/obj/item/weapon/archaeological_find/statuette,
	/obj/item/weapon/archaeological_find/instrument,
	/obj/item/weapon/archaeological_find/container,
	/obj/item/weapon/archaeological_find/mask,
	/obj/item/weapon/archaeological_find/sword,
	/obj/item/weapon/archaeological_find/katana,
	/obj/item/weapon/archaeological_find/trap)