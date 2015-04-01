/obj/item/glass_jar
	name = "glass jar"
	desc = "A small empty jar."
	icon = 'icons/obj/items.dmi'
	icon_state = "jar"
	w_class = 2
	matter = list("glass" = 200)
	var/contains = 0 // 0 = nothing, 1 = money, 2 = animal, 3 = spiderling

/obj/item/glass_jar/New()
	..()
	update_icon()

/obj/item/glass_jar/afterattack(var/atom/A, var/mob/user, var/proximity)
	if(!proximity || contains)
		return
	if(istype(A, /mob/living/simple_animal/lizard) || istype(A, /mob/living/simple_animal/mouse))
		var/mob/living/simple_animal/L = A
		user.visible_message("<span class='notice'>[user] scoops [L] into \the [src].</span>", "<span class='notice'>You scoop [L] into \the [src].</span>")
		L.loc = src
		contains = 2
		update_icon()
		return
	if(istype(A, /obj/effect/spider/spiderling))
		var/obj/effect/spider/spiderling/S = A
		user.visible_message("<span class='notice'>[user] scoops [S] into \the [src].</span>", "<span class='notice'>You scoop [S] into \the [src].</span>")
		S.loc = src
		processing_objects.Remove(S) // No growing inside jars
		contains = 3
		update_icon()
		return

/obj/item/glass_jar/attack_self(var/mob/user)
	if(contains == 1)
		for(var/obj/O in src)
			O.loc = user.loc
		user << "<span class='notice'>You take money out of \the [src].</span>"
		contains = 0
		update_icon()
		return
	if(contains == 2)
		for(var/mob/M in src)
			M.loc = user.loc
			user.visible_message("<span class='notice'>[user] releases [M] from \the [src].</span>", "<span class='notice'>You release [M] from \the [src].</span>")
		contains = 0
		update_icon()
		return
	if(contains == 3)
		for(var/obj/effect/spider/spiderling/S in src)
			S.loc = user.loc
			user.visible_message("<span class='notice'>[user] releases [S] from \the [src].</span>", "<span class='notice'>You release [S] from \the [src].</span>")
			processing_objects.Add(S) // They can grow after being let out though
		contains = 0
		update_icon()
		return

/obj/item/glass_jar/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/weapon/spacecash))
		if(contains == 0)
			contains = 1
		if(contains != 1)
			return
		var/obj/item/weapon/spacecash/S = W
		user.visible_message("<span class='notice'>[user] puts [S.worth] thalers into \the [src].</span>")
		user.drop_from_inventory(S)
		S.loc = src
		update_icon()

/obj/item/glass_jar/update_icon() // Also updates name and desc
	underlays.Cut()
	overlays.Cut()
	if(contains == 0)
		name = initial(name)
		desc = initial(desc)
	else if(contains == 1)
		name = "tip jar"
		desc = "A small jar with money inside."
		for(var/obj/item/weapon/spacecash/S in src)
			var/image/money = image(S.icon, S.icon_state)
			money.pixel_x = rand(-3, 3)
			money.pixel_y = rand(-6, 6)
			money.transform *= 0.75
			underlays += money
	else if(contains == 2)
		for(var/mob/M in src)
			var/image/victim = image(M.icon, M.icon_state)
			victim.pixel_y = 6
			underlays += victim
			name = "glass jar with [M]"
			desc = "A small jar with [M] inside."
	else if(contains == 3)
		for(var/obj/effect/spider/spiderling/S in src)
			var/image/victim = image(S.icon, S.icon_state)
			underlays += victim
			name = "glass jar with [S]"
			desc = "A small jar with [S] inside."
	return