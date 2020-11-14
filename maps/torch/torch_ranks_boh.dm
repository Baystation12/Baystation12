// Branch-specific defines
#define UNRESTRICTED /datum/mil_branch/civilian, /datum/mil_branch/fleet
#define SEMIRESTRICTED /datum/mil_branch/marine_corps, /datum/mil_branch/private_security, /datum/mil_branch/soviet

// Rank-specific defines
#define SMC_TROOPERS_ONLY /datum/mil_branch/marine_corps = list(\
	/datum/mil_rank/marine_corps/e1,\
	/datum/mil_rank/marine_corps/e2,\
	/datum/mil_rank/marine_corps/e3,\
	/datum/mil_rank/marine_corps/e4,\
	)
#define SMC_LIMITED_RANKS /datum/mil_branch/marine_corps = list(\
	/datum/mil_rank/marine_corps/e1,\
	/datum/mil_rank/marine_corps/e2,\
	/datum/mil_rank/marine_corps/e3,\
	/datum/mil_rank/marine_corps/e4,\
	/datum/mil_rank/marine_corps/e5,\
	/datum/mil_rank/marine_corps/e6,\
	/datum/mil_rank/marine_corps/e7,\
	/datum/mil_rank/marine_corps/e8,\
	/datum/mil_rank/marine_corps/e8_alt,\
	/datum/mil_rank/marine_corps/e9,\
	/datum/mil_rank/marine_corps/e9_alt,\
	/datum/mil_rank/marine_corps/w1,\
	/datum/mil_rank/marine_corps/w2,\
	/datum/mil_rank/marine_corps/w3,\
	/datum/mil_rank/marine_corps/w4,\
	/datum/mil_rank/marine_corps/w5,\
	/datum/mil_rank/marine_corps/o1,\
	/datum/mil_rank/marine_corps/o2,\
	/datum/mil_rank/marine_corps/o3,\
	)
#define NTEF_ENLISTED_ONLY /datum/mil_branch/fleet = list(\
	/datum/mil_rank/fleet/e1, \
	/datum/mil_rank/fleet/e2, \
	/datum/mil_rank/fleet/e3, \
	/datum/mil_rank/fleet/e4, \
	/datum/mil_rank/fleet/e5, \
	/datum/mil_rank/fleet/e6, \
	/datum/mil_rank/fleet/e7, \
	/datum/mil_rank/fleet/e8, \
	/datum/mil_rank/fleet/e9, \
	/datum/mil_rank/fleet/e9_alt1, \
	)
#define SOLGOV_NO_SFP /datum/mil_branch/solgov = list(\
	/datum/mil_rank/sol/gov, \
	/datum/mil_rank/sol/scientist, \
	)

