#define DUAL_WIELD_ALLOWED DUAL_WIELD_UNSC + DUAL_WIELD_COVIE
#define DUAL_WIELD_UNSC list(/obj/item/weapon/gun/projectile/m7_smg,/obj/item/weapon/gun/projectile/m6d_magnum)
#define DUAL_WIELD_COVIE list(/obj/item/weapon/gun/energy/plasmarifle,/obj/item/weapon/gun/energy/plasmapistol,\
/obj/item/weapon/gun/projectile/needler)

/mob/living/carbon/human/proc/dual_wield_weapons()
	set category = "Abilities"
	set name = "Dual Wield Weapons"
	set desc = "Dual wield two allowed weapons."

	var/obj/active_hand_item = get_active_hand()
	var/obj/inactive_hand_item = get_inactive_hand()
	if(!isnull(active_hand_item) && !isnull(inactive_hand_item))
		if(istype(active_hand_item,/obj/item/weapon/gun) && istype(inactive_hand_item,/obj/item/weapon/gun))
			if((active_hand_item.type in DUAL_WIELD_ALLOWED) && (inactive_hand_item.type in DUAL_WIELD_ALLOWED))
				var/obj/item/weapon/gun/dual_wield_placeholder/DW = new /obj/item/weapon/gun/dual_wield_placeholder(loc)
				DW.add_wielding_weapon(active_hand_item,src)
				DW.add_wielding_weapon(inactive_hand_item,src)
				put_in_active_hand(DW)

/obj/item/weapon/gun/dual_wield_placeholder
	name = "Dual Wield Placeholder"
	desc = "You're holding two guns in such a way as to allow you to fire both at once."

	one_hand_penalty = -1
	var/list/weapons_wielded = list()
	var/weapon_delay = 2 //The time in ticks between each weapon firing.

/obj/item/weapon/gun/dual_wield_placeholder/New()
	.=..()
	name = ""

/obj/item/weapon/gun/dual_wield_placeholder/proc/add_wielding_weapon(var/obj/weapon,var/mob/user)
	user.drop_from_inventory(weapon)
	contents += weapon
	weapons_wielded += weapon
	name += "[weapon.name] "
	generate_icon()

/obj/item/weapon/gun/dual_wield_placeholder/proc/generate_icon()
	var/icon/base_icon
	var/icon/weaponicon
	for(var/obj/weapon in weapons_wielded)
		var/index = weapons_wielded.Find(weapon)
		if(!base_icon)
			base_icon = new(weapon.icon,weapon.icon_state)
			continue
		weaponicon = new(weapon.icon,weapon.icon_state)
		weaponicon.Shift(SOUTH,3*index)
		base_icon.Blend(weaponicon,ICON_OVERLAY)
	icon = base_icon

/obj/item/weapon/gun/dual_wield_placeholder/get_mob_overlay(var/mob/user,var/slot)
	var/image/newimage = new
	var/image/weapon_image
	for(var/obj/item/weapon in weapons_wielded)
		var/index = weapons_wielded.Find(weapon)
		if((index % 2) == 0)
			weapon_image = weapon.get_mob_overlay(user,slot_r_hand_str)
		else
			weapon_image = weapon.get_mob_overlay(user,slot_l_hand_str)
		newimage.overlays += weapon_image

	return newimage

/obj/item/weapon/gun/dual_wield_placeholder/Fire(atom/target, mob/living/user, clickparams, pointblank, reflex)
	for(var/obj/item/weapon/gun/weapon in weapons_wielded)
		weapon.Fire(target,user,clickparams,pointblank,reflex)
		sleep(weapon_delay)

/obj/item/weapon/gun/dual_wield_placeholder/update_twohanding() //Overriden to do nothing so the name doesn't get reset to "dual wield placeholder"
	return

/obj/item/weapon/gun/dual_wield_placeholder/dropped(var/mob/user)
	var/obj/weapon
	if(!user.put_in_active_hand(weapons_wielded[1]))
		weapon = weapons_wielded[1]
		weapon.forceMove(user.loc)
	if(!user.put_in_inactive_hand(weapons_wielded[2]))
		weapon = weapons_wielded[2]
		weapon.forceMove(user.loc)
	weapons_wielded.Cut()
	qdel(src)
