
/mob/living/carbon/human/proc/dual_wield_weapons()
	set category = "Abilities"
	set name = "Dual Wield Weapons"
	set desc = "Dual wield two allowed weapons."

	var/obj/item/weapon/gun/active_hand_item = get_active_hand()
	var/obj/item/weapon/gun/inactive_hand_item = get_inactive_hand()
	if(!isnull(active_hand_item) && !isnull(inactive_hand_item))
		if(istype(active_hand_item,/obj/item/weapon/gun) && istype(inactive_hand_item,/obj/item/weapon/gun))
			if((active_hand_item.one_hand_penalty != -1) && (inactive_hand_item.one_hand_penalty != -1))
				var/obj/item/weapon/gun/dual_wield_placeholder/DW = new /obj/item/weapon/gun/dual_wield_placeholder(loc)
				DW.add_wielding_weapon(active_hand_item,src)
				DW.add_wielding_weapon(inactive_hand_item,src)
				put_in_active_hand(DW)

/obj/item/weapon/gun/dual_wield_placeholder
	name = "Dual Wield Placeholder"
	desc = "You're holding two guns in such a way as to allow you to fire both at once."

	w_class = 9
	slot_flags = 0

	one_hand_penalty = -1
	var/list/weapons_wielded = list()

/obj/item/weapon/gun/dual_wield_placeholder/New()
	. =..()
	name = ""

/obj/item/weapon/gun/dual_wield_placeholder/proc/add_wielding_weapon(var/obj/item/weapon/gun/weapon,var/mob/user)
	user.drop_from_inventory(weapon)
	contents += weapon
	weapons_wielded += weapon
	name += "+ [weapon.name] "
	fire_delay = max(fire_delay,weapon.fire_delay + weapon.burst * weapon.burst_delay)
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

/obj/item/weapon/gun/dual_wield_placeholder/Fire(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0)
	next_fire_time = world.time + fire_delay
	for(var/obj/item/weapon/gun/weapon in weapons_wielded)
		var/index = weapons_wielded.Find(weapon)
			sleep((weapon.fire_delay/2) * index)
			weapon.next_fire_time = 0
			weapon.afterattack(target, user, pointblank, clickparams)


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