// Not used so far but will once we have ship
#define GIAF_LIMITED_RANKS /datum/mil_branch/soviet = list(\
		/datum/mil_rank/soviet/e1,\
		/datum/mil_rank/soviet/e1_gnf, \
		/datum/mil_rank/soviet/e2, \
		/datum/mil_rank/soviet/e2_gnf, \
		/datum/mil_rank/soviet/e3, \
		/datum/mil_rank/soviet/e3_gnf, \
		/datum/mil_rank/soviet/e4, \
		/datum/mil_rank/soviet/e4_gnf, \
		/datum/mil_rank/soviet/e5, \
		/datum/mil_rank/soviet/w1, \
		/datum/mil_rank/soviet/o1, \
		/datum/mil_rank/soviet/o1_gnf, \
		/datum/mil_rank/soviet/o2, \
		/datum/mil_rank/soviet/o2_gnf, \
		/datum/mil_rank/soviet/o3, \
		/datum/mil_rank/soviet/o3_gnf, \
		/datum/mil_rank/soviet/o4, \
		/datum/mil_rank/soviet/o4_gnf, \
		/datum/mil_rank/soviet/o5, \
		/datum/mil_rank/soviet/o5_gnf, \
		/datum/mil_rank/soviet/o6, \
		/datum/mil_rank/soviet/o6_gnf, \
		/datum/mil_rank/soviet/o7, \
		/datum/mil_rank/soviet/o7_gnf, \
		/datum/mil_rank/soviet/o8 \
		/datum/mil_rank/soviet/o8_gnf \
)
//
/datum/map/torch
	branch_types = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet,
		/datum/mil_branch/marine_corps,
		/datum/mil_branch/civilian,
		/datum/mil_branch/solgov,
		/datum/mil_branch/private_security,
		/datum/mil_branch/army,
		/datum/mil_branch/alien,
		/datum/mil_branch/skrell_fleet,
		/datum/mil_branch/soviet
	)

	spawn_branch_types = list(
		/datum/mil_branch/fleet,
		/datum/mil_branch/marine_corps,
		/datum/mil_branch/civilian,
		/datum/mil_branch/solgov,
		/datum/mil_branch/private_security,
		/datum/mil_branch/alien,
		/datum/mil_branch/skrell_fleet,
		/datum/mil_branch/soviet
	)

	species_to_branch_blacklist = list(
		/datum/species/human   = list(/datum/mil_branch/alien, /datum/mil_branch/skrell_fleet),
		/datum/species/machine = list(/datum/mil_branch/alien, /datum/mil_branch/skrell_fleet, /datum/mil_branch/soviet),
		/datum/species/vox     = list(
			/datum/mil_branch/expeditionary_corps,
			/datum/mil_branch/fleet,
			/datum/mil_branch/marine_corps,
			/datum/mil_branch/civilian,
			/datum/mil_branch/private_security,
			/datum/mil_branch/solgov,
			/datum/mil_branch/skrell_fleet,
			/datum/mil_branch/soviet
		)
	)

	species_to_branch_whitelist = list(
		/datum/species/diona		= list(UNRESTRICTED, /datum/mil_branch/solgov, /datum/mil_branch/private_security),
		/datum/species/nabber		= list(/datum/mil_branch/civilian),
		/datum/species/skrell		= list(UNRESTRICTED, SEMIRESTRICTED, /datum/mil_branch/solgov, /datum/mil_branch/skrell_fleet),
		/datum/species/unathi		= list(UNRESTRICTED, SEMIRESTRICTED, /datum/mil_branch/solgov),
		/datum/species/unathi/yeosa	= list(UNRESTRICTED, SEMIRESTRICTED, /datum/mil_branch/solgov),
		/datum/species/adherent		= list(/datum/mil_branch/civilian, /datum/mil_branch/solgov),
		/datum/species/custom		= list(UNRESTRICTED, SEMIRESTRICTED, /datum/mil_branch/solgov),
		/datum/species/humanathi	= list(UNRESTRICTED, SEMIRESTRICTED, /datum/mil_branch/solgov),
		/datum/species/tajaran		= list(UNRESTRICTED, SEMIRESTRICTED, /datum/mil_branch/solgov),
 		/datum/species/shapeshifter/promethean	= list(UNRESTRICTED, /datum/mil_branch/solgov, /datum/mil_branch/private_security),
		/datum/species/plasmasans	= list(/datum/mil_branch/civilian, /datum/mil_branch/solgov),
		/datum/species/vox			= list(/datum/mil_branch/alien),
		/datum/species/vox/armalis	= list(/datum/mil_branch/alien)
	)

	species_to_rank_whitelist = list(
		/datum/species/diona		= list(SOLGOV_NO_SFP),
		/datum/species/adherent		= list(SOLGOV_NO_SFP),
		/datum/species/shapeshifter/promethean	= list(SOLGOV_NO_SFP),
		/datum/species/plasmasans	= list(SOLGOV_NO_SFP)
	)

