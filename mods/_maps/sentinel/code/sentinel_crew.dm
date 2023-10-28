#define WEBHOOK_SUBMAP_LOADED_SOL	"webhook_submap_sol"

/obj/submap_landmark/joinable_submap/away_scg_patrol
	name = "Patrol Ship"
	archetype = /singleton/submap_archetype/away_scg_patrol

/singleton/submap_archetype/away_scg_patrol
	descriptor = "SCGF Patrol Ship"
	map = "Patrol Ship"
	crew_jobs = list(
		/datum/job/submap/patrol/commander,
		/datum/job/submap/patrol/pilot1,
		/datum/job/submap/patrol,
		/datum/job/submap/patrol/captain,
		/datum/job/submap/patrol/surgeon,
		/datum/job/submap/patrol/engineer
	)
	call_webhook = WEBHOOK_SUBMAP_LOADED_SOL

/obj/submap_landmark/spawnpoint/away_patrol
	name = "Army SCGSO Trooper"
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/submap_landmark/spawnpoint/away_patrol/captain
	name = "Army SCGSO Leader"

/obj/submap_landmark/spawnpoint/away_patrol/commander
	name = "Fleet Commander"

/obj/submap_landmark/spawnpoint/away_patrol/pilot1
	name = "Fleet Pilot"

/obj/submap_landmark/spawnpoint/away_patrol/surgeon
	name = "Fleet Corpsman"

/obj/submap_landmark/spawnpoint/away_patrol/engineer
	name = "Fleet Technician"

/* ACCESS
 * =======
 */

var/global/const/access_away_cavalry = "ACCESS_CAVALRY"
var/global/const/access_away_cavalry_fleet_armory = "ACCESS_CAVALRY_EMERG_ARMORY"
var/global/const/access_away_cavalry_ops = "ACCESS_CAVALRY_OPS"
var/global/const/access_away_cavalry_pilot = "ACCESS_CAVALRY_PILOT"
var/global/const/access_away_cavalry_captain = "ACCESS_CAVALRY_CAPTAIN"
var/global/const/access_away_cavalry_commander = "ACCESS_CAVALRY_COMMANDER"

/datum/access/access_away_cavalry_patrol
	id = access_away_cavalry
	desc = "SPS Main"
	region = ACCESS_REGION_NONE

/datum/access/access_away_cavalry_ops
	id = access_away_cavalry_ops
	desc = "SPS Army"
	region = ACCESS_REGION_NONE

/datum/access/access_away_cavalry_captain
	id = access_away_cavalry_captain
	desc = "SPS Captain"
	region = ACCESS_REGION_NONE

/datum/access/access_away_patrol_commander
	id = access_away_cavalry_commander
	desc = "SPS Commander"
	region = ACCESS_REGION_NONE

/* JOBS
 * =======
 */

/datum/job/submap/patrol
	title = "Army SCGSO Trooper"
	total_positions = 2
	outfit_type = /singleton/hierarchy/outfit/job/patrol/army_ops
	minimum_character_age = list(SPECIES_HUMAN = 23)
	ideal_character_age = 25
	allowed_branches = list(/datum/mil_branch/scga)
	allowed_ranks = list(
		/datum/mil_rank/scga/e5
		)
	supervisors = "Army Captain"
	loadout_allowed = TRUE
	is_semi_antagonist = TRUE
	info = "Вы просыпаетесь и выходите из криосна, ощущая прохладный воздух на своём лице, а также лёгкую тошноту. \
	Являясь одним из членов экипажа патрульного корабля 5-го флота ЦПСС, вы - член группы 'Буря', разведовательных войск СОЦПСС. \
	По данным бортового компьютера, поступал сигнал о неизвестных нападениях в этом регионе.\
	\
	 Вам крайне нежелательно приближаться к кораблям и станциям с опозновательными знаками без разрешения от командования группировкой. \
	 Исключением являются те ситуации, когда вы терпите бедствие или на вашем судне аварийная ситуация."
	required_language = LANGUAGE_HUMAN_EURO
	whitelisted_species = list(SPECIES_HUMAN)
	min_skill = list(SKILL_COMBAT  = SKILL_BASIC,
					 SKILL_WEAPONS = SKILL_BASIC,
					 SKILL_HAULING = SKILL_BASIC,
					 SKILL_MEDICAL = SKILL_BASIC,
					 SKILL_EVA = SKILL_BASIC)
	access = list(access_away_cavalry, access_away_cavalry_ops)

