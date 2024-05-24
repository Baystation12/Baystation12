/obj/item/clothing/accessory/solgov
	name = "master solgov accessory"
	icon = 'maps/torch/icons/obj/obj_accessories_solgov.dmi'
	accessory_icons = list(slot_w_uniform_str = 'maps/torch/icons/mob/onmob_accessories_solgov.dmi', slot_wear_suit_str = 'maps/torch/icons/mob/onmob_accessories_solgov.dmi')
	w_class = ITEM_SIZE_TINY
	sprite_sheets = list(
		SPECIES_UNATHI = 'maps/torch/icons/mob/unathi/onmob_accessories_solgov_unathi.dmi'
		)

/*****
medals
*****/
/obj/item/clothing/accessory/medal/solgov
	name = "master solgov medal"
	desc = "You shouldn't be seeing this."
	icon = 'maps/torch/icons/obj/obj_accessories_solgov.dmi'
	accessory_icons = list(slot_w_uniform_str = 'maps/torch/icons/mob/onmob_accessories_solgov.dmi', slot_wear_suit_str = 'maps/torch/icons/mob/onmob_accessories_solgov.dmi')

//medals ranked from least to greatest

//Military medals
/obj/item/clothing/accessory/medal/solgov/mil/bronze_heart
	name = "\improper Bronze Heart medal"
	desc = "A bronze heart awarded by the SCG for members of the SCG Defense Forces who suffer injury or death in a combat zone."
	icon_state = "medal_bronze_heart"

/obj/item/clothing/accessory/medal/solgov/mil/home_guard
	name = "\improper Home Guard medal"
	desc = "A bronze medal awarded by the SCG for members of the SCG Defense Forces who have helped defend the border regions of Sol."
	icon_state = "medal_home_guard"

/obj/item/clothing/accessory/medal/solgov/mil/iron_star
	name = "\improper Iron Star medal"
	desc = "An iron star awarded by the SCG to members of the SCG Defense Forces who have performed acts of 'meritorious achievements or service.'"
	icon_state = "medal_iron_star"

/obj/item/clothing/accessory/medal/solgov/mil/medical
	name = "\improper Combat Medical Award"
	desc = "An electrum heart medal with a Staff of Hermes and sanguine cross, awarded by the SCG to individuals who have served as medical personnel in an active combat zone."
	icon_state = "medal_medical"

/obj/item/clothing/accessory/medal/solgov/mil/armed_forces
	name = "\improper Armed Forces Medal"
	desc = "A brass medal awarded by the SCG for members of the SCG Defense Forces who have performed distinguishing acts outside of direct combat with an enemy."
	icon_state = "medal_armed_forces"

/obj/item/clothing/accessory/medal/solgov/mil/silver_sword
	name = "\improper Silver Sword medal"
	desc = "A silver medal awarded by the SCG for members of the SCG Defense Forces who have demonstrated exceptional valor in combat."
	icon_state = "medal_silver_sword"

/obj/item/clothing/accessory/medal/solgov/mil/service_cross
	name = "\improper Superior Service Cross"
	desc = "A copper cross awarded by the SCG for members of the SCG Defense Forces who have performed acts of incredible valor against an enemy of Sol."
	icon_state = "medal_service_cross"

/obj/item/clothing/accessory/medal/solgov/mil/medal_of_honor
	name = "\improper Medal of Honor"
	desc = "An ornate golden medal awarded and conferred by the SCG Secretary-General to members of the SCG Defense Forces who have committed acts of 'conspicuous gallantry beyond the call of duty.'"
	icon_state = "medal_of_honor"

//Civilian medals
/obj/item/clothing/accessory/medal/solgov/civ/expeditionary
	name = "\improper Expeditionary Medal"
	desc = "An iron medal awarded by the SCG for individuals who have participated in missions outside the borders of the Sol Central Government."
	icon_state = "medal_expeditionary"

/obj/item/clothing/accessory/medal/solgov/civ/sapientarian
	name = "\improper Sapientarian Peace Award"
	desc = "A copper medal awarded by the SCG for individuals who have contributed substantially to sapient rights or fostered greater brotherhood between sapient species. It is embossed with a date, text, and an image of famous Expeditionary Corps sapientarian, Samuel Carr."
	icon_state = "medal_sapientarian"