/datum/mil_branch/fleet
	name = "Expeditionary Fleet"
	name_short = "NTEF"
	email_domain = "dagon.nt.exp"

	rank_types = list(
		/datum/mil_rank/fleet/e1,
		/datum/mil_rank/fleet/e2,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/fleet/e5,
		/datum/mil_rank/fleet/e6,
		/datum/mil_rank/fleet/e7,
		/datum/mil_rank/fleet/e8,
		/datum/mil_rank/fleet/e9,
		/datum/mil_rank/fleet/e9_alt1,
		/datum/mil_rank/fleet/e9_alt2,
		/datum/mil_rank/fleet/e9_alt3,
		/datum/mil_rank/fleet/e9_alt4,
		/datum/mil_rank/fleet/w1,
		/datum/mil_rank/fleet/w2,
		/datum/mil_rank/fleet/w3,
		/datum/mil_rank/fleet/w4,
		/datum/mil_rank/fleet/w5,
		/datum/mil_rank/fleet/o1,
		/datum/mil_rank/fleet/o2,
		/datum/mil_rank/fleet/o3,
		/datum/mil_rank/fleet/o4,
		/datum/mil_rank/fleet/o5,
		/datum/mil_rank/fleet/o6,
		/datum/mil_rank/fleet/o7,
		/datum/mil_rank/fleet/o8,
		/datum/mil_rank/fleet/o9,
		/datum/mil_rank/fleet/o10,
		/datum/mil_rank/fleet/o10_alt
	)

	spawn_rank_types = list(
		/datum/mil_rank/fleet/e2,
		/datum/mil_rank/fleet/e3,
		/datum/mil_rank/fleet/e4,
		/datum/mil_rank/fleet/e5,
		/datum/mil_rank/fleet/e6,
		/datum/mil_rank/fleet/e7,
		/datum/mil_rank/fleet/e8,
		/datum/mil_rank/fleet/e9,
		/datum/mil_rank/fleet/e9_alt1,
		/datum/mil_rank/fleet/w1,
		/datum/mil_rank/fleet/w2,
		/datum/mil_rank/fleet/w3,
		/datum/mil_rank/fleet/w4,
		/datum/mil_rank/fleet/w5,
		/datum/mil_rank/fleet/o1,
		/datum/mil_rank/fleet/o2,
		/datum/mil_rank/fleet/o3,
		/datum/mil_rank/fleet/o4,
		/datum/mil_rank/fleet/o5,
		/datum/mil_rank/fleet/o6
	)


	min_skill = list(	SKILL_MEDICAL = SKILL_BASIC,
						SKILL_EVA     = SKILL_BASIC)

/datum/mil_branch/marine_corps
	name = "Solar Marine Corps"
	name_short = "SMC"
	email_domain = "dagon.oorah.mil"

// Uses SCG Army's uniforms, at least for now.
	rank_types = list(
		/datum/mil_rank/marine_corps/e1,
		/datum/mil_rank/marine_corps/e2,
		/datum/mil_rank/marine_corps/e3,
		/datum/mil_rank/marine_corps/e4,
		/datum/mil_rank/marine_corps/e5,
		/datum/mil_rank/marine_corps/e6,
		/datum/mil_rank/marine_corps/e7,
		/datum/mil_rank/marine_corps/e8,
		/datum/mil_rank/marine_corps/e8_alt,
		/datum/mil_rank/marine_corps/e9,
		/datum/mil_rank/marine_corps/e9_alt,
		/datum/mil_rank/marine_corps/e9_alt2,
		/datum/mil_rank/marine_corps/w1,
		/datum/mil_rank/marine_corps/w2,
		/datum/mil_rank/marine_corps/w3,
		/datum/mil_rank/marine_corps/w4,
		/datum/mil_rank/marine_corps/w5,
		/datum/mil_rank/marine_corps/o1,
		/datum/mil_rank/marine_corps/o2,
		/datum/mil_rank/marine_corps/o3,
		/datum/mil_rank/marine_corps/o4,
		/datum/mil_rank/marine_corps/o5,
		/datum/mil_rank/marine_corps/o6,
		/datum/mil_rank/marine_corps/o7,
		/datum/mil_rank/marine_corps/o8,
		/datum/mil_rank/marine_corps/o9,
		/datum/mil_rank/marine_corps/o10
	)

	spawn_rank_types = list(
		/datum/mil_rank/marine_corps/e2,
		/datum/mil_rank/marine_corps/e3,
		/datum/mil_rank/marine_corps/e4,
		/datum/mil_rank/marine_corps/e5,
		/datum/mil_rank/marine_corps/e6,
		/datum/mil_rank/marine_corps/e7,
		/datum/mil_rank/marine_corps/e8,
		/datum/mil_rank/marine_corps/e8_alt,
		/datum/mil_rank/marine_corps/e9,
		/datum/mil_rank/marine_corps/e9_alt,
		/datum/mil_rank/marine_corps/w1,
		/datum/mil_rank/marine_corps/w2,
		/datum/mil_rank/marine_corps/w3,
		/datum/mil_rank/marine_corps/w4,
		/datum/mil_rank/marine_corps/w5,
		/datum/mil_rank/marine_corps/o1,
		/datum/mil_rank/marine_corps/o2,
		/datum/mil_rank/marine_corps/o3,
		/datum/mil_rank/marine_corps/o4,
		/datum/mil_rank/marine_corps/o5,
		/datum/mil_rank/marine_corps/o6
	)

	assistant_job = /datum/job/crew

	min_skill = list(	SKILL_HAULING = SKILL_BASIC,
						SKILL_WEAPONS = SKILL_BASIC,
						SKILL_COMBAT  = SKILL_BASIC)

