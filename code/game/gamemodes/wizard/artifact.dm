// Veil render //

/obj/item/weapon/veilrender
	name = "veil render"
	desc = "A wicked curved blade of alien origin, recovered from the ruins of a vast city."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "render"
	item_state = "render"
	flags = FPRINT | TABLEPASS
	force = 15
	throwforce = 10
	w_class = 3
	var/charged = 1


/obj/effect/rend
	name = "Tear in the fabric of reality"
	desc = "You should run now"
	icon = 'icons/obj/biomass.dmi'
	icon_state = "rift"
	density = 1
	unacidable = 1
	anchored = 1.0


/obj/effect/rend/New()
	spawn(50)
		new /obj/machinery/singularity/narsie/wizard(get_turf(src))
		del(src)
		return
	return


/obj/item/weapon/veilrender/attack_self(mob/user as mob)
	if(charged == 1)
		new /obj/effect/rend(get_turf(usr))
		charged = 0
		visible_message("\red <B>[src] hums with power as [usr] deals a blow to reality itself!</B>")
	else
		user << "\red The unearthly energies that powered the blade are now dormant"

// Scrying orb //

/obj/item/weapon/scrying
	name = "scrying orb"
	desc = "An incandescent orb of otherworldly energy, staring into it gives you vision beyond mortal means."
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "bluespace"
	throw_speed = 3
	throw_range = 7
	throwforce = 10
	damtype = BURN
	force = 10
	hitsound = 'sound/items/welder2.ogg'

/obj/item/weapon/scrying/attack_self(mob/user as mob)
	user << "<span class='info'>You can see... everything!</span>"
	visible_message("<span class='danger'>[usr] stares into [src], their eyes glazing over.</span>")
	user.ghostize(1)
	return