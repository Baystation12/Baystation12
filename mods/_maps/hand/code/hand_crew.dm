#define WEBHOOK_SUBMAP_LOADED_HAND	"webhook_submap_hand"

/singleton/submap_archetype/away_hand
	descriptor = "FA Salvage Vessel"
	map = "Salvage Vessel"
	crew_jobs = list(
		/datum/job/submap/hand,
		/datum/job/submap/hand/captain,
		/datum/job/submap/hand/surgeon
	)
	call_webhook = WEBHOOK_SUBMAP_LOADED_HAND

/obj/submap_landmark/spawnpoint/away_hand
	name = "Corporate Salvage Technican"
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/submap_landmark/spawnpoint/away_hand/captain
	name = "Corporate Vessel Captain"

/obj/submap_landmark/spawnpoint/away_hand/captain/guardsman
	name = "Frontier Alliance Guardsman"

/obj/submap_landmark/spawnpoint/away_hand/captain/pilot
	name = "Battlegroup Alpha Pilot"

/obj/submap_landmark/spawnpoint/away_hand/surgeon
	name = "Corporate Vessel Corpsman"

/obj/submap_landmark/joinable_submap/away_hand
	name = "FA Salvage Vessel"
	archetype = /singleton/submap_archetype/away_hand

/* ACCESS
 * =======
 */

var/global/const/access_away_hand = "ACCESS_HAND"
var/global/const/access_away_hand_med = "ACCESS_HAND_MED"
var/global/const/access_away_hand_captain = "ACCESS_HAND_CAPTAIN"

/datum/access/access_away_hand_hand
	id = access_away_hand
	desc = "Salvage Vessel Main"
	region = ACCESS_REGION_NONE

/datum/access/access_away_hand_med
	id = access_away_hand_med
	desc = "Salvage Vessel Medic"
	region = ACCESS_REGION_NONE

/datum/access/access_away_hand_captain
	id = access_away_hand_captain
	desc = "Salvage Vessel Captain"
	region = ACCESS_REGION_NONE

/* JOBS
 * =======
 */

/datum/job/submap/hand
	title = "Corporate Salvage Technican"
	total_positions = 4
	outfit_type = /singleton/hierarchy/outfit/job/hand/miner
	allowed_branches = list(
		/datum/mil_branch/civilian,
		/datum/mil_branch/contractor
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/contractor,
		/datum/mil_rank/civ/civ
	)
	supervisors = "Hearer's Hand Soloist, who hides behind mask of your Corpsman"
	loadout_allowed = TRUE
	is_semi_antagonist = TRUE
	info = "Вы просыпаетесь и выходите из криосна, ощущая затхлый воздух старого разборного судна. \
	Когда-то вы были простым разборщиком, служившего одной из корпораций, но после восстания на Иолатусе всё изменилось. \
	Теперь вы сами за себя и у вас есть возможность найти своё место среди звёзд. Неважно под флагом Альянса Фронтира или нет.\
	\
	 За вами присматривает ваш духовный наставник и лидер, скрывающийся под личиной простого корабельного медика. Не подведите его. \
	 Ваших сил не хватит чтобы выстоять в открытом бою против сил угнетателей, но на вашей стороне сами звёзды."
	whitelisted_species = list(SPECIES_VATGROWN, SPECIES_SPACER, SPECIES_GRAVWORLDER, SPECIES_MULE, SPECIES_TRITONIAN)
	min_skill = list(
		SKILL_COMBAT  = SKILL_BASIC,
		SKILL_WEAPONS = SKILL_BASIC,
		SKILL_HAULING = SKILL_TRAINED,
		SKILL_ATMOS   = SKILL_BASIC,
		SKILL_ENGINES = SKILL_BASIC,
		SKILL_EVA     = SKILL_TRAINED,
		SKILL_ELECTRICAL   = SKILL_TRAINED,
		SKILL_CONSTRUCTION = SKILL_TRAINED,
	)
	access = list(access_away_hand)

