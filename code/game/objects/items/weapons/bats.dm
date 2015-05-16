/obj/item/weapon/twohanded/baseballbat
	name = "wooden bat"
	desc = "HOME RUN!"
	icon_state = "metalbat0"
	base_icon = "metalbat"
	item_state = "metalbat"
	sharp = 0
	edge = 0
	w_class = 3
	force = 10
	throw_speed = 3
	throw_range = 7
	throwforce = 7
	attack_verb = list("smashed", "beaten", "slammed", "smacked", "struck", "battered", "bonked")
	hitsound = 'sound/weapons/genhit3.ogg'
	force_wielded = 20
	health = 10
	var/material/material

/obj/item/weapon/twohanded/baseballbat/New(var/newloc, var/material_key)
	..(newloc)
	if(!material_key)
		material_key = "wood"
	material = get_material_by_name(material_key)
	if(!material)
		qdel(src)
	else
		name = "[material.display_name] bat"
		base_name = name
		health = round(material.integrity/10)
		force = round(material.get_blunt_damage()/2)
		force_unwielded = force
		force_wielded = material.get_blunt_damage()
		color = material.icon_colour
		if(material.products_need_process())
			processing_objects |= src

/obj/item/weapon/twohanded/baseballbat/Destroy()
	processing_objects -= src
	..()

/obj/item/weapon/twohanded/baseballbat/attack()
	if(!..())
		return
	if(!prob(material.hardness))
		health--
	if(health<=0)
		shatter()

/obj/item/weapon/twohanded/baseballbat/proc/shatter()
	var/turf/T = get_turf(src)
	T.visible_message("<span class='danger'>\The [src] shatters!</span>")
	if(istype(loc, /mob/living))
		var/mob/living/M = loc
		M.drop_from_inventory(src)
	playsound(src, "shatter", 70, 1)
	new material.shard_type(T)
	qdel(src)

/obj/item/weapon/twohanded/baseballbat/process()
	if(!material.radioactivity)
		return
	for(var/mob/living/L in range(1,src))
		L.apply_effect(round(material.radioactivity/3),IRRADIATE,0)

//Predefined materials go here.
/obj/item/weapon/twohanded/baseballbat/metal/New(var/newloc)
	..(newloc,"steel")

/obj/item/weapon/twohanded/baseballbat/uranium/New(var/newloc)
	..(newloc,"uranium")

/obj/item/weapon/twohanded/baseballbat/gold/New(var/newloc)
	..(newloc,"gold")

/obj/item/weapon/twohanded/baseballbat/platinum/New(var/newloc)
	..(newloc,"platinum")

/obj/item/weapon/twohanded/baseballbat/diamond/New(var/newloc)
	..(newloc,"diamond")