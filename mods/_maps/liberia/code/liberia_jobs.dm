// Submap datum and archetype.
/datum/job/submap/merchant_leader
	title = "Merchant"

	info = "Вы свободные торговцы, которых в поисках выгоды занесло в неизведанные дали. Путешествуйте, торгуйте, make profit! \
	\
	Посещать неизведанные обьекты крайне небезопасно. Вы торговцы, а не мусорщики, ваша смерть не принесет прибыли, не лезьте куда не надо."
	total_positions = 1
	spawn_positions = 1
	supervisors = "невидимой рукой рынка"
	selection_color = "#515151"
	ideal_character_age = 30
	minimal_player_age = 7
	create_record = FALSE
	outfit_type = /singleton/hierarchy/outfit/job/liberia/merchant/leader
	whitelisted_species = null
	blacklisted_species = list(SPECIES_VOX, SPECIES_ALIEN, SPECIES_GOLEM, SPECIES_ADHERENT, SPECIES_NABBER) // SPECIES_MANTID_GYNE, SPECIES_MANTID_ALATE, SPECIES_MONARCH_WORKER, SPECIES_MONARCH_QUEEN Not yet... not yet...

	latejoin_at_spawnpoints = TRUE

	access = list(
		access_merchant
	)

	announced = FALSE
	min_skill = list(
		SKILL_FINANCE = SKILL_TRAINED,
		SKILL_PILOT   = SKILL_BASIC
	)
	give_psionic_implant_on_join = FALSE
	skill_points = 24
	economic_power = 10 // We use splitted from station account system, which need lover economic_power to not break things

/datum/job/submap/merchant_leader/equip(mob/living/carbon/human/H)
	return ..()

/datum/job/submap/merchant/is_position_available()
	. = ..()
	if(. && requires_supervisor)
		for(var/mob/M in GLOB.player_list)
			if(!M.client || !M.mind || !M.mind.assigned_job || M.mind.assigned_job.title != requires_supervisor)
				continue
			var/datum/job/submap/merchant_leader/merchant_job = M.mind.assigned_job
			if(istype(merchant_job) && merchant_job.owner == owner)
				return TRUE
		return FALSE

/datum/job/submap/merchant
	title = "Merchant Assistant"

	var/requires_supervisor = "Merchant"
	total_positions = 5
	spawn_positions = 5
	supervisors = "Торговцем"
	selection_color = "#515151"
	ideal_character_age = 20
	minimal_player_age = 0
	create_record = FALSE
	whitelisted_species = null
	blacklisted_species = list(SPECIES_VOX, SPECIES_ALIEN, SPECIES_GOLEM, ) // SPECIES_MANTID_GYNE, SPECIES_MANTID_ALATE, SPECIES_MONARCH_WORKER, SPECIES_MONARCH_QUEEN Not yet... not yet...
	alt_titles = list(
		"Merchant Security" = /singleton/hierarchy/outfit/job/liberia/merchant/security,
		"Merchant Engineer" = /singleton/hierarchy/outfit/job/liberia/merchant/engineer,
		"Merchant Medical" = /singleton/hierarchy/outfit/job/liberia/merchant/doctor
	)
	outfit_type = /singleton/hierarchy/outfit/job/liberia/merchant

	latejoin_at_spawnpoints = TRUE
	access = list(
		access_merchant
	)
	announced = FALSE
	min_skill = list(
		SKILL_FINANCE = SKILL_BASIC
	)

	max_skill = list(
		SKILL_COMBAT  = SKILL_MAX,
	    SKILL_WEAPONS = SKILL_MAX
	)

	give_psionic_implant_on_join = FALSE

	economic_power = 4
	skill_points = 24

/datum/job/submap/merchant/equip(mob/living/carbon/human/H)
	outfit_type =  H.mind.role_alt_title!="Merchant Assistant" ? alt_titles[H.mind.role_alt_title] : outfit_type
	. = ..()

// Spawn points.
/obj/submap_landmark/spawnpoint/liberia
	name = "Merchant"

