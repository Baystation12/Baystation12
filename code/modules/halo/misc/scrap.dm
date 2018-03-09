
/obj/item/metalscrap
	name = "metallic junk"
	desc = "A load of junk. Take a welder to this and you might get some usable metal out of it though."
	icon = 'code/modules/halo/icons/scrap/trash.dmi'
	icon_state = "base1"

/obj/item/metalscrap/New()
	..()
	icon_state = "base[rand(1,18)]"

/obj/item/metalscrap/attackby(var/obj/item/I, var/mob/living/user)
	if(istype(I, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = I
		if(WT.remove_fuel(3, user))
			user.visible_message("<span class='info'>[user] breaks down [src] for scrap.</span>", \
				"<span class='info'>You break down [src] for scrap.</span>")
			var/obj/item/stack/material/steel/S = new(src.loc)
			S.amount = 3
			qdel(src)
		else
			to_chat(user, "<span class='notice'>There is not enough fuel to break down [src]!</span>")
	else
		..()
