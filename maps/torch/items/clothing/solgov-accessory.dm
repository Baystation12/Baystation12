/obj/item/clothing/accessory/solgov
	name = "master solgov accessory"
	icon = 'maps/torch/icons/obj/obj_accessories_solgov.dmi'
	accessory_icons = list(slot_w_uniform_str = 'maps/torch/icons/mob/onmob_accessories_solgov.dmi', slot_wear_suit_str = 'maps/torch/icons/mob/onmob_accessories_solgov.dmi')

/*****
medals
*****/
/obj/item/clothing/accessory/medal/solgov
	name = "master solgov medal"
	desc = "You shouldn't be seeing this."
	icon = 'maps/torch/icons/obj/obj_accessories_solgov.dmi'
	accessory_icons = list(slot_w_uniform_str = 'maps/torch/icons/mob/onmob_accessories_solgov.dmi', slot_wear_suit_str = 'maps/torch/icons/mob/onmob_accessories_solgov.dmi')

/obj/item/clothing/accessory/medal/solgov/iron/star
	name = "iron star medal"
	desc = "An iron star awarded to members of the SCG for meritorious achievement or service in a combat zone."
	icon_state = "iron_star"

/obj/item/clothing/accessory/medal/solgov/iron/sol
	name = "\improper Sol expeditionary medal"
	desc = "An iron medal awarded to members of the SCG for service outside of the borders of the Sol Central Government."
	icon_state = "iron_sol"

/obj/item/clothing/accessory/medal/solgov/bronze/heart
	name = "bronze heart medal"
	desc = "A bronze heart awarded to members of the SCG for injury or death in the line of duty."
	icon_state = "bronze_heart"

/obj/item/clothing/accessory/medal/solgov/bronze/sol
	name = "\improper Sol defensive operations medal"
	desc = "A bronze medal awarded for members of the SCG for service defending the border regions."
	icon_state = "bronze_sol"

/obj/item/clothing/accessory/medal/solgov/silver/sword
	name = "combat action medal"
	desc = "A silver medal awarded to members of the SCG for honorable service while under enemy fire."
	icon_state = "silver_sword"

/obj/item/clothing/accessory/medal/solgov/silver/sol
	name = "\improper Sol valor medal"
	desc = "A silver medal awarded for members of the SCG for acts of exceptional valor."
	icon_state = "silver_sol"

/obj/item/clothing/accessory/medal/solgov/gold/star
	name = "gold star medal"
	desc = "A gold star awarded to members of the SCG for acts of heroism in a combat zone."
	icon_state = "gold_star"

/obj/item/clothing/accessory/medal/solgov/gold/sun
	name = "solar service medal"
	desc = "A gold medal awarded to members of the SCG by the Secretary General for significant contributions to the Sol Central Government."
	icon_state = "gold_sun"

/obj/item/clothing/accessory/medal/solgov/gold/crest
	name = "solar honor medal"
	desc = "A gold medal awarded to members of the Defense Forces by the Secretary General for personal acts of valor and heroism above and beyond the call of duty."
	icon_state = "gold_crest"

/obj/item/clothing/accessory/medal/solgov/gold/sol
	name = "\improper Sol sapientarian medal"
	desc = "A gold medal awarded for members of the SCG for significant contributions to sapient rights."
	icon_state = "gold_sol"

/obj/item/clothing/accessory/medal/solgov/heart
	name = "medical medal"
	desc = "A white heart emblazoned with a red cross awarded to members of the SCG for service as a medical professional in a combat zone."
	icon_state = "white_heart"

/obj/item/clothing/accessory/solgov/torch_patch
	name = "\improper mission patch"
	desc = "A Patch given to all personnel from the fleet working on the Sandros Mission. Worn on the left sleeve of your utility uniform."
	icon_state = "torchpatch"
	on_rolled = list("down" = "none")
	slot = ACCESSORY_SLOT_INSIGNIA
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_accessories_sol_unathi.dmi'
		)
