/obj/structure/fence
	name = "fence"
	icon = 'icons/fallout/fences.dmi'
	icon_state = "normal_fence"
	density = 1
	anchored= 1
	opacity = 0
	var/cut = 0

/obj/structure/fence/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/weapon/wirecutters))
		user.visible_message("<span class='notice'>\The [user] snips a hole in \the [src] with \the [I].</span>","<span class='notice'>You snip a hole in \the [src] with \the [I].</span>")
		icon_state = "cut_fence"
		cut = 1
		density = 0
	if(istype(I, /obj/item/stack/rods))
		if(!cut)
			to_chat(user, "<span class='warning'>You see no use for \the [I] at this time.</span>")
		else
			var/obj/item/stack/rods/replacements = I
			if(replacements.amount < 5)
				to_chat(user, "<span class='warning'>You do not have enough rods to fix the fence!</span>")
			else
				user.visible_message("<span class='notice'>\The [user] mends the hole in \the [src] with \the [I].</span>","<span class='notice'>You mend the hole in \the [src] with \the [I].</span>")
				replacements.amount -= 5
				icon_state = initial(icon_state)
				cut = 0
				density = 1

/obj/structure/fence/corner
	icon_state = "fence_corner"