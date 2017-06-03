/obj/item/gun_component/body
	name = "body"
	component_type = COMPONENT_BODY
	projectile_type = GUN_TYPE_BALLISTIC
	icon = 'icons/obj/gun_components/body.dmi'
	var/base_desc = "It is an ambiguous firearm of some sort."
	var/wielded_state = "assault-wielded"

/obj/item/gun_component/body/attackby(var/obj/item/thing, var/mob/user)
	if(istype(thing, /obj/item/gun_component))
		var/obj/item/gun_component/GC = thing
		if(GC.component_type == COMPONENT_ACCESSORY)
			user << "<span class='warning'>Accessories can only be installed into gun assemblies or firearms, not into individual components.</span>"
			return
		if(GC.component_type == component_type)
			user << "<span class='warning'>Why are you trying to install one [component_type] into another?</span>"
			return
		var/obj/item/gun_assembly/GA = new(get_turf(src))
		GA.attackby(src, user)
		GA.attackby(GC, user)
		GA.update_components()
		if(!GA.contents.len)
			qdel(GA)
		return
	..()

/obj/item/gun_component/body/proc/is_laser()
	 return (projectile_type == GUN_TYPE_LASER)

/obj/item/gun_component/body/pistol
	icon_state = "pistol"
	weapon_type = GUN_PISTOL
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	w_class = 2
	force = 5
	item_state = "gun"
	base_desc = "It's a pistol."
	color = COLOR_GUNMETAL

/obj/item/gun_component/body/pistol/revolver
	icon_state = "revolver"
	item_state = "revolver"
	base_desc = "It's a revolver."

/obj/item/gun_component/body/pistol/small
	name = "light body"
	force = 2
	w_class = 1
	base_desc = "It's a small pistol."

/obj/item/gun_component/body/smg
	icon_state = "smg"
	weapon_type = GUN_SMG
	slot_flags = SLOT_BELT|SLOT_BACK|SLOT_HOLSTER
	w_class = 2
	force = 7
	item_state = "c20r"
	base_desc = "It's a submachine gun."
	color = COLOR_GUNMETAL
	wielded_state = "assault-wielded"

/obj/item/gun_component/body/rifle
	icon_state = "rifle"
	weapon_type = GUN_RIFLE
	slot_flags = SLOT_BACK
	w_class = 2
	force = 10
	accepts_accessories = 1
	item_state = "huntingrifle"
	base_desc = "It's a rifle."
	two_handed = 1
	recoil_mod = -1
	wielded_state = "rifle-wielded"

/obj/item/gun_component/body/rifle/black
	icon_state = "sniper"
	base_desc = "It's a heavy rifle."
	item_state = "l6closednomag"
	w_class = 3
	wielded_state = "sniper-wielded"

/obj/item/gun_component/body/cannon
	icon_state = "cannon"
	weapon_type = GUN_CANNON
	w_class = 3
	force = 8
	slot_flags = 0
	accepts_accessories = 1
	item_state = "riotgun"
	base_desc = "It's a cannon."
	two_handed = 1
	recoil_mod = -2
	wielded_state = "cannon-wielded"

/obj/item/gun_component/body/assault
	icon_state = "assault"
	weapon_type = GUN_ASSAULT
	slot_flags = SLOT_BACK
	w_class = 3
	force = 10
	accepts_accessories = 1
	item_state = "z8carbine"
	base_desc = "It's an assault rifle."
	two_handed = 1
	recoil_mod = -1
	wielded_state = "assault-wielded"

/obj/item/gun_component/body/shotgun
	icon_state = "shotgun"
	weapon_type = GUN_SHOTGUN
	slot_flags = SLOT_BACK
	w_class = 2
	force = 10
	accepts_accessories = 1
	item_state = "shotgun"
	base_desc = "It's a shotgun."
	two_handed = 1
	recoil_mod = -1
	wielded_state = "shotgun-wielded"

/obj/item/gun_component/body/shotgun/combat
	item_state = "cshotgun"

/obj/item/gun_component/body/shotgun/hunting
	icon_state = "shotgun_hunting"

/obj/item/gun_component/body/pistol/laser
	icon_state = "las_pistol"
	projectile_type = GUN_TYPE_LASER
	item_state = "retro"
	base_desc = "It's an energy pistol."

/obj/item/gun_component/body/smg/laser
	icon_state = "las_smg"
	projectile_type = GUN_TYPE_LASER
	item_state = "xray"
	base_desc = "It's an energy submachine gun."
	wielded_state = "lassault-wielded"

/obj/item/gun_component/body/rifle/laser
	icon_state = "las_assault"
	projectile_type = GUN_TYPE_LASER
	item_state = "laser"
	base_desc = "It's an energy rifle."
	wielded_state = "lassault-wielded"

/obj/item/gun_component/body/cannon/laser
	icon_state = "las_cannon"
	projectile_type = GUN_TYPE_LASER
	item_state = "lasercannon"
	base_desc = "It's an energy cannon."
	wielded_state = "lassault-wielded"

/obj/item/gun_component/body/assault/laser
	icon_state = "las_assault"
	projectile_type = GUN_TYPE_LASER
	item_state = "laser"
	w_class = 3
	base_desc = "It's an energy assault rifle."
	wielded_state = "lassault-wielded"

/obj/item/gun_component/body/shotgun/laser
	icon_state = "las_shotgun"
	projectile_type = GUN_TYPE_LASER
	item_state = "pulse"
	base_desc = "It's an energy shotgun."
	wielded_state = "lassault-wielded"