/*
/obj/item/clothing/accessory/solgov/ec_patch
	name = "\improper Observatory patch"
	desc = "A laminated shoulder patch, carrying the symbol of the Sol Central Government Expeditionary Corpss Observatory, or SCGEO for short, the eyes and ears of the Expeditionary Corps' missions."
	icon_state = "ecpatch1"
	on_rolled = list("down" = "none")
	slot = ACCESSORY_SLOT_INSIGNIA

/obj/item/clothing/accessory/solgov/ec_patch/fieldops
	name = "\improper Field Operations patch"
	desc = "A radiation-shielded shoulder patch, carrying the symbol of the Sol Central Government Expeditionary Corps Field Operations, or SCGECFO for short, the hands-on workers of every Expeditionary Corps mission."
	icon_state = "ecpatch2"
*/
/obj/item/clothing/accessory/solgov/fleet_patch
	name = "\improper TF73 patch"
	desc = "A Patch denoting service in Task Force 73, famous for their bulwark to defend human colonies during the First Contact War."
	icon_state = "fleetpatch1"
	on_rolled = list("down" = "none")
	slot = ACCESSORY_SLOT_INSIGNIA

/obj/item/clothing/accessory/solgov/fleet_patch/second
	name = "\improper 11th AC Patch"
	desc = "A Patch denoting service in the 11th Assault Corps, primarily known for their ground assault training."
	icon_state = "fleetpatch2"

/obj/item/clothing/accessory/solgov/fleet_patch/third
	name = "\improper 1st SF Patch"
	desc = "A Patch denoting service in the 1st Surveyor Fleet. Famed for their explorations and science personnel, and for their advancement of technology and requisitions fields."
	icon_state = "fleetpatch3"

/obj/item/clothing/accessory/solgov/fleet_patch/fourth
	name = "\improper 214th SOG Patch"
	desc = "A Patch denoting service in the 214th Special Operations Group. Famed for their hit-and-run tactics behind enemy lines, Force Recon tactics, and defensive holds."
	icon_state = "fleetpatch4"

/obj/item/clothing/accessory/solgov/fleet_patch/fifth
	name = "\improper Lucky 7th Patch"
	desc = "A Patch denoting service in the ''Lucky'' 7th Fleet. Famed for their spearhead into enemy lines during the First Contact War. The best that Humanity has to offer."
	icon_state = "fleetpatch5"

/******
ribbons
******/
/obj/item/clothing/accessory/ribbon/solgov
	name = "ribbon"
	desc = "A simple military decoration."
	icon_state = "ribbon_marksman"
	on_rolled = list("down" = "none")
	slot = ACCESSORY_SLOT_MEDAL
	icon = 'maps/torch/icons/obj/obj_accessories_solgov.dmi'
	accessory_icons = list(slot_w_uniform_str = 'maps/torch/icons/mob/onmob_accessories_solgov.dmi', slot_wear_suit_str = 'maps/torch/icons/mob/onmob_accessories_solgov.dmi')

/obj/item/clothing/accessory/ribbon/solgov/marksman
	name = "marksmanship ribbon"
	desc = "A military decoration awarded to members of the TDF for good marksmanship scores in training. Common in the days of energy weapons."
	icon_state = "ribbon_marksman"

/obj/item/clothing/accessory/ribbon/solgov/peace
	name = "peacekeeping ribbon"
	desc = "A military decoration awarded to members of the TDF for service during a peacekeeping operation."
	icon_state = "ribbon_peace"

/obj/item/clothing/accessory/ribbon/solgov/frontier
	name = "frontier ribbon"
	desc = "A military decoration awarded to members of the TDF for service along the frontier."
	icon_state = "ribbon_frontier"

/obj/item/clothing/accessory/ribbon/solgov/instructor
	name = "instructor ribbon"
	desc = "A military decoration awarded to members of the TDF for service as an instructor."
	icon_state = "ribbon_instructor"

/*************
specialty pins
*************/
/obj/item/clothing/accessory/solgov/specialty
	name = "speciality blaze"
	desc = "A color blaze denoting fleet personnel in some special role. This one is silver."
	icon_state = "marinerank_command"
	slot = ACCESSORY_SLOT_INSIGNIA

/obj/item/clothing/accessory/solgov/specialty/get_fibers()
	return null

/obj/item/clothing/accessory/solgov/specialty/janitor
	name = "custodial blazes"
	desc = "Purple blazes denoting a custodial technician."
	icon_state = "fleetspec_janitor"

/obj/item/clothing/accessory/solgov/specialty/brig
	name = "brig blazes"
	desc = "Red blazes denoting a brig officer."
	icon_state = "fleetspec_brig"

/obj/item/clothing/accessory/solgov/specialty/forensic
	name = "forensics blazes"
	desc = "Steel blazes denoting a forensic technician."
	icon_state = "fleetspec_forensic"