/obj/item/clothing/accessory/medal/solgov/civ/service
	name = "\improper Distinguished Service Medal"
	desc = "A golden sun medal awarded by the SCG to nonmilitary individuals who have made exceptional contributions to the Sol Central Government."
	icon_state = "medal_service"

/obj/item/clothing/accessory/solgov
	var/check_codex_val = FACTION_FLEET

/obj/item/clothing/accessory/solgov/get_codex_value()
	return check_codex_val || ..()

/*****
patches
*****/
/obj/item/clothing/accessory/solgov/torch_patch
	name = "\improper Torch mission patch"
	desc = "A fire resistant shoulder patch, worn by the personnel involved in the Torch Project."
	icon_state = "torchpatch"
	on_rolled_down = ACCESSORY_ROLLED_NONE
	slot = ACCESSORY_SLOT_INSIGNIA

/obj/item/clothing/accessory/solgov/ec_patch
	name = "\improper Observatory patch"
	desc = "A laminated shoulder patch, carrying the symbol of the Sol Central Government Expeditionary Corpss Observatory, or SCGEO for short, the eyes and ears of the Expeditionary Corps' missions."
	icon_state = "ecpatch1"
	on_rolled_down = ACCESSORY_ROLLED_NONE
	slot = ACCESSORY_SLOT_INSIGNIA
	check_codex_val = FACTION_EXPEDITIONARY

/obj/item/clothing/accessory/solgov/ec_patch/fieldops
	name = "\improper Field Operations patch"
	desc = "A radiation-shielded shoulder patch, carrying the symbol of the Sol Central Government Expeditionary Corps Field Operations, or SCGECFO for short, the hands-on workers of every Expeditionary Corps mission."
	icon_state = "ecpatch2"

/obj/item/clothing/accessory/solgov/cultex_patch
	name = "\improper Cultural Exchange patch"
	desc = "A radiation-shielded shoulder patch, denoting service in the the Sol Central Government Expeditionary Corps Cultural Exchange program."
	icon_state = "ecpatch3"
	on_rolled_down = ACCESSORY_ROLLED_NONE
	slot = ACCESSORY_SLOT_INSIGNIA
	check_codex_val = FACTION_EXPEDITIONARY

/obj/item/clothing/accessory/solgov/fleet_patch
	name = "\improper First Fleet patch"
	desc = "A fancy shoulder patch carrying insignia of First Fleet, the Sol Guard, stationed in Sol."
	icon_state = "fleetpatch1"
	on_rolled_down = ACCESSORY_ROLLED_NONE
	slot = ACCESSORY_SLOT_INSIGNIA

/obj/item/clothing/accessory/solgov/fleet_patch/second
	name = "\improper Second Fleet patch"
	desc = "A well-worn shoulder patch carrying insignia of Second Fleet, the Home Defense Group, tasked with defense of Sol territories."
	icon_state = "fleetpatch2"

/obj/item/clothing/accessory/solgov/fleet_patch/third
	name = "\improper Third Fleet patch"
	desc = "A scuffed shoulder patch carrying insignia of Third Fleet, the Border Guard, guarding borders of Sol territory against Vox and pirates."
	icon_state = "fleetpatch3"

/obj/item/clothing/accessory/solgov/fleet_patch/fourth
	name = "\improper Fourth Fleet patch"
	desc = "A pristine shoulder patch carrying insignia of Fourth Fleet, stationed on Skrell border."
	icon_state = "fleetpatch4"

/obj/item/clothing/accessory/solgov/fleet_patch/fifth
	name = "\improper Fifth Fleet patch"
	desc = "A tactical shoulder patch carrying insignia of Fifth Fleet, the Quick Reaction Force, recently formed and outfited with the latest tech."
	icon_state = "fleetpatch5"

/*****
scarves
*****/
/obj/item/clothing/accessory/solgov/ec_scarf
	name = "expeditionary scarf"
	desc = "An SCG blue silk scarf, meant to be worn with Expeditionary Corps uniforms."
	icon = 'icons/obj/clothing/obj_accessories.dmi'
	accessory_icons = list(slot_w_uniform_str = 'icons/mob/onmob/onmob_accessories.dmi', slot_wear_suit_str = 'icons/mob/onmob/onmob_accessories.dmi')
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_accessories_unathi.dmi'
		)
	icon_state = "whitescarf"
	on_rolled_down = ACCESSORY_ROLLED_NONE
	color = "#68a0ce"
	check_codex_val = FACTION_EXPEDITIONARY

