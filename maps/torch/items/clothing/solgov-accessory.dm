/obj/item/clothing/accessory/solgov
	name = "master solgov accessory"
	icon = 'maps/torch/icons/obj/solgov-accessory.dmi'
	accessory_icons = list(slot_w_uniform_str = 'maps/torch/icons/mob/solgov-accessory.dmi', slot_wear_suit_str = 'maps/torch/icons/mob/solgov-accessory.dmi')

/*****
medals
*****/
/obj/item/clothing/accessory/medal/solgov
	name = "master solgov medal"
	desc = "You shouldn't be seeing this."
	icon = 'maps/torch/icons/obj/solgov-accessory.dmi'
	accessory_icons = list(slot_w_uniform_str = 'maps/torch/icons/mob/solgov-accessory.dmi', slot_wear_suit_str = 'maps/torch/icons/mob/solgov-accessory.dmi')

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
	name = "\improper Torch mission patch"
	desc = "A fire resistant shoulder patch, worn by the personnel involved in the Torch Project."
	icon_state = "torchpatch"
	slot = ACCESSORY_SLOT_INSIGNIA

/******
ribbons
******/
/obj/item/clothing/accessory/ribbon/solgov
	name = "ribbon"
	desc = "A simple military decoration."
	icon_state = "ribbon_marksman"
	slot = ACCESSORY_SLOT_MEDAL
	icon = 'maps/torch/icons/obj/solgov-accessory.dmi'
	accessory_icons = list(slot_w_uniform_str = 'maps/torch/icons/mob/solgov-accessory.dmi', slot_wear_suit_str = 'maps/torch/icons/mob/solgov-accessory.dmi')

/obj/item/clothing/accessory/ribbon/solgov/marksman
	name = "marksmanship ribbon"
	desc = "A military decoration awarded to members of the SCG for good marksmanship scores in training. Common in the days of energy weapons."
	icon_state = "ribbon_marksman"

/obj/item/clothing/accessory/ribbon/solgov/peace
	name = "peacekeeping ribbon"
	desc = "A military decoration awarded to members of the SCG for service during a peacekeeping operation."
	icon_state = "ribbon_peace"

/obj/item/clothing/accessory/ribbon/solgov/frontier
	name = "frontier ribbon"
	desc = "A military decoration awarded to members of the SCG for service along the frontier."
	icon_state = "ribbon_frontier"

/obj/item/clothing/accessory/ribbon/solgov/instructor
	name = "instructor ribbon"
	desc = "A military decoration awarded to members of the SCG for service as an instructor."
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

/obj/item/clothing/accessory/solgov/speciality/pilot
	name = "pilot's qualification pin"
	desc = "An iron pin denoting the qualification to fly in the SGDF."
	icon_state = "pin_pilot"

/*****
badges
*****/
/obj/item/clothing/accessory/badge/solgov
	name = "master solgov badge"
	icon = 'maps/torch/icons/obj/solgov-accessory.dmi'
	accessory_icons = list(slot_w_uniform_str = 'maps/torch/icons/mob/solgov-accessory.dmi', slot_wear_suit_str = 'maps/torch/icons/mob/solgov-accessory.dmi')

/obj/item/clothing/accessory/badge/solgov/security
	name = "security forces badge"
	desc = "A silver law enforcement badge. Stamped with the words 'Master at Arms'."
	icon_state = "silverbadge"
	slot_flags = SLOT_TIE
	badge_string = "Sol Central Government"

/obj/item/clothing/accessory/badge/solgov/tags
	name = "dog tags"
	desc = "Plain identification tags made from a durable metal. Stamped with a variety of informational details."
	gender = PLURAL
	icon_state = "tags"
	badge_string = "Sol Central Government"
	slot_flags = SLOT_MASK | SLOT_TIE

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
	icon = 'maps/torch/icons/obj/solgov-accessory.dmi'
	accessory_icons = list(slot_w_uniform_str = 'maps/torch/icons/mob/solgov-accessory.dmi', slot_wear_suit_str = 'maps/torch/icons/mob/solgov-accessory.dmi')

