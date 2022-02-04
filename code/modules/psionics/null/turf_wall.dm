/turf/simulated/wall/disrupts_psionics()
	return ((material && material.is_psi_null()) || (reinf_material && reinf_material.is_psi_null())) ? src : ..()

/turf/simulated/wall/withstand_psi_stress(var/stress, var/atom/source)
	. = ..(stress, source)
	if(. > 0 && disrupts_psionics())
		var/cap = material.integrity
		if(reinf_material) cap += reinf_material.integrity
		var/stress_total = get_damage_value() + .
		damage_health(.)
		. = max(0, -(cap-stress_total))

/turf/simulated/wall/nullglass
	color = COLOR_NULLGLASS

/turf/simulated/wall/nullglass/Initialize(ml)
	..(ml, MATERIAL_NULLGLASS)