/obj/item/clothing/accessory/solgov/ec_scarf/observatory
	name = "\improper Observatory scarf"
	desc = "A silk scarf in Expeditionary Corps Observatory section colors, meant to be worn with Expeditionary Corps uniforms."
	color = "#58bb59"

/obj/item/clothing/accessory/solgov/ec_scarf/fieldops
	name = "\improper Field Operations scarf"
	desc = "A silk scarf in Expeditionary Corps Field Operations section colors, meant to be worn with Expeditionary Corps uniforms."
	color = "#9f84b3"

/******
ribbons
******/
/obj/item/clothing/accessory/ribbon
	on_rolled_down = ACCESSORY_ROLLED_NONE

/obj/item/clothing/accessory/ribbon/solgov
	name = "ribbon"
	desc = "A simple military decoration."
	icon_state = "ribbon_marksman"
	on_rolled_down = ACCESSORY_ROLLED_NONE
	slot = ACCESSORY_SLOT_MEDAL
	icon = 'maps/torch/icons/obj/obj_accessories_solgov.dmi'
	accessory_icons = list(slot_w_uniform_str = 'maps/torch/icons/mob/onmob_accessories_solgov.dmi', slot_wear_suit_str = 'maps/torch/icons/mob/onmob_accessories_solgov.dmi')
	w_class = ITEM_SIZE_TINY

//General ribbons/decorations
/obj/item/clothing/accessory/ribbon/solgov/marksman
	name = "marksmanship ribbon"
	desc = "A military ribbon awarded to members of the SCG Defense Forces for good marksmanship scores in training. Common in the days of energy weapons."
	icon_state = "ribbon_marksman"

/obj/item/clothing/accessory/ribbon/solgov/peace
	name = "peacekeeping ribbon"
	desc = "A military ribbon awarded to members of the SCG Defense Forces for service during a peacekeeping operation."
	icon_state = "ribbon_peace"

/obj/item/clothing/accessory/ribbon/solgov/frontier
	name = "frontier ribbon"
	desc = "A military ribbon awarded to members of the SCG Defense Forces for service along the frontier."
	icon_state = "ribbon_frontier"

/obj/item/clothing/accessory/ribbon/solgov/instructor
	name = "instructor ribbon"
	desc = "A military ribbon awarded to members of the SCG Defense Forces for service as an instructor or professional development agent."
	icon_state = "ribbon_instructor"

/obj/item/clothing/accessory/ribbon/solgov/combat
	name = "combat action ribbon"
	desc = "A military ribbon awarded to members of the SCG Defense Forces for serving in active combat. Colloquially known as 'blood gold.'"
	icon_state = "ribbon_combat"

/obj/item/clothing/accessory/ribbon/solgov/gaiaconflict
	name = "\improper Gaia Conflict ribbon"
	desc = "A military ribbon awarded to members of the SCG Defense Forces for serving in the Gaia Conflict."
	icon_state = "ribbon_gaiaconflict"

/obj/item/clothing/accessory/ribbon/solgov/distinguished_unit
	name = "distinguished unit ribbon"
	desc = "A military ribbon awarded to members of the SCG Defense Forces for service as part of a unit that has performed a distinguishing act of valor."
	icon_state = "ribbon_distinguished_unit"

//Medal ribbons
/obj/item/clothing/accessory/ribbon/solgov/medal/bronze_heart
	name = "\improper Bronze Heart ribbon"
	desc = "A military ribbon awarded by the SCG alongside the Bronze Heart. To be worn when it is impossible or undesirable to wear the Bronze Heart."
	icon_state = "ribbon_medal_bronze_heart"

/obj/item/clothing/accessory/ribbon/solgov/medal/home_guard
	name = "\improper Home Guard ribbon"
	desc = "A military ribbon awarded by the SCG alongside the Home Guard medal. To be worn when it is impossible or undesirable to wear the Home Guard medal."
	icon_state = "ribbon_medal_home_guard"

/obj/item/clothing/accessory/ribbon/solgov/medal/iron_star
	name = "\improper Iron Star ribbon"
	desc = "A military ribbon awarded by the SCG alongside the Iron Star medal. To be worn when it is impossible or undesirable to wear the Iron Star."
	icon_state = "ribbon_medal_iron_star"

