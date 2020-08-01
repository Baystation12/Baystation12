
/area/exo_ice_facility/interior/salvage_cov
	name = "KS7 - Covenant Salvage, Left"

/area/exo_ice_facility/interior/salvage_cov2
	name = "KS7 - Covenant Salvage, Middle"

/area/exo_ice_facility/interior/salvage_unsc
	name = "KS7 - UNSC Salvage"

/obj/machinery/door/airlock/covenant/covScrap

/obj/machinery/door/airlock/humanScrap

/obj/item/weapon/card/id/building_key/pirateVault //"PV"
	name = "Key (Vault)"
	access = list(8086)

/obj/machinery/door/airlock/pirate_vault
	name = "Armory Door"
	secured_wires = 1
	req_access = list(8086)


/obj/structure/closet/secure_closet/ks7_unsc
	name = "Crewman - Envoy Armour"
	desc = "Armour worn by personnel acting as diplomatic envoys to far-flung colonies. Often, no other armour is present on these vessels to reduce insurrectionist ability to frame the unsc."
	icon = 'icons/obj/guncabinet.dmi'
	icon_broken = "closed_full"
	icon_closed = "closed_full"
	icon_locked = "closed_full"
	icon_off = "closed_full"
	icon_opened = "open_full"
	icon_state = "closed_full"

/obj/structure/closet/secure_closet/ks7_unsc/WillContain()
	return list(\
	/obj/item/clothing/head/helmet/crewman,
	/obj/item/clothing/suit/storage/marine/crewman,
	/obj/item/clothing/shoes/marine/crewman,
	/obj/item/clothing/gloves/thick/unsc/crewman,
	/obj/item/weapon/storage/belt/marine_ammo,
	/obj/item/weapon/gun/projectile/m6d_magnum,
	/obj/item/weapon/gun/projectile/m7_smg,
	/obj/item/weapon/storage/backpack/marine
	)

/obj/structure/closet/secure_closet/ks7_unsc/ammo
	name = "Crewman - Ammunition"
	desc = "Ammunition for weapons provided as part of a crewman's self-defense kit"
	icon = 'icons/obj/closet.dmi'
	icon_broken = "hossecurebroken"
	icon_closed = "hossecure"
	icon_locked = "hossecure1"
	icon_off = "hossecureoff"
	icon_opened = "hossecureopen"
	icon_state = "hossecure1"

/obj/structure/closet/secure_closet/ks7_unsc/ammo/WillContain()
	return list(\
	/obj/item/ammo_magazine/m5,/obj/item/ammo_magazine/m5,/obj/item/ammo_magazine/m5,
	/obj/item/ammo_magazine/m5,/obj/item/ammo_magazine/m5,/obj/item/ammo_magazine/m5,
	/obj/item/ammo_magazine/m5,/obj/item/ammo_magazine/m5,/obj/item/ammo_magazine/m5,
	/obj/item/ammo_magazine/m5,/obj/item/ammo_magazine/m5,/obj/item/ammo_magazine/m5,
	/obj/item/ammo_magazine/m127_saphe,/obj/item/ammo_magazine/m127_saphe,/obj/item/ammo_magazine/m127_saphe,
	/obj/item/ammo_magazine/m127_saphe,/obj/item/ammo_magazine/m127_saphe,/obj/item/ammo_magazine/m127_saphe,
	/obj/item/ammo_magazine/m127_saphe,/obj/item/ammo_magazine/m127_saphe,/obj/item/ammo_magazine/m127_saphe,
	/obj/item/ammo_magazine/m127_saphe,/obj/item/ammo_magazine/m127_saphe,/obj/item/ammo_magazine/m127_saphe,
	)

/obj/structure/closet/secure_closet/ks7_innie
	name = "Insurrectionist Salvaged Gear"
	desc = "Gear salvaged from a lightly-armed unsc wreck. Looks like it was for unsc crewmen."
	icon = 'icons/obj/guncabinet.dmi'
	icon_broken = "closed_full"
	icon_closed = "closed_full"
	icon_locked = "closed_full"
	icon_off = "closed_full"
	icon_opened = "open_full"
	icon_state = "closed_full"

/obj/structure/closet/secure_closet/ks7_innie/WillContain()
	return list(\
	/obj/item/clothing/head/helmet/crewman,
	/obj/item/clothing/suit/storage/marine/crewman,
	/obj/item/clothing/shoes/marine/crewman,
	/obj/item/clothing/gloves/thick/unsc/crewman,
	/obj/item/weapon/storage/belt/marine_ammo,
	/obj/item/weapon/gun/projectile/m6d_magnum,
	/obj/item/weapon/gun/projectile/m7_smg,
	/obj/item/weapon/storage/backpack/marine
	)

/obj/structure/closet/secure_closet/ks7_innie/ammo
	name = "Insurrectionist Salvaged Ammunition"
	desc = "Ammo salvaged from a lightly-armed unsc wreck."
	icon = 'icons/obj/closet.dmi'
	icon_broken = "hossecurebroken"
	icon_closed = "hossecure"
	icon_locked = "hossecure1"
	icon_off = "hossecureoff"
	icon_opened = "hossecureopen"
	icon_state = "hossecure1"

/obj/structure/closet/secure_closet/ks7_innie/ammo/WillContain()
	return list(\
	/obj/item/ammo_magazine/m5,/obj/item/ammo_magazine/m5,/obj/item/ammo_magazine/m5,
	/obj/item/ammo_magazine/m5,/obj/item/ammo_magazine/m5,/obj/item/ammo_magazine/m5,
	/obj/item/ammo_magazine/m5,/obj/item/ammo_magazine/m5,/obj/item/ammo_magazine/m5,
	/obj/item/ammo_magazine/m5,/obj/item/ammo_magazine/m5,/obj/item/ammo_magazine/m5,
	/obj/item/ammo_magazine/m127_saphe,/obj/item/ammo_magazine/m127_saphe,/obj/item/ammo_magazine/m127_saphe,
	/obj/item/ammo_magazine/m127_saphe,/obj/item/ammo_magazine/m127_saphe,/obj/item/ammo_magazine/m127_saphe,
	/obj/item/ammo_magazine/m127_saphe,/obj/item/ammo_magazine/m127_saphe,/obj/item/ammo_magazine/m127_saphe,
	/obj/item/ammo_magazine/m127_saphe,/obj/item/ammo_magazine/m127_saphe,/obj/item/ammo_magazine/m127_saphe,
	)

//KS7 OM OBJ OVERRIDE//
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


