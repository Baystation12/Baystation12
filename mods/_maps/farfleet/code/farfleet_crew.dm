#define WEBHOOK_SUBMAP_LOADED_ICCGN	"webhook_submap_ICCGN"

/obj/submap_landmark/joinable_submap/away_iccgn_farfleet
	name = "Pioneer Corps Recon Craft"
	archetype = /singleton/submap_archetype/away_iccgn_farfleet

/singleton/submap_archetype/away_iccgn_farfleet
	descriptor = "ICCG Pioneer Corps Recon Craft"
	map = "Recon Ship"
	crew_jobs = list(
		/datum/job/submap/away_iccgn_farfleet,
		/datum/job/submap/away_iccgn_farfleet/iccgn_captain,
		/datum/job/submap/away_iccgn_farfleet/iccgn_sergeant,
		/datum/job/submap/away_iccgn_farfleet/iccgn_medic,
		/datum/job/submap/away_iccgn_farfleet/iccgn_gunner,
		/datum/job/submap/away_iccgn_farfleet/iccgn_pawn
	)
	call_webhook = WEBHOOK_SUBMAP_LOADED_ICCGN

/decl/submap_archetype/away_iccgn_farfleet/New()
	. = ..()
	GLOB.using_map.map_admin_faxes.Add("Lordania Pioneer Corps Relay")
	for(var/obj/machinery/photocopier/faxmachine/fax in SSmachines.machinery)
		GLOB.admin_departments += "Lordania Pioneer Corps Relay"

/obj/submap_landmark/spawnpoint/away_iccgn_farfleet
	name = "ICCG Droptrooper"
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/submap_landmark/spawnpoint/away_iccgn_farfleet/sergeant
	name = "ICCG Droptrooper Sergeant"

/obj/submap_landmark/spawnpoint/away_iccgn_farfleet/captain
	name = "Pioneer Corps Captain"

/obj/submap_landmark/spawnpoint/away_iccgn_farfleet/iccgn_pawn
	name = "CSS Field Operative"

/obj/submap_landmark/spawnpoint/away_iccgn_farfleet/medic
	name = "Pioneer Corpsman"

/obj/submap_landmark/spawnpoint/away_iccgn_farfleet/gunner
	name = "Senior Technician"

/* ACCESS
 * =======
 */

var/global/const/access_away_iccgn = "ACCESS_ICCGN"
var/global/const/access_away_iccgn_droptroops = "ACCESS_ICCGN_DROPTROOPS"
var/global/const/access_away_iccgn_sergeant = "ACCESS_ICCGN_SERGEANT"
var/global/const/access_away_iccgn_captain = "ACCESS_ICCGN_CAPTAIN"

/datum/access/access_away_iccgn
	id = access_away_iccgn
	desc = "ICCGN Main"
	region = ACCESS_REGION_NONE

/datum/access/access_away_iccgn_droptroops
	id = access_away_iccgn_droptroops
	desc = "ICCGN Droptroops"
	region = ACCESS_REGION_NONE

/datum/access/access_away_iccgn_sergeant
	id = access_away_iccgn_sergeant
	desc = "ICCGN Sergeant"
	region = ACCESS_REGION_NONE

/datum/access/access_away_iccgn_captain
	id = access_away_iccgn_captain
	desc = "ICCGN Captain"
	region = ACCESS_REGION_NONE

/obj/item/card/id/awayiccgn/fleet
	color = COLOR_GRAY40
	detail_color = "#447ab1"
	access = list(access_away_iccgn, access_engine_equip)

/obj/item/card/id/awayiccgn/droptroops
	color = COLOR_GRAY40
	detail_color = "#0018a0"
	access = list(access_away_iccgn, access_away_iccgn_droptroops, access_engine_equip)

/obj/item/card/id/awayiccgn/droptroops/sergeant
	access = list(access_away_iccgn, access_away_iccgn_droptroops, access_away_iccgn_sergeant)
	extra_details = list("goldstripe")

/obj/item/card/id/awayiccgn/fleet/captain
	access = list(access_away_iccgn, access_away_iccgn_droptroops, access_away_iccgn_sergeant, access_away_iccgn_captain, access_engine_equip)
	extra_details = list("goldstripe")