/obj/item/clothing/accessory/ribbon/solgov/medal/armed_forces
	name = "\improper Armed Forces ribbon"
	desc = "A military ribbon awarded by the SCG alongside the Armed Forces Medal. To be worn when it is impossible or undesirable to wear the Armed Forces Medal."
	icon_state = "ribbon_medal_armed_forces"

/obj/item/clothing/accessory/ribbon/solgov/medal/silver_sword
	name = "\improper Silver Sword ribbon"
	desc = "A military ribbon awarded by the SCG alongside the Silver Sword medal. To be worn when it is impossible or undesirable to wear the Silver Sword."
	icon_state = "ribbon_medal_silver_sword"

/obj/item/clothing/accessory/ribbon/solgov/medal/service_cross
	name = "\improper Superior Service ribbon"
	desc = "A military ribbon awarded by the SCG alongside the Superior Service Cross. To be worn when it is impossible or undesirable to wear the Service Cross."
	icon_state = "ribbon_medal_service_cross"

/obj/item/clothing/accessory/ribbon/solgov/medal/medal_of_honor
	name = "\improper Medal of Honor ribbon"
	desc = "A military ribbon awarded by the SCG alongside the Medal of Honor. To be worn when it is impossible or undesirable to wear the Medal of Honor."
	icon_state = "ribbon_medal_of_honor"

/obj/item/clothing/accessory/ribbon/solgov/medal/expeditionary_medal
	name = "\improper Expeditionary Ribbon"
	desc = "A military ribbon awarded by the SCG alongside the Expeditionary Medal. To be worn when it is impossible or undesirable to wear the Expeditionary Medal."
	icon_state = "ribbon_medal_expeditionary"

/obj/item/clothing/accessory/ribbon/solgov/medal/sapientarian
	name = "\improper Sapientarian ribbon"
	desc = "A military ribbon awarded by the SCG alongside the Sapientarian Peace Award. To be worn when it is impossible or undesirable to wear the Sapientarian Award."
	icon_state = "ribbon_medal_sapientarian"

/obj/item/clothing/accessory/ribbon/solgov/medal/service
	name = "\improper Distinguished Service ribbon"
	desc = "A military ribbon awarded by the SCG alongside the Distinguished Service Medal. To be worn when it is impossible or undesirable to wear the Distinguished Service Medal."
	icon_state = "ribbon_medal_service"

/obj/item/clothing/accessory/ribbon/solgov/medal/medical
	name = "\improper Combat Medical ribbon"
	desc = "A military ribbon awarded by the SCG alongside the Combat Medical Award. To be worn when it is impossible or undesirable to wear the Combat Medical Award."
	icon_state = "ribbon_medal_medical"


/*************
specialty pins
*************/
/obj/item/clothing/accessory/solgov/specialty
	name = "speciality blaze"
	desc = "A color blaze denoting fleet personnel in some special role. This one is silver."
	icon_state = "marinerank_command"
	slot = ACCESSORY_SLOT_INSIGNIA
	icon_state = "fleetspec"
	on_rolled_down = ACCESSORY_ROLLED_NONE

/obj/item/clothing/accessory/solgov/specialty/janitor
	name = "custodial blazes"
	desc = "Purple blazes denoting a custodial technician."
	color = "#913da7"

/obj/item/clothing/accessory/solgov/specialty/brig
	name = "brig blazes"
	desc = "Red blazes denoting a brig chief."
	color = "#bf0000"

/obj/item/clothing/accessory/solgov/specialty/forensic
	name = "forensics blazes"
	desc = "Steel blazes denoting a forensic technician."
	color = "#939fb1"

/obj/item/clothing/accessory/solgov/specialty/atmos
	name = "atmospherics blazes"
	desc = "Turquoise blazes denoting an atmospheric technician."
	color = "#469085"

/obj/item/clothing/accessory/solgov/specialty/counselor
	name = "counselor blazes"
	desc = "Blue blazes denoting a counselor."
	color = "#4c9ce4"

/obj/item/clothing/accessory/solgov/specialty/chemist
	name = "pharmacy blazes"
	desc = "Orange blazes denoting a pharmacist."
	color = "#ff6600"

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
	var/owner_rank
	var/owner_name
	var/owner_branch