/obj/item/clothing/accessory/solgov/specialty/atmos
	name = "atmospherics blazes"
	desc = "Turquoise blazes denoting an atmospheric technician."
	icon_state = "fleetspec_atmos"

/obj/item/clothing/accessory/solgov/specialty/counselor
	name = "counselor blazes"
	desc = "Blue blazes denoting a counselor."
	icon_state = "fleetspec_counselor"

/obj/item/clothing/accessory/solgov/specialty/chemist
	name = "chemistry blazes"
	desc = "Orange blazes denoting a chemist."
	icon_state = "fleetspec_chemist"

/obj/item/clothing/accessory/solgov/specialty/enlisted
	name = "enlisted qualification pin"
	desc = "An iron pin denoting some special qualification."
	icon_state = "fleetpin_enlisted"

/obj/item/clothing/accessory/solgov/specialty/officer
	name = "officer's qualification pin"
	desc = "A golden pin denoting some special qualification."
	icon_state = "fleetpin_officer"

/obj/item/clothing/accessory/solgov/specialty/pilot
	name = "pilot's qualification pin"
	desc = "An iron pin denoting the qualification to fly SCG spacecraft."
	icon_state = "pin_pilot"

/*****
badges
*****/
/obj/item/clothing/accessory/badge/solgov
	name = "master solgov badge"
	icon = 'maps/torch/icons/obj/obj_accessories_solgov.dmi'
	accessory_icons = list(slot_w_uniform_str = 'maps/torch/icons/mob/onmob_accessories_solgov.dmi', slot_wear_suit_str = 'maps/torch/icons/mob/onmob_accessories_solgov.dmi')

/obj/item/clothing/accessory/badge/solgov/security
	name = "security forces badge"
	desc = "A silver law enforcement badge. Stamped with the words 'Master at Arms'."
	icon_state = "silverbadge"
	slot_flags = SLOT_TIE
	badge_string = "Sol Central Government"

/obj/item/clothing/accessory/badge/solgov/tags
	name = "dog tags"
	desc = "Plain identification tags made from a durable metal. They are stamped with a variety of informational details."
	gender = PLURAL
	icon_state = "tags"
	badge_string = "Sol Central Government"
	slot_flags = SLOT_MASK | SLOT_TIE

/obj/item/clothing/accessory/badge/solgov/tags/Initialize()
	. = ..()
	var/mob/living/carbon/human/H
	H = get_holder_of_type(src, /mob/living/carbon/human)
	if(H)
		set_name(H.real_name)
		set_desc(H)

/obj/item/clothing/accessory/badge/solgov/tags/set_desc(var/mob/living/carbon/human/H)
	if(!istype(H))
		return
	var/decl/cultural_info/culture = H.get_cultural_value(TAG_RELIGION)
	var/religion = culture ? culture.name : "Unset"
	desc = "[initial(desc)]\nName: [H.real_name] ([H.get_species()])[H.char_branch ? "\nBranch: [H.char_branch.name]" : ""]\nReligion: [religion]\nBlood type: [H.b_type]"

/obj/item/clothing/accessory/badge/solgov/representative
	name = "representative's badge"
	desc = "A leather-backed plastic badge with a variety of information printed on it. Belongs to a paperwork jockey."
	icon_state = "solbadge"
	slot_flags = SLOT_TIE
	badge_string = "Sol Central Government"

/*******
armbands
*******/
/obj/item/clothing/accessory/armband/solgov
	name = "master solgov armband"
	icon = 'maps/torch/icons/obj/obj_accessories_solgov.dmi'
	accessory_icons = list(slot_w_uniform_str = 'maps/torch/icons/mob/onmob_accessories_solgov.dmi', slot_wear_suit_str = 'maps/torch/icons/mob/onmob_accessories_solgov.dmi')
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_accessories_sol_unathi.dmi'
		)

/obj/item/clothing/accessory/armband/solgov/mp
	name = "military police brassard"
	desc = "An armlet, worn by the crew to display which department they're assigned to. This one is black with 'MP' in white."
	icon_state = "mpband"

/obj/item/clothing/accessory/armband/solgov/ma
	name = "master at arms brassard"
	desc = "An armlet, worn by the crew to display which department they're assigned to. This one is white with 'MA' in navy blue."
	icon_state = "maband"

