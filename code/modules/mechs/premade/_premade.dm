//GLOBAL_LIST_INIT(mech_decals, (icon_states('icons/mecha/mech_decals.dmi')-list("template", "mask")))

/mob/living/exosuit/premade
	name = "impossible exosuit"
	desc = "It seems to be saying 'please let me die'."
	var/decal

/mob/living/exosuit/premade/Initialize()
	if(arms)
		arms.decal = decal
		arms.prebuild()
	if(legs)
		legs.decal = decal
		legs.prebuild()
	if(head)
		head.decal = decal
		head.prebuild()
	if(body)
		body.decal = decal
		body.prebuild()
	if(!material)
		material = SSmaterials.get_material_by_name(MATERIAL_STEEL)
	. = ..()

	spawn_mech_equipment()

/mob/living/exosuit/premade/proc/spawn_mech_equipment()
	set waitfor = FALSE
	install_system(new /obj/item/mech_equipment/light(src), HARDPOINT_HEAD)

/mob/living/exosuit/premade/random
	name = "mismatched exosuit"
	desc = "It seems to have been roughly thrown together and then spraypainted a single colour."

/mob/living/exosuit/premade/random/Initialize(mapload, var/obj/structure/heavy_vehicle_frame/source_frame, var/super_random = FALSE, var/using_boring_colours = FALSE)
	//if(!prob(100/(LAZYLEN(GLOB.mech_decals)+1)))
	//	decal = pick(GLOB.mech_decals)

	var/list/use_colours
	if(using_boring_colours)
		use_colours = list(
			COLOR_DARK_GRAY,
			COLOR_GRAY40,
			COLOR_DARK_BROWN,
			COLOR_GRAY,
			COLOR_RED_GRAY,
			COLOR_BROWN,
			COLOR_GREEN_GRAY,
			COLOR_BLUE_GRAY,
			COLOR_PURPLE_GRAY,
			COLOR_BEIGE,
			COLOR_PALE_GREEN_GRAY,
			COLOR_PALE_RED_GRAY,
			COLOR_PALE_PURPLE_GRAY,
			COLOR_PALE_BLUE_GRAY,
			COLOR_SILVER,
			COLOR_GRAY80,
			COLOR_OFF_WHITE,
			COLOR_GUNMETAL,
			COLOR_SOL,
			COLOR_TITANIUM,
			COLOR_DARK_GUNMETAL,
			COLOR_BRONZE,
			COLOR_BRASS
		)
	else
		use_colours = list(
			COLOR_NAVY_BLUE,
			COLOR_GREEN,
			COLOR_DARK_GRAY,
			COLOR_MAROON,
			COLOR_PURPLE,
			COLOR_VIOLET,
			COLOR_OLIVE,
			COLOR_BROWN_ORANGE,
			COLOR_DARK_ORANGE,
			COLOR_GRAY40,
			COLOR_SEDONA,
			COLOR_DARK_BROWN,
			COLOR_BLUE,
			COLOR_DEEP_SKY_BLUE,
			COLOR_LIME,
			COLOR_CYAN,
			COLOR_TEAL,
			COLOR_RED,
			COLOR_PINK,
			COLOR_ORANGE,
			COLOR_YELLOW,
			COLOR_GRAY,
			COLOR_RED_GRAY,
			COLOR_BROWN,
			COLOR_GREEN_GRAY,
			COLOR_BLUE_GRAY,
			COLOR_SUN,
			COLOR_PURPLE_GRAY,
			COLOR_BLUE_LIGHT,
			COLOR_RED_LIGHT,
			COLOR_BEIGE,
			COLOR_PALE_GREEN_GRAY,
			COLOR_PALE_RED_GRAY,
			COLOR_PALE_PURPLE_GRAY,
			COLOR_PALE_BLUE_GRAY,
			COLOR_LUMINOL,
			COLOR_SILVER,
			COLOR_GRAY80,
			COLOR_OFF_WHITE,
			COLOR_NT_RED,
			COLOR_BOTTLE_GREEN,
			COLOR_PALE_BTL_GREEN,
			COLOR_GUNMETAL,
			COLOR_MUZZLE_FLASH,
			COLOR_CHESTNUT,
			COLOR_BEASTY_BROWN,
			COLOR_WHEAT,
			COLOR_CYAN_BLUE,
			COLOR_LIGHT_CYAN,
			COLOR_PAKISTAN_GREEN,
			COLOR_SOL,
			COLOR_AMBER,
			COLOR_COMMAND_BLUE,
			COLOR_SKY_BLUE,
			COLOR_PALE_ORANGE,
			COLOR_CIVIE_GREEN,
			COLOR_TITANIUM,
			COLOR_DARK_GUNMETAL,
			COLOR_BRONZE,
			COLOR_BRASS,
			COLOR_INDIGO
		)

	var/mech_colour = super_random ? FALSE : pick(use_colours)
	if(!arms)
		var/armstype = pick(typesof(/obj/item/mech_component/manipulators)-/obj/item/mech_component/manipulators)
		arms = new armstype(src)
		arms.color = mech_colour ? mech_colour : pick(use_colours)
	if(!legs)
		var/legstype = pick(typesof(/obj/item/mech_component/propulsion)-/obj/item/mech_component/propulsion)
		legs = new legstype(src)
		legs.color = mech_colour ? mech_colour : pick(use_colours)
	if(!head)
		var/headtype = pick(typesof(/obj/item/mech_component/sensors)-/obj/item/mech_component/sensors)
		head = new headtype(src)
		head.color = mech_colour ? mech_colour : pick(use_colours)
	if(!body)
		var/bodytype = pick(typesof(/obj/item/mech_component/chassis)-/obj/item/mech_component/chassis)
		body = new bodytype(src)
		body.color = mech_colour ? mech_colour : pick(use_colours)
	. = ..()

// Used for spawning/debugging.
/mob/living/exosuit/premade/random/normal

/mob/living/exosuit/premade/random/boring/Initialize(mapload, var/obj/structure/heavy_vehicle_frame/source_frame)
	..(mapload, source_frame, using_boring_colours = TRUE)

/mob/living/exosuit/premade/random/extra/Initialize(mapload, var/obj/structure/heavy_vehicle_frame/source_frame)
	..(mapload, source_frame, super_random = TRUE)