/obj/item/clothing/accessory/badge/solgov/tags/proc/loadout_setup(mob/M)
	set_name(M.real_name)
	set_desc(M)

/obj/item/clothing/accessory/badge/solgov/tags/set_desc(mob/living/carbon/human/H)
	if(!istype(H))
		return
	owner_rank = H.char_rank && H.char_rank.name
	owner_name = H.real_name
	owner_branch = H.char_branch && H.char_branch.name
	var/singleton/cultural_info/culture = H.get_cultural_value(TAG_RELIGION)
	var/religion = culture ? culture.name : "Unset"
	desc = "[initial(desc)]\nName: [H.real_name] ([H.get_species()])[H.char_branch ? "\nBranch: [H.char_branch.name]" : ""]\nReligion: [religion]\nBlood type: [H.b_type]"

/obj/item/clothing/accessory/badge/solgov/representative
	name = "representative's badge"
	desc = "A leather-backed plastic badge with a variety of information printed on it. Belongs to a representative of the Sol Central Government."
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

/obj/item/clothing/accessory/armband/solgov/mp
	name = "military police brassard"
	desc = "An armlet, worn by the crew to display which department they're assigned to. This one is black with 'MP' in white."
	icon_state = "mpband"

/obj/item/clothing/accessory/armband/solgov/ma
	name = "master at arms brassard"
	desc = "An armlet, worn by the crew to display which department they're assigned to. This one is white with 'MA' in navy blue."
	icon_state = "maband"

/obj/item/storage/box/armband
	name = "box of spare military police armbands"
	desc = "A box full of security armbands. For use in emergencies when provisional security personnel are needed."
	startswith = list(/obj/item/clothing/accessory/armband/solgov/mp = 5)

/*****************
armour attachments
*****************/
/obj/item/clothing/accessory/armor_tag/solgov
	name = "\improper SCG Flag"
	desc = "An emblem depicting the Sol Central Government's flag."
	icon_override = 'maps/torch/icons/obj/obj_accessories_solgov.dmi'
	icon = 'maps/torch/icons/obj/obj_accessories_solgov.dmi'
	accessory_icons = list(slot_w_uniform_str = 'maps/torch/icons/mob/onmob_accessories_solgov.dmi', slot_wear_suit_str = 'maps/torch/icons/mob/onmob_accessories_solgov.dmi')
	icon_state = "solflag"
	slot = ACCESSORY_SLOT_ARMOR_MISC

/obj/item/clothing/accessory/armor_tag/solgov/ec
	name = "\improper Expeditionary Corps crest"
	desc = "An emblem depicting the crest of the SCG Expeditionary Corps."
	icon_state = "ecflag"

/obj/item/clothing/accessory/armor_tag/solgov/fleet
	name = "\improper Fleet crest"
	desc = "An emblem depicting the crest of the SCG Fleet."
	icon_state = "fleetflag"

/obj/item/clothing/accessory/armor_tag/solgov/sec
	name = "\improper POLICE tag"
	desc = "An armor tag with the word POLICE printed in silver lettering on it."
	icon_state = "sectag"

/obj/item/clothing/accessory/armor_tag/solgov/medic
	name = "\improper MEDIC tag"
	desc = "An armor tag with the word MEDIC printed in red lettering on it."
	icon_state = "medictag"

/obj/item/clothing/accessory/armor_tag/solgov/agent
	name = "\improper SFP AGENT tag"
	desc = "An armor tag with the words SFP AGENT printed in gold lettering on it."
	icon_state = "agenttag"

/obj/item/clothing/accessory/armor_tag/solgov/com
	name = "\improper SCG tag"
	desc = "An armor tag with the words SOL CENTRAL GOVERNMENT printed in gold lettering on it."
	icon_state = "comtag"

/obj/item/clothing/accessory/armor_tag/solgov/com/sec
	name = "\improper POLICE tag"
	desc = "An armor tag with the words POLICE printed in gold lettering on it."

/obj/item/clothing/accessory/armor_tag/solgov/lead
	name = "\improper LEAD tag"
	desc = "An armor tag denoting the leader of a fireteam."
	icon_state = "leadtag"

/obj/item/clothing/accessory/helmet_cover/blue/sol
	name = "peacekeeper helmet cover"
	desc = "A fabric cover for armored helmets. This one is in SCG peacekeeper colors."

