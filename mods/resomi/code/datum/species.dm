

/datum/species/resomi
	name = SPECIES_RESOMI
	name_plural = "Resomii"
	description = "Раса пернатых хищников, которые развивались на холодном мире, почти \
	за пределами зоны Златовласки. Крайне хрупкие, они выработали охотничьи навыки \
	в которых особое внимание уделялось уничтожению добычи без ущерба для себя. Они являются \
	развитой культурой, находящаяся в хороших отношениях с Скрелами и людьми.."

	min_age = 15
	max_age = 45
	hidden_from_codex = FALSE
	health_hud_intensity = 3

	blood_color = "#d514f7"
	flesh_color = "#5f7bb0"
	base_color = "#001144"
	tail = "resomitail"
	tail_hair = "feathers"
	strength = STR_HIGH
	breath_pressure = 12

	move_trail = /obj/decal/cleanable/blood/tracks/paw

	icobase = 			'packs/infinity/icons/mob/human_races/species/resomi/body.dmi'
	deform = 			'packs/infinity/icons/mob/human_races/species/resomi/body.dmi'
	damage_overlays = 	'packs/infinity/icons/mob/human_races/species/resomi/damage_overlay.dmi'
	damage_mask = 		'packs/infinity/icons/mob/human_races/species/resomi/damage_mask.dmi'
	blood_mask = 		'packs/infinity/icons/mob/human_races/species/resomi/blood_mask.dmi'
	preview_icon =		'packs/infinity/icons/mob/human_races/species/resomi/preview.dmi'
	husk_icon = 		'packs/infinity/icons/mob/human_races/species/resomi/husk.dmi'

	slowdown = -0.8 //speed fix?

	darksight_range = 2
	darksight_tint = DARKTINT_GOOD
	flash_mod = 2
	total_health = 150
	brute_mod = 1.35
	burn_mod =  1.35
	metabolism_mod = 2.0
	mob_size = MOB_SMALL
	holder_type = /obj/item/holder
	light_sensitive = 6
	gluttonous = GLUT_TINY
	blood_volume = 280
	hunger_factor = DEFAULT_HUNGER_FACTOR * 1.5
	taste_sensitivity = TASTE_SENSITIVE
	body_temperature = 314.15

	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED | SPECIES_NO_FBP_CONSTRUCTION | SPECIES_NO_FBP_CHARGEN
	appearance_flags = SPECIES_APPEARANCE_HAS_HAIR_COLOR | SPECIES_APPEARANCE_HAS_SKIN_COLOR | SPECIES_APPEARANCE_HAS_EYE_COLOR | SPECIES_APPEARANCE_HAS_A_SKIN_TONE
	bump_flag = MONKEY
	swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	push_flags = MONKEY|SLIME|SIMPLE_ANIMAL|ALIEN

	cold_level_1 = 180
	cold_level_2 = 130
	cold_level_3 = 70
	heat_level_1 = 320
	heat_level_2 = 370
	heat_level_3 = 600
	heat_discomfort_level = 292
	heat_discomfort_strings = list(
		"Вашу кожу покалывает от жары.",
		"Вам жарко.",
		)
	cold_discomfort_level = 200
	cold_discomfort_strings = list(
		"Вы не чувствуете своих лап из-за холода.",
		"Вы чувствуете усталость и чувство холода.",
		"Ваши перья щетинятся от холода.")

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/resomi),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/resomi),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/resomi),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/resomi)
		)

	has_organ = list(
		BP_HEART =    /obj/item/organ/internal/heart,
		BP_LUNGS =    /obj/item/organ/internal/lungs,
		BP_LIVER =    /obj/item/organ/internal/liver/resomi,
		BP_STOMACH =  /obj/item/organ/internal/stomach,
		BP_KIDNEYS =  /obj/item/organ/internal/kidneys/resomi,
		BP_BRAIN =    /obj/item/organ/internal/brain,
		BP_EYES =     /obj/item/organ/internal/eyes/resomi
		)

	unarmed_types = list(
		/datum/unarmed_attack/bite/sharp,
		/datum/unarmed_attack/claws,
		/datum/unarmed_attack/punch,
		/datum/unarmed_attack/stomp/weak
		)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/resomi_sonar_ping,
		/mob/living/proc/toggle_pass_table
		)

	descriptors = list(
		/datum/mob_descriptor/height = -8,
		/datum/mob_descriptor/build = -8
		)

	available_cultural_info = list(
		TAG_CULTURE = list(
			CULTURE_RESOMI_REFUGEE,
			CULTURE_RESOMI_NEWGENERATION,
			//CULTURE_RESOMI_BIRDCAGE,
			CULTURE_RESOMI_EREMUS,
			CULTURE_RESOMI_ASRANDA,
			CULTURE_HUMAN_LUNAPOOR,
			CULTURE_HUMAN_MARTIAN,
			CULTURE_HUMAN_MARSTUN,
			CULTURE_HUMAN_PLUTO,
			CULTURE_HUMAN_BELTER,
			CULTURE_HUMAN_CETII,
			CULTURE_RESOMI_LOSTCOLONYRICH,
			CULTURE_RESOMI_LOSTCOLONYPOOR,
			CULTURE_RESOMI_SKRELL,
			//CULTURE_RESOMI_SAVEEL,
			CULTURE_OTHER
		),
		TAG_HOMEWORLD = list(
			HOME_SYSTEM_RESOMI_BIRDCAGE,
			HOME_SYSTEM_RESOMI_EREMUS,
			HOME_SYSTEM_RESOMI_ASRANDA,
			//HOME_SYSTEM_RESOMI_TIAMATH
			HOME_SYSTEM_LUNA,
			HOME_SYSTEM_MARS,
			HOME_SYSTEM_PLUTO,
			HOME_SYSTEM_CERES,
			HOME_SYSTEM_TAU_CETI,
			HOME_SYSTEM_RESOMI_REFUGEE_COLONY,
			HOME_SYSTEM_RESOMI_LOST_COLONY,
			HOME_SYSTEM_RESOMI_SAVEEL,
			HOME_SYSTEM_RESOMI_RESOBALAK,
			HOME_SYSTEM_RESOMI_HOMELESS,
			HOME_SYSTEM_OTHER
		),
		TAG_FACTION = list(
			FACTION_NANOTRASEN,
			FACTION_FREETRADE,
			FACTION_HEPHAESTUS,
			FACTION_XYNERGY,
			FACTION_EXPEDITIONARY,
			FACTION_CORPORATE,
			FACTION_DAIS,
			FACTION_SKRELL_KRRIGLI,
			FACTION_SKRELL_MED,
			FACTION_SKRELL_FOOD,
			//FACTION_ZENG_HU,
			//FACTION_WARD_TAKAHASHI,
			//FACTION_GRAYSON,
			//FACTION_AERTHER,
			//FACTION_MAJOR_BILL,
			//FACTION_FOCAL_POINT,
			//FACTION_VEY_MED,
			//FACTION_BISHOP,
			//FACTION_SEPTENERGO,
			FACTION_OTHER
		),
		TAG_RELIGION =  list(
			RELIGION_RESOMI_CHOSEN,
			RELIGION_RESOMI_EMPEROR,
			RELIGION_AGNOSTICISM,
			RELIGION_ATHEISM,
			RELIGION_RESOMI_SKIES,
			RELIGION_RESOMI_MOUNTAIN,
			RELIGION_CHRISTIANITY,
			RELIGION_OTHER
		)
	)

/datum/species/resomi/equip_survival_gear(mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/lenses(H), slot_glasses)

/datum/species/resomi/get_surgery_overlay_icon(mob/living/carbon/human/H)
	return 'packs/infinity/icons/mob/human_races/species/resomi/surgery.dmi'

/datum/species/resomi/skills_from_age(age)
	switch(age)
		if(0 to 17)		. = -4
		if(18 to 25)	. = 0
		if(26 to 35)	. = 4
		else			. = 8

/datum/species/resomi
	default_emotes = list(
		/singleton/emote/audible/chuckle/resomi,
		/singleton/emote/audible/cough/resomi,
		/singleton/emote/audible/laugh/resomi,
		/singleton/emote/audible/scream/resomi,
		/singleton/emote/audible/sneeze/resomi,
		)