/obj/item/weapon/storage/box/armband
	name = "box of spare military police armbands"
	desc = "A box full of security armbands. For use in emergencies when provisional security personnel are needed."
	startswith = list(/obj/item/clothing/accessory/armband/solgov/mp = 5)

/*****************
armour attachments
*****************/
/obj/item/clothing/accessory/armor/tag/solgov
	name = "\improper TAR Flag"
	desc = "An emblem depicting the Terran Amalgamated Republics flag."
	icon_override = 'maps/torch/icons/obj/obj_accessories_solgov.dmi'
	icon = 'maps/torch/icons/obj/obj_accessories_solgov.dmi'
	accessory_icons = list(slot_w_uniform_str = 'maps/torch/icons/mob/onmob_accessories_solgov.dmi', slot_wear_suit_str = 'maps/torch/icons/mob/onmob_accessories_solgov.dmi')
	icon_state = "solflag"
	slot = ACCESSORY_SLOT_ARMOR_M
/*
/obj/item/clothing/accessory/armor/tag/solgov/ec
	name = "\improper Expeditionary Corps crest"
	desc = "An emblem depicting the crest of the SCG Expeditionary Corps."
	icon_state = "ecflag"
*/
/obj/item/clothing/accessory/armor/tag/solgov/sec
	name = "\improper POLICE tag"
	desc = "An armor tag with the word POLICE printed in silver lettering on it."
	icon_state = "sectag"

/obj/item/clothing/accessory/armor/tag/solgov/medic
	name = "\improper MEDIC tag"
	desc = "An armor tag with the word MEDIC printed in red lettering on it."
	icon_state = "medictag"
/*
/obj/item/clothing/accessory/armor/tag/solgov/agent
	name = "\improper OCIE AGENT tag"
	desc = "An armor tag with the word OCIE AGENT printed in gold lettering on it."
	icon_state = "agenttag"
*/
/obj/item/clothing/accessory/armor/tag/solgov/com
	name = "\improper TAR Tag"
	desc = "A tag with 'TERRAN AMALGAMATED REPUBLICS' written in gold lettering."
	icon_state = "comtag"

/obj/item/clothing/accessory/armor/tag/solgov/com/sec
	name = "\improper POLICE tag"
	desc = "An armor tag with the words POLICE printed in gold lettering on it."
/*
/obj/item/clothing/accessory/armor/helmcover/blue/sol
	name = "peacekeeper helmet cover"
	desc = "A fabric cover for armored helmets. This one is in SCG peacekeeper colors."
*/
/**************
department tags
**************/
/obj/item/clothing/accessory/solgov/department
	name = "department insignia"
	desc = "Insignia denoting assignment to a department. These appear blank."
	icon_state = "dept_exped"
	on_rolled = list("down" = "none", "rolled" = "dept_exped_sleeves")
	slot = ACCESSORY_SLOT_DEPT
	removable = FALSE
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_accessories_sol_unathi.dmi'
		)

/obj/item/clothing/accessory/solgov/department/command
	name = "command insignia"
	desc = "Insignia denoting assignment to the command department. These fit Xenocorps uniforms."
	color = "#e5ea4f"

/obj/item/clothing/accessory/solgov/department/command/service
	icon_state = "dept_exped_service"

/obj/item/clothing/accessory/solgov/department/command/fleet
	icon_state = "dept_fleet"
	desc = "Insignia denoting assignment to the command department. These fit Fleet uniforms."
	on_rolled = list("rolled" = "dept_fleet_sleeves", "down" = "none")

/obj/item/clothing/accessory/solgov/department/command/army
	icon_state = "dept_army"
	desc = "Insignia denoting assignment to the command department. These fit Army uniforms."
	on_rolled = list("down" = "none")

/obj/item/clothing/accessory/solgov/department/engineering
	name = "engineering insignia"
	desc = "Insignia denoting assignment to the engineering department. These fit Xenocorps uniforms."
	color = "#ff7f00"

/obj/item/clothing/accessory/solgov/department/engineering/service
	icon_state = "dept_exped_service"

/obj/item/clothing/accessory/solgov/department/engineering/fleet
	icon_state = "dept_fleet"
	desc = "Insignia denoting assignment to the engineering department. These fit Fleet uniforms."
	on_rolled = list("rolled" = "dept_fleet_sleeves", "down" = "none")

