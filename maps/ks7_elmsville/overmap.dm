/obj/effect/overmap/sector/exo_depot
	name = "KS7-535"
	icon = 'ks7_sector_icon.dmi'
	icon_state = "ice"

	faction = "Human Civilian"
	base = 1
	block_slipspace = 1

	map_bounds = list(1,150,150,1) //Format: (TOP_LEFT_X,TOP_LEFT_Y,BOTTOM_RIGHT_X,BOTTOM_RIGHT_Y)

/obj/effect/overmap/sector/exo_depot/New()
	. = ..()
	/*loot_distributor.loot_list += list(\
	"ks7unique" = list(/obj/structure/xeno_plant,/obj/structure/autoturret/ONI,null,null)
	)*/
	loot_distributor.loot_list["covScrapLoot"] = list(\
	/obj/item/weapon/gun/projectile/needler,/obj/item/weapon/gun/projectile/needler,/obj/item/weapon/gun/projectile/needler,
	/obj/item/weapon/gun/energy/plasmapistol,/obj/item/weapon/gun/energy/plasmapistol,
	/obj/item/weapon/gun/energy/plasmarifle,/obj/item/weapon/gun/energy/plasmarifle,/obj/item/weapon/gun/energy/plasmarifle,
	/obj/item/weapon/gun/energy/plasmarifle,/obj/item/weapon/gun/energy/plasmarifle,/obj/item/weapon/grenade/plasma,
	/obj/item/weapon/grenade/plasma,/obj/item/weapon/grenade/plasma,/obj/item/weapon/grenade/plasma,/obj/item/weapon/grenade/plasma,
	/obj/item/weapon/gun/projectile/type51carbine,/obj/item/weapon/gun/projectile/type51carbine,
	/obj/item/weapon/gun/projectile/type31needlerifle,/obj/item/weapon/gun/projectile/type31needlerifle,
	null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null
	)

	loot_distributor.loot_list["humanSalvageLoot"] = list(\
	/obj/item/weapon/gun/projectile/m7_smg,/obj/item/weapon/gun/projectile/m7_smg,/obj/item/weapon/gun/projectile/m7_smg,
	/obj/item/weapon/gun/projectile/m6d_magnum,/obj/item/weapon/gun/projectile/m6d_magnum,
	/obj/item/weapon/gun/projectile/ma5b_ar,/obj/item/weapon/gun/projectile/ma5b_ar/MA37,/obj/item/weapon/gun/projectile/ma5b_ar/MA3,
	/obj/item/weapon/gun/projectile/br55,/obj/item/weapon/gun/projectile/br55,/obj/item/weapon/gun/projectile/shotgun/pump/m90_ts,
	/obj/item/weapon/gun/projectile/shotgun/pump/m90_ts,/obj/item/weapon/gun/projectile/shotgun/pump/m45_ts,
	/obj/item/weapon/gun/projectile/m739_lmg,/obj/item/weapon/gun/projectile/m392_dmr,/obj/item/weapon/gun/projectile/m392_dmr,
	null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null
	)

	loot_distributor.loot_list["piratePostLoot"] = list(\
	/obj/item/weapon/gun/projectile/ma5b_ar/MA3,/obj/item/weapon/gun/projectile/ma5b_ar/MA3,,/obj/item/weapon/gun/projectile/ma5b_ar/MA3,
	/obj/item/weapon/gun/projectile/ma5b_ar/MA3,,/obj/item/weapon/gun/projectile/ma5b_ar/MA3,/obj/item/weapon/gun/projectile/ma5b_ar,
	/obj/item/weapon/gun/projectile/ma5b_ar,/obj/item/weapon/gun/projectile/needler,/obj/item/weapon/gun/projectile/needler,
	/obj/item/weapon/gun/projectile/needler,/obj/item/weapon/gun/projectile/type51carbine,
	/obj/item/weapon/gun/projectile/type51carbine,/obj/item/weapon/gun/projectile/type51carbine,/obj/item/weapon/gun/projectile/m392_dmr,
	/obj/item/weapon/gun/projectile/m392_dmr,/obj/item/weapon/gun/projectile/m392_dmr,/obj/item/weapon/gun/projectile/m6d_magnum,
	/obj/item/weapon/gun/projectile/m6d_magnum,/obj/item/weapon/gun/projectile/m6d_magnum,/obj/item/weapon/gun/projectile/m6d_magnum,
	/obj/item/weapon/gun/projectile/type31needlerifle,/obj/item/weapon/gun/projectile/type31needlerifle,/obj/item/weapon/gun/projectile/type31needlerifle,
	/obj/item/weapon/card/id/building_key/pirateVault, //Sometimes you don't have to break in,there's a key!
	null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null
	)

	loot_distributor.loot_list["easySalvageLoot"] = list(\
	/obj/item/weapon/gun/projectile/ma5b_ar/MA3,/obj/item/weapon/gun/projectile/m7_smg,/obj/item/weapon/gun/projectile/m7_smg,
	/obj/item/weapon/gun/projectile/ma5b_ar/MA37,/obj/item/weapon/gun/projectile/m6d_magnum,
	null,null,null,null,null,null,null,null
	)//10
	loot_distributor.loot_list["salvageDefenders"] = list(\
	/mob/living/simple_animal/hostile/pirate_defender,/mob/living/simple_animal/hostile/pirate_defender,/mob/living/simple_animal/hostile/pirate_defender,
	/mob/living/simple_animal/hostile/pirate_defender,/mob/living/simple_animal/hostile/pirate_defender,/mob/living/simple_animal/hostile/pirate_defender,
	/mob/living/simple_animal/hostile/pirate_defender/civ,/mob/living/simple_animal/hostile/pirate_defender/civ,/mob/living/simple_animal/hostile/pirate_defender/civ,
	/mob/living/simple_animal/hostile/pirate_defender/medium,/mob/living/simple_animal/hostile/pirate_defender/medium,/mob/living/simple_animal/hostile/pirate_defender/medium,
	/mob/living/simple_animal/hostile/pirate_defender/medium,/mob/living/simple_animal/hostile/pirate_defender/medium,/mob/living/simple_animal/hostile/pirate_defender/medium,
	/mob/living/simple_animal/hostile/pirate_defender/medium,/mob/living/simple_animal/hostile/pirate_defender/medium,/mob/living/simple_animal/hostile/pirate_defender/medium,
	/mob/living/simple_animal/hostile/pirate_defender/heavy,/mob/living/simple_animal/hostile/pirate_defender/heavy,/mob/living/simple_animal/hostile/pirate_defender/heavy,
	/mob/living/simple_animal/hostile/pirate_defender/heavy,/mob/living/simple_animal/hostile/pirate_defender/heavy,/mob/living/simple_animal/hostile/pirate_defender/heavy,
	/mob/living/simple_animal/hostile/pirate_defender/heavy,
	null,null,null,null,null,null,null,null,null,null,null,null
	)

	loot_distributor.loot_list["piratePostDefenders"] = list(\
	/mob/living/simple_animal/hostile/pirate_defender/heavy,/mob/living/simple_animal/hostile/pirate_defender/heavy,/mob/living/simple_animal/hostile/pirate_defender/heavy,
	/mob/living/simple_animal/hostile/pirate_defender/heavy,/mob/living/simple_animal/hostile/pirate_defender/heavy,/mob/living/simple_animal/hostile/pirate_defender/heavy,
	/mob/living/simple_animal/hostile/pirate_defender/heavy,/mob/living/simple_animal/hostile/pirate_defender/heavy,/mob/living/simple_animal/hostile/pirate_defender/heavy,
	/mob/living/simple_animal/hostile/pirate_defender/medium,/mob/living/simple_animal/hostile/pirate_defender/medium,/mob/living/simple_animal/hostile/pirate_defender/medium,
	/mob/living/simple_animal/hostile/pirate_defender/medium,/mob/living/simple_animal/hostile/pirate_defender/medium,/mob/living/simple_animal/hostile/pirate_defender/medium,
	/mob/living/simple_animal/hostile/pirate_defender/medium,/mob/living/simple_animal/hostile/pirate_defender/medium,/mob/living/simple_animal/hostile/pirate_defender/medium,
	/mob/living/simple_animal/hostile/pirate_defender,/mob/living/simple_animal/hostile/pirate_defender,/mob/living/simple_animal/hostile/pirate_defender,
	/mob/living/simple_animal/hostile/pirate_defender,/mob/living/simple_animal/hostile/pirate_defender,/mob/living/simple_animal/hostile/pirate_defender,
	/mob/living/simple_animal/hostile/pirate_defender/civ,/mob/living/simple_animal/hostile/pirate_defender/civ,/mob/living/simple_animal/hostile/pirate_defender/civ,
	null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null
	)

//dummy path so this compiles
/obj/effect/overmap/sector/exo_research

/obj/effect/overmap/sector/geminus_city
/*
/obj/structure/co_ord_console/ks7
	known_locations = list(/obj/effect/overmap/sector/exo_research = "VT9-042",/obj/effect/overmap/sector/geminus_city = "Geminus City Colony")
/obj/effect/loot_marker/ks7unique
	loot_type = "ks7unique"
*/
/obj/effect/loot_marker/covScrap
	loot_type = "covScrapLoot"

/obj/effect/loot_marker/humanScrap
	loot_type = "humanSalvageLoot"

/obj/effect/loot_marker/pirateLoot
	loot_type = "piratePostLoot"

/obj/effect/loot_marker/easyLoot
	loot_type = "easySalvageLoot"

/obj/effect/loot_marker/salvageDefenders
	loot_type = "salvageDefenders"

/obj/effect/loot_marker/pirateDefenders
	loot_type = "piratePostDefenders"



