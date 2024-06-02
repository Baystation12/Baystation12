/datum/map_template/ruin/exoplanet/ejected_datapod
	name = "ejected data capsule"
	id = "ejected_datapod"
	description = "A damaged capsule with some strange contents."
	suffixes = list("ejected_datapod/ejected_datapod.dmm")
	spawn_cost = 0.5
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS
	ruin_tags = RUIN_HUMAN|RUIN_WRECK
	apc_test_exempt_areas = list(
		/area/map_template/ejected_datapod = NO_SCRUBBER|NO_VENT|NO_APC
	)


/datum/map_template/ejected_datapod_contents
	name = "random datapod contents #1 (chem vials)"
	id = "datapod_1"
	mappaths = list("maps/random_ruins/exoplanet_ruins/ejected_datapod/contents_1.dmm")


/datum/map_template/ejected_datapod_contents/type2
	name = "random datapod contents #2 (servers)"
	id = "datapod_2"
	mappaths = list("maps/random_ruins/exoplanet_ruins/ejected_datapod/contents_2.dmm")


/datum/map_template/ejected_datapod_contents/type3
	name = "random datapod contents #2 (spiders)"
	id = "datapod_3"
	mappaths = list("maps/random_ruins/exoplanet_ruins/ejected_datapod/contents_3.dmm")


/obj/landmark/map_load_mark/ejected_datapod
	name = "random datapod contents"
	templates = list(
		/datum/map_template/ejected_datapod_contents,
		/datum/map_template/ejected_datapod_contents/type2,
		/datum/map_template/ejected_datapod_contents/type3
	)


/area/map_template/ejected_datapod
	name = "\improper Ejected Data Capsule"
	icon_state = "blue"
	turfs_airless = TRUE


/obj/item/reagent_containers/glass/beaker/vial/ejected_datapod
	name = "unmarked vial"


/obj/item/reagent_containers/glass/beaker/vial/ejected_datapod/Initialize()
	. = ..()
	desc += "Label is smudged, and there's crusted blood fingerprints on it."
	var/reagent_type = pickweight(list(
		/datum/reagent/random = 50,
		/datum/reagent/rezadone = 25,
		/datum/reagent/drugs/three_eye = 20,
		/datum/reagent/zombie = 5
	))
	reagents.add_reagent(reagent_type, 5)


/obj/structure/backup_server
	name = "backup server"
	icon = 'icons/obj/machines/research/server.dmi'
	icon_state = "server"
	desc = "Impact resistant server rack. You might be able to pry a disk out."

	/// When truthy, the server has already been harvested
	var/drive_removed


/obj/structure/backup_server/use_tool(obj/item/tool, mob/living/user, list/click_params)
	if (!isCrowbar(tool))
		return ..()
	if (drive_removed)
		USE_FEEDBACK_FAILURE("\The [src] has no drive to remove.")
		return TRUE
	drive_removed = TRUE
	var/obj/item/stock_parts/computer/hard_drive/cluster/drive = new
	drive.origin_tech = list(
		TECH_DATA = rand(4, 5),
		TECH_ENGINEERING = rand(4, 5),
		TECH_PHORON = rand(4, 5),
		TECH_COMBAT = rand(2, 5),
		TECH_ESOTERIC = rand(0, 6)
	)
	drive.dropInto(loc)
	playsound(src, 'sound/items/Crowbar.ogg', 50, TRUE)
	user.visible_message(
		SPAN_NOTICE("\The [user] pries a drive from \the [src] with \a [tool]."),
		SPAN_NOTICE("You pry \a [drive] from \the [src] with \a [tool].")
	)
	return TRUE
