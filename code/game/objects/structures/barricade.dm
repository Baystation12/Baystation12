//Barricades!
/obj/structure/barricade
	name = "barricade"
	icon_state = "barricade"
	anchored = TRUE
	density = TRUE
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE
	layer = ABOVE_WINDOW_LAYER

	var/spiky = FALSE

/obj/structure/barricade/Initialize(mapload, material_name)
	. = ..(mapload)
	if(!material_name)
		material_name = MATERIAL_WOOD
	material = SSmaterials.get_material_by_name("[material_name]")
	if(!material)
		return INITIALIZE_HINT_QDEL
	SetName("[material.display_name] barricade")
	desc = "A heavy, solid barrier made of [material.display_name]."
	color = material.icon_colour
	set_max_health(round(material.integrity * 1.33)) // Equivalent to a global resistance value of 0.75

/obj/structure/barricade/get_material()
	return material


/obj/structure/barricade/use_tool(obj/item/tool, mob/user, list/click_params)
	// Rods - Make barricade spiky
	if (istype(tool, /obj/item/stack/material/rods))
		if (spiky)
			USE_FEEDBACK_FAILURE("\The [src] already has spikes on it.")
			return TRUE
		var/obj/item/stack/material/rods/rods = tool
		if (!rods.can_use(5))
			USE_FEEDBACK_STACK_NOT_ENOUGH(rods, 5, "to build a cheval de frise.")
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] starts adding some [tool.name] to \the [src]."),
			SPAN_NOTICE("You start adding some [tool.name] to \the [src].")
		)
		if (!user.do_skilled(4 SECONDS, SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		if (spiky)
			USE_FEEDBACK_FAILURE("\The [src] already has spikes on it.")
			return TRUE
		if (!rods.use(5))
			USE_FEEDBACK_STACK_NOT_ENOUGH(rods, 5, "to build a cheval de frise.")
			return TRUE
		var/obj/structure/barricade/spike/CDF = new(loc, material.name, rods.material.name)
		CDF.set_dir(user.dir)
		transfer_fingerprints_to(CDF)
		user.visible_message(
			SPAN_NOTICE("\The [user] adds some [tool.name] to \the [src]."),
			SPAN_NOTICE("You add some [tool.name] to \the [src].")
		)
		qdel_self()
		return TRUE

	// Material Stack - Repair
	if (istype(tool, /obj/item/stack))
		var/obj/item/stack/material/stack = tool
		if (stack.material != material)
			USE_FEEDBACK_FAILURE("\The [tool] is the wrong type of material to repair \the [src].")
			return TRUE
		if (!get_damage_value())
			USE_FEEDBACK_FAILURE("\The [src] doesn't need repairs.")
			return TRUE
		if (!stack.can_use(1))
			USE_FEEDBACK_STACK_NOT_ENOUGH(stack, 1, "to repair \the [src].")
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] starts repairing \the [src] with some [tool.name]."),
			SPAN_NOTICE("You start repairing \the [src] with some [tool.name].")
		)
		if (!user.do_skilled(2 SECONDS, SKILL_CONSTRUCTION, src, do_flags = DO_REPAIR_CONSTRUCT) || !user.use_sanity_check(src, tool))
			return TRUE
		if (!get_damage_value())
			USE_FEEDBACK_FAILURE("\The [src] doesn't need repairs.")
			return TRUE
		if (!stack.use(1))
			USE_FEEDBACK_STACK_NOT_ENOUGH(stack, 1, "to repair \the [src].")
			return TRUE
		revive_health()
		user.visible_message(
			SPAN_NOTICE("\The [user] repairs \the [src] with some [tool.name]."),
			SPAN_NOTICE("You repair \the [src] with some [tool.name].")
		)
		return TRUE

	return ..()


/obj/structure/barricade/on_death()
	dismantle()

/obj/structure/barricade/proc/dismantle()
	visible_message(SPAN_DANGER("The barricade is smashed apart!"))
	material.place_dismantled_product(get_turf(src))
	qdel(src)

/obj/structure/barricade/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)//So bullets will fly over and stuff.
	if(air_group || (height==0))
		return 1
	if(istype(mover) && mover.checkpass(PASS_FLAG_TABLE))
		return 1
	else
		return 0

//spikey barriers
/obj/structure/barricade/spike
	name = "spiked barricade"
	icon_state = "cheval"
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE
	spiky = TRUE

	var/spike_overlay = "cheval_spikes"
	var/material/rod_material
	var/damage //how badly it smarts when you run into this like a rube
	var/list/poke_description = list("gored", "spiked", "speared", "stuck", "stabbed")

/obj/structure/barricade/spike/Initialize(mapload, material_name, rod_material_name)
	. = ..(mapload, material_name)
	if(!rod_material_name)
		rod_material_name = MATERIAL_WOOD
	rod_material = SSmaterials.get_material_by_name("[rod_material_name]")
	SetName("spiked barricade")
	desc = "A rather simple [material.display_name] spiked barricade, also known as a cheval-de-frise. It menaces with spikes of [rod_material.display_name] which look like they would hurt to walk in to."
	damage = (rod_material.hardness * 0.85)
	AddOverlays(overlay_image(icon, spike_overlay, color = rod_material.icon_colour, flags = RESET_COLOR))

/obj/structure/barricade/spike/Bumped(mob/living/victim)
	. = ..()
	if(!isliving(victim))
		return
	if(world.time - victim.last_bumped <= 15) //spam guard
		return FALSE
	victim.last_bumped = world.time
	var/damage_holder = damage
	var/target_zone = pick(BP_CHEST, BP_GROIN, BP_L_LEG, BP_R_LEG)

	if(MOVING_DELIBERATELY(victim)) //creeping into this is less hurty than walking
		damage_holder = (damage / 4)

	if(isanimal(victim)) //simple animals have simple health, reduce our damage
		damage_holder = (damage / 4)

	victim.apply_damage(damage_holder, DAMAGE_BRUTE, target_zone, damage_flags = DAMAGE_FLAG_SHARP, used_weapon = src)
	visible_message(SPAN_DANGER("\The [victim] is [pick(poke_description)] by \the [src]!"))