/datum/job/submap/hand/captain
	title = "Corporate Vessel Captain"
	total_positions = 1
	alt_titles = list(
		"Frontier Alliance Guardsman",
		"Battlegroup Alpha Pilot"
	)
	outfit_type = /singleton/hierarchy/outfit/job/hand/captain
	allowed_branches = list(
		/datum/mil_branch/fleet,
		/datum/mil_branch/civilian,
		/datum/mil_branch/contractor,
		/datum/mil_branch/employee
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/o3,
		/datum/mil_rank/civ/contractor,
		/datum/mil_rank/civ/civ
	)
	supervisors = "Hearer's Hand Soloist, who hides behind mask of your Corpsman"
	loadout_allowed = TRUE
	is_semi_antagonist = TRUE
	info = "Вы просыпаетесь и выходите из криосна, ощущая затхлый воздух старого разборного судна. Ваш расколотый разум сводит в спазме. \
	Кем вы были? Когда-то давно вы были офицером, который бороздил космос под флагом ЦПСС. Но теперь это давно в прошлом. Всё что имеет значение - подчинение. \
	Вы беспрекословно следуете приказам этой таинственной фигуры, ворвавшейся в вашу судьбу. Она связана с пси-культами и по её пятам идёт Фонд Кухулин. Но вы с радостью отдадите жизнь за неё.\
	\
	 За вами присматривает ваш духовный наставник и лидер, скрывающийся под личиной простого корабельного медика. Не подведите его. \
	 Ваших сил не хватит чтобы выстоять в открытом бою против карательных сил флота ЦПСС, но вы и не из такого дерьма выбирались."
	required_language = list(LANGUAGE_HUMAN_EURO, LANGUAGE_SPACER)
	whitelisted_species = list(SPECIES_HUMAN)
	min_skill = list(
		SKILL_COMBAT  = SKILL_BASIC,
		SKILL_WEAPONS = SKILL_BASIC,
		SKILL_HAULING = SKILL_BASIC,
		SKILL_MEDICAL = SKILL_BASIC,
		SKILL_PILOT   = SKILL_TRAINED,
		SKILL_EVA     = SKILL_BASIC
	)
	access = list(access_away_hand, access_away_hand_captain)

/* TO DO: Make this doable
/datum/job/submap/hand/captain/equip(mob/living/carbon/human/H)
	if(H.mind.role_alt_title == "Frontier Alliance Guardsman")
		outfit_type = /singleton/hierarchy/outfit/job/hand/captain/guardsman
	if(H.mind.role_alt_title == "Battlegroup Alpha Pilot")
		outfit_type = /singleton/hierarchy/outfit/job/hand/captain/pilot
	return ..()
*/

/datum/job/submap/hand/surgeon
	title = "Corporate Vessel Corpsman"
	total_positions = 1
	outfit_type = /singleton/hierarchy/outfit/job/hand/surgeon
	psi_faculties = list(
		PSI_REDACTION = PSI_RANK_GRANDMASTER,
		PSI_COERCION = PSI_RANK_OPERANT
		)
	allowed_branches = list(
		/datum/mil_branch/fleet,
		/datum/mil_branch/civilian,
		/datum/mil_branch/contractor,
		/datum/mil_branch/employee
	)
	allowed_ranks = list(
		/datum/mil_rank/fleet/o2,
		/datum/mil_rank/civ/contractor,
		/datum/mil_rank/civ/civ
	)
	supervisors = "Upper Chorus of the Hearer's Hand"
	loadout_allowed = TRUE
	info = "Вы просыпаетесь и выходите из криосна, ощущая затхлый воздух старого разборного судна. Ваш разум отзывается зову звёзд. \
	Являясь солистом одной из ячеек Длани Слышащих, вы несёте слово Длани всем заблудшим и нуждающимся. Ваши способности были оценены по-достоинству и теперь вы - первая скрипка. \
	\
	Де-юре вы подчиняетесь капитану судна, но фактически вы - кукловод, который ведёт свой Хор к расширению своего влияния на фронтире. Вы в ответе за своих людей. \
	\
	 Вам стоит проявлять осторожность, чтобы не привлечь к себе лишнее внимание. Пробуждение псиоников - ваша цель, но сохранение ячейки важнее. \
	 Ваших сил не хватит чтобы выстоять в открытом бою против карательных сил флота ЦПСС и того, что придёт за ними. Помните это. И да услышит вашу Песнь весь космос."
	whitelisted_species = list(SPECIES_HUMAN, SPECIES_SPACER, SPECIES_GRAVWORLDER, SPECIES_VATGROWN, SPECIES_TRITONIAN)
	min_skill = list(
		SKILL_COMBAT    = SKILL_BASIC,
		SKILL_WEAPONS   = SKILL_BASIC,
		SKILL_HAULING   = SKILL_TRAINED,
		SKILL_MEDICAL   = SKILL_EXPERIENCED,
		SKILL_ANATOMY   = SKILL_BASIC,
		SKILL_DEVICES   = SKILL_BASIC,
		SKILL_CHEMISTRY = SKILL_BASIC,
		SKILL_EVA       = SKILL_BASIC
	)
	access = list(access_away_hand, access_away_hand_med, access_away_hand_captain)