/*
 *  Fleet (NTEF Override)
 *  =====
 */
/datum/mil_rank/fleet/e1
	name = "Crewman Recruit"
	name_short = "CR"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/enlisted, /obj/item/clothing/accessory/solgov/specialty/enlisted)
	sort_order = 1
	pow_cat = 1

/datum/mil_rank/fleet/e2
	name = "Crewman Apprentice"
	name_short = "CA"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e2, /obj/item/clothing/accessory/solgov/specialty/enlisted)
	sort_order = 2
	pow_cat = 1

/datum/mil_rank/fleet/e3
	name = "Crewman"
	name_short = "CN"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e3, /obj/item/clothing/accessory/solgov/specialty/enlisted)
	sort_order = 3
	pow_cat = 1

/datum/mil_rank/fleet/e4
	name = "Petty Officer Third Class"
	name_short = "PO3"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e4, /obj/item/clothing/accessory/solgov/specialty/enlisted)
	sort_order = 4
	pow_cat = 1

/datum/mil_rank/fleet/e5
	name = "Petty Officer Second Class"
	name_short = "PO2"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e5, /obj/item/clothing/accessory/solgov/specialty/enlisted)
	sort_order = 5
	pow_cat = 2

/datum/mil_rank/fleet/e6
	name = "Petty Officer First Class"
	name_short = "PO1"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e6, /obj/item/clothing/accessory/solgov/specialty/enlisted)
	sort_order = 6
	pow_cat = 2

/datum/mil_rank/fleet/e7
	name = "Chief Petty Officer"
	name_short = "CPO"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e7, /obj/item/clothing/accessory/solgov/specialty/enlisted)
	sort_order = 7
	pow_cat = 2

/datum/mil_rank/fleet/e8
	name = "Senior Chief Petty Officer"
	name_short = "SCPO"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e8, /obj/item/clothing/accessory/solgov/specialty/enlisted)
	sort_order = 8
	pow_cat = 2

/datum/mil_rank/fleet/e9
	name = "Master Chief Petty Officer"
	name_short = "MCPO"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e9, /obj/item/clothing/accessory/solgov/specialty/enlisted)
	sort_order = 9
	pow_cat = 2

/datum/mil_rank/fleet/e9_alt1
	name = "Command Master Chief Petty Officer"
	name_short = "CMCPO"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e9_alt1, /obj/item/clothing/accessory/solgov/specialty/enlisted)
	sort_order = 9
	pow_cat = 2

/datum/mil_rank/fleet/e9_alt2
	name = "Fleet Master Chief Petty Officer"
	name_short = "FLTCM"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e9_alt2, /obj/item/clothing/accessory/solgov/specialty/enlisted)
	sort_order = 9
	pow_cat = 2

/datum/mil_rank/fleet/e9_alt3
	name = "Force Master Chief Petty Officer"
	name_short = "FORCM"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e9_alt3, /obj/item/clothing/accessory/solgov/specialty/enlisted)
	sort_order = 9
	pow_cat = 2

/datum/mil_rank/fleet/e9_alt4
	name = "Master Chief Petty Officer of the Fleet"
	name_short = "MCPOF"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e9_alt4, /obj/item/clothing/accessory/solgov/specialty/enlisted)
	sort_order = 9
	pow_cat = 2

/datum/mil_rank/fleet/w1
	name = "Junior Warrant Officer"
	name_short = "JWO"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/warrant_officer/w1)
	sort_order = 11

/datum/mil_rank/fleet/w2
	name = "Chief Warrant Officer"
	name_short = "CWO"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/warrant_officer/w2)
	sort_order = 12

/datum/mil_rank/fleet/w3
	name = "Senior Chief Warrant Officer"
	name_short = "SCWO"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/warrant_officer/w3)
	sort_order = 13

