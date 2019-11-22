// SEE code/modules/materials/materials.dm FOR DETAILS ON INHERITED DATUM.
// This class of weapons takes force and appearance data from a material datum.
// They are also fragile based on material data and many can break/smash apart.
/obj/item/weapon/material
	health = 10
	hitsound = 'sound/weapons/bladeslice.ogg'
	gender = NEUTER
	throw_speed = 3
	throw_range = 7
	w_class = ITEM_SIZE_NORMAL
	sharp = 0
	edge = 0

	var/default_material = MATERIAL_STEEL
	var/material/material

	var/applies_material_colour = 1
	var/applies_material_name = 1 //if false, does not rename item to 'material item.name'
	var/furniture_icon  //icon states for non-material colorable overlay, i.e. handles
	
	var/max_force = 40	 //any damage above this is added to armor penetration value
	var/force_divisor = 0.5	// multiplier (sic) to material's generic damage value for this specific type of weapon
	var/thrown_force_divisor = 0.5

	var/attack_cooldown_modifier
	var/unbreakable
	var/drops_debris = 1
	var/worth_multiplier = 1

/obj/item/weapon/material/New(var/newloc, var/material_key)
	if(!material_key)
		material_key = default_material
	set_material(material_key)
	..(newloc)
	queue_icon_update()
	if(!material)
		qdel(src)
		return

	matter = material.get_matter()
	if(matter.len)
		for(var/material_type in matter)
			if(!isnull(matter[material_type]))
				matter[material_type] *= force_divisor // May require a new var instead.

/obj/item/weapon/material/get_material()
	return material

/obj/item/weapon/material/proc/update_force()
	var/new_force
	if(edge || sharp)
		new_force = material.get_edge_damage()
	else
		new_force = material.get_blunt_damage()
	new_force = round(new_force*force_divisor)
	force = min(new_force, max_force)

	if(new_force > max_force)
		armor_penetration = initial(armor_penetration) + new_force - max_force
	armor_penetration += 2*max(0, material.brute_armor - 2)

	throwforce = round(material.get_blunt_damage()*thrown_force_divisor)
	attack_cooldown = material.get_attack_cooldown() + attack_cooldown_modifier
	//spawn(1)
//		log_debug("[src] has force [force] and throwforce [throwforce] when made from default material [material.name]")

/obj/item/weapon/material/proc/set_material(var/new_material)
	material = SSmaterials.get_material_by_name(new_material)
	if(!material)
		qdel(src)
	else
		health = round(material.integrity/5)
		if(material.products_need_process())
			START_PROCESSING(SSobj, src)
		if(material.conductive)
			obj_flags |= OBJ_FLAG_CONDUCTIBLE
		else
			obj_flags &= (~OBJ_FLAG_CONDUCTIBLE)
		update_force()
		if(applies_material_name)
			SetName("[material.display_name] [initial(name)]")
		update_icon()

/obj/item/weapon/material/on_update_icon()
	overlays.Cut()
	if(applies_material_colour && istype(material))
		color = material.icon_colour
		alpha = 100 + material.opacity * 255
	if(furniture_icon)
		var/image/I = image(icon, icon_state = furniture_icon)
		I.appearance_flags = RESET_COLOR
		overlays += I

/obj/item/weapon/material/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/weapon/material/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	. = ..()
	if(material.is_brittle() || target.get_blocked_ratio(hit_zone, BRUTE, damage_flags(), armor_penetration, force) * 100 >= material.hardness/5)
		check_shatter()

/obj/item/weapon/material/on_parry(damage_source)
	if(istype(damage_source, /obj/item/weapon/material))
		check_shatter()

/obj/item/weapon/material/proc/check_shatter()
	if(!unbreakable && prob(material.hardness))
		if(material.is_brittle())
			health = 0
		else
			health--
		check_health()

/obj/item/weapon/material/proc/check_health(var/consumed)
	if(health<=0)
		shatter(consumed)

/obj/item/weapon/material/proc/shatter(var/consumed)
	var/turf/T = get_turf(src)
	T.visible_message("<span class='danger'>\The [src] [material.destruction_desc]!</span>")
	playsound(src, "shatter", 70, 1)
	if(!consumed && drops_debris)
		material.place_shard(T)
	qdel(src)