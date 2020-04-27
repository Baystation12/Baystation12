
/mob/living/simple_animal/hostile
	var/list/possible_weapons = list()
	var/icon/gun_overlay
	var/combat_tier = 0

/mob/living/simple_animal/hostile/toggle_hold_fire()
	hold_fire = !hold_fire
	if(hold_fire == FALSE)
		visible_message("<span class = 'danger'>[src] raises their weapon, ready to fire.</span>")
	else
		visible_message("<span class = 'notice'>[src] lowers their weapon, warily watching.</span>")

/mob/living/simple_animal/hostile/proc/spawn_weapon()
	if(possible_weapons.len == 0)
		return
	var/type_equip = pick(possible_weapons)
	var/obj/item/weapon/gun/projectile/g_proj = new type_equip(src)
	var/obj/item/weapon/gun/energy/g_energy = g_proj
	if(istype(g_proj))
		ranged = 1
		burst_size = g_proj.burst
		burst_delay = g_proj.burst_delay
		projectilesound = g_proj.fire_sound
		var/obj/item/ammo_casing/casing
		if(!isnull(g_proj.magazine_type))
			var/obj/item/ammo_magazine/mag = new g_proj.magazine_type
			casingtype = mag.ammo_type
			casing = new casingtype
		else
			casingtype = g_proj.ammo_type
			casing = new casingtype

		if(isnull(casing))
			return
		projectiletype = casing.projectile_type
		if(isnull(projectilesound))
			projectilesound = casing.fire_sound
		qdel(casing)

	else if(istype(g_energy))
		ranged = 1
		burst_size = g_energy.burst
		projectiletype = g_energy.projectile_type
		projectilesound = g_energy.fire_sound
		burst_delay = g_energy.burst_delay

	gun_overlay = icon(g_proj.item_icons[slot_r_hand_str],g_proj.item_state)
	update_icon()

/mob/living/simple_animal/hostile/update_icon()
	. = ..()
	if(stat == DEAD || isnull(gun_overlay))
		return
	overlays += gun_overlay