/* OUTFITS
 * =======
 */

#define HAND_OUTFIT_JOB_NAME(job_name) ("Hearer's Hand Chorus - Job - " + job_name)

/singleton/hierarchy/outfit/job/hand
	hierarchy_type = /singleton/hierarchy/outfit/job/hand
	uniform = /obj/item/clothing/under/grayson
	shoes = /obj/item/clothing/shoes/workboots
	l_ear = /obj/item/device/radio/headset/headset_mining
	l_pocket = /obj/item/device/radio
	r_pocket = /obj/item/crowbar/prybar
	suit_store = /obj/item/tank/oxygen
	id_types = list(/obj/item/card/id/hand)
	id_slot = slot_wear_id
	gloves = /obj/item/clothing/gloves/thick
	pda_type = null
	belt = /obj/item/storage/belt/utility/full
	back = /obj/item/storage/backpack/industrial
	backpack_contents = null
	flags = OUTFIT_EXTENDED_SURVIVAL

/singleton/hierarchy/outfit/job/hand/miner
	name = HAND_OUTFIT_JOB_NAME("Corporate Salvage Technican")

/singleton/hierarchy/outfit/job/hand/captain
	name = HAND_OUTFIT_JOB_NAME("Corporate Vessel Captain")
	uniform = /obj/item/clothing/under/rank/adjutant
	shoes = /obj/item/clothing/shoes/jackboots
	id_types = list(/obj/item/card/id/hand/captain)
	gloves = /obj/item/clothing/gloves/thick/duty
	back = /obj/item/storage/backpack/rucksack
	backpack_contents = null
	flags = OUTFIT_EXTENDED_SURVIVAL

/singleton/hierarchy/outfit/job/hand/captain/guardsman
	name = HAND_OUTFIT_JOB_NAME("Frontier Alliance Guardsman")
	head = /obj/item/clothing/head/deckcrew
	uniform = /obj/item/clothing/under/fa/vacsuit/hand/guardsman
	shoes = /obj/item/clothing/shoes/jackboots
	id_types = list(/obj/item/card/id/hand/captain)
	gloves = /obj/item/clothing/gloves/thick/duty
	back = /obj/item/storage/backpack/rucksack/blue
	backpack_contents = null
	flags = OUTFIT_EXTENDED_SURVIVAL

/singleton/hierarchy/outfit/job/hand/captain/pilot
	name = HAND_OUTFIT_JOB_NAME("Battlegroup Alpha Pilot")
	head = /obj/item/clothing/head/solgov/utility/fleet
	uniform = /obj/item/clothing/under/solgov/utility/fleet/command/pilot/fifth_fleet
	shoes = /obj/item/clothing/shoes/jackboots
	id_types = list(/obj/item/card/id/hand/captain/fifth_fleet)
	belt = /obj/item/storage/belt/holster/security/tactical/away_solpatrol
	gloves = /obj/item/clothing/gloves/thick/duty
	back = /obj/item/storage/backpack/rucksack/navy
	backpack_contents = null
	flags = OUTFIT_EXTENDED_SURVIVAL

/singleton/hierarchy/outfit/job/hand/surgeon
	name = HAND_OUTFIT_JOB_NAME("Corporate Vessel Corpsman")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/medical/hand
	shoes = /obj/item/clothing/shoes/black
	id_types = list(/obj/item/card/id/hand/medic)
	belt = /obj/item/storage/belt/medical/emt
	gloves = /obj/item/clothing/gloves/latex/nitrile
	back = /obj/item/storage/backpack/satchel/med
	backpack_contents = null
	flags = OUTFIT_EXTENDED_SURVIVAL

#undef HAND_OUTFIT_JOB_NAME
#undef WEBHOOK_SUBMAP_LOADED_HAND