/obj/item/card/id/awayiccgn/fleet/iccgn_pawn
	access = list(access_away_iccgn, access_away_iccgn_droptroops, access_away_iccgn_sergeant, access_away_iccgn_captain, access_engine_equip)
	color = COLOR_SURGERY_BLUE
	extra_details = list("goldstripe")

/* JOBS
 * =======
 */

/datum/job/submap/away_iccgn_farfleet
	title = "Pioneer Corps Trooper"
	total_positions = 2
	outfit_type = /singleton/hierarchy/outfit/job/iccgn/iccgn_droptroops
	allowed_branches = list(/datum/mil_branch/iccgn)
	allowed_ranks = list(/datum/mil_rank/iccgn/or3)
	supervisors = "sergeant"
	loadout_allowed = TRUE
	is_semi_antagonist = TRUE
	info = "Вы просыпаетесь и выходите из криосна, ощущая прохладный воздух на своём лице, а также лёгкую тошноту. \
	Являясь одним из членов экипажа разведывательного корабля Пионерского Корпуса ГКК, вы - член прикоммандированного к нему отряда Космодесантных войск ГКК. \
	По данным бортового компьютера, в данном регионе могут потенциально находиться цели вашей разведывательной экседиции.\
	\
	 Вам крайне нежелательно приближаться к кораблям и станциям с опозновательными знаками, или вступать в огневой контакт с кораблями или войсками ЦПСС без разрешения от командования группировкой. \
	 Исключением являются те ситуации, когда вы атакованы противником, терпите бедствие или на вашем судне аварийная ситуация."
	required_language = LANGUAGE_HUMAN_RUSSIAN
	whitelisted_species = list(SPECIES_HUMAN, SPECIES_IPC)
	min_skill = list(SKILL_COMBAT  = SKILL_BASIC,
					 SKILL_WEAPONS = SKILL_BASIC,
					 SKILL_HAULING = SKILL_BASIC,
					 SKILL_MEDICAL = SKILL_BASIC,
					 SKILL_EVA = SKILL_BASIC)

	access = list(access_away_iccgn, access_away_iccgn_droptroops, access_engine_equip)

/datum/job/submap/away_iccgn_farfleet/iccgn_sergeant
	title = "Pioneer Corps Sergeant"
	total_positions = 1
	outfit_type = /singleton/hierarchy/outfit/job/iccgn/iccgn_sergeant
	supervisors = "Recon captain, Command of the Pioneer Corps , ICCGN"
	minimum_character_age = list(SPECIES_HUMAN = 23)
	ideal_character_age = 25
	allowed_branches = list(/datum/mil_rank/iccgn)
	allowed_ranks = list(/datum/mil_rank/iccgn/or5)
	loadout_allowed = TRUE
	is_semi_antagonist = TRUE
	info = "Вы просыпаетесь и выходите из криосна, ощущая прохладный воздух на своём лице, а также лёгкую тошноту. \
	Являясь одним из членов экипажа разведывательного корабля Пионерского Корпуса ГКК, вы - командир прикоммандированного к нему отряда Космодесантных войск ГКК. \
	По данным бортового компьютера, в данном регионе могут потенциально находиться цели вашей разведывательной экседиции.\
	\
	 Вам крайне нежелательно приближаться к кораблям и станциям с опозновательными знаками, или вступать в огневой контакт с кораблями или войсками ЦПСС без разрешения от командования группировкой. \
	 Исключением являются те ситуации, когда вы атакованы противником, терпите бедствие или на вашем судне аварийная ситуация."
	required_language = LANGUAGE_HUMAN_RUSSIAN
	whitelisted_species = list(SPECIES_HUMAN)
	min_skill = list(SKILL_COMBAT  = SKILL_BASIC,
					 SKILL_WEAPONS = SKILL_BASIC,
					 SKILL_HAULING = SKILL_BASIC,
					 SKILL_MEDICAL = SKILL_BASIC,
					 SKILL_PILOT = SKILL_TRAINED,
					 SKILL_EVA = SKILL_BASIC)


	access = list(access_away_iccgn, access_away_iccgn_droptroops, access_away_iccgn_sergeant, access_engine_equip)

