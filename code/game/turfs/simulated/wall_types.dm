//Commonly used
/turf/simulated/wall/prepainted
	paint_color = COLOR_GUNMETAL

/turf/simulated/wall/r_wall/prepainted
	paint_color = COLOR_GUNMETAL

/turf/simulated/wall/r_wall
	icon_state = "r_generic"

/turf/simulated/wall/r_wall/New(newloc)
	..(newloc, MATERIAL_STEEL,MATERIAL_PLASTEEL) //3strong

/turf/simulated/wall/r_wall/hull
	name = "hull"
	color = COLOR_SOL

/turf/simulated/wall/r_wall/hull/vox
	initial_gas = list("nitrogen" = 101.38)
	color = COLOR_GREEN_GRAY

/turf/simulated/wall/prepainted
	paint_color = COLOR_WALL_GUNMETAL
/turf/simulated/wall/r_wall/prepainted
	paint_color = COLOR_WALL_GUNMETAL

/turf/simulated/wall/r_wall/hull/Initialize()
	. = ..()
	paint_color = color
	color = null //color is just for mapping
	if(prob(40))
		var/spacefacing = FALSE
		for(var/direction in GLOB.cardinal)
			var/turf/T = get_step(src, direction)
			var/area/A = get_area(T)
			if(A && (A.area_flags & AREA_FLAG_EXTERNAL))
				spacefacing = TRUE
				break
		if(spacefacing)
			var/bleach_factor = rand(10,50)
			paint_color = adjust_brightness(paint_color, bleach_factor)
	update_icon()

/turf/simulated/wall/titanium
	icon_state = "titanium"

/turf/simulated/wall/titanium/New(newloc)
	..(newloc,MATERIAL_TITANIUM)

/turf/simulated/wall/r_titanium
	icon_state = "r_titanium"

/turf/simulated/wall/r_titanium/New(newloc)
	..(newloc, MATERIAL_TITANIUM,MATERIAL_TITANIUM)

/turf/simulated/wall/ocp_wall
	icon_state = "r_ocp"

/turf/simulated/wall/ocp_wall/New(newloc)
	..(newloc, MATERIAL_OSMIUM_CARBIDE_PLASTEEL, MATERIAL_OSMIUM_CARBIDE_PLASTEEL)

//Material walls

/turf/simulated/wall/r_wall/rglass_wall/New(newloc)
	..(newloc, MATERIAL_GLASS, MATERIAL_STEEL)
	icon_state = "r_generic"

/turf/simulated/wall/iron/New(newloc)
	..(newloc,MATERIAL_IRON)

/turf/simulated/wall/uranium/New(newloc)
	..(newloc,MATERIAL_URANIUM)

/turf/simulated/wall/diamond/New(newloc)
	..(newloc,MATERIAL_DIAMOND)

/turf/simulated/wall/gold/New(newloc)
	..(newloc,MATERIAL_GOLD)

/turf/simulated/wall/silver/New(newloc)
	..(newloc,MATERIAL_SILVER)

/turf/simulated/wall/phoron/New(newloc)
	..(newloc,MATERIAL_PHORON)

/turf/simulated/wall/sandstone/New(newloc)
	..(newloc,MATERIAL_SANDSTONE)

/turf/simulated/wall/rutile/New(newloc)
	..(newloc,MATERIAL_RUTILE)

/turf/simulated/wall/wood
	blend_turfs = list(/turf/simulated/wall/cult, /turf/simulated/wall)
	icon_state = "woodneric"

/turf/simulated/wall/wood/New(newloc)
	..(newloc,MATERIAL_WOOD)

/turf/simulated/wall/mahogany
	blend_turfs = list(/turf/simulated/wall/cult, /turf/simulated/wall)
	icon_state = "woodneric"

/turf/simulated/wall/mahogany/New(newloc)
	..(newloc,MATERIAL_MAHOGANY)

/turf/simulated/wall/maple
	blend_turfs = list(/turf/simulated/wall/cult, /turf/simulated/wall)
	icon_state = "woodneric"

/turf/simulated/wall/maple/New(newloc)
	..(newloc,MATERIAL_MAPLE)

/turf/simulated/wall/ebony
	blend_turfs = list(/turf/simulated/wall/cult, /turf/simulated/wall)
	icon_state = "woodneric"

/turf/simulated/wall/ebony/New(newloc)
	..(newloc,MATERIAL_EBONY)

/turf/simulated/wall/walnut
	blend_turfs = list(/turf/simulated/wall/cult, /turf/simulated/wall)
	icon_state = "woodneric"

/turf/simulated/wall/walnut/New(newloc)
	..(newloc,MATERIAL_WALNUT)

/turf/simulated/wall/ironphoron/New(newloc)
	..(newloc,MATERIAL_IRON,MATERIAL_PHORON)

/turf/simulated/wall/golddiamond/New(newloc)
	..(newloc,MATERIAL_GOLD,MATERIAL_DIAMOND)

/turf/simulated/wall/silvergold/New(newloc)
	..(newloc,MATERIAL_SILVER,MATERIAL_GOLD)

/turf/simulated/wall/sandstone/diamond/New(newloc)
	..(newloc,MATERIAL_SANDSTONE,MATERIAL_DIAMOND)

/turf/simulated/wall/crystal/New(newloc)
	..(newloc,MATERIAL_CRYSTAL)

/turf/simulated/wall/voxshuttle
	atom_flags = ATOM_FLAG_NO_TOOLS

/turf/simulated/wall/voxshuttle/New(newloc)
	..(newloc, MATERIAL_VOX)

/turf/simulated/wall/growth/New(newloc)
	..(newloc, MATERIAL_GROWTH)

/turf/simulated/wall/concrete/New(newloc)
	..(newloc,MATERIAL_CONCRETE)

//Alien metal walls
/turf/simulated/wall/alium
	icon_state = "jaggy"
	floor_type = /turf/simulated/floor/fixed/alium
	blend_objects = newlist()

/turf/simulated/wall/alium/New(newloc)
	..(newloc,MATERIAL_ALIENALLOY)

//Cult wall
/turf/simulated/wall/cult
	icon_state = "cult"
	blend_turfs = list(/turf/simulated/wall)

/turf/simulated/wall/cult/New(newloc, reinforce = 0)
	..(newloc, MATERIAL_CULT, reinforce ? MATERIAL_REINFORCED_CULT : null)

/turf/simulated/wall/cult/reinf/New(newloc)
	..(newloc, 1)

/turf/simulated/wall/cult/dismantle_wall()
	GLOB.cult.remove_cultiness(CULTINESS_PER_TURF)
	..()

/turf/simulated/wall/cult/can_join_with(turf/simulated/wall/W)
	if(material && W.material && material.wall_icon_base == W.material.wall_icon_base)
		return 1
	else if(istype(W, /turf/simulated/wall))
		return 1
	return 0
