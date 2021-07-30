
/obj/effect/itemspawn_marker
	name = "Itemspawn Marker"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x4"
	invisibility = 101
	var/spawn_interval = 2 MINUTES
	var/time_next_item_spawn = 0
	var/obj/last_spawned_item //We track our last spawned item, until we realise it's moved off of our position.
	var/list/spawnables = list()
	var/mags_spawn = 0

/obj/effect/itemspawn_marker/Initialize()
	. = ..()
	GLOB.processing_objects += src

/obj/effect/itemspawn_marker/ex_act()
	return

/obj/effect/itemspawn_marker/process()
	if(last_spawned_item)
		if(last_spawned_item.loc != get_turf(loc)) //.loc is intentionally used here to disallow standing on the spawn tile
			//whilst holding the item and other such things.
			last_spawned_item = null
			time_next_item_spawn = world.time + spawn_interval
	else
		if(world.time >= time_next_item_spawn)
			spawn_item()

/obj/effect/itemspawn_marker/proc/spawn_item()
	var/turf/t = get_turf(loc)
	if(!t)
		return
	var/to_spawn = pick(spawnables)
	last_spawned_item = new to_spawn (t)
	var/obj/item/weapon/gun/projectile/g = last_spawned_item
	if(mags_spawn > 0 && istype(g))
		for(var/i = 0 to mags_spawn)
			new g.magazine_type (t)

/obj/effect/itemspawn_marker/Destroy()
	GLOB.processing_objects -= src
	. = ..()

//Marker Variants//

/obj/effect/itemspawn_marker/melee
	spawnables = list(\
	/obj/item/weapon/material/machete,
	/obj/item/weapon/material/machete/officersword,
	/obj/item/weapon/melee/energy/elite_sword,
	/obj/item/weapon/melee/energy/elite_sword/honour_staff,
	/obj/item/weapon/melee/blamite/cutlass
	)

/obj/effect/itemspawn_marker/pistols
	spawn_interval = 1 MINUTE
	mags_spawn = 5
	spawnables = list(\
	/obj/item/weapon/gun/projectile/m6d_magnum,
	/obj/item/weapon/gun/projectile/m6c_magnum_s,
	/obj/item/weapon/gun/energy/plasmapistol
	)

/obj/effect/itemspawn_marker/smgs
	spawn_interval = 1.5 MINUTES
	mags_spawn = 5
	spawnables = list(\
	/obj/item/weapon/gun/projectile/m7_smg,
	/obj/item/weapon/gun/projectile/m7_smg/silenced,
	/obj/item/weapon/gun/projectile/needler,
	/obj/item/weapon/gun/projectile/boltshot
	)

/obj/effect/itemspawn_marker/rifles
	mags_spawn = 5
	spawnables = list(\
	/obj/item/weapon/gun/projectile/ma37_ar,
	/obj/item/weapon/gun/projectile/ma5b_ar,
	/obj/item/weapon/gun/energy/plasmarifle,
	/obj/item/weapon/gun/energy/plasmarifle/brute,
	/obj/item/weapon/gun/projectile/suppressor
	)

/obj/effect/itemspawn_marker/rifles_precision
	mags_spawn = 4
	spawnables = list(\
	/obj/item/weapon/gun/projectile/m392_dmr,
	/obj/item/weapon/gun/projectile/br55,
	/obj/item/weapon/gun/projectile/type51carbine,
	/obj/item/weapon/gun/projectile/type31needlerifle
	)

/obj/effect/itemspawn_marker/lmg
	spawn_interval = 2.5 MINUTES
	mags_spawn = 3
	spawnables = list(\
	/obj/item/weapon/gun/projectile/m545_lmg,
	/obj/item/weapon/gun/projectile/m739_lmg,
	/obj/item/weapon/gun/energy/plasmarepeater
	)

/obj/effect/itemspawn_marker/snipers
	spawn_interval = 2.5 MINUTES
	mags_spawn = 3
	spawnables = list(\
	/obj/item/weapon/gun/projectile/srs99_sniper,
	/obj/item/weapon/gun/energy/beam_rifle,
	/obj/item/weapon/gun/projectile/binary_rifle
	)

/obj/effect/itemspawn_marker/detached_turrets
	spawn_interval = 2.5 MINUTES
	mags_spawn = 0
	spawnables = list(\
	/obj/item/weapon/gun/projectile/turret/HMG/detached,
	/obj/item/weapon/gun/projectile/turret/plas/detached,
	/obj/item/weapon/gun/projectile/turret/chaingun/detached
	)

/obj/effect/itemspawn_marker/explosives
	spawn_interval = 30 SECONDS
	spawnables = list(\
	/obj/item/weapon/grenade/frag/m9_hedp,
	/obj/item/weapon/grenade/plasma,
	/obj/item/weapon/grenade/splinter,

	)

/obj/effect/itemspawn_marker/launchers
	spawn_interval = 2.5 MINUTES
	mags_spawn = 1
	spawnables = list(\
	/obj/item/weapon/gun/projectile/m41,
	/obj/item/weapon/gun/projectile/fuel_rod,
	/obj/item/weapon/gun/projectile/concussion_rifle
	)

/obj/effect/itemspawn_marker/medical
	spawn_interval = 45 SECONDS
	spawnables = list(\
	/obj/item/weapon/storage/firstaid/unsc/cov,
	/obj/item/weapon/storage/firstaid/unsc
	)