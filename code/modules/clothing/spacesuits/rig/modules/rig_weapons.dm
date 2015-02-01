//Weapon types intended to be used with rig modules

/obj/item/weapon/gun/energy/lasercannon/mounted/load_into_chamber()
	if(in_chamber)
		return 1
	var/obj/item/rig_module/module = loc
	if(!istype(module))
		return 0
	if(module.holder && module.holder.wearer)
		var/mob/living/carbon/human/H = module.holder.wearer
		if(istype(H) && H.back)
			var/obj/item/weapon/rig/suit = H.back
			if(istype(suit) && suit.cell && suit.cell.charge >= 250)
				suit.cell.use(250)
				in_chamber = new /obj/item/projectile/beam/heavylaser(src)
				return 1
	return 0

/obj/item/weapon/gun/energy/gun/mounted/load_into_chamber()
	if(in_chamber)
		return 1
	var/obj/item/rig_module/module = loc
	if(!istype(module))
		return 0
	if(module.holder && module.holder.wearer)
		var/mob/living/carbon/human/H = module.holder.wearer
		if(istype(H) && H.back)
			var/obj/item/weapon/rig/suit = H.back
			if(istype(suit) && suit.cell && suit.cell.charge >= 250)
				suit.cell.use(250)
				var/prog_path = text2path(projectile_type)
				in_chamber = new prog_path(src)
				return 1
	return 0

/obj/item/weapon/gun/energy/taser/mounted/load_into_chamber()
	if(in_chamber)
		return 1
	var/obj/item/rig_module/module = loc
	if(!istype(module))
		return 0
	if(module.holder && module.holder.wearer)
		var/mob/living/carbon/human/H = module.holder.wearer
		if(istype(H) && H.back)
			var/obj/item/weapon/rig/suit = H.back
			if(istype(suit) && suit.cell && suit.cell.charge >= 250)
				suit.cell.use(250)
				var/prog_path = text2path(projectile_type)
				in_chamber = new prog_path(src)
				return 1
	return 0