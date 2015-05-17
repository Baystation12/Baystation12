/obj/item/weapon/material
	health = 10
	hitsound = 'sound/weapons/bladeslice.ogg'
	gender = NEUTER

	var/applies_material_colour = 1
	var/unbreakable
	var/damage_divisor = 0.5
	var/default_material = DEFAULT_WALL_MATERIAL
	var/material/material

/obj/item/weapon/material/New(var/newloc, var/material_key)
	..(newloc)
	if(!material_key)
		material_key = default_material
	set_material(material_key)

/obj/item/weapon/material/proc/update_force()
	force = round(material.get_blunt_damage()*damage_divisor)

/obj/item/weapon/material/proc/set_material(var/new_material)
	material = get_material_by_name(new_material)
	if(!material)
		qdel(src)
	else
		name = "[material.display_name] [initial(name)]"
		health = round(material.integrity/10)
		if(applies_material_colour)
			color = material.icon_colour
		if(material.products_need_process())
			processing_objects |= src
		update_force()

/obj/item/weapon/material/Destroy()
	processing_objects -= src
	..()

/obj/item/weapon/material/attack()
	if(!..())
		return
	if(!unbreakable)
		if(!prob(material.hardness))
			health--
		if(health<=0)
			shatter()

/obj/item/weapon/material/proc/shatter()
	var/turf/T = get_turf(src)
	T.visible_message("<span class='danger'>\The [src] shatters!</span>")
	if(istype(loc, /mob/living))
		var/mob/living/M = loc
		M.drop_from_inventory(src)
	playsound(src, "shatter", 70, 1)
	new material.shard_type(T)
	qdel(src)

/obj/item/weapon/material/process()
	if(!material.radioactivity)
		return
	for(var/mob/living/L in range(1,src))
		L.apply_effect(round(material.radioactivity/3),IRRADIATE,0)