/datum/mil_rank/fleet/w4
	name = "Master Chief Warrant Officer"
	name_short = "MCWO"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/warrant_officer/w4)
	sort_order = 14

/datum/mil_rank/fleet/w5
	name = "Command Master Chief Warrant Officer"
	name_short = "CMCWO"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/warrant_officer/w5)
	sort_order = 15

/datum/mil_rank/fleet/o1
	name = "Ensign"
	name_short = "ENS"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/officer, /obj/item/clothing/accessory/solgov/specialty/officer)
	sort_order = 16
	pow_cat = 3

/datum/mil_rank/fleet/o2
	name = "Lieutenant Junior-Grade"
	name_short = "LTJG"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/officer/o2, /obj/item/clothing/accessory/solgov/specialty/officer)
	sort_order = 17
	pow_cat = 3

/datum/mil_rank/fleet/o3
	name = "Lieutenant"
	name_short = "LT"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/officer/o3, /obj/item/clothing/accessory/solgov/specialty/officer)
	sort_order = 18
	pow_cat = 3

/datum/mil_rank/fleet/o4
	name = "Lieutenant Commander"
	name_short = "LCDR"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/officer/o4, /obj/item/clothing/accessory/solgov/specialty/officer)
	sort_order = 19
	pow_cat = 4

/datum/mil_rank/fleet/o5
	name = "Commander"
	name_short = "CDR"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/officer/o5, /obj/item/clothing/accessory/solgov/specialty/officer)
	sort_order = 20
	pow_cat = 4

/datum/mil_rank/fleet/o6
	name = "Captain"
	name_short = "CAPT"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/officer/o6, /obj/item/clothing/accessory/solgov/specialty/officer)
	sort_order = 21
	pow_cat = 4

/datum/mil_rank/fleet/o7
	name = "Commodore"
	name_short = "CDRE"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/flag, /obj/item/clothing/accessory/solgov/specialty/officer)
	sort_order = 22
	pow_cat = 5

/datum/mil_rank/fleet/o8
	name = "Rear Admiral"
	name_short = "RADM"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/flag/o8, /obj/item/clothing/accessory/solgov/specialty/officer)
	sort_order = 23
	pow_cat = 5

/datum/mil_rank/fleet/o9
	name = "Vice Admiral"
	name_short = "VADM"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/flag/o9, /obj/item/clothing/accessory/solgov/specialty/officer)
	sort_order = 24
	pow_cat = 5

/datum/mil_rank/fleet/o10
	name = "Admiral"
	name_short = "ADM"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/flag/o10, /obj/item/clothing/accessory/solgov/specialty/officer)
	sort_order = 25
	pow_cat = 5

/datum/mil_rank/fleet/o10_alt
	name = "Fleet Admiral"
	name_short = "FADM"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/flag/o10_alt, /obj/item/clothing/accessory/solgov/specialty/officer)
	sort_order = 25
	pow_cat = 5
/*****/

/*
 *  Marine Corps
 *  ============
 */
/datum/mil_rank/marine_corps/e1
	name = "Private"
	name_short = "Pvt"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/marine_corps/enlisted)
	sort_order = 1
	pow_cat = 1

/datum/mil_rank/marine_corps/e2
	name = "Private First Class"
	name_short = "PFC"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/marine_corps/enlisted/e2)
	sort_order = 2
	pow_cat = 1

/datum/mil_rank/marine_corps/e3
	name = "Lance Corporal"
	name_short = "LCpl"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/marine_corps/enlisted/e3)
	sort_order = 3
	pow_cat = 1

/datum/mil_rank/marine_corps/e4
	name = "Corporal"
	name_short = "Cpl"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/marine_corps/enlisted/e4)
	sort_order = 4
	pow_cat = 1

/datum/mil_rank/marine_corps/e5
	name = "Sergeant"
	name_short = "Sgt"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/marine_corps/enlisted/e5)
	sort_order = 5
	pow_cat = 2

/datum/mil_rank/marine_corps/e6
	name = "Staff Sergeant"
	name_short = "SSgt"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/marine_corps/enlisted/e6)
	sort_order = 6
	pow_cat = 2

/datum/mil_rank/marine_corps/e7
	name = "Gunnery Sergeant"
	name_short = "GySgt"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/marine_corps/enlisted/e7)
	sort_order = 7
	pow_cat = 2