/obj/item/clothing/accessory/armband/solgov/mp
	name = "military police brassard"
	desc = "An armlet, worn by the crew to display which department they're assigned to. This one is black with white letters MP."
	icon_state = "mpband"

/obj/item/clothing/accessory/armband/solgov/ma
	name = "master at arms brassard"
	desc = "An armlet, worn by the crew to display which department they're assigned to. This one is white with navy blue letters MA."
	icon_state = "maband"

/obj/item/weapon/storage/box/armband
	name = "box of spare military police armbands"
	desc = "A box full of security armbands. For use in emergencies when provisional security personnel are needed."
	startswith = list(/obj/item/clothing/accessory/armband/solgov/mp = 5)

/*****************
armour attachments
*****************/
/obj/item/clothing/accessory/armor/tag/solgov
	name = "\improper SCG Flag"
	desc = "An emblem depicting the Sol Central Government's flag."
	icon_override = 'maps/torch/icons/obj/solgov-accessory.dmi'
	icon = 'maps/torch/icons/obj/solgov-accessory.dmi'
	accessory_icons = list(slot_tie_str = 'maps/torch/icons/mob/solgov-accessory.dmi', slot_w_uniform_str = 'maps/torch/icons/mob/solgov-accessory.dmi', slot_wear_suit_str = 'maps/torch/icons/mob/solgov-accessory.dmi')
	icon_state = "solflag"
	slot = ACCESSORY_SLOT_ARMOR_M

/obj/item/clothing/accessory/armor/tag/solgov/ec
	name = "\improper Expeditionary Corps crest"
	desc = "An emblem depicting the crest of the SCG Expeditionary Corps."
	icon_state = "ecflag"

/obj/item/clothing/accessory/armor/tag/solgov/sec
	name = "\improper POLICE tag"
	desc = "An armor tag with the word POLICE printed in silver lettering on it."
	icon_state = "sectag"

/obj/item/clothing/accessory/armor/tag/solgov/com
	name = "\improper SCG tag"
	desc = "An armor tag with the words SOL CENTRAL GOVERNMENT printed in gold lettering on it."
	icon_state = "comtag"

/obj/item/clothing/accessory/armor/tag/solgov/com/sec
	name = "\improper POLICE tag"
	desc = "An armor tag with the words POLICE printed in gold lettering on it."
	icon_state = "comsectag"

/obj/item/clothing/accessory/armor/helmcover/blue/sol
	name = "peacekeeper helmet cover"
	desc = "A fabric cover for armored helmets. This one is in SCG peacekeeper colors."

/**************
department tags
**************/
/obj/item/clothing/accessory/solgov/department
	name = "department insignia"
	desc = "Insignia denoting assignment to a department. These appear blank."
	icon_state = "dept_exped"
	on_rolled = list("down" = "none")
	slot = ACCESSORY_SLOT_DEPT

/obj/item/clothing/accessory/solgov/department/command
	name = "command insignia"
	desc = "Insignia denoting assignment to the command department. These fit Expeditionary Corps uniforms."
	color = "#e5ea4f"

/obj/item/clothing/accessory/solgov/department/command/fleet
	icon_state = "dept_fleet"
	desc = "Insignia denoting assignment to the command department. These fit Fleet uniforms."
	on_rolled = list("rolled" = "dept_fleet_sleeves", "down" = "none")

/obj/item/clothing/accessory/solgov/department/command/marine
	icon_state = "dept_marine"
	desc = "Insignia denoting assignment to the command department. These fit Marine Corps uniforms."
	on_rolled = list("down" = "none")

/obj/item/clothing/accessory/solgov/department/engineering
	name = "engineering insignia"
	desc = "Insignia denoting assignment to the engineering department. These fit Expeditionary Corps uniforms."
	color = "#ff7f00"

/obj/item/clothing/accessory/solgov/department/engineering/fleet
	icon_state = "dept_fleet"
	desc = "Insignia denoting assignment to the engineering department. These fit Fleet uniforms."
	on_rolled = list("rolled" = "dept_fleet_sleeves", "down" = "none")

/obj/item/clothing/accessory/solgov/department/engineering/marine
	icon_state = "dept_marine"
	desc = "Insignia denoting assignment to the engineering department. These fit Marine Corps uniforms."
	on_rolled = list("down" = "none")

