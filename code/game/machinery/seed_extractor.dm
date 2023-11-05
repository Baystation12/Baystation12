/obj/machinery/seed_extractor
	name = "seed extractor"
	desc = "Extracts and bags seeds from produce."
	icon = 'icons/obj/machines/hydroponics_machines.dmi'
	icon_state = "sextractor"
	density = TRUE
	anchored = TRUE
	use_power = POWER_USE_ACTIVE
	idle_power_usage = 10
	active_power_usage = 2000
	construct_state = /singleton/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	machine_name = "seed extractor"
	machine_desc = "Extracts a number of growable seed packets from a provided plant sample. The sample is destroyed in the process."

/obj/machinery/seed_extractor/use_tool(obj/item/O, mob/living/user, list/click_params)
	if ((. = ..()))
		return
	// Fruits and vegetables.
	if(istype(O, /obj/item/reagent_containers/food/snacks/grown))
		if(!user.unEquip(O))
			return TRUE

		var/obj/item/reagent_containers/food/snacks/grown/F = O
		var/datum/seed/new_seed_type = SSplants.seeds[F.plantname]

		if(new_seed_type)
			to_chat(user, SPAN_NOTICE("You extract some seeds from [O]."))
			var/produce = rand(1,4)
			for(var/i = 0;i<=produce;i++)
				var/obj/item/seeds/seeds = new(get_turf(src))
				seeds.seed_type = new_seed_type.name
				seeds.update_seed()
		else
			to_chat(user, "[O] doesn't seem to have any usable seeds inside it.")

		qdel(O)
		return TRUE

	//Grass.
	if (istype(O, /obj/item/stack/tile/grass))
		var/obj/item/stack/tile/grass/S = O
		if (S.use(1))
			to_chat(user, SPAN_NOTICE("You extract some seeds from the grass tile."))
			new /obj/item/seeds/grassseed(loc)
		return TRUE

	if (istype(O, /obj/item/fossil/plant)) // Fossils
		var/obj/item/seeds/random/R = new(get_turf(src))
		to_chat(user, "\The [src] scans \the [O] and spits out \a [R].")
		qdel(O)
		return TRUE