/obj/item/clothing/accessory/solgov/department/engineering/army
	icon_state = "dept_army"
	desc = "Insignia denoting assignment to the engineering department. These fit Army uniforms."
	on_rolled = list("down" = "none")

/obj/item/clothing/accessory/solgov/department/security
	name = "security insignia"
	desc = "Insignia denoting assignment to the security department. These fit Xenocorps uniforms."
	color = "#bf0000"

/obj/item/clothing/accessory/solgov/department/security/service
	icon_state = "dept_exped_service"

/obj/item/clothing/accessory/solgov/department/security/fleet
	icon_state = "dept_fleet"
	desc = "Insignia denoting assignment to the security department. These fit Fleet uniforms."
	on_rolled = list("rolled" = "dept_fleet_sleeves", "down" = "none")

/obj/item/clothing/accessory/solgov/department/security/army
	icon_state = "dept_army"
	desc = "Insignia denoting assignment to the security department. These fit Army uniforms."
	on_rolled = list("down" = "none")

/obj/item/clothing/accessory/solgov/department/medical
	name = "medical insignia"
	desc = "Insignia denoting assignment to the medical department. These fit Xenocorps uniforms."
	color = "#4c9ce4"

/obj/item/clothing/accessory/solgov/department/medical/service
	icon_state = "dept_exped_service"

/obj/item/clothing/accessory/solgov/department/medical/fleet
	icon_state = "dept_fleet"
	desc = "Insignia denoting assignment to the medical department. These fit Fleet uniforms."
	on_rolled = list("rolled" = "dept_fleet_sleeves", "down" = "none")

/obj/item/clothing/accessory/solgov/department/medical/army
	icon_state = "dept_army"
	desc = "Insignia denoting assignment to the medical department. These fit Army uniforms."
	on_rolled = list("down" = "none")

/obj/item/clothing/accessory/solgov/department/supply
	name = "supply insignia"
	desc = "Insignia denoting assignment to the supply department. These fit Xenocorps uniforms."
	color = "#bb9042"

/obj/item/clothing/accessory/solgov/department/supply/service
	icon_state = "dept_exped_service"

/obj/item/clothing/accessory/solgov/department/supply/fleet
	icon_state = "dept_fleet"
	desc = "Insignia denoting assignment to the supply department. These fit Fleet uniforms."
	on_rolled = list("rolled" = "dept_fleet_sleeves", "down" = "none")

/obj/item/clothing/accessory/solgov/department/supply/army
	icon_state = "dept_army"
	desc = "Insignia denoting assignment to the supply department. These fit Army uniforms."
	on_rolled = list("down" = "none")

/obj/item/clothing/accessory/solgov/department/service
	name = "service insignia"
	desc = "Insignia denoting assignment to the service department. These fit Xenocorps uniforms."
	color = "#6eaa2c"

/obj/item/clothing/accessory/solgov/department/service/service
	icon_state = "dept_exped_service"

/obj/item/clothing/accessory/solgov/department/service/fleet
	icon_state = "dept_fleet"
	desc = "Insignia denoting assignment to the service department. These fit Fleet uniforms."
	on_rolled = list("rolled" = "dept_fleet_sleeves", "down" = "none")

/obj/item/clothing/accessory/solgov/department/service/army
	icon_state = "dept_army"
	desc = "Insignia denoting assignment to the service department. These fit Army uniforms."
	on_rolled = list("down" = "none")

/obj/item/clothing/accessory/solgov/department/exploration
	name = "exploration insignia"
	desc = "Insignia denoting assignment to the exploration department. These fit Xenoorps uniforms."
	color = "#68099e"

/obj/item/clothing/accessory/solgov/department/exploration/service
	icon_state = "dept_exped_service"

/obj/item/clothing/accessory/solgov/department/exploration/fleet
	icon_state = "dept_fleet"
	desc = "Insignia denoting assignment to the exploration department. These fit Fleet uniforms."
	on_rolled = list("rolled" = "dept_fleet_sleeves", "down" = "none")

/obj/item/clothing/accessory/solgov/department/exploration/army
	icon_state = "dept_army"
	desc = "Insignia denoting assignment to the exploration department. These fit Army uniforms."
	on_rolled = list("down" = "none")

/obj/item/clothing/accessory/solgov/department/research
	name = "research insignia"
	desc = "Insignia denoting assignment to the research department. These fit Xenocorps uniforms."
	color = COLOR_RESEARCH