/obj/item/clothing/accessory/solgov/department/security
	name = "security insignia"
	desc = "Insignia denoting assignment to the security department. These fit Expeditionary Corps uniforms."
	color = "#bf0000"

/obj/item/clothing/accessory/solgov/department/security/fleet
	icon_state = "dept_fleet"
	desc = "Insignia denoting assignment to the security department. These fit Fleet uniforms."
	on_rolled = list("rolled" = "dept_fleet_sleeves", "down" = "none")

/obj/item/clothing/accessory/solgov/department/security/marine
	icon_state = "dept_marine"
	desc = "Insignia denoting assignment to the security department. These fit Marine Corps uniforms."
	on_rolled = list("down" = "none")

/obj/item/clothing/accessory/solgov/department/medical
	name = "medical insignia"
	desc = "Insignia denoting assignment to the medical department. These fit Expeditionary Corps uniforms."
	color = "#4c9ce4"

/obj/item/clothing/accessory/solgov/department/medical/fleet
	icon_state = "dept_fleet"
	desc = "Insignia denoting assignment to the medical department. These fit Fleet uniforms."
	on_rolled = list("rolled" = "dept_fleet_sleeves", "down" = "none")

/obj/item/clothing/accessory/solgov/department/medical/marine
	icon_state = "dept_marine"
	desc = "Insignia denoting assignment to the medical department. These fit Marine Corps uniforms."
	on_rolled = list("down" = "none")

/obj/item/clothing/accessory/solgov/department/supply
	name = "supply insignia"
	desc = "Insignia denoting assignment to the supply department. These fit Expeditionary Corps uniforms."
	color = "#bb9042"

/obj/item/clothing/accessory/solgov/department/supply/fleet
	icon_state = "dept_fleet"
	desc = "Insignia denoting assignment to the supply department. These fit Fleet uniforms."
	on_rolled = list("rolled" = "dept_fleet_sleeves", "down" = "none")

/obj/item/clothing/accessory/solgov/department/supply/marine
	icon_state = "dept_marine"
	desc = "Insignia denoting assignment to the supply department. These fit Marine Corps uniforms."
	on_rolled = list("down" = "none")

/obj/item/clothing/accessory/solgov/department/service
	name = "service insignia"
	desc = "Insignia denoting assignment to the service department. These fit Expeditionary Corps uniforms."
	color = "#6eaa2c"

/obj/item/clothing/accessory/solgov/department/service/fleet
	icon_state = "dept_fleet"
	desc = "Insignia denoting assignment to the service department. These fit Fleet uniforms."
	on_rolled = list("rolled" = "dept_fleet_sleeves", "down" = "none")

/obj/item/clothing/accessory/solgov/department/service/marine
	icon_state = "dept_marine"
	desc = "Insignia denoting assignment to the service department. These fit Marine Corps uniforms."
	on_rolled = list("down" = "none")

/obj/item/clothing/accessory/solgov/department/exploration
	name = "exploration insignia"
	desc = "Insignia denoting assignment to the exploration department. These fit Expeditionary Corps uniforms."
	color = "#68099e"

/obj/item/clothing/accessory/solgov/department/exploration/fleet
	icon_state = "dept_fleet"
	desc = "Insignia denoting assignment to the exploration department. These fit Fleet uniforms."
	on_rolled = list("rolled" = "dept_fleet_sleeves", "down" = "none")

/obj/item/clothing/accessory/solgov/department/exploration/marine
	icon_state = "dept_marine"
	desc = "Insignia denoting assignment to the exploration department. These fit Marine Corps uniforms."
	on_rolled = list("down" = "none")

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

/obj/item/clothing/accessory/solgov/rank/get_fibers()
	return null

/obj/item/clothing/accessory/solgov/rank/ec
	name = "explorer ranks"
	desc = "Insignia denoting rank of some kind. These appear blank."
	icon_state = "ecrank_e1"
	on_rolled = list("down" = "none")

/obj/item/clothing/accessory/solgov/rank/ec/enlisted
	name = "ranks (E-1 apprentice explorer)"
	desc = "Insignia denoting the rank of Apprentice Explorer."
	icon_state = "ecrank_e1"

