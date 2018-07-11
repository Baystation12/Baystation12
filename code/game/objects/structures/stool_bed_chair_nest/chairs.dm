/obj/structure/bed/chair	//YES, chairs are a type of bed, which are a type of stool. This works, believe me.	-Pete
	name = "chair"
	desc = "You sit in this, either by will or force."
	icon_state = "chair_preview"
	color = "#666666"
	base_icon = "chair"
	buckle_dir = 0
	buckle_lying = 0 //force people to sit up in chairs when buckled
	var/propelled = 0 // Check for fire-extinguisher-driven chairs

/obj/structure/bed/chair/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(!padding_material && istype(W, /obj/item/assembly/shock_kit))
		var/obj/item/assembly/shock_kit/SK = W
		if(!SK.status)
			to_chat(user, "<span class='notice'>\The [SK] is not ready to be attached!</span>")
			return
		if(!user.unEquip(SK))
			return
		var/obj/structure/bed/chair/e_chair/E = new (src.loc, material.name)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		E.set_dir(dir)
		E.part = SK
		SK.forceMove(E)
		SK.master = E
		qdel(src)

/obj/structure/bed/chair/attack_tk(mob/user as mob)
	if(buckled_mob)
		..()
	else
		rotate()
	return

/obj/structure/bed/chair/post_buckle_mob()
	update_icon()
	return ..()

/obj/structure/bed/chair/update_icon()
	..()

	var/cache_key = "[base_icon]-[material.name]-over"
	if(isnull(stool_cache[cache_key]))
		var/image/I = image('icons/obj/furniture.dmi', "[base_icon]_over")
		if(material_alteration & MATERIAL_ALTERATION_COLOR)
			I.color = material.icon_colour
		I.plane = ABOVE_HUMAN_PLANE
		I.layer = ABOVE_HUMAN_LAYER
		stool_cache[cache_key] = I
	overlays |= stool_cache[cache_key]
	// Padding overlay.
	if(padding_material)
		var/padding_cache_key = "[base_icon]-padding-[padding_material.name]-over"
		if(isnull(stool_cache[padding_cache_key]))
			var/image/I =  image(icon, "[base_icon]_padding_over")
			if(material_alteration & MATERIAL_ALTERATION_COLOR)
				I.color = padding_material.icon_colour
			I.plane = ABOVE_HUMAN_PLANE
			I.layer = ABOVE_HUMAN_LAYER
			stool_cache[padding_cache_key] = I
		overlays |= stool_cache[padding_cache_key]

	if(buckled_mob)
		cache_key = "[base_icon]-armrest-[padding_material.name]"
		if(isnull(stool_cache[cache_key]))
			var/image/I = image(icon, "[base_icon]_armrest")
			I.plane = ABOVE_HUMAN_PLANE
			I.layer = ABOVE_HUMAN_LAYER
			if(material_alteration & MATERIAL_ALTERATION_COLOR)
				I.color = material.icon_colour
			stool_cache[cache_key] = I
		overlays |= stool_cache[cache_key]
		if(padding_material)
			cache_key = "[base_icon]-padding-armrest-[padding_material.name]"
			if(isnull(stool_cache[cache_key]))
				var/image/I = image(icon, "[base_icon]_padding_armrest")
				I.plane = ABOVE_HUMAN_PLANE
				I.layer = ABOVE_HUMAN_LAYER
				if(material_alteration & MATERIAL_ALTERATION_COLOR)
					I.color = padding_material.icon_colour
				stool_cache[cache_key] = I
			overlays |= stool_cache[cache_key]

/obj/structure/bed/chair/set_dir()
	..()
	if(buckled_mob)
		buckled_mob.set_dir(dir)

/obj/structure/bed/chair/AltClick()
	rotate()

/obj/structure/bed/chair/verb/rotate()
	set name = "Rotate Chair"
	set category = "Object"
	set src in oview(1)

	if(!usr || !Adjacent(usr))
		return

	if(usr.stat == DEAD)
		if(!round_is_spooky())
			to_chat(src, "<span class='warning'>The veil is not thin enough for you to do that.</span>")
			return
	else if(usr.incapacitated())
		return

	src.set_dir(turn(src.dir, 90))
	return

/obj/structure/bed/chair/padded/red/New(var/newloc,var/newmaterial)
	..(newloc,"steel","carpet")

/obj/structure/bed/chair/padded/brown/New(var/newloc,var/newmaterial)
	..(newloc,"steel","leather")

/obj/structure/bed/chair/padded/teal/New(var/newloc,var/newmaterial)
	..(newloc,"steel","teal")

/obj/structure/bed/chair/padded/black/New(var/newloc,var/newmaterial)
	..(newloc,"steel","black")

/obj/structure/bed/chair/padded/green/New(var/newloc,var/newmaterial)
	..(newloc,"steel","green")