/obj/item/clothing/accessory/solgov/department/research/service
	icon_state = "dept_exped_service"

/*********
ranks - ec
*********/

/obj/item/clothing/accessory/solgov/rank
	name = "ranks"
	desc = "Insignia denoting rank of some kind. These appear blank."
	icon_state = "fleetrank"
	on_rolled = list("down" = "none")
	slot = ACCESSORY_SLOT_RANK
	gender = PLURAL
	high_visibility = 1
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_accessories_sol_unathi.dmi'
		)

/obj/item/clothing/accessory/solgov/rank/get_fibers()
	return null

/obj/item/clothing/accessory/solgov/rank/ec
	name = "explorer ranks"
	desc = "Insignia denoting rank of some kind. These appear blank."
	icon_state = "ecrank_e1"
	on_rolled = list("down" = "none")

/obj/item/clothing/accessory/solgov/rank/ec/enlisted
	name = "ranks (E-1 auxiliary)"
	desc = "Insignia denoting the rank of Auxiliary."
	icon_state = "ecrank_e1"

/obj/item/clothing/accessory/solgov/rank/ec/enlisted/e3
	name = "ranks (E-3 legionnaire)"
	desc = "Insignia denoting the rank of Legionnaire."
	icon_state = "ecrank_e3"

/obj/item/clothing/accessory/solgov/rank/ec/enlisted/e5
	name = "ranks (E-5 decanus)"
	desc = "Insignia denoting the rank of Decanus."
	icon_state = "ecrank_e5"

/obj/item/clothing/accessory/solgov/rank/ec/enlisted/e7
	name = "ranks (E-7 tessarius)"
	desc = "Insignia denoting the rank of Tessarius."
	icon_state = "ecrank_e7"

/obj/item/clothing/accessory/solgov/rank/ec/officer
	name = "ranks (O-1 aspirant)"
	desc = "Insignia denoting the rank of Aspirant."
	icon_state = "ecrank_o1"

/obj/item/clothing/accessory/solgov/rank/ec/officer/o3
	name = "ranks (O-3 optio)"
	desc = "Insignia denoting the rank of Optio."
	icon_state = "ecrank_o3"

/obj/item/clothing/accessory/solgov/rank/ec/officer/o5
	name = "ranks (O-5 centurion)"
	desc = "Insignia denoting the rank of Centurion."
	icon_state = "ecrank_o5"

/obj/item/clothing/accessory/solgov/rank/ec/officer/o6
	name = "ranks (O-6 legatus)"
	desc = "Insignia denoting the rank of Legatus."
	icon_state = "ecrank_o6"

/obj/item/clothing/accessory/solgov/rank/ec/officer/o8
	name = "ranks (O-8 legatus praetore)"
	desc = "Insignia denoting the rank of the Legatus Praetore."
	icon_state = "ecrank_o8"

/************
ranks - fleet
************/
/obj/item/clothing/accessory/solgov/rank/fleet
	name = "naval ranks"
	desc = "Insignia denoting naval rank of some kind. These appear blank."
	icon_state = "fleetrank"
	on_rolled = list("down" = "none")

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted
	name = "ranks (E-1 recruit)"
	desc = "Insignia denoting the rank of Recruit."
	icon_state = "fleetrank_enlisted"

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e2
	name = "ranks (E-2 recruit specialist)"
	desc = "Insignia denoting the rank of Recruit Specialist."

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e3
	name = "ranks (E-3 petty officer third class)"
	desc = "Insignia denoting the rank of Petty Officer Third Class."

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e4
	name = "ranks (E-4 petty officer second class)"
	desc = "Insignia denoting the rank of Petty Officer Second Class."

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e5
	name = "ranks (E-5 petty officer first class)"
	desc = "Insignia denoting the rank of Petty Officer First Class."

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e6
	name = "ranks (E-6 technical petty officer)"
	desc = "Insignia denoting the rank of Technical Petty Officer."

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e7
	name = "ranks (E-7 chief petty officer)"
	desc = "Insignia denoting the rank of Chief Petty Officer."

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e7_alt1
	name = "ranks (E-7 chief munitions petty officer)"
	desc = "Insignia denoting the rank of Chief Munitions Petty Officer."

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e8
	name = "ranks (E-8 senior chief petty officer)"
	desc = "Insignia denoting the rank of Senior Chief Petty Officer."

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e8_alt1
	name = "ranks (E-8 chief munitions petty officer)"
	desc = "Insignia denoting the rank of Chief Munitions Petty Officer."

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e9
	name = "ranks (E-9 master chief petty officer)"
	desc = "Insignia denoting the rank of Master Chief Petty Officer."

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e9_alt1
	name = "ranks (E-9 command master chief petty officer)"
	desc = "Insignia denoting the rank of Command Master Chief Petty Officer."

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e9_alt2
	name = "ranks (E-9 fleet master chief petty officer)"
	desc = "Insignia denoting the rank of Fleet Master Chief Petty Officer."

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e9_alt3
	name = "ranks (E-9 force master chief petty officer)"
	desc = "Insignia denoting the rank of Force Master Chief Petty Officer."

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e9_alt4
	name = "ranks (E-9 master chief petty officer of the Fleet)"
	desc = "Insignia denoting the rank of Master Chief Petty Officer of the Fleet."

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e10
	name = "ranks (E-9 master chief petty officer of the navy)"
	desc = "Insignia denoting the rank of Chief Petty Officer of the Navy."