/obj/item/clothing/accessory/solgov/rank/ec/enlisted/e2
	name = "ranks (E-2 explorer)"
	desc = "Insignia denoting the rank of Explorer."
	icon_state = "ecrank_e2"

/obj/item/clothing/accessory/solgov/rank/ec/enlisted/e4
	name = "ranks (E-4 senior explorer)"
	desc = "Insignia denoting the rank of Senior Explorer."
	icon_state = "ecrank_e4"

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

/************
ranks - fleet
************/
/obj/item/clothing/accessory/solgov/rank/fleet
	name = "naval ranks"
	desc = "Insignia denoting naval rank of some kind. These appear blank."
	icon_state = "fleetrank"
	on_rolled = list("down" = "none")

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted
	name = "ranks (E-1 crewman recruit)"
	desc = "Insignia denoting the rank of Crewman Recruit."
	icon_state = "fleetrank_enlisted"

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e2
	name = "ranks (E-2 crewman apprentice)"
	desc = "Insignia denoting the rank of Crewman Apprentice."

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e3
	name = "ranks (E-3 crewman)"
	desc = "Insignia denoting the rank of Crewman."

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e4
	name = "ranks (E-4 petty officer third class)"
	desc = "Insignia denoting the rank of Petty Officer Third Class."

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e5
	name = "ranks (E-5 petty officer second class)"
	desc = "Insignia denoting the rank of Petty Officer Second Class."

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e6
	name = "ranks (E-6 petty officer first class)"
	desc = "Insignia denoting the rank of Petty Officer First Class."

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e7
	name = "ranks (E-7 chief petty officer)"
	desc = "Insignia denoting the rank of Chief Petty Officer."

/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e8
	name = "ranks (E-8 senior chief petty officer)"
	desc = "Insignia denoting the rank of Senior Chief Petty Officer."

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

/obj/item/clothing/accessory/solgov/rank/fleet/officer
	name = "ranks (O-1 ensign)"
	desc = "Insignia denoting the rank of Ensign."
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
	name = "ranks (O-4 lieutenant commander)"
	desc = "Insignia denoting the rank of Lieutenant Commander."

/obj/item/clothing/accessory/solgov/rank/fleet/officer/o5
	name = "ranks (O-5 commander)"
	desc = "Insignia denoting the rank of Commander."

/obj/item/clothing/accessory/solgov/rank/fleet/officer/o6
	name = "ranks (O-6 captain)"
	desc = "Insignia denoting the rank of Captain."
	icon_state = "fleetrank_command"

/obj/item/clothing/accessory/solgov/rank/fleet/flag
	name = "ranks (O-7 commodore)"
	desc = "Insignia denoting the rank of Commodore."
	icon_state = "fleetrank_command"

/obj/item/clothing/accessory/solgov/rank/fleet/flag/o8
	name = "ranks (O-8 rear admiral)"
	desc = "Insignia denoting the rank of Rear Admiral."

/obj/item/clothing/accessory/solgov/rank/fleet/flag/o9
	name = "ranks (O-9 vice admiral)"
	desc = "Insignia denoting the rank of Vice Admiral."

/obj/item/clothing/accessory/solgov/rank/fleet/flag/o10
	name = "ranks (O-10 admiral)"
	desc = "Insignia denoting the rank of Admiral."

/obj/item/clothing/accessory/solgov/rank/fleet/flag/o10_alt
	name = "ranks (O-10 fleet admiral)"
	desc = "Insignia denoting the rank of Fleet Admiral."

/**************
ranks - marines
**************/
/obj/item/clothing/accessory/solgov/rank/marine
	name = "marine ranks"
	desc = "Insignia denoting marine rank of some kind. These appear blank."
	icon_state = "marinerank_enlisted"
	on_rolled = list("down" = "none")

/obj/item/clothing/accessory/solgov/rank/marine/enlisted
	name = "ranks (E-1 private)"
	desc = "Insignia denoting the rank of Private."
	icon_state = "marinerank_enlisted"

/obj/item/clothing/accessory/solgov/rank/marine/enlisted/e2
	name = "ranks (E-2 private first class)"
	desc = "Insignia denoting the rank of Private First Class."