/datum/job/submap/away_iccgn_farfleet/iccgn_captain
	title = "Pioneer Corps Captain"
	total_positions = 1
	outfit_type = /singleton/hierarchy/outfit/job/iccgn/iccgn_captain
	minimum_character_age = list(SPECIES_HUMAN = 36)
	ideal_character_age = 40
	allowed_branches = list(/datum/mil_rank/iccgn)
	allowed_ranks = list(
		/datum/mil_rank/iccgn/of4,
		/datum/mil_rank/iccgn/of5)
	supervisors = "command of the Pioneer Corps , ICCGN"
	loadout_allowed = TRUE
	is_semi_antagonist = TRUE
	info = "Вы просыпаетесь и выходите из криосна, ощущая прохладный воздух на своём лице, а также лёгкую тошноту. \
	Будучи одним из членов экипажа разведывательного корабля Пионерского Корпуса ГКК, вы - капитан разведывательного корабля. \
	По данным бортового компьютера, в данном регионе могут потенциально находиться цели вашей разведывательной экседиции.\
	\
	 Вам крайне нежелательно приближаться к кораблям и станциям с опозновательными знаками, или вступать в огневой контакт с кораблями или войсками ЦПСС без разрешения от командования группировкой. \
	 Исключением являются те ситуации, когда вы атакованы противником, терпите бедствие или на вашем судне аварийная ситуация."
	required_language = LANGUAGE_HUMAN_RUSSIAN
	whitelisted_species = list(SPECIES_HUMAN)
	min_skill = list(SKILL_COMBAT  = SKILL_BASIC,
					 SKILL_WEAPONS = SKILL_BASIC,
					 SKILL_HAULING = SKILL_BASIC,
					 SKILL_MEDICAL = SKILL_BASIC,
					 SKILL_PILOT = SKILL_TRAINED,
					 SKILL_EVA = SKILL_BASIC)

	access = list(access_away_iccgn, access_away_iccgn_droptroops, access_away_iccgn_sergeant, access_away_iccgn_captain, access_engine_equip)


/datum/job/submap/away_iccgn_farfleet/iccgn_medic
	title = "Pioneer Corpsman"
	total_positions = 1
	outfit_type = /singleton/hierarchy/outfit/job/iccgn/iccgn_medic
	minimum_character_age = list(SPECIES_HUMAN = 26)
	ideal_character_age = 30
	allowed_branches = list(/datum/mil_rank/iccgn)
	allowed_ranks = list(
		/datum/mil_rank/iccgn/of1,
		/datum/mil_rank/iccgn/of2,
		/datum/mil_rank/iccgn/of3)
	loadout_allowed = TRUE
	info = "Вы просыпаетесь и выходите из криосна, ощущая прохладный воздух на своём лице, а также лёгкую тошноту. \
	Являясь одним из членов экипажа разведывательного корабля Пионерского Корпуса ГКК, ваша задача состоит в медицинской поддержке экипажа. \
	\
	 Вам крайне нежелательно приближаться к кораблям и станциям с опозновательными знаками, или вступать в огневой контакт с кораблями или войсками ЦПСС без разрешения от командования группировкой. \
	 Исключением являются те ситуации, когда вы атакованы противником, терпите бедствие или на вашем судне аварийная ситуация."
	required_language = LANGUAGE_HUMAN_RUSSIAN
	whitelisted_species = list(SPECIES_HUMAN, SPECIES_IPC)
	is_semi_antagonist = TRUE
	min_skill = list(SKILL_COMBAT  = SKILL_BASIC,
					 SKILL_WEAPONS = SKILL_BASIC,
					 SKILL_HAULING = SKILL_TRAINED,
					 SKILL_MEDICAL = SKILL_EXPERIENCED,
					 SKILL_ANATOMY = SKILL_BASIC,
					 SKILL_CHEMISTRY = SKILL_BASIC,
					 SKILL_EVA = SKILL_BASIC)



	access = list(access_away_iccgn, access_engine_equip)

