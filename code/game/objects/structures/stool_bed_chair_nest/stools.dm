//Todo: add leather and cloth for arbitrary coloured stools.
var/global/list/stool_cache = list() //haha stool

/obj/item/weapon/stool
	name = "stool"
	desc = "Apply butt."
	icon = 'icons/obj/furniture.dmi'
	icon_state = "stool_preview" //set for the map
	item_state = "stool"
	randpixel = 0
	force = 10
	throwforce = 10
	w_class = ITEM_SIZE_HUGE
	var/base_icon = "stool"
	var/material/material
	var/material/padding_material

/obj/item/weapon/stool/padded
	icon_state = "stool_padded_preview" //set for the map

/obj/item/weapon/stool/New(var/newloc, var/new_material, var/new_padding_material)
	..(newloc)
	if(!new_material)
		new_material = DEFAULT_WALL_MATERIAL
	material = get_material_by_name(new_material)
	if(new_padding_material)
		padding_material = get_material_by_name(new_padding_material)
	if(!istype(material))
		qdel(src)
		return
	force = round(material.get_blunt_damage()*0.4)
	update_icon()

/obj/item/weapon/stool/padded/New(var/newloc, var/new_material)
	..(newloc, "steel", "carpet")

/obj/item/weapon/stool/bar
	name = "bar stool"
	icon_state = "bar_stool_preview" //set for the map
	item_state = "bar_stool"
	base_icon = "bar_stool"

/obj/item/weapon/stool/bar/padded
	icon_state = "bar_stool_padded_preview"

/obj/item/weapon/stool/bar/padded/New(var/newloc, var/new_material)
	..(newloc, "steel", "carpet")

/obj/item/weapon/stool/update_icon()
	// Prep icon.
	icon_state = ""
	// Base icon.
	var/list/noverlays = list()
	var/cache_key = "[base_icon]-[material.name]"
	if(isnull(stool_cache[cache_key]))
		var/image/I = image(icon, "[base_icon]_base")
		I.color = material.icon_colour
		stool_cache[cache_key] = I
	noverlays |= stool_cache[cache_key]
	// Padding overlay.
	if(padding_material)
		var/padding_cache_key = "[base_icon]-padding-[padding_material.name]"
		if(isnull(stool_cache[padding_cache_key]))
			var/image/I =  image(icon, "[base_icon]_padding")
			I.color = padding_material.icon_colour
			stool_cache[padding_cache_key] = I
		noverlays |= stool_cache[padding_cache_key]
	overlays = noverlays
	// Strings.
	if(padding_material)
		name = "[padding_material.display_name] [initial(name)]" //this is not perfect but it will do for now.
		desc = "A padded stool. Apply butt. It's made of [material.use_name] and covered with [padding_material.use_name]."
	else
		name = "[material.display_name] [initial(name)]"
		desc = "A stool. Apply butt with care. It's made of [material.use_name]."

/obj/item/weapon/stool/proc/add_padding(var/padding_type)
	padding_material = get_material_by_name(padding_type)
	update_icon()

/obj/item/weapon/stool/proc/remove_padding()
	if(padding_material)
		padding_material.place_sheet(get_turf(src))
		padding_material = null
	update_icon()

/obj/item/weapon/stool/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	if (prob(5))
		user.visible_message("<span class='danger'>[user] breaks [src] over [target]'s back!</span>")
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		user.do_attack_animation(target)
		user.remove_from_mob(src)
		dismantle()
		qdel(src)

		var/blocked = target.run_armor_check(hit_zone, "melee")
		target.Weaken(10 * blocked_mult(blocked))
		target.apply_damage(20, BRUTE, hit_zone, blocked, src)
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

/obj/item/weapon/stool/proc/dismantle()
	if(material)
		material.place_sheet(get_turf(src))
	if(padding_material)
		padding_material.place_sheet(get_turf(src))
	qdel(src)

/obj/item/weapon/stool/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(iswrench(W))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		dismantle()
		qdel(src)
	else if(istype(W,/obj/item/stack))
		if(padding_material)
			to_chat(user, "\The [src] is already padded.")
			return
		var/obj/item/stack/C = W
		if(C.get_amount() < 1) // How??
			user.drop_from_inventory(C)
			qdel(C)
			return
		var/padding_type //This is awful but it needs to be like this until tiles are given a material var.
		if(istype(W,/obj/item/stack/tile/carpet))
			padding_type = "carpet"
		else if(istype(W,/obj/item/stack/material))
			var/obj/item/stack/material/M = W
			if(M.material && (M.material.flags & MATERIAL_PADDING))
				padding_type = "[M.material.name]"
		if(!padding_type)
			to_chat(user, "You cannot pad \the [src] with that.")
			return
		C.use(1)
		if(!istype(src.loc, /turf))
			user.drop_from_inventory(src)
			src.dropInto(loc)
		to_chat(user, "You add padding to \the [src].")
		add_padding(padding_type)
		return
	else if(iswirecutter(W))
		if(!padding_material)
			to_chat(user, "\The [src] has no padding to remove.")
			return
		to_chat(user, "You remove the padding from \the [src].")
		playsound(src, 'sound/items/Wirecutter.ogg', 100, 1)
		remove_padding()
	else
		..()