/datum/mil_rank/marine_corps/e8
	name = "Master Sergeant"
	name_short = "MSgt"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/marine_corps/enlisted/e8)
	sort_order = 8
	pow_cat = 2

/datum/mil_rank/marine_corps/e8_alt
	name = "First Sergeant"
	name_short = "1stSg"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/marine_corps/enlisted/e8_alt)
	sort_order = 8
	pow_cat = 2

/datum/mil_rank/marine_corps/e9
	name = "Master Gunnery Sergeant"
	name_short = "MGySgt"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/marine_corps/enlisted/e9)
	sort_order = 9
	pow_cat = 2

/datum/mil_rank/marine_corps/e9_alt
	name = "Sergeant Major"
	name_short = "SgtMaj"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/marine_corps/enlisted/e9_alt)
	sort_order = 9
	pow_cat = 2

/datum/mil_rank/marine_corps/e9_alt2
	name = "Sergeant Major of the Marine Corps"
	name_short = "SMMC"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/marine_corps/enlisted/e9_alt2)
	sort_order = 9
	pow_cat = 2

/datum/mil_rank/marine_corps/w1
	name = "Warrant Officer"
	name_short = "WO"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/marine_corps/warrant_officer/w1)
	sort_order = 11

/datum/mil_rank/marine_corps/w2
	name = "Second Warrant Officer"
	name_short = "SWO"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/marine_corps/warrant_officer/w2)
	sort_order = 12

/datum/mil_rank/marine_corps/w3
	name = "First Warrant Officer"
	name_short = "FWO"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/marine_corps/warrant_officer/w3)
	sort_order = 13

/datum/mil_rank/marine_corps/w4
	name = "Major Warrant Officer"
	name_short = "MWO"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/marine_corps/warrant_officer/w4)
	sort_order = 14

/datum/mil_rank/marine_corps/w5
	name = "General Warrant Officer"
	name_short = "GWO"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/marine_corps/warrant_officer/w5)
	sort_order = 15

/datum/mil_rank/marine_corps/o1
	name = "Second Lieutenant"
	name_short = "2ndLt"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/marine_corps/officer)
	sort_order = 16
	pow_cat = 3

/datum/mil_rank/marine_corps/o2
	name = "First Lieutenant"
	name_short = "1stLt"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/marine_corps/officer/o2)
	sort_order = 17
	pow_cat = 3

/datum/mil_rank/marine_corps/o3
	name = "Captain "
	name_short = "CPT"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/marine_corps/officer/o3)
	sort_order = 18
	pow_cat = 3

// Specially, to avoid two "Capt" on-board.
/datum/mil_rank/marine_corps/o3_alt
	name = "Marine Captain"
	name_short = "M-CPT"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/marine_corps/officer/o3_alt)
	sort_order = 19
	pow_cat = 3

/datum/mil_rank/marine_corps/o3_alt2
	name = "Specialist Captain"
	name_short = "SP-CPT"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/marine_corps/officer/o3_alt2)
	sort_order = 20
	pow_cat = 3

/datum/mil_rank/marine_corps/o4
	name = "Major"
	name_short = "Maj"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/marine_corps/officer/o4)
	sort_order = 21
	pow_cat = 4

/datum/mil_rank/marine_corps/o5
	name = "Lieutenant Colonel"
	name_short = "LtCol"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/marine_corps/officer/o5)
	sort_order = 22
	pow_cat = 4

/datum/mil_rank/marine_corps/o6
	name = "Colonel"
	name_short = "Col"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/marine_corps/officer/o6)
	sort_order = 23
	pow_cat = 4

/datum/mil_rank/marine_corps/o7
	name = "Brigadier General"
	name_short = "BGen"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/marine_corps/flag)
	sort_order = 24
	pow_cat = 5

/datum/mil_rank/marine_corps/o8
	name = "Major General"
	name_short = "MGen"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/marine_corps/flag/o8)
	sort_order = 25
	pow_cat = 5

/datum/mil_rank/marine_corps/o9
	name = "Lieutenant General"
	name_short = "LtGen"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/marine_corps/flag/o9)
	sort_order = 26
	pow_cat = 5

/datum/mil_rank/marine_corps/o10
	name = "General"
	name_short = "Gen"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/marine_corps/flag/o10)
	sort_order = 27
	pow_cat = 5
