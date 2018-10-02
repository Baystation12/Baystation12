
/obj/item/projectile/overmap/flood_pod
	name = "Spores"
	desc = "A fleshy pod surrounded by spores."
	icon = 'code/modules/halo/overmap/overmap_projectiles/flood_overmap_proj.dmi'
	icon_state = "spores"

	ship_damage_projectile = /obj/item/projectile/flood_pod_onmap

/obj/item/projectile/overmap/flood_pod/sector_hit_effects(var/z_level,var/obj/effect/overmap/hit,var/list/hit_bounds)
	var/turf/turf_to_hit = locate(rand(hit_bounds[1],hit_bounds[3]),rand(hit_bounds[2],hit_bounds[4]),z_level)
	new /obj/structure/biomass/medium (turf_to_hit)

/obj/item/projectile/flood_pod_onmap
	damage = 0
	penetrating = 4
	invisibility = 101

/obj/item/projectile/flood_pod_onmap/on_impact(var/atom/impacted)
	var/type_to_spawn = pick(list(/obj/structure/biomass/medium,/obj/structure/biomass))//No sprites for large, so let's not spawn them.//,/obj/structure/biomass/large))
	var/obj/spawned = new type_to_spawn (loc)
	spawned.loc = impacted.loc
	qdel(src)
	return 1