/obj/item/clothing/accessory/solgov/rank/marine/enlisted/e3
	name = "ranks (E-3 lance corporal)"
	desc = "Insignia denoting the rank of Lance Corporal."

/obj/item/clothing/accessory/solgov/rank/marine/enlisted/e4
	name = "ranks (E-4 corporal)"
	desc = "Insignia denoting the rank of Corporal."

/obj/item/clothing/accessory/solgov/rank/marine/enlisted/e5
	name = "ranks (E-5 sergeant)"
	desc = "Insignia denoting the rank of Sergeant."

/obj/item/clothing/accessory/solgov/rank/marine/enlisted/e6
	name = "ranks (E-6 staff sergeant)"
	desc = "Insignia denoting the rank of Staff Sergeant."

/obj/item/clothing/accessory/solgov/rank/marine/enlisted/e7
	name = "ranks (E-7 gunnery sergeant)"
	desc = "Insignia denoting the rank of Gunnery Sergeant."

/obj/item/clothing/accessory/solgov/rank/marine/enlisted/e8
	name = "ranks (E-8 master sergeant)"
	desc = "Insignia denoting the rank of Master Sergeant."

/obj/item/clothing/accessory/solgov/rank/marine/enlisted/e8_alt
	name = "ranks (E-8 first sergeant)"
	desc = "Insignia denoting the rank of First Sergeant."

/obj/item/clothing/accessory/solgov/rank/marine/enlisted/e9
	name = "ranks (E-9 master gunnery sergeant)"
	desc = "Insignia denoting the rank of Master Gunnery Sergeant."

/obj/item/clothing/accessory/solgov/rank/marine/enlisted/e9_alt1
	name = "ranks (E-9 sergeant major)"
	desc = "Insignia denoting the rank of Sergeant Major."

/obj/item/clothing/accessory/solgov/rank/marine/enlisted/e9_alt2
	name = "ranks (E-9 sergeant major of the Marine Corps)"
	desc = "Insignia denoting the rank of Sergeant Major of the Marine Corps."

/obj/item/clothing/accessory/solgov/rank/marine/officer
	name = "ranks (O-1 second lieutenant)"
	desc = "Insignia denoting the rank of Second Lieutenant."
	icon_state = "marinerank_officer"

/obj/item/clothing/accessory/solgov/rank/marine/officer/o2
	name = "ranks (O-2 first lieutenant)"
	desc = "Insignia denoting the rank of First Lieutenant."

/obj/item/clothing/accessory/solgov/rank/marine/officer/o3
	name = "ranks (O-3 captain)"
	desc = "Insignia denoting the rank of Captain."

/obj/item/clothing/accessory/solgov/rank/marine/officer/o4
	name = "ranks (O-4 major)"
	desc = "Insignia denoting the rank of Major."

/obj/item/clothing/accessory/solgov/rank/marine/officer/o5
	name = "ranks (O-5 lieutenant colonel)"
	desc = "Insignia denoting the rank of Lieutenant Colonel."

/obj/item/clothing/accessory/solgov/rank/marine/officer/o6
	name = "ranks (O-6 colonel)"
	desc = "Insignia denoting the rank of Colonel."

/obj/item/clothing/accessory/solgov/rank/marine/flag
	name = "ranks (O-7 brigadier general)"
	desc = "Insignia denoting the rank of Brigadier General."
	icon_state = "marinerank_command"

/obj/item/clothing/accessory/solgov/rank/marine/flag/o8
	name = "ranks (O-8 major general)"
	desc = "Insignia denoting the rank of Major General."

/obj/item/clothing/accessory/solgov/rank/marine/flag/o9
	name = "ranks (O-9 lieutenant general)"
	desc = "Insignia denoting the rank of lieutenant general."

/obj/item/clothing/accessory/solgov/rank/marine/flag/o10
	name = "ranks (O-10 general)"
	desc = "Insignia denoting the rank of General."

/obj/item/clothing/accessory/solgov/rank/marine/flag/o10_alt
	name = "ranks (O-10 commandant of the Marine Corps)"
	desc = "Insignia denoting the rank of Commandant of the Marine Corps."