/obj/structure/bed/chair/padded/purp/New(var/newloc,var/newmaterial)
	..(newloc,"steel","purple")

/obj/structure/bed/chair/padded/blue/New(var/newloc,var/newmaterial)
	..(newloc,"steel","blue")

/obj/structure/bed/chair/padded/beige/New(var/newloc,var/newmaterial)
	..(newloc,"steel","beige")

/obj/structure/bed/chair/padded/lime/New(var/newloc,var/newmaterial)
	..(newloc,"steel","lime")

/obj/structure/bed/chair/padded/yellow/New(var/newloc,var/newmaterial)
	..(newloc,"steel","yellow")

// Leaving this in for the sake of compilation.
/obj/structure/bed/chair/comfy
	name = "comfy chair"
	desc = "It's a chair. It looks comfy."
	icon_state = "comfychair_preview"
	base_icon = "comfychair"

/obj/structure/bed/chair/comfy/brown/New(var/newloc,var/newmaterial)
	..(newloc,"steel","leather")

/obj/structure/bed/chair/comfy/red/New(var/newloc,var/newmaterial)
	..(newloc,"steel","carpet")

/obj/structure/bed/chair/comfy/teal/New(var/newloc,var/newmaterial)
	..(newloc,"steel","teal")

/obj/structure/bed/chair/comfy/black/New(var/newloc,var/newmaterial)
	..(newloc,"steel","black")

/obj/structure/bed/chair/comfy/green/New(var/newloc,var/newmaterial)
	..(newloc,"steel","green")

/obj/structure/bed/chair/comfy/purp/New(var/newloc,var/newmaterial)
	..(newloc,"steel","purple")

/obj/structure/bed/chair/comfy/blue/New(var/newloc,var/newmaterial)
	..(newloc,"steel","blue")

/obj/structure/bed/chair/comfy/beige/New(var/newloc,var/newmaterial)
	..(newloc,"steel","beige")

/obj/structure/bed/chair/comfy/lime/New(var/newloc,var/newmaterial)
	..(newloc,"steel","lime")

/obj/structure/bed/chair/comfy/yellow/New(var/newloc,var/newmaterial)
	..(newloc,"steel","yellow")

/obj/structure/bed/chair/comfy/captain
	name = "captain chair"
	desc = "It's a chair. Only for the highest ranked asses."
	icon_state = "capchair_preview"
	base_icon = "capchair"
	buckle_movable = 1

/obj/structure/bed/chair/comfy/captain/update_icon()
	..()
	var/image/I = image(icon, "[base_icon]_special")
	I.plane = ABOVE_HUMAN_PLANE
	I.layer = ABOVE_HUMAN_LAYER
	overlays |= I

/obj/structure/bed/chair/comfy/captain/New(var/newloc,var/newmaterial)
	..(newloc,"steel","blue")

/obj/structure/bed/chair/armchair
	name = "armchair"
	desc = "It's an armchair. It looks comfy."
	icon_state = "armchair_preview"
	base_icon = "armchair"

/obj/structure/bed/chair/armchair/brown/New(var/newloc,var/newmaterial)
	..(newloc,"steel","leather")

/obj/structure/bed/chair/armchair/red/New(var/newloc,var/newmaterial)
	..(newloc,"steel","carpet")

/obj/structure/bed/chair/armchair/teal/New(var/newloc,var/newmaterial)
	..(newloc,"steel","teal")

/obj/structure/bed/chair/armchair/black/New(var/newloc,var/newmaterial)
	..(newloc,"steel","black")

/obj/structure/bed/chair/armchair/green/New(var/newloc,var/newmaterial)
	..(newloc,"steel","green")

/obj/structure/bed/chair/armchair/purp/New(var/newloc,var/newmaterial)
	..(newloc,"steel","purple")

/obj/structure/bed/chair/armchair/blue/New(var/newloc,var/newmaterial)
	..(newloc,"steel","blue")

/obj/structure/bed/chair/armchair/beige/New(var/newloc,var/newmaterial)
	..(newloc,"steel","beige")

/obj/structure/bed/chair/armchair/lime/New(var/newloc,var/newmaterial)
	..(newloc,"steel","lime")

/obj/structure/bed/chair/armchair/yellow/New(var/newloc,var/newmaterial)
	..(newloc,"steel","yellow")

/obj/structure/bed/chair/office
	name = "office chair"
	icon_state = "officechair_preview"
	base_icon = "officechair"
	anchored = 0
	buckle_movable = 1

/obj/structure/bed/chair/office/Move()
	. = ..()
	if(buckled_mob)
		var/mob/living/occupant = buckled_mob
		if (occupant && (src.loc != occupant.loc))
			if (propelled)
				for (var/mob/O in src.loc)
					if (O != occupant)
						Bump(O)
			else
				unbuckle_mob()

