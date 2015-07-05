var/global/list/ashtray_cache = list()

/obj/item/weapon/material/ashtray
	name = "ashtray"
	icon = 'icons/obj/objects.dmi'
	icon_state = "blank"
	force_divisor = 0.1
	thrown_force_divisor = 0.1
	var/image/base_image
	var/max_butts = 10

/obj/item/weapon/material/ashtray/New(var/newloc, var/material_name)
	..(newloc, material_name)
	if(!material)
		qdel(src)
		return
	max_butts = round(material.hardness/10) //This is arbitrary but whatever.
	src.pixel_y = rand(-5, 5)
	src.pixel_x = rand(-6, 6)
	update_icon()
	return

/obj/item/weapon/material/ashtray/update_icon()
	color = null
	overlays.Cut()
	var/cache_key = "base-[material.name]"
	if(!ashtray_cache[cache_key])
		var/image/I = image('icons/obj/objects.dmi',"ashtray")
		I.color = material.icon_colour
		ashtray_cache[cache_key] = I
	overlays |= ashtray_cache[cache_key]

	if (contents.len == max_butts)
		if(!ashtray_cache["full"])
			ashtray_cache["full"] = image('icons/obj/objects.dmi',"ashtray_full")
		overlays |= ashtray_cache["full"]
		desc = "It's stuffed full."
	else if (contents.len > max_butts/2)
		if(!ashtray_cache["half"])
			ashtray_cache["half"] = image('icons/obj/objects.dmi',"ashtray_half")
		overlays |= ashtray_cache["half"]
		desc = "It's half-filled."
	else
		desc = "An ashtray made of [material.display_name]."

/obj/item/weapon/material/ashtray/attackby(obj/item/weapon/W as obj, mob/user as mob)
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
				//spawn(1)
				//	TemperatureAct(150)
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
			shatter()
	return

/obj/item/weapon/material/ashtray/throw_impact(atom/hit_atom)
	if (health > 0)
		health = max(0,health - 3)
		if (contents.len)
			src.visible_message("<span class='danger'>\The [src] slams into [hit_atom], spilling its contents!</span>")
		for (var/obj/item/clothing/mask/smokable/cigarette/O in contents)
			O.loc = src.loc
		if (health < 1)
			shatter()
			return
		update_icon()
	return ..()

/obj/item/weapon/material/ashtray/plastic/New(var/newloc)
	..(newloc, "plastic")

/obj/item/weapon/material/ashtray/bronze/New(var/newloc)
	..(newloc, "bronze")

/obj/item/weapon/material/ashtray/glass/New(var/newloc)
	..(newloc, "glass")