/**************
department tags
**************/
/obj/item/clothing/accessory/solgov/department
	name = "department insignia"
	desc = "Insignia denoting assignment to a department. These appear blank."
	icon_state = "dept_exped"
	on_rolled_down = ACCESSORY_ROLLED_NONE
	on_rolled_sleeves = "dept_exped_sleeves"
	slot = ACCESSORY_SLOT_FLASH
	accessory_flags = EMPTY_BITFIELD

/obj/item/clothing/accessory/solgov/department/command
	name = "command insignia"
	desc = "Insignia denoting assignment to the command department. These fit Expeditionary Corps uniforms."
	color = "#e5ea4f"

/obj/item/clothing/accessory/solgov/department/command/service
	icon_state = "dept_exped_service"

/obj/item/clothing/accessory/solgov/department/command/fleet
	icon_state = "dept_fleet"
	desc = "Insignia denoting assignment to the command department. These fit Fleet uniforms."
	on_rolled_sleeves = "dept_fleet_sleeves"


/obj/item/clothing/accessory/solgov/department/engineering
	name = "engineering insignia"
	desc = "Insignia denoting assignment to the engineering department. These fit Expeditionary Corps uniforms."
	color = "#ff7f00"

/obj/item/clothing/accessory/solgov/department/engineering/service
	icon_state = "dept_exped_service"

/obj/item/clothing/accessory/solgov/department/engineering/fleet
	icon_state = "dept_fleet"
	desc = "Insignia denoting assignment to the engineering department. These fit Fleet uniforms."
	on_rolled_sleeves = "dept_fleet_sleeves"


/obj/item/clothing/accessory/solgov/department/security
	name = "security insignia"
	desc = "Insignia denoting assignment to the security department. These fit Expeditionary Corps uniforms."
	color = "#bf0000"

/obj/item/clothing/accessory/solgov/department/security/service
	icon_state = "dept_exped_service"

/obj/item/clothing/accessory/solgov/department/security/fleet
	icon_state = "dept_fleet"
	desc = "Insignia denoting assignment to the security department. These fit Fleet uniforms."
	on_rolled_sleeves = "dept_fleet_sleeves"


/obj/item/clothing/accessory/solgov/department/medical
	name = "medical insignia"
	desc = "Insignia denoting assignment to the medical department. These fit Expeditionary Corps uniforms."
	color = "#4c9ce4"

/obj/item/clothing/accessory/solgov/department/medical/service
	icon_state = "dept_exped_service"
	color = "#7faad1"

/obj/item/clothing/accessory/solgov/department/medical/fleet
	icon_state = "dept_fleet"
	desc = "Insignia denoting assignment to the medical department. These fit Fleet uniforms."
	on_rolled_sleeves = "dept_fleet_sleeves"


/obj/item/clothing/accessory/solgov/department/supply
	name = "supply insignia"
	desc = "Insignia denoting assignment to the supply department. These fit Expeditionary Corps uniforms."
	color = "#bb9042"

/obj/item/clothing/accessory/solgov/department/supply/service
	icon_state = "dept_exped_service"

/obj/item/clothing/accessory/solgov/department/supply/fleet
	icon_state = "dept_fleet"
	desc = "Insignia denoting assignment to the supply department. These fit Fleet uniforms."
	on_rolled_sleeves = "dept_fleet_sleeves"


/obj/item/clothing/accessory/solgov/department/service
	name = "service insignia"
	desc = "Insignia denoting assignment to the service department. These fit Expeditionary Corps uniforms."
	color = "#6eaa2c"

/obj/item/clothing/accessory/solgov/department/service/service
	icon_state = "dept_exped_service"

/obj/item/clothing/accessory/solgov/department/service/fleet
	icon_state = "dept_fleet"
	desc = "Insignia denoting assignment to the service department. These fit Fleet uniforms."
	on_rolled_sleeves = "dept_fleet_sleeves"


/obj/item/clothing/accessory/solgov/department/exploration
	name = "exploration insignia"
	desc = "Insignia denoting assignment to the exploration department. These fit Expeditionary Corps uniforms."
	color = "#68099e"

/obj/item/clothing/accessory/solgov/department/exploration/service
	icon_state = "dept_exped_service"

