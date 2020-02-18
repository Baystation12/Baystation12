
/mob/living/simple_animal/hostile/defender_mob
	name = "Capture Point Defender"
	icon = 'code/modules/halo/icons/mobs/defense_mobs.dmi'
	health = 100
	maxHealth = 100
	resistance = 10
	var/list/possible_weapons = list()
	var/icon/gun_overlay

/mob/living/simple_animal/hostile/defender_mob/Initialize()
	. = ..()
	process_weapon()

/mob/living/simple_animal/hostile/defender_mob/toggle_hold_fire()
	hold_fire = !hold_fire
	if(hold_fire == FALSE)
		visible_message("<span class = 'danger'>[src] raises their weapon, ready to fire.</span>")
	else
		visible_message("<span class = 'notice'>[src] lowers their weapon, warily watching.</span>")

/mob/living/simple_animal/hostile/defender_mob/proc/process_weapon()
	if(possible_weapons.len == 0)
		return
	var/type_equip = pick(possible_weapons)
	var/obj/item/weapon/gun/projectile/g_proj = new type_equip
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
	g_energy = null
	qdel(g_proj)
	update_icon()

/mob/living/simple_animal/hostile/defender_mob/update_icon()
	. = ..()
	if(stat == DEAD || isnull(gun_overlay))
		return
	overlays += gun_overlay

/mob/living/simple_animal/hostile/defender_mob/examine(var/mob/examiner)
	. = ..()
	to_chat(examiner,"<span class = 'notice'>A defender belonging to the [faction] faction.</span>")

/mob/living/simple_animal/hostile/defender_mob/unsc
	faction = "UNSC"

/mob/living/simple_animal/hostile/defender_mob/unsc/marine
	name = "UNSC Defender (Marine)"
	icon_state = "marine"
	icon_living  = "marine"
	icon_dead = "dead_marine"
	possible_weapons = list(/obj/item/weapon/gun/projectile/m6d_magnum,/obj/item/weapon/gun/projectile/ma5b_ar,/obj/item/weapon/gun/projectile/m7_smg,/obj/item/weapon/gun/projectile/m392_dmr)

/mob/living/simple_animal/hostile/defender_mob/unsc/odst
	health = 125
	name = "UNSC Defender (ODST)"
	icon_state = "odst"
	icon_living  = "odst"
	icon_dead = "dead_odst"
	possible_weapons = list(/obj/item/weapon/gun/projectile/m7_smg, /obj/item/weapon/gun/projectile/br55, /obj/item/weapon/gun/projectile/m392_dmr)

/mob/living/simple_animal/hostile/defender_mob/innie
	faction = "Insurrection"

/mob/living/simple_animal/hostile/defender_mob/innie/medium
	name = "Insurrection Defender (Medium Armoured)"
	icon_state = "medium_innie_brown"
	icon_living  = "medium_innie_brown"
	icon_dead = "dead_medium_innie_brown"
	possible_weapons = list(/obj/item/weapon/gun/projectile/m6d_magnum,/obj/item/weapon/gun/projectile/ma5b_ar/MA37,/obj/item/weapon/gun/projectile/ma5b_ar/MA3,/obj/item/weapon/gun/projectile/m392_dmr/innie)

/mob/living/simple_animal/hostile/defender_mob/innie/heavy
	name = "Insurrection Defender (Heavy Armoured)"
	health = 125
	icon_state = "heavy_innie_brown"
	icon_living  = "heavy_innie_brown"
	icon_dead = "dead_heavy_innie_brown"

	possible_weapons = list(/obj/item/weapon/gun/projectile/ma5b_ar/MA3,/obj/item/weapon/gun/projectile/m392_dmr/innie,/obj/item/weapon/gun/projectile/shotgun/pump/m90_ts)

/mob/living/simple_animal/hostile/defender_mob/cov
	faction = "Covenant"

/mob/living/simple_animal/hostile/defender_mob/cov/grunt
	name = "Covenant Defender (Grunt)"
	icon_state = "grunt"
	icon_living = "grunt"
	icon_dead = "dead_grunt"
	possible_weapons = list(/obj/item/weapon/gun/energy/plasmapistol, /obj/item/weapon/gun/projectile/needler)

/mob/living/simple_animal/hostile/defender_mob/cov/kig
	name = "Covenant Defender (Kig Yar)"
	health = 125
	icon_state = "kigyar"
	icon_living = "kigyar"
	icon_dead = "dead_kigyar"
	possible_weapons = list(/obj/item/weapon/gun/energy/plasmapistol, /obj/item/weapon/gun/projectile/type51carbine, /obj/item/weapon/gun/projectile/type31needlerifle)