/*****/

// Addon: Sec Contractors
/datum/mil_branch/private_security
	name = "Security Company"
	name_short = "Sec"
	email_domain = "dagon.sec"

	rank_types = list(
		/datum/mil_rank/private_security/pcrc,
		/datum/mil_rank/private_security/pcrc_agt,
		/datum/mil_rank/private_security/saare
	)

	spawn_rank_types = list(
		/datum/mil_rank/private_security/pcrc,
		/datum/mil_rank/private_security/pcrc_agt,
		/datum/mil_rank/private_security/saare
	)

/datum/mil_rank/private_security/pcrc
	name = "PCRC Contractor"
	name_short = "PCRC"
	pow_cat = 3

// Kind of hacky, to allow usage of PCRC suit via outfit.
/datum/mil_rank/private_security/pcrc_agt
	name = "PCRC Agent"
	name_short = "PCRC-AGT"
	pow_cat = 3

/datum/mil_rank/private_security/saare
	name = "SAARE Operative"
	name_short = "SAARE"
	pow_cat = 3
/*****/
//Currently not in use, will be used later once we get actual ship that can use these

//The Gilgamesh Independent Armed Forces

/datum/mil_branch/soviet
	name = "Gilgamesh Independant Armed Forces"
	name_short = "GIAF"
	email_domain = "dagon.ucg"

//Without designation (Gilgamesh Army/Marine corps), with designation (Gilgamesh National FLeet)

	rank_types = list(
		/datum/mil_rank/soviet/e1,
		/datum/mil_rank/soviet/e1_gnf,
		/datum/mil_rank/soviet/e2,
		/datum/mil_rank/soviet/e2_gnf,
		/datum/mil_rank/soviet/e3,
		/datum/mil_rank/soviet/e3_gnf,
		/datum/mil_rank/soviet/e4,
		/datum/mil_rank/soviet/e4_gnf,
		/datum/mil_rank/soviet/e5,
		/datum/mil_rank/soviet/w1,
		/datum/mil_rank/soviet/o1,
		/datum/mil_rank/soviet/o1_gnf,
		/datum/mil_rank/soviet/o2,
		/datum/mil_rank/soviet/o2_gnf,
		/datum/mil_rank/soviet/o3,
		/datum/mil_rank/soviet/o3_gnf,
		/datum/mil_rank/soviet/o4,
		/datum/mil_rank/soviet/o4_gnf,
		/datum/mil_rank/soviet/o5,
		/datum/mil_rank/soviet/o5_gnf,
		/datum/mil_rank/soviet/o6,
		/datum/mil_rank/soviet/o6_gnf,
		/datum/mil_rank/soviet/o7,
		/datum/mil_rank/soviet/o7_gnf,
		/datum/mil_rank/soviet/o8,
		/datum/mil_rank/soviet/o8_gnf
	)
	spawn_rank_types = list(
		/datum/mil_rank/soviet/e1,
		/datum/mil_rank/soviet/e1_gnf,
		/datum/mil_rank/soviet/e2,
		/datum/mil_rank/soviet/e2_gnf,
		/datum/mil_rank/soviet/e3,
		/datum/mil_rank/soviet/e3_gnf,
		/datum/mil_rank/soviet/e4,
		/datum/mil_rank/soviet/e4_gnf,
		/datum/mil_rank/soviet/e5,
		/datum/mil_rank/soviet/w1,
		/datum/mil_rank/soviet/o1,
		/datum/mil_rank/soviet/o1_gnf,
		/datum/mil_rank/soviet/o2,
		/datum/mil_rank/soviet/o2_gnf,
		/datum/mil_rank/soviet/o3,
		/datum/mil_rank/soviet/o3_gnf,
		/datum/mil_rank/soviet/o4,
		/datum/mil_rank/soviet/o4_gnf,
		/datum/mil_rank/soviet/o5,
		/datum/mil_rank/soviet/o5_gnf,
		/datum/mil_rank/soviet/o6,
		/datum/mil_rank/soviet/o6_gnf,
		/datum/mil_rank/soviet/o7,
		/datum/mil_rank/soviet/o7_gnf,
		/datum/mil_rank/soviet/o8,
		/datum/mil_rank/soviet/o8_gnf
	)
//Gilgamesh National Army (GNA)