/obj/item/clothing/accessory/solgov/department/exploration/fleet
	icon_state = "dept_fleet"
	desc = "Insignia denoting assignment to the exploration department. These fit Fleet uniforms."
	on_rolled_sleeves = "dept_fleet_sleeves"


/obj/item/clothing/accessory/solgov/department/research
	name = "research insignia"
	desc = "Insignia denoting assignment to the research department. These fit Expeditionary Corps uniforms."
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
	on_rolled_down = ACCESSORY_ROLLED_NONE
	slot = ACCESSORY_SLOT_RANK
	gender = PLURAL
	accessory_flags = ACCESSORY_REMOVABLE | ACCESSORY_HIGH_VISIBILITY

/obj/item/clothing/accessory/solgov/rank/ec
	name = "explorer ranks"
	desc = "Insignia denoting rank of some kind. These appear blank."
	icon_state = "ecrank_e1"

/obj/item/clothing/accessory/solgov/rank/ec/enlisted
	name = "ranks (E-1 apprentice explorer)"
	desc = "Insignia denoting the rank of Apprentice Explorer."
	icon_state = "ecrank_e1"

/obj/item/clothing/accessory/solgov/rank/ec/enlisted/e3
	name = "ranks (E-3 explorer)"
	desc = "Insignia denoting the rank of Explorer."
	icon_state = "ecrank_e3"

/obj/item/clothing/accessory/solgov/rank/ec/enlisted/e5
	name = "ranks (E-5 senior explorer)"
	desc = "Insignia denoting the rank of Senior Explorer."
	icon_state = "ecrank_e5"

/obj/item/clothing/accessory/solgov/rank/ec/enlisted/e7
	name = "ranks (E-7 chief explorer)"
	desc = "Insignia denoting the rank of Chief Explorer."
	icon_state = "ecrank_e7"

/obj/item/clothing/accessory/solgov/rank/ec/officer
	name = "ranks (O-1 ensign)"
	desc = "Insignia denoting the rank of Ensign."
	icon_state = "ecrank_o1"

/obj/item/clothing/accessory/solgov/rank/ec/officer/o3
	name = "ranks (O-3 lieutenant)"
	desc = "Insignia denoting the rank of Lieutenant."
	icon_state = "ecrank_o3"

/obj/item/clothing/accessory/solgov/rank/ec/officer/o5
	name = "ranks (O-5 commander)"
	desc = "Insignia denoting the rank of Commander."
	icon_state = "ecrank_o5"

/obj/item/clothing/accessory/solgov/rank/ec/officer/o6
	name = "ranks (O-6 captain)"
	desc = "Insignia denoting the rank of Captain."
	icon_state = "ecrank_o6"

/obj/item/clothing/accessory/solgov/rank/ec/officer/o8
	name = "ranks (O-8 admiral)"
	desc = "Insignia denoting the rank of Admiral."
	icon_state = "ecrank_o8"

/obj/item/clothing/accessory/solgov/rank/ec/officer/o8_alt
	name = "ranks (O-8 commandant of the expeditionary corps)"
	desc = "Insignia denoting the rank of Commandant of the Expeditonary Corps."
	icon_state = "ecrank_o8_alt"