/datum/job/submap/patrol/captain
	title = "Army SCGSO Leader"
	total_positions = 1
	outfit_type = /singleton/hierarchy/outfit/job/patrol/captain
	minimum_character_age = list(SPECIES_HUMAN = 25)
	ideal_character_age = 27
	allowed_branches = list(/datum/mil_branch/scga)
	allowed_ranks = list(/datum/mil_rank/scga/o3)
	supervisors = "Lieutenant Commander, Command of the Battle Group Bravo of the 5th fleet, SCGDF"
	loadout_allowed = TRUE
	is_semi_antagonist = TRUE
	info = "Вы просыпаетесь и выходите из криосна, ощущая прохладный воздух на своём лице, а также лёгкую тошноту. \
	Являясь одним из членов соединения, входящего в экипаж патрульного корабля 5-го флота ЦПСС, ваша задача состоит в руководстве группой 'Буря', разведовательных войск СОЦПСС. \
	По данным бортового компьютера, поступал сигнал о неизвестных нападениях в этом регионе.\
	\
	 Вам крайне нежелательно приближаться к кораблям и станциям с опозновательными знаками без разрешения от командования группировкой. \
	 Исключением являются те ситуации, когда вы терпите бедствие или на вашем судне аварийная ситуация."
	required_language = LANGUAGE_HUMAN_EURO
	whitelisted_species = list(SPECIES_HUMAN)
	min_skill = list(
		SKILL_COMBAT  = SKILL_BASIC,
		SKILL_WEAPONS = SKILL_BASIC,
		SKILL_HAULING = SKILL_BASIC,
		SKILL_MEDICAL = SKILL_BASIC,
		SKILL_EVA     = SKILL_BASIC
	)
	access = list(access_away_cavalry, access_away_cavalry_ops, access_away_cavalry_fleet_armory, access_away_cavalry_captain)

/datum/job/submap/patrol/commander
	title = "Fleet Commander"
	total_positions = 1
	outfit_type = /singleton/hierarchy/outfit/job/patrol/commander
	minimum_character_age = list(SPECIES_HUMAN = 30)
	ideal_character_age = 33
	allowed_branches = list(/datum/mil_branch/fleet)
	allowed_ranks = list(/datum/mil_rank/fleet/o4)
	supervisors = "Command of the Battle Group Bravo of the 5th fleet, SCGDF"
	loadout_allowed = TRUE
	info = "Вы просыпаетесь и выходите из криосна, ощущая прохладный воздух на своём лице, а также лёгкую тошноту. \
	Являясь одним из членов экипажа патрульного корабля 5-го флота ЦПСС, ваша задача состоит в патруле и разведке данного сектора. \
	По данным бортового компьютера, поступал сигнал о неизвестных нападениях в этом регионе.\
	\
	 Вам крайне нежелательно приближаться к кораблям и станциям с опозновательными знаками без разрешения от командования группировкой. \
	 Исключением являются те ситуации, когда вы терпите бедствие или на вашем судне аварийная ситуация."
	min_skill = list(
		SKILL_COMBAT  = SKILL_BASIC,
		SKILL_WEAPONS = SKILL_BASIC,
		SKILL_HAULING = SKILL_BASIC,
		SKILL_MEDICAL = SKILL_BASIC,
		SKILL_PILOT   = SKILL_TRAINED,
		SKILL_EVA     = SKILL_BASIC
	)
	access = list(access_away_cavalry, access_away_cavalry_ops, access_away_cavalry_pilot, access_away_cavalry_fleet_armory, access_away_cavalry_commander)