/obj/item/clothing/accessory/solgov/rank/fleet/officer
	name = "ranks (O-1 cadet)"
	desc = "Insignia denoting the rank of Cadet."
	icon_state = "fleetrank_officer"

/obj/item/clothing/accessory/solgov/rank/fleet/officer/wo1_monkey
	name = "makeshift ranks (WO-1 warrant officer 1)"
	desc = "Insignia denoting the elusive rank of Warrant Officer. Too bad it's obviously fake."

/obj/item/clothing/accessory/solgov/rank/fleet/officer/o2
	name = "ranks (O-2 sub-lieutenant)"
	desc = "Insignia denoting the rank of Sub-lieutenant."

/obj/item/clothing/accessory/solgov/rank/fleet/officer/o3
	name = "ranks (O-3 lieutenant)"
	desc = "Insignia denoting the rank of Lieutenant."

/obj/item/clothing/accessory/solgov/rank/fleet/officer/o4
	name = "ranks (O-4 staff lieutenant)"
	desc = "Insignia denoting the rank of Staff Lieutenant."

/obj/item/clothing/accessory/solgov/rank/fleet/officer/o4_alt1
	name = "ranks (O-4 sub commander)"
	desc = "Insignia denoting the rank of Sub Commander."

/obj/item/clothing/accessory/solgov/rank/fleet/officer/o5
	name = "ranks (O-5 commander)"
	desc = "Insignia denoting the rank of Commander."

/obj/item/clothing/accessory/solgov/rank/fleet/officer/o6
	name = "ranks (O-6 captain)"
	desc = "Insignia denoting the rank of Captain."
	icon_state = "fleetrank_command"

/obj/item/clothing/accessory/solgov/rank/fleet/flag
	name = "ranks (O-7 marshal second class)"
	desc = "Insignia denoting the rank of Marshal Second Class."
	icon_state = "fleetrank_command"

/obj/item/clothing/accessory/solgov/rank/fleet/flag/o8
	name = "ranks (O-8 marshal first class)"
	desc = "Insignia denoting the rank of Marshal First Class."

/obj/item/clothing/accessory/solgov/rank/fleet/flag/o9
	name = "ranks (O-9 fleet marshal)"
	desc = "Insignia denoting the rank of Fleet Marshal."

/obj/item/clothing/accessory/solgov/rank/fleet/flag/o10
	name = "ranks (O-10 grand marshal of the navy)"
	desc = "Insignia denoting the rank of Grand Marshal of the Navy."

/obj/item/clothing/accessory/solgov/rank/fleet/flag/o10_alt
	name = "ranks (O-10 fleet admiral)"
	desc = "Insignia denoting the rank of Fleet Admiral."

/**************
ranks - marines
**************/
/obj/item/clothing/accessory/solgov/rank/army
	name = "army ranks"
	desc = "Insignia denoting marine rank of some kind. These appear blank."
	icon_state = "armyrank_enlisted"
	on_rolled = list("down" = "none")

/obj/item/clothing/accessory/solgov/rank/army/enlisted
	name = "ranks (E-1 private)"
	desc = "Insignia denoting the rank of Private."
	icon_state = "armyrank_enlisted"

/obj/item/clothing/accessory/solgov/rank/army/enlisted/e2
	name = "ranks (E-2 private first class)"
	desc = "Insignia denoting the rank of Private First Class."