/************
ranks - fleet
************/
/obj/item/clothing/accessory/solgov/rank/fleet
	name = "naval ranks"
	desc = "Insignia denoting naval rank of some kind. These appear blank."
	icon_state = "fleetrank"

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted
	name = "ranks (E-1 crewman recruit)"
	desc = "Insignia denoting the rank of Crewman Recruit."
	icon_state = "fleetrank_e1"

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e2
	name = "ranks (E-2 crewman apprentice)"
	desc = "Insignia denoting the rank of Crewman Apprentice."
	icon_state = "fleetrank_e2"

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e3
	name = "ranks (E-3 crewman)"
	desc = "Insignia denoting the rank of Crewman."
	icon_state = "fleetrank_e3"

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e4
	name = "ranks (E-4 petty officer third class)"
	desc = "Insignia denoting the rank of Petty Officer Third Class."
	icon_state = "fleetrank_e4"

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e5
	name = "ranks (E-5 petty officer second class)"
	desc = "Insignia denoting the rank of Petty Officer Second Class."
	icon_state = "fleetrank_e5"

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e6
	name = "ranks (E-6 petty officer first class)"
	desc = "Insignia denoting the rank of Petty Officer First Class."
	icon_state = "fleetrank_e6"

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e7
	name = "ranks (E-7 chief petty officer)"
	desc = "Insignia denoting the rank of Chief Petty Officer."
	icon_state = "fleetrank_e7"

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e8
	name = "ranks (E-8 senior chief petty officer)"
	desc = "Insignia denoting the rank of Senior Chief Petty Officer."
	icon_state = "fleetrank_e8"

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e9
	name = "ranks (E-9 master chief petty officer)"
	desc = "Insignia denoting the rank of Master Chief Petty Officer."
	icon_state = "fleetrank_e9"

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e9_alt1
	name = "ranks (E-9 command master chief petty officer)"
	desc = "Insignia denoting the rank of Command Master Chief Petty Officer."
	icon_state = "fleetrank_e9"

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e9_alt2
	name = "ranks (E-9 fleet master chief petty officer)"
	desc = "Insignia denoting the rank of Fleet Master Chief Petty Officer."
	icon_state = "fleetrank_e9"

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e9_alt3
	name = "ranks (E-9 force master chief petty officer)"
	desc = "Insignia denoting the rank of Force Master Chief Petty Officer."
	icon_state = "fleetrank_e9"

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e9_alt4
	name = "ranks (E-9 master chief petty officer of the Fleet)"
	desc = "Insignia denoting the rank of Master Chief Petty Officer of the Fleet."
	icon_state = "fleetrank_e9"

/obj/item/clothing/accessory/solgov/rank/fleet/officer
	name = "ranks (O-1 ensign)"
	desc = "Insignia denoting the rank of Ensign."
	icon_state = "fleetrank_o1"

/obj/item/clothing/accessory/solgov/rank/fleet/officer/wo1_monkey
	name = "makeshift ranks (WO-1 warrant officer 1)"
	desc = "Insignia denoting the mythical rank of Warrant Officer. Too bad it's obviously fake."
	icon_state = "fleetrank_o1"

/obj/item/clothing/accessory/solgov/rank/fleet/officer/o2
	name = "ranks (O-2 sub-lieutenant)"
	desc = "Insignia denoting the rank of Sub-lieutenant."
	icon_state = "fleetrank_o2"

/obj/item/clothing/accessory/solgov/rank/fleet/officer/o3
	name = "ranks (O-3 lieutenant)"
	desc = "Insignia denoting the rank of Lieutenant."
	icon_state = "fleetrank_o3"

/obj/item/clothing/accessory/solgov/rank/fleet/officer/o4
	name = "ranks (O-4 lieutenant commander)"
	desc = "Insignia denoting the rank of Lieutenant Commander."
	icon_state = "fleetrank_o4"

/obj/item/clothing/accessory/solgov/rank/fleet/officer/o5
	name = "ranks (O-5 commander)"
	desc = "Insignia denoting the rank of Commander."
	icon_state = "fleetrank_o5"

/obj/item/clothing/accessory/solgov/rank/fleet/officer/o6
	name = "ranks (O-6 captain)"
	desc = "Insignia denoting the rank of Captain."
	icon_state = "fleetrank_o6"

/obj/item/clothing/accessory/solgov/rank/fleet/flag
	name = "ranks (O-7 commodore)"
	desc = "Insignia denoting the rank of Commodore."
	icon_state = "fleetrank_o7"

/obj/item/clothing/accessory/solgov/rank/fleet/flag/o8
	name = "ranks (O-8 rear admiral)"
	desc = "Insignia denoting the rank of Rear Admiral."
	icon_state = "fleetrank_o8"

/obj/item/clothing/accessory/solgov/rank/fleet/flag/o9
	name = "ranks (O-9 vice admiral)"
	desc = "Insignia denoting the rank of Vice Admiral."
	icon_state = "fleetrank_o9"

/obj/item/clothing/accessory/solgov/rank/fleet/flag/o10
	name = "ranks (O-10 admiral)"
	desc = "Insignia denoting the rank of Admiral."
	icon_state = "fleetrank_o10"

/obj/item/clothing/accessory/solgov/rank/fleet/flag/o10_alt
	name = "ranks (O-10 fleet admiral)"
	desc = "Insignia denoting the rank of Fleet Admiral."
	icon_state = "fleetrank_o10"