/datum/mil_rank/soviet/e1
	name = "Private"
	name_short = "PVT"
	sort_order = 1
	pow_cat = 3

/datum/mil_rank/soviet/e2
	name = "Junior Sergeant"
	name_short = "JSG"
	sort_order = 2
	pow_cat = 3

/datum/mil_rank/soviet/e3
	name = "Sergeant"
	name_short = "SGT"
	sort_order = 3
	pow_cat = 3

/datum/mil_rank/soviet/e4
	name = "Senior Sergeant"
	name_short = "SSG"
	sort_order = 4
	pow_cat = 3

/datum/mil_rank/soviet/e5
	name = "Sergeant Major"
	name_short = "SGM"
	sort_order = 5
	pow_cat = 3

/datum/mil_rank/soviet/w1
	name = "Warrant Officer"
	name_short = "WRO"
	sort_order = 6
	pow_cat = 3

/datum/mil_rank/soviet/o1
	name = "Lieutenant"
	name_short = "LFT"
	sort_order = 7
	pow_cat = 3

/datum/mil_rank/soviet/o2
	name = "Captain"
	name_short = "CPT"
	sort_order = 8
	pow_cat = 3

/datum/mil_rank/soviet/o3
	name = "Major"
	name_short = "MAJ"
	sort_order = 9
	pow_cat = 3

/datum/mil_rank/soviet/o4
	name = "Colonel"
	name_short = "COL"
	sort_order = 10
	pow_cat = 3

/datum/mil_rank/soviet/o5
	name = "Major General"
	name_short = "MJG"
	sort_order = 11
	pow_cat = 3

/datum/mil_rank/soviet/o6
	name = "Colonel General"
	name_short = "COG"
	sort_order = 12
	pow_cat = 3

/datum/mil_rank/soviet/o7
	name = "General"
	name_short = "GEN"
	sort_order = 13
	pow_cat = 3

/datum/mil_rank/soviet/o8
	name = "Marshal"
	name_short = "MAR"
	sort_order = 14
	pow_cat = 3

//Gilgamesh National Fleet (GNF)
/datum/mil_rank/soviet/e1_gnf
	name = "Seaman"
	name_short = "SEA"
	sort_order = 1
	pow_cat = 3

/datum/mil_rank/soviet/e2_gnf
	name = "Leading Seaman"
	name_short = "LSE"
	sort_order = 2
	pow_cat = 3

/datum/mil_rank/soviet/e3_gnf
	name = "Junior Sergeant"
	name_short = "JSG"
	sort_order = 3
	pow_cat = 3

/datum/mil_rank/soviet/e4_gnf
	name = "Sergeant"
	name_short = "SGT"
	sort_order = 4
	pow_cat = 3

/datum/mil_rank/soviet/o1_gnf
	name = "Junior Officer"
	name_short = "JNO"
	sort_order = 7
	pow_cat = 3

/datum/mil_rank/soviet/o2_gnf
	name = "Lieutenant"
	name_short = "LFT"
	sort_order = 8
	pow_cat = 3

/datum/mil_rank/soviet/o3_gnf
	name = "Captain Lieutenant"
	name_short = "CLF"
	sort_order = 9
	pow_cat = 3

/datum/mil_rank/soviet/o4_gnf
	name = "Captain 2nd Class"
	name_short = "CAP2nd"
	sort_order = 10
	pow_cat = 3

/datum/mil_rank/soviet/o5_gnf
	name = "Captain 1st Class"
	name_short = "CAP1st"
	sort_order = 11
	pow_cat = 3

/datum/mil_rank/soviet/o6_gnf
	name = "Vice Admiral"
	name_short = "VAM"
	sort_order = 12
	pow_cat = 3

/datum/mil_rank/soviet/o7_gnf
	name = "Admiral"
	name_short = "ADM"
	sort_order = 13
	pow_cat = 3

/datum/mil_rank/soviet/o8_gnf
	name = "High Admiral"
	name_short = "HAM"
	sort_order = 14
	pow_cat = 3
//
//
// Ends of defines
#undef UNRESTRICTED
#undef SEMIRESTRICTED
#undef SMC_TROOPERS_ONLY
#undef SMC_LIMITED_RANKS
#undef NTEF_ENLISTED_ONLY
#undef SOLGOV_NO_SFP