/obj/item/clothing/accessory/solgov/rank/army/enlisted/e3
	name = "ranks (E-3 corporal)"
	desc = "Insignia denoting the rank of Corporal."

/obj/item/clothing/accessory/solgov/rank/army/enlisted/e4
	name = "ranks (E-4 Sergeant)"
	desc = "Insignia denoting the rank of Sergeant."

/obj/item/clothing/accessory/solgov/rank/army/enlisted/e5
	name = "ranks (E-5 technical sergeant)"
	desc = "Insignia denoting the rank of Technical Sergeant."

/obj/item/clothing/accessory/solgov/rank/army/enlisted/e6
	name = "ranks (E-6 senior technical sergeant)"
	desc = "Insignia denoting the rank of Senior Technical Sergeant."

/obj/item/clothing/accessory/solgov/rank/army/enlisted/e7
	name = "ranks (E-7 command sergeant)"
	desc = "Insignia denoting the rank of a Command Sergeant."

/obj/item/clothing/accessory/solgov/rank/army/enlisted/e7_alt
	name = "ranks (E-7 munitions sergeant)"
	desc = "Insignia denoting the rank of a Munitions Sergeant."

/obj/item/clothing/accessory/solgov/rank/army/enlisted/e8
	name = "ranks (E-8 senior command sergeant)"
	desc = "Insignia denoting the rank of a Senior Command Sergeant."

/obj/item/clothing/accessory/solgov/rank/army/enlisted/e8_alt
	name = "ranks (E-8 senior munitions sergeant)"
	desc = "Insignia denoting the rank of a Senior Munitions Sergeant."

/obj/item/clothing/accessory/solgov/rank/army/enlisted/e9
	name = "ranks (E-9 sergeant major)"
	desc = "Insignia denoting the rank of Sergeant Major."

/obj/item/clothing/accessory/solgov/rank/army/enlisted/e9_alt1
	name = "ranks (E-9 command sergeant major)"
	desc = "Insignia denoting the rank of Command Sergeant Major."

/obj/item/clothing/accessory/solgov/rank/army/enlisted/e9_alt2
	name = "ranks (E-9 sergeant major of the Army)"
	desc = "Insignia denoting the rank of Sergeant Major of the Army."

/obj/item/clothing/accessory/solgov/rank/army/officer
	name = "ranks (O-1 junior lieutenant)"
	desc = "Insignia denoting the rank of Junior Lieutenant."
	icon_state = "armyrank_officer"

/obj/item/clothing/accessory/solgov/rank/army/officer/o2
	name = "ranks (O-2 lieutenant)"
	desc = "Insignia denoting the rank of Lieutenant."

/obj/item/clothing/accessory/solgov/rank/army/officer/o3
	name = "ranks (O-3 captain)"
	desc = "Insignia denoting the rank of Captain."

/obj/item/clothing/accessory/solgov/rank/army/officer/o4
	name = "ranks (O-4 major)"
	desc = "Insignia denoting the rank of Major."

/obj/item/clothing/accessory/solgov/rank/army/officer/o5
	name = "ranks (O-5 lieutenant colonel)"
	desc = "Insignia denoting the rank of Lieutenant Colonel."

/obj/item/clothing/accessory/solgov/rank/army/officer/o6
	name = "ranks (O-6 colonel)"
	desc = "Insignia denoting the rank of Colonel."

/obj/item/clothing/accessory/solgov/rank/army/flag
	name = "ranks (O-7 minor praetor)"
	desc = "Insignia denoting the rank of a Minor Praetor."
	icon_state = "armyrank_command"

/obj/item/clothing/accessory/solgov/rank/army/flag/o8
	name = "ranks (O-8 praetor second grade)"
	desc = "Insignia denoting the rank of a Praetor Second Grade."

/obj/item/clothing/accessory/solgov/rank/army/flag/o9
	name = "ranks (O-9 praetor first grade)"
	desc = "Insignia denoting the rank of Praetor First Grade."

/obj/item/clothing/accessory/solgov/rank/army/flag/o10
	name = "ranks (O-10 grand praetor)"
	desc = "Insignia denoting the rank of the Grand Praetor."

/obj/item/clothing/accessory/solgov/rank/army/flag/o10_alt
	name = "ranks (O-10 field marshal)"
	desc = "Insignia denoting the rank of Field Marshal."
