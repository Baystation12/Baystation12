/obj/item/ashtray
	icon = 'icons/obj/objects.dmi'
	icon_state = "blank"
	var/max_butts = 0
	var/material/material

/obj/item/ashtray/New(var/newloc, var/material_name)
	..(newloc)
	if(!material_name)
		material_name = "plastic"
	material = get_material_by_name(material_name)
	if(!material)
		qdel(src)
		return
	name = "[material.display_name] ashtray"
	src.pixel_y = rand(-5, 5)
	src.pixel_x = rand(-6, 6)
	update_icon()
	return

/obj/item/ashtray/update_icon()
	overlays.Cut()
	var/image/I = image('icons/obj/objects.dmi',"ashtray")
	I.color = material.icon_colour
	overlays |= I

	if (contents.len == max_butts)
		overlays |= image('icons/obj/objects.dmi',"ashtray_full")
		desc = "It's stuffed full."
	else if (contents.len > max_butts/2)
		overlays |= image('icons/obj/objects.dmi',"ashtray_half")
		desc = "It's half-filled."
	else
		desc = "An ashtray made of [material.display_name]."

/obj/item/ashtray/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (health <= 0)
		return
	if (istype(W,/obj/item/weapon/cigbutt) || istype(W,/obj/item/clothing/mask/smokable/cigarette) || istype(W, /obj/item/weapon/flame/match))
		if (contents.len >= max_butts)
			user << "\The [src] is full."
			return
		user.remove_from_mob(W)
		W.loc = src

		if (istype(W,/obj/item/clothing/mask/smokable/cigarette))
			var/obj/item/clothing/mask/smokable/cigarette/cig = W
			if (cig.lit == 1)
				src.visible_message("[user] crushes [cig] in \the [src], putting it out.")
				processing_objects.Remove(cig)
				var/obj/item/butt = new cig.type_butt(src)
				cig.transfer_fingerprints_to(butt)
				qdel(cig)
				W = butt
			else if (cig.lit == 0)
				user << "You place [cig] in [src] without even smoking it. Why would you do that?"

		src.visible_message("[user] places [W] in [src].")
		user.update_inv_l_hand()
		user.update_inv_r_hand()
		add_fingerprint(user)
		update_icon()
	else
		health = max(0,health - W.force)
		user << "You hit [src] with [W]."
		if (health < 1)
			die()
	return

/obj/item/ashtray/throw_impact(atom/hit_atom)
	if (health > 0)
		health = max(0,health - 3)
		if (health < 1)
			die()
			return
		if (contents.len)
			src.visible_message("\red [src] slams into [hit_atom] spilling its contents!")
		for (var/obj/item/clothing/mask/smokable/cigarette/O in contents)
			O.loc = src.loc
		update_icon()
	return ..()

/obj/item/ashtray/proc/die()
	material.place_shard(get_turf(src))
	qdel(src)
	return

/obj/item/ashtray/plastic
	max_butts = 14
	health = 24
	throwforce = 3

/obj/item/ashtray/plastic/New(var/newloc)
	..(newloc, "plastic")

/obj/item/ashtray/bronze
	max_butts = 10
	health = 72
	throwforce = 10

/obj/item/ashtray/bronze/New(var/newloc)
	..(newloc, "gold") //placeholder

/obj/item/ashtray/glass
	max_butts = 12
	health = 12
	throwforce = 6

/obj/item/ashtray/glass/New(var/newloc)
	..(newloc, "glass")