/datum/job/submap/away_iccgn_farfleet/iccgn_gunner
	title = "Pioneer Corps Technician"
	total_positions = 1
	outfit_type = /singleton/hierarchy/outfit/job/iccgn/iccgn_gunner
	allowed_branches = list(/datum/mil_rank/iccgn)
	allowed_ranks = list(
		/datum/mil_rank/iccgn/of1,
		/datum/mil_rank/iccgn/of2,
		/datum/mil_rank/iccgn/of3)
	minimum_character_age = list(SPECIES_HUMAN = 23)
	ideal_character_age = 27
	supervisors = "captain"
	loadout_allowed = TRUE
	info = "Вы просыпаетесь и выходите из криосна, ощущая прохладный воздух на своём лице, а также лёгкую тошноту. \
	Являясь одним из членов экипажа разведывательного корабля Пионерского Корпуса ГКК, ваша задача состоит в ведении огня из ракетных установок, пилотирования корабля, поддержании работоспособности судна и экипировки экипажа. \
	\
	 Вам крайне нежелательно приближаться к кораблям и станциям с опозновательными знаками, или вступать в огневой контакт с кораблями или войсками ЦПСС без разрешения от командования группировкой. \
	 Исключением являются те ситуации, когда вы атакованы противником,  терпите бедствие или на вашем судне аварийная ситуация."
	required_language = LANGUAGE_HUMAN_RUSSIAN
	whitelisted_species = list(SPECIES_HUMAN, SPECIES_IPC)
	is_semi_antagonist = TRUE
	min_skill = list(SKILL_COMBAT  = SKILL_BASIC,
					 SKILL_WEAPONS = SKILL_BASIC,
					 SKILL_HAULING = SKILL_TRAINED,
					 SKILL_MEDICAL = SKILL_BASIC,
					 SKILL_PILOT = SKILL_TRAINED,
					 SKILL_EVA = SKILL_TRAINED,
					 SKILL_CONSTRUCTION = SKILL_TRAINED,
					 SKILL_ELECTRICAL = SKILL_TRAINED,
					 SKILL_ATMOS  = SKILL_BASIC,
					 SKILL_ENGINES = SKILL_TRAINED,
					 SKILL_DEVICES = SKILL_BASIC)

	access = list(access_away_iccgn, access_engine_equip)

/datum/job/submap/away_iccgn_farfleet/iccgn_pawn
	title = "CSS Field Operative"
	total_positions = 1
	outfit_type = /singleton/hierarchy/outfit/job/iccgn/iccgn_pawn
	minimum_character_age = list(SPECIES_HUMAN = 31)
	ideal_character_age = 40
	allowed_branches = list(/datum/mil_branch/css)
	allowed_ranks = list(/datum/mil_rank/css/fa7)
	supervisors = "chief of 'P' Department, Confederate Security Service"
	psi_faculties = list(PSI_COERCION = PSI_RANK_MASTER)
	loadout_allowed = TRUE
	info = "Вы просыпаетесь и выходите из криосна, ощущая прохладный воздух на своём лице, а также лёгкую тошноту. \
	Вы - сотрдник отдела 'П' Конфедеративной Службы Безопасности, приписанный к кораблю Пионерского Корпуса. \
	По данным бортового компьютера, в данном регионе могут потенциально находиться цели вашей разведывательной экседиции.\
	\
	 Вашей первичной задачей является сбор разведданных об активности корпоративных судов, судов ЦПСС, а также иной активности, которая покажется вам подозрительной. \
	 У вас нет права подниматься на борт судов NanoTrasen или ЦПСС. Помните об этом и не провоцируйте ненужные Конфедерации конфликты. \
	 Исключением являются те ситуации, когда вы атакованы противником, терпите бедствие или на вашем судне аварийная ситуация."
	required_language = LANGUAGE_HUMAN_RUSSIAN
	whitelisted_species = list(SPECIES_HUMAN)
	is_semi_antagonist = TRUE
	min_skill = list(SKILL_BUREAUCRACY = SKILL_TRAINED,
					 SKILL_COMBAT  = SKILL_BASIC,
					 SKILL_WEAPONS = SKILL_BASIC,
					 SKILL_HAULING = SKILL_BASIC,
					 SKILL_MEDICAL = SKILL_BASIC,
					 SKILL_PILOT = SKILL_TRAINED,
					 SKILL_EVA = SKILL_BASIC)

	access = list(access_away_iccgn, access_away_iccgn_droptroops, access_away_iccgn_sergeant, access_away_iccgn_captain, access_engine_equip)


/* OUTFITS
 * =======
 */