/datum/job/submap/patrol/pilot1
	title = "Fleet Pilot"
	total_positions = 1
	outfit_type = /singleton/hierarchy/outfit/job/patrol/pilot1
	minimum_character_age = list(SPECIES_HUMAN = 23)
	ideal_character_age = 25
	allowed_branches = list(/datum/mil_branch/fleet)
	allowed_ranks = list(/datum/mil_rank/fleet/o2)
	supervisors = "Lieutenant Commander"
	loadout_allowed = TRUE
	info = "Вы просыпаетесь и выходите из криосна, ощущая прохладный воздух на своём лице, а также лёгкую тошноту. \
	Являясь одним из членов экипажа патрульного корабля 5-го флота ЦПСС, ваша задача состоит в пилотировании и руководством экипажа. \
	По данным бортового компьютера, поступал сигнал о неизвестных нападениях в этом регионе.\
	\
	 Вам крайне нежелательно приближаться к кораблям и станциям с опозновательными знаками без разрешения от командования группировкой. \
	 Исключением являются те ситуации, когда вы терпите бедствие или на вашем судне аварийная ситуация."
	min_skill = list(
		SKILL_COMBAT  = SKILL_BASIC,
		SKILL_WEAPONS = SKILL_BASIC,
		SKILL_HAULING = SKILL_BASIC,
		SKILL_MEDICAL = SKILL_BASIC,
		SKILL_PILOT   = SKILL_TRAINED,
		SKILL_EVA     = SKILL_BASIC
	)
	access = list(access_away_cavalry, access_away_cavalry_pilot, access_away_cavalry_fleet_armory)

/datum/job/submap/patrol/surgeon
	title = "Fleet Corpsman"
	total_positions = 1
	outfit_type = /singleton/hierarchy/outfit/job/patrol/surgeon
	minimum_character_age = list(SPECIES_HUMAN = 26)
	ideal_character_age = 30
	allowed_branches = list(/datum/mil_branch/fleet)
	allowed_ranks = list(/datum/mil_rank/fleet/o1)
	supervisors = "Sub-Lieutenant, Lieutenant Commander"
	loadout_allowed = TRUE
	info = "Вы просыпаетесь и выходите из криосна, ощущая прохладный воздух на своём лице, а также лёгкую тошноту. \
	Являясь одним из членов экипажа патрульного корабля 5-го флота ЦПСС, ваша задача состоит в медицинской поддержке экипажа. \
	\
	Хоть вы и являетесь офицером, в ваши обязанности НЕ входит командование экипажем - это всего лишь показатель вашего профессионализма в медицинской сфере. \
	\
	 Вам крайне нежелательно приближаться к кораблям и станциям с опозновательными знаками без разрешения от командования группировкой. \
	 Исключением являются те ситуации, когда вы терпите бедствие или на вашем судне аварийная ситуация."
	min_skill = list(
		SKILL_COMBAT    = SKILL_BASIC,
		SKILL_WEAPONS   = SKILL_BASIC,
		SKILL_HAULING   = SKILL_TRAINED,
		SKILL_MEDICAL   = SKILL_EXPERIENCED,
		SKILL_ANATOMY   = SKILL_BASIC,
		SKILL_CHEMISTRY = SKILL_BASIC,
		SKILL_EVA       = SKILL_BASIC
	)
	access = list(access_away_cavalry)

/datum/job/submap/patrol/engineer
	title = "Fleet Technician"
	total_positions = 1
	outfit_type = /singleton/hierarchy/outfit/job/patrol/engineer
	minimum_character_age = list(SPECIES_HUMAN = 26)
	ideal_character_age = 28
	allowed_branches = list(/datum/mil_branch/fleet)
	allowed_ranks = list(/datum/mil_rank/fleet/e6)
	supervisors = "Sub-Lieutenant, Lieutenant Commander"
	loadout_allowed = TRUE
	info = "Вы просыпаетесь и выходите из криосна, ощущая прохладный воздух на своём лице, а также лёгкую тошноту. \
	Являясь одним из членов экипажа патрульного корабля 5-го флота ЦПСС, ваша задача состоит в поддержании работоспособности судна и экипировки экипажа. \
	\
	 Вам крайне нежелательно приближаться к кораблям и станциям с опозновательными знаками без разрешения от командования группировкой. \
	 Исключением являются те ситуации, когда вы терпите бедствие или на вашем судне аварийная ситуация."
	min_skill = list(
		SKILL_COMBAT  = SKILL_BASIC,
		SKILL_WEAPONS = SKILL_BASIC,
		SKILL_HAULING = SKILL_TRAINED,
		SKILL_MEDICAL = SKILL_BASIC,
		SKILL_ATMOS   = SKILL_BASIC,
		SKILL_ENGINES = SKILL_TRAINED,
		SKILL_DEVICES = SKILL_BASIC,
		SKILL_EVA     = SKILL_TRAINED,
		SKILL_ELECTRICAL   = SKILL_TRAINED,
		SKILL_CONSTRUCTION = SKILL_TRAINED,
	)
	access = list(access_away_cavalry)


