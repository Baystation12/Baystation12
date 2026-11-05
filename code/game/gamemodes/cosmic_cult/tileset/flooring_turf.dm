/turf/simulated/floor/cosmic_cult
	icon = 'icons/coscult/tiles.dmi'

/turf/simulated/floor/cosmic_cult/glyph
	name = "malign glyphic surface"
	icon_state = "glyph"
	initial_flooring = /singleton/flooring/cosmic_cult/glyph

/turf/simulated/floor/cosmic_cult/smooth
	name = "malign smooth surface"
	icon_state = "smooth"
	initial_flooring = /singleton/flooring/cosmic_cult/smooth

/turf/simulated/floor/cosmic_cult/half
	name = "malign half-pattern surface"
	icon_state = "half"
	initial_flooring = /singleton/flooring/cosmic_cult/half

/turf/simulated/floor/cosmic_cult/split
	name = "malign split-pattern surface"
	icon_state = "split"
	initial_flooring = /singleton/flooring/cosmic_cult/split

/turf/simulated/floor/cosmic_cult/notched
	name = "malign notch-pattern surface"
	icon_state = "notch"
	initial_flooring = /singleton/flooring/cosmic_cult/notch

/turf/simulated/floor/cosmic_cult/malign
	name = "malign surface"
	icon_state = "malign0"
	initial_flooring = /singleton/flooring/cosmic_cult/malign

/turf/simulated/floor/cosmic_cult/rough
	name = "rough malign surface"
	icon_state = "rough"
	initial_flooring = /singleton/flooring/cosmic_cult/rough

/turf/simulated/floor/cosmic_cult/void
	name = "void floor surface"
	icon_state = "void"
	initial_flooring = /singleton/flooring/cosmic_cult/void
	z_flags = ZM_MIMIC_DEFAULTS

/turf/simulated/floor/cosmic_cult/decay
	name = "decaying malign surface"
	icon = 'icons/coscult/cosmicfloor-decay.dmi'
	icon_state = "full"
	initial_flooring = /singleton/flooring/cosmic_cult/decay
	z_flags = ZM_MIMIC_DEFAULTS

/turf/simulated/floor/cosmic_cult/decay/on_update_icon()
	. = ..()

	ClearOverlays()

	icon_state = "blank"

	var/list/dirs = list()

	for(var/stepdir in GLOB.alldirs)
		var/turf/simulated/floor/cosmic_cult/decay/T = get_step(src, stepdir)
		if(istype(T))
			dirs += get_dir(src, T)
	var/list/connections = dirs_to_corner_states(dirs)

	for(var/i = 1 to 4)
		var/I = image(icon, "floor[connections[i]]", dir = SHIFTL(1, i - 1))
		AddOverlays(I)
