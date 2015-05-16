/obj/item/weapon/stool
	name = "stool"
	desc = "Apply butt."
	icon = 'icons/obj/objects.dmi'
	icon_state = "stool"
	force = 10
	throwforce = 10
	w_class = 5
	var/material/material

/obj/item/weapon/stool/New(var/newloc, var/new_material)
	..(newloc)
	if(!new_material)
		new_material = DEFAULT_WALL_MATERIAL
	material = get_material_by_name(new_material)
	if(!istype(material))
		qdel(src)
		return
	force = round(material.get_blunt_damage()*0.4)
	color = material.icon_colour
	name = "[material.display_name] [initial(name)]"
	desc = "[initial(desc)] It's made of [material.display_name]."

/obj/item/weapon/stool/attack(mob/M as mob, mob/user as mob)
	if (prob(5) && istype(M,/mob/living))
		user.visible_message("\red [user] breaks [src] over [M]'s back!")
		user.remove_from_mob(src)
		material.place_sheet(get_turf(src))
		qdel(src)
		var/mob/living/T = M
		T.Weaken(10)
		T.apply_damage(20)
		return
	..()

/obj/item/weapon/stool/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return
		if(3.0)
			if (prob(5))
				qdel(src)
				return

/obj/item/weapon/stool/blob_act()
	if(prob(75))
		material.place_sheet(get_turf(src))
		qdel(src)

/obj/item/weapon/stool/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/wrench))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		material.place_sheet(get_turf(src))
		qdel(src)
	..()