/* BRANCH & RANKS
 * =======
 */

/datum/mil_branch/fleet
	name = "SCG Fleet"
	name_short = "SCGF"
	email_domain = "fleet.mil"
	rank_types = list(
		/datum/mil_rank/fleet/e6,
		/datum/mil_rank/fleet/o1,
		/datum/mil_rank/fleet/o2,
		/datum/mil_rank/fleet/o4,
		/datum/mil_rank/fleet/o6,
		/datum/mil_rank/fleet/o7,
		/datum/mil_rank/fleet/o8
	)
	spawn_rank_types = list(
		/datum/mil_rank/fleet/e6,
		/datum/mil_rank/fleet/o1,
		/datum/mil_rank/fleet/o2,
		/datum/mil_rank/fleet/o4,
		/datum/mil_rank/fleet/o6,
		/datum/mil_rank/fleet/o7,
		/datum/mil_rank/fleet/o8
	)

/datum/mil_rank/grade()
	. = ..()
	if(!sort_order)
		return ""
	if(sort_order <= 10)
		return "E[sort_order]"
	return "O[sort_order - 10]"

/datum/mil_rank/fleet/e6
	name = "Petty Officer First Class"
	name_short = "PO1"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e6, /obj/item/clothing/accessory/solgov/specialty/enlisted)
	sort_order = 6

/datum/mil_rank/fleet/o1
	name = "Ensign"
	name_short = "ENS"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/officer, /obj/item/clothing/accessory/solgov/specialty/officer)
	sort_order = 11

/datum/mil_rank/fleet/o2
	name = "Sub-lieutenant"
	name_short = "SLT"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/officer/o2, /obj/item/clothing/accessory/solgov/specialty/officer)
	sort_order = 12

/datum/mil_rank/fleet/o4
	name = "Lieutenant Commander"
	name_short = "LCDR"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/officer/o4, /obj/item/clothing/accessory/solgov/specialty/officer)
	sort_order = 14

/datum/mil_rank/fleet/o6
	name = "Captain"
	name_short = "CAPT"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/officer/o6, /obj/item/clothing/accessory/solgov/specialty/officer)
	sort_order = 16

/datum/mil_rank/fleet/o7
	name = "Commodore"
	name_short = "CDRE"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/flag, /obj/item/clothing/accessory/solgov/specialty/officer)
	sort_order = 17

/datum/mil_rank/fleet/o8
	name = "Rear Admiral"
	name_short = "RADM"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/flag/o8, /obj/item/clothing/accessory/solgov/specialty/officer)
	sort_order = 18

/datum/mil_branch/scga
	name = "SCG Army"
	name_short = "SCGA"
	email_domain = "army.mil"
	rank_types = list(
		/datum/mil_rank/scga/e5,
		/datum/mil_rank/scga/o3
	)
	spawn_rank_types = list(
		/datum/mil_rank/scga/e5,
		/datum/mil_rank/scga/o3
	)

/datum/mil_rank/scga/e5
	name = "Sergeant"
	name_short = "SGT"
	accessory = list(/obj/item/clothing/accessory/scga_badge/enlisted)
	sort_order = 5

/datum/mil_rank/scga/o3
	name = "Captain"
	name_short = "CAPT"
	accessory = list(/obj/item/clothing/accessory/scga_badge/officer)
	sort_order = 13

/* OUTFITS
 * =======
 */

#define PATROL_OUTFIT_JOB_NAME(job_name) ("SCG Patrol Ship - Job - " + job_name)