/obj/submap_landmark/spawnpoint/liberia/trainee
	name = "Merchant Assistant"

/obj/submap_landmark/spawnpoint/liberia/security
 	name = "Merchant Security"

/obj/submap_landmark/spawnpoint/liberia/engineer
 	name = "Merchant Engineer"

/obj/submap_landmark/spawnpoint/liberia/doctor
 	name = "Merchant Medical"

/singleton/hierarchy/outfit/job/liberia/merchant
	name = OUTFIT_JOB_NAME("Merchant Assistant")
	uniform = /obj/item/clothing/under/suit_jacket/tan
	shoes = /obj/item/clothing/shoes/brown
	id_types = list(/obj/item/card/id/liberia/merchant)

/singleton/hierarchy/outfit/job/liberia/merchant/proc/get_briefcase_money(mob/living/carbon/human/H, datum/job/J)
	. = 0.25 * rand(2.5, 5) * J.economic_power

	var/culture_mod =   0
	var/culture_count = 0
	for(var/token in H.cultural_info)
		var/singleton/cultural_info/culture = H.get_cultural_value(token)
		if(culture && !isnull(culture.economic_power))
			culture_count++
			culture_mod += culture.economic_power
	if(culture_count)
		culture_mod /= culture_count
	. *= culture_mod

	. *= GLOB.using_map.salary_modifier
	. *= 1 + 0.4 * H.get_skill_value(SKILL_FINANCE)/(SKILL_MAX - SKILL_MIN)
	. = round(.)

/singleton/hierarchy/outfit/job/liberia/merchant/post_equip(mob/living/carbon/human/H)
	..()
	var/datum/job/J = SSjobs.get_by_title(H.job)
	var/money_to_put = get_briefcase_money(H, J)
	var/obj/item/storage/secure/briefcase/sec_briefcase = new(H)
	for(var/obj/item/briefcase_item in sec_briefcase)
		qdel(briefcase_item)
	for(var/i = money_to_put, i > 0, i--)
		new /obj/item/spacecash/bundle/c2500(sec_briefcase)
	H.equip_to_slot_or_del(sec_briefcase, slot_l_hand)

/singleton/hierarchy/outfit/job/liberia/merchant/security
	name = OUTFIT_JOB_NAME("Merchant Security")
	uniform = /obj/item/clothing/under/syndicate/tacticool
	suit = /obj/item/clothing/suit/armor/pcarrier/light
	shoes = /obj/item/clothing/shoes/jackboots
	id_pda_assignment = "Merchant Security"

/singleton/hierarchy/outfit/job/liberia/merchant/engineer
	name = OUTFIT_JOB_NAME("Merchant Engineer")
	uniform = /obj/item/clothing/under/rank/engineer
	shoes = /obj/item/clothing/shoes/jackboots
	id_pda_assignment = "Merchant Engineer"

/singleton/hierarchy/outfit/job/liberia/merchant/doctor
	name = OUTFIT_JOB_NAME("Merchant Medical")
	uniform = /obj/item/clothing/under/color/white
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	shoes = /obj/item/clothing/shoes/dress
	id_pda_assignment = "Merchant Medical"

/singleton/hierarchy/outfit/job/liberia/merchant/leader
	name = OUTFIT_JOB_NAME("Merchant Leader - liberia")
	uniform = /obj/item/clothing/under/suit_jacket/charcoal
	shoes = /obj/item/clothing/shoes/laceup
	id_types = list(/obj/item/card/id/liberia/merchant/leader)

/obj/item/card/id/liberia/merchant
	desc = "An identification card issued to Merchants."
	job_access_type = /datum/job/submap/merchant
	color = COLOR_OFF_WHITE
	detail_color = COLOR_BEIGE

/obj/item/card/id/liberia/merchant/leader
	desc = "An identification card issued to Merchant Leaders, indicating their right to sell and buy goods."
	job_access_type = /datum/job/submap/merchant_leader
