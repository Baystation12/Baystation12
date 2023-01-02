/// Every roomotron has a source.
/obj/machinery/roomotron/generator
	name = "bluespace roomotron generator"
	desc = "A segment of a bluespace roomotron. It can generate a beam of bluespace particles."
	icon_state = "generator"
	/// The type of beam generated.
	var/datum/particle_beam/beam_type = /datum/particle_beam


/obj/machinery/roomotron/generator/return_valid_dirs()
	return list(dir)

/// Creates a new beam instance to be shot around the roomotron.
/obj/machinery/roomotron/generator/proc/generate_beam()
	beam = new beam_type(src)