/singleton/hierarchy/outfit/job/patrol
	hierarchy_type = /singleton/hierarchy/outfit/job/patrol
	uniform = /obj/item/clothing/under/solgov/utility/fleet/away_solpatrol
	shoes = /obj/item/clothing/shoes/dutyboots
	l_ear = /obj/item/device/radio/headset/away_scg_patrol
	l_pocket = /obj/item/device/radio
	r_pocket = /obj/item/crowbar/prybar
	suit_store = /obj/item/tank/oxygen
	id_types = list(/obj/item/card/id/awaycavalry/fleet)
	id_slot = slot_wear_id
	pda_type = null
	belt = null
	back = /obj/item/storage/backpack/satchel/leather/navy
	backpack_contents = null
	flags = OUTFIT_EXTENDED_SURVIVAL

/singleton/hierarchy/outfit/job/patrol/army_ops
	name = PATROL_OUTFIT_JOB_NAME("Ops")
	head = /obj/item/clothing/head/scga/utility
	uniform = /obj/item/clothing/under/scga/utility
	id_types = list(/obj/item/card/id/awaycavalry/ops)
	gloves = /obj/item/clothing/gloves/thick/combat

/singleton/hierarchy/outfit/job/patrol/captain
	name = PATROL_OUTFIT_JOB_NAME("Captain")
	head = /obj/item/clothing/head/scga/utility
	uniform = /obj/item/clothing/under/scga/utility
	id_types = list(/obj/item/card/id/awaycavalry/ops/captain)
	gloves = /obj/item/clothing/gloves/thick/combat

/singleton/hierarchy/outfit/job/patrol/engineer
	name = PATROL_OUTFIT_JOB_NAME("Technician")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/engineering/away_solpatrol
	belt = /obj/item/storage/belt/holster/security/tactical/away_solpatrol
	gloves = /obj/item/clothing/gloves/insulated

/singleton/hierarchy/outfit/job/patrol/surgeon
	name = PATROL_OUTFIT_JOB_NAME("Doctor")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/medical/away_solpatrol
	belt = /obj/item/storage/belt/holster/security/tactical/away_solpatrol
	gloves = /obj/item/clothing/gloves/latex/nitrile

/singleton/hierarchy/outfit/job/patrol/commander
	name = PATROL_OUTFIT_JOB_NAME("Lieutenant Commander")
	head = /obj/item/clothing/head/beret/solgov/fleet/branch/fifth
	uniform = /obj/item/clothing/under/solgov/utility/fleet/officer/command/commander/away_solpatrol
	belt = /obj/item/storage/belt/holster/security/tactical/away_solpatrol
	id_types = list(/obj/item/card/id/awaycavalry/fleet/commander)
	gloves = /obj/item/clothing/gloves/thick/duty/solgov/cmd

/singleton/hierarchy/outfit/job/patrol/pilot1
	name = PATROL_OUTFIT_JOB_NAME("Sub-Lieutenant")
	head = /obj/item/clothing/head/beret/solgov/fleet/branch/fifth
	uniform = /obj/item/clothing/under/solgov/utility/fleet/officer/pilot1/away_solpatrol
	belt = /obj/item/storage/belt/holster/security/tactical/away_solpatrol
	gloves = /obj/item/clothing/gloves/thick/duty

/singleton/hierarchy/outfit/job/patrol/fleet_command
	name = PATROL_OUTFIT_JOB_NAME("Senior Officer")
	head = /obj/item/clothing/head/solgov/dress/fleet/command
	uniform = /obj/item/clothing/under/solgov/service/fleet
	belt = /obj/item/storage/belt/holster/general/away_solpatrol
	shoes = /obj/item/clothing/shoes/dress
	suit = /obj/item/clothing/suit/storage/solgov/service/fleet/command/away_solpatrol
	r_pocket = /obj/item/card/id/syndicate
	id_types = list(/obj/item/card/id/centcom/station)
	id_pda_assignment = "5th Fleet Senior Officer"

#undef PATROL_OUTFIT_JOB_NAME
#undef WEBHOOK_SUBMAP_LOADED_SOL