#define ICCGN_OUTFIT_JOB_NAME(job_name) ("ICCGN Recon Craft - Job - " + job_name)

/singleton/hierarchy/outfit/job/iccgn
	hierarchy_type = /singleton/hierarchy/outfit/job/iccgn
	uniform = /obj/item/clothing/under/iccgn/utility
	shoes = /obj/item/clothing/shoes/iccgn/utility
	l_ear = /obj/item/device/radio/headset/iccgn
	l_pocket = /obj/item/device/radio
	r_pocket = /obj/item/crowbar/prybar
	suit_store = /obj/item/tank/oxygen
	id_types = list(/obj/item/card/id/awayiccgn/fleet)
	id_slot = slot_wear_id
	pda_type = null
	belt = null
	back = /obj/item/storage/backpack/satchel/leather/navy
	backpack_contents = null
	flags = OUTFIT_EXTENDED_SURVIVAL

/singleton/hierarchy/outfit/job/iccgn/iccgn_droptroops
	name = ICCGN_OUTFIT_JOB_NAME("Droptrooper")
	head = /obj/item/clothing/head/iccgn/beret
	uniform = /obj/item/clothing/under/iccgn/pt
	id_types = list(/obj/item/card/id/awayiccgn/droptroops)
	belt = /obj/item/storage/belt/holster/security/tactical/farfleet
	gloves = /obj/item/clothing/gloves/thick/combat

/singleton/hierarchy/outfit/job/iccgn/iccgn_sergeant
	name = ICCGN_OUTFIT_JOB_NAME("Droptroops Sergeant")
	head = /obj/item/clothing/head/iccgn/beret
	uniform = /obj/item/clothing/under/iccgn/pt
	id_types = list(/obj/item/card/id/awayiccgn/droptroops/sergeant)
	belt = /obj/item/storage/belt/holster/security/tactical/farfleet
	gloves = /obj/item/clothing/gloves/thick/combat

/singleton/hierarchy/outfit/job/iccgn/iccgn_gunner
	name = ICCGN_OUTFIT_JOB_NAME("Senior Technican")
	head = /obj/item/clothing/head/iccgn/service
	uniform = /obj/item/clothing/under/iccgn/utility
	belt = /obj/item/storage/belt/utility/full
	gloves = /obj/item/clothing/gloves/insulated //black

/singleton/hierarchy/outfit/job/iccgn/iccgn_medic
	name = ICCGN_OUTFIT_JOB_NAME("Pioneer Corpsman")
	head = /obj/item/clothing/head/iccgn/service
	uniform = /obj/item/clothing/under/iccgn/utility
	belt = /obj/item/storage/belt/medical/emt
	gloves = /obj/item/clothing/gloves/latex/nitrile

/singleton/hierarchy/outfit/job/iccgn/iccgn_captain
	name = ICCGN_OUTFIT_JOB_NAME("Pioneer Corps Captain")
	head = /obj/item/clothing/head/iccgn/service_command
	uniform = /obj/item/clothing/under/iccgn/service_command
	suit = /obj/item/clothing/suit/iccgn/service_command
	id_types = list(/obj/item/card/id/awayiccgn/fleet/captain)
	shoes = /obj/item/clothing/shoes/iccgn/service
	gloves = /obj/item/clothing/gloves/iccgn/duty
	belt = /obj/item/storage/belt/holster/security/tactical/farfleet

/singleton/hierarchy/outfit/job/iccgn/iccgn_pawn
	name = ICCGN_OUTFIT_JOB_NAME("Eighth Department's Consultant")
	head = /obj/item/clothing/head/iccgn/service
	uniform =  /obj/item/clothing/under/suit_jacket/charcoal
	suit = /obj/item/clothing/suit/iccgn/dress_officer
	id_types = list(/obj/item/card/id/awayiccgn/fleet/iccgn_pawn)
	shoes =    /obj/item/clothing/shoes/dress
	gloves = /obj/item/clothing/gloves/iccgn/duty
	holster =  /obj/item/clothing/accessory/storage/holster/armpit
	belt = /obj/item/storage/belt/holster/security/farfleet/iccgn_pawn

#undef ICCGN_OUTFIT_JOB_NAME
#undef WEBHOOK_SUBMAP_LOADED_ICCGN