/obj/structure/bed/chair/office/Bump(atom/A)
	..()
	if(!buckled_mob)	return

	if(propelled)
		var/mob/living/occupant = unbuckle_mob()

		var/def_zone = ran_zone()
		var/blocked = occupant.run_armor_check(def_zone, "melee")
		occupant.throw_at(A, 3, propelled)
		occupant.apply_effect(6, STUN, blocked)
		occupant.apply_effect(6, WEAKEN, blocked)
		occupant.apply_effect(6, STUTTER, blocked)
		occupant.apply_damage(10, BRUTE, def_zone, blocked)
		playsound(src.loc, 'sound/weapons/punch1.ogg', 50, 1, -1)
		if(istype(A, /mob/living))
			var/mob/living/victim = A
			def_zone = ran_zone()
			blocked = victim.run_armor_check(def_zone, "melee")
			victim.apply_effect(6, STUN, blocked)
			victim.apply_effect(6, WEAKEN, blocked)
			victim.apply_effect(6, STUTTER, blocked)
			victim.apply_damage(10, BRUTE, def_zone, blocked)
		occupant.visible_message("<span class='danger'>[occupant] crashed into \the [A]!</span>")

/obj/structure/bed/chair/office/light/New(var/newloc,var/newmaterial)
	..(newloc,"steel","cotton")

/obj/structure/bed/chair/office/dark/New(var/newloc,var/newmaterial)
	..(newloc,"steel","black")

/obj/structure/bed/chair/office/comfy
	name = "comfy office chair"
	desc = "It's an office chair. It looks comfy."
	icon_state = "comfyofficechair_preview"
	base_icon = "comfyofficechair"

/obj/structure/bed/chair/office/comfy/brown/New(var/newloc,var/newmaterial)
	..(newloc,"steel","leather")

/obj/structure/bed/chair/office/comfy/red/New(var/newloc,var/newmaterial)
	..(newloc,"steel","carpet")

/obj/structure/bed/chair/office/comfy/teal/New(var/newloc,var/newmaterial)
	..(newloc,"steel","teal")

/obj/structure/bed/chair/office/comfy/black/New(var/newloc,var/newmaterial)
	..(newloc,"steel","black")

/obj/structure/bed/chair/office/comfy/green/New(var/newloc,var/newmaterial)
	..(newloc,"steel","green")

/obj/structure/bed/chair/office/comfy/purp/New(var/newloc,var/newmaterial)
	..(newloc,"steel","purple")

/obj/structure/bed/chair/office/comfy/blue/New(var/newloc,var/newmaterial)
	..(newloc,"steel","blue")

/obj/structure/bed/chair/office/comfy/beige/New(var/newloc,var/newmaterial)
	..(newloc,"steel","beige")

/obj/structure/bed/chair/office/comfy/lime/New(var/newloc,var/newmaterial)
	..(newloc,"steel","lime")

/obj/structure/bed/chair/office/comfy/yellow/New(var/newloc,var/newmaterial)
	..(newloc,"steel","yellow")

// Chair types
/obj/structure/bed/chair/wood
	name = "wooden chair"
	desc = "Old is never too old to not be in fashion."
	base_icon = "wooden_chair"
	icon_state = "wooden_chair_preview"

/obj/structure/bed/chair/wood/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/stack) || istype(W, /obj/item/weapon/wirecutters))
		return
	..()

/obj/structure/bed/chair/wood/New(var/newloc)
	..(newloc, "wood")

/obj/structure/bed/chair/wood/wings
	name = "winged wooden chair"
	base_icon = "wooden_chair_wings"
	icon_state = "wooden_chair_wings_preview"

/obj/structure/bed/chair/shuttle
	name = "shuttle seat"
	desc = "A comfortable, secure seat. It has a sturdy-looking buckling system for smoother flights."
	base_icon = "shuttle_chair"
	icon_state = "shuttle_chair_preview"

/obj/structure/bed/chair/shuttle/post_buckle_mob()
	if(buckled_mob)
		base_icon = "shuttle_chair-b"
	else
		base_icon = "shuttle_chair"
	..()

/obj/structure/bed/chair/shuttle/update_icon()
	..()
	if(!buckled_mob)
		var/image/I = image(icon, "[base_icon]_special")
		I.plane = ABOVE_HUMAN_PLANE
		I.layer = ABOVE_HUMAN_LAYER
		if(material_alteration & MATERIAL_ALTERATION_COLOR)
			I.color = material.icon_colour
		overlays |= I

/obj/structure/bed/chair/shuttle/blue/New(var/newloc,var/newmaterial)
	..(newloc,"steel","blue")

/obj/structure/bed/chair/shuttle/black/New(var/newloc,var/newmaterial)
	..(newloc,"steel","black")

/obj/structure/bed/chair/shuttle/white/New(var/newloc,var/newmaterial)
	..(newloc,"steel","cotton")