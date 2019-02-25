/datum/job/submap
	branch = /datum/mil_branch/civilian
	rank =   /datum/mil_rank/civ/civ

/datum/map/torch
	branch_types = list(
		/datum/mil_branch/expeditionary_corps,
		/datum/mil_branch/fleet,
		/datum/mil_branch/civilian,
		/datum/mil_branch/solgov,
		/datum/mil_branch/army
	)

	spawn_branch_types = list(
		/datum/mil_branch/fleet,
		/datum/mil_branch/civilian,
		/datum/mil_branch/solgov
	)

	species_to_branch_whitelist = list(
		/datum/species/diona      = list(),
		/datum/species/nabber     = list(),
		/datum/species/skrell     = list(),
		/datum/species/unathi     = list(/datum/mil_branch/fleet, /datum/mil_branch/civilian),
		/datum/species/vox        = list(),
		/datum/species/adherent   = list()
	)

	species_to_rank_whitelist = list(
		/datum/species/machine = list(
			/datum/mil_branch/expeditionary_corps = list(
				/datum/mil_rank/ec/e3,
				/datum/mil_rank/ec/e5,
				/datum/mil_rank/ec/e7,
				/datum/mil_rank/ec/o1
			),
			/datum/mil_branch/fleet = list(
				/datum/mil_rank/fleet/e1,
				/datum/mil_rank/fleet/e2,
				/datum/mil_rank/fleet/e3,
				/datum/mil_rank/fleet/e4,
				/datum/mil_rank/fleet/e5,
				/datum/mil_rank/fleet/e6,
				/datum/mil_rank/fleet/e7,
				/datum/mil_rank/fleet/o1
			),
			/datum/mil_branch/solgov = list(
				/datum/mil_rank/sol/agent
			)
		),
		/datum/species/skrell = list(
			/datum/mil_branch/expeditionary_corps = list(
				/datum/mil_rank/ec/e3,
				/datum/mil_rank/ec/e5,
				/datum/mil_rank/ec/e7,
				/datum/mil_rank/ec/o1
			)
		),
		/datum/species/unathi = list(
			/datum/mil_branch/expeditionary_corps = list(
				/datum/mil_rank/ec/e3,
				/datum/mil_rank/ec/e5
			)
		)
	)


/*
 *  Branches
 *  ========
 */

/datum/mil_branch/expeditionary_corps
	name = "Xenocorps"
	name_short = "XC"
	email_domain = "Sandros.XC.scg"

	rank_types = list(
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/ec/e5,
		/datum/mil_rank/ec/e7,
		/datum/mil_rank/ec/o1,
		/datum/mil_rank/ec/o3,
		/datum/mil_rank/ec/o5,
		/datum/mil_rank/ec/o6
	)

	spawn_rank_types = list(
		/datum/mil_rank/ec/e3,
		/datum/mil_rank/ec/e5,
		/datum/mil_rank/ec/e7,
		/datum/mil_rank/ec/o1,
		/datum/mil_rank/ec/o3,
		/datum/mil_rank/ec/o5,
		/datum/mil_rank/ec/o6
	)

	assistant_job = /datum/job/crew

	min_skill = list(	SKILL_SCIENCE = SKILL_BASIC,
						SKILL_EVA     = SKILL_BASIC)

/datum/mil_branch/fleet
	name = "Fleet"
	name_short = "TRDF"
	email_domain = "sandros.fleet.mil"

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
		/datum/mil_rank/fleet/o10
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
		/datum/mil_rank/fleet/o1,
		/datum/mil_rank/fleet/o2,
		/datum/mil_rank/fleet/o3,
		/datum/mil_rank/fleet/o4,
		/datum/mil_rank/fleet/o5
	)

	assistant_job = /datum/job/crew
	min_skill = list(	SKILL_HAULING = SKILL_BASIC,
						SKILL_WEAPONS = SKILL_BASIC,
						SKILL_EVA     = SKILL_BASIC)

/datum/mil_branch/army
	name = "Army"
	name_short = "TDA"
	email_domain = "army.mil"

	rank_types = list(
		/datum/mil_rank/army/e1,
		/datum/mil_rank/army/e2,
		/datum/mil_rank/army/e3,
		/datum/mil_rank/army/e4,
		/datum/mil_rank/army/e5,
		/datum/mil_rank/army/e6,
		/datum/mil_rank/army/e7,
		/datum/mil_rank/army/e7_alt,
		/datum/mil_rank/army/e8,
		/datum/mil_rank/army/e8_alt,
		/datum/mil_rank/army/e9,
		/datum/mil_rank/army/e9_alt1,
		/datum/mil_rank/army/e9_alt2,
		/datum/mil_rank/army/o1,
		/datum/mil_rank/army/o2,
		/datum/mil_rank/army/o3,
		/datum/mil_rank/army/o4,
		/datum/mil_rank/army/o5,
		/datum/mil_rank/army/o6,
		/datum/mil_rank/army/o7,
		/datum/mil_rank/army/o8,
		/datum/mil_rank/army/o9,
		/datum/mil_rank/army/o10,
		/datum/mil_rank/army/o10_alt
	)

	assistant_job = /datum/job/crew
	min_skill = list(	SKILL_HAULING = SKILL_ADEPT,
	                    SKILL_WEAPONS = SKILL_BASIC,
	                    SKILL_COMBAT  = SKILL_BASIC)

/datum/mil_branch/civilian
	name = "Civilian"
	name_short = "Civ"
	email_domain = "freemail.net"

	rank_types = list(
		/datum/mil_rank/civ/civ,
		/datum/mil_rank/civ/sv,
		/datum/mil_rank/civ/sc,
		/datum/mil_rank/civ/synthetic
	)

	spawn_rank_types = list(
		/datum/mil_rank/civ/civ,
		/datum/mil_rank/civ/sv,
		/datum/mil_rank/civ/sc,
		/datum/mil_rank/civ/synthetic
	)

/datum/mil_branch/solgov
	name = "Terran Employee"
	name_short = "SAR"
	email_domain = "torch.TAR"

	rank_types = list(
		/datum/mil_rank/sol/gov,
		/datum/mil_rank/sol/agent,
		/datum/mil_rank/sol/scientist
	)

	spawn_rank_types = list(
		/datum/mil_rank/sol/gov,
		/datum/mil_rank/sol/agent,
		/datum/mil_rank/sol/scientist
	)

/datum/mil_branch/terran
	name = "Independent Navy"
	name_short = "ICCGN"
	email_domain = "gilgamesh.navy.mil"

	rank_types = list(
		/datum/mil_rank/terran/e1,
		/datum/mil_rank/terran/e3,
		/datum/mil_rank/terran/e4,
		/datum/mil_rank/terran/e6,
		/datum/mil_rank/terran/e7,
		/datum/mil_rank/terran/e9,
		/datum/mil_rank/terran/e9_alt1,
		/datum/mil_rank/terran/o1,
		/datum/mil_rank/terran/o2,
		/datum/mil_rank/terran/o3,
		/datum/mil_rank/terran/o4,
		/datum/mil_rank/terran/o5,
		/datum/mil_rank/terran/o6,
		/datum/mil_rank/terran/o7,
		/datum/mil_rank/terran/o8,
		/datum/mil_rank/terran/o9,
		/datum/mil_rank/terran/o10
	)
	min_skill = list(	SKILL_HAULING = SKILL_BASIC,
						SKILL_WEAPONS = SKILL_BASIC,
						SKILL_EVA     = SKILL_BASIC)

/datum/mil_rank/grade()
	. = ..()
	if(!sort_order)
		return ""
	if(sort_order <= 10)
		return "E[sort_order]"
	return "O[sort_order - 10]"
/*
 *  Fleet
 *  =====
 */

/datum/mil_rank/fleet/e1
	name = "Recruit"
	name_short = "RCT"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/enlisted, /obj/item/clothing/accessory/solgov/specialty/enlisted)
	sort_order = 1

/datum/mil_rank/fleet/e2
	name = "Recruit Specialist"
	name_short = "RSPEC"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e2, /obj/item/clothing/accessory/solgov/specialty/enlisted)
	sort_order = 2

/datum/mil_rank/fleet/e3
	name = "Petty Officer Third Class"
	name_short = "PO3"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e3, /obj/item/clothing/accessory/solgov/specialty/enlisted)
	sort_order = 3

/datum/mil_rank/fleet/e4
	name = "Petty Officer Second Class"
	name_short = "PO2"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e4, /obj/item/clothing/accessory/solgov/specialty/enlisted)
	sort_order = 4

/datum/mil_rank/fleet/e5
	name = "Petty Officer First Class"
	name_short = "PO1"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e5, /obj/item/clothing/accessory/solgov/specialty/enlisted)
	sort_order = 5

/datum/mil_rank/fleet/e6
	name = "Technical Petty Officer"
	name_short = "TPO"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e6, /obj/item/clothing/accessory/solgov/specialty/enlisted)
	sort_order = 6

/datum/mil_rank/fleet/e7
	name = "Chief Petty Officer"
	name_short = "CPO"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e7, /obj/item/clothing/accessory/solgov/specialty/enlisted)
	sort_order = 7

/datum/mil_rank/fleet/e7_alt1
	name = "Munitions Petty Officer"
	name_short = "MPO"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e7_alt1, /obj/item/clothing/accessory/solgov/specialty/enlisted)
	sort_order = 7

/datum/mil_rank/fleet/e8
	name = "Senior Chief Petty Officer"
	name_short = "SCPO"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e8, /obj/item/clothing/accessory/solgov/specialty/enlisted)
	sort_order = 8

/datum/mil_rank/fleet/e8_alt1
	name = "Chief Munitions Petty Officer"
	name_short = "CMPO"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e8_alt1, /obj/item/clothing/accessory/solgov/specialty/enlisted)
	sort_order = 8

/datum/mil_rank/fleet/e9
	name = "Master Chief Petty Officer"
	name_short = "MCPO"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e9, /obj/item/clothing/accessory/solgov/specialty/enlisted)
	sort_order = 9

/datum/mil_rank/fleet/e9_alt1
	name = "Command Master Chief Petty Officer"
	name_short = "CMCPO"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e9_alt1, /obj/item/clothing/accessory/solgov/specialty/enlisted)
	sort_order = 9

/datum/mil_rank/fleet/e10
	name = "Master Chief Petty Officer of the Navy"
	name_short = "MCPON"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/enlisted/e10, /obj/item/clothing/accessory/solgov/specialty/enlisted)
	sort_order = 9

/datum/mil_rank/fleet/w1
	name = "Warrant Officer 1"
	name_short = "WO1"
	sort_order = -1

/datum/mil_rank/fleet/w2
	name = "Chief Warrant Officer 2"
	name_short = "CWO2"
	sort_order = -2

/datum/mil_rank/fleet/w3
	name = "Chief Warrant Officer 3"
	name_short = "CWO3"
	sort_order = -3

/datum/mil_rank/fleet/w4
	name = "Chief Warrant Officer 4"
	name_short = "CWO4"
	sort_order = -4

/datum/mil_rank/fleet/w5
	name = "Officer Designate"
	name_short = "OffDes"
	sort_order = -5

/datum/mil_rank/fleet/o1
	name = "Cadet"
	name_short = "CDT"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/officer, /obj/item/clothing/accessory/solgov/specialty/officer)
	sort_order = 11

/datum/mil_rank/fleet/o2
	name = "Sub-lieutenant"
	name_short = "SLT"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/officer/o2, /obj/item/clothing/accessory/solgov/specialty/officer)
	sort_order = 12

/datum/mil_rank/fleet/o3
	name = "Principal Lieutenant"
	name_short = "PLT"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/officer/o3, /obj/item/clothing/accessory/solgov/specialty/officer)
	sort_order = 13

/datum/mil_rank/fleet/o4
	name = "Staff Lieutenant"
	name_short = "StLT"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/officer/o4, /obj/item/clothing/accessory/solgov/specialty/officer)
	sort_order = 14

/datum/mil_rank/fleet/o4_alt1
	name = "Sub Commander"
	name_short = "SCdr"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/officer/o4_alt1, /obj/item/clothing/accessory/solgov/specialty/officer)
	sort_order = 14

/datum/mil_rank/fleet/o5
	name = "Commander"
	name_short = "CDR"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/officer/o5, /obj/item/clothing/accessory/solgov/specialty/officer)
	sort_order = 15

/datum/mil_rank/fleet/o6
	name = "Captain"
	name_short = "CAPT"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/officer/o6, /obj/item/clothing/accessory/solgov/specialty/officer)
	sort_order = 16

/datum/mil_rank/fleet/o7
	name = "Marshal Second Class"
	name_short = "MAR2"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/flag, /obj/item/clothing/accessory/solgov/specialty/officer)
	sort_order = 17

/datum/mil_rank/fleet/o8
	name = "Marshal First Class"
	name_short = "MAR1"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/flag/o8, /obj/item/clothing/accessory/solgov/specialty/officer)
	sort_order = 18

/datum/mil_rank/fleet/o9
	name = "Fleet Marshal"
	name_short = "FMar"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/flag/o9, /obj/item/clothing/accessory/solgov/specialty/officer)
	sort_order = 19

/datum/mil_rank/fleet/o10
	name = "Grand Marshal of the Navy"
	name_short = "GMN"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/fleet/flag/o10, /obj/item/clothing/accessory/solgov/specialty/officer)
	sort_order = 20


/*
 *  EC
 *  =====
 */
/datum/mil_rank/ec/e1
	name = "Auxiliary"
	name_short = "AUX"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/ec/enlisted)
	sort_order = 1

/datum/mil_rank/ec/e3
	name = "Legionnaire"
	name_short = "LGN"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/ec/enlisted/e3)
	sort_order = 3

/datum/mil_rank/ec/e5
	name = "Decanus"
	name_short = "DCN"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/ec/enlisted/e5)
	sort_order = 5

/datum/mil_rank/ec/e7
	name = "Tessarius"
	name_short = "TRS"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/ec/enlisted/e7)
	sort_order = 7

/datum/mil_rank/ec/o1
	name = "Aspirant"
	name_short = "ASP"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/ec/officer)
	sort_order = 11

/datum/mil_rank/ec/o3
	name = "Optio"
	name_short = "OPT"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/ec/officer/o3)
	sort_order = 13

/datum/mil_rank/ec/o5
	name = "Centurion"
	name_short = "CNT"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/ec/officer/o5)
	sort_order = 15

/datum/mil_rank/ec/o6
	name = "Legatus"
	name_short = "LGT"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/ec/officer/o6)
	sort_order = 16

/datum/mil_rank/ec/o8
	name = "Legatus Praetore"
	name_short = "LPRT"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/ec/officer/o8)
	sort_order = 16

/*
 *  Army
 *  ====
 */
/datum/mil_rank/army/e1
	name = "Private"
	name_short = "PVT"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/army/enlisted)
	sort_order = 1

/datum/mil_rank/army/e2
	name = "Private First Class"
	name_short = "PFC"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/army/enlisted/e2)
	sort_order = 2

/datum/mil_rank/army/e3
	name = "Corporal"
	name_short = "CPL"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/army/enlisted/e3)
	sort_order = 3

/datum/mil_rank/army/e4
	name = "Sergeant"
	name_short = "SGT"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/army/enlisted/e4)
	sort_order = 4

/datum/mil_rank/army/e5
	name = "Technical Sergeant"
	name_short = "TSGT"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/army/enlisted/e5)
	sort_order = 5

/datum/mil_rank/army/e6
	name = "Senior Technical Sergeant"
	name_short = "TSGT2"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/army/enlisted/e6)
	sort_order = 6

/datum/mil_rank/army/e7
	name = "Command Sergeant"
	name_short = "CSGT"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/army/enlisted/e7)
	sort_order = 7

/datum/mil_rank/army/e7_alt
	name = "Munitions Sergeant"
	name_short = "MSGT"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/army/enlisted/e8_alt)
	sort_order = 7

/datum/mil_rank/army/e8
	name = "Senior Command Sergeant"
	name_short = "CSGT2"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/army/enlisted/e8)
	sort_order = 8

/datum/mil_rank/army/e8_alt
	name = "Senior Munitions Sergeant"
	name_short = "MSGT2"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/army/enlisted/e8_alt)
	sort_order = 8

/datum/mil_rank/army/e9
	name = "Sergeant Major"
	name_short = "SGM"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/army/enlisted/e9)
	sort_order = 9

/datum/mil_rank/army/e9_alt1
	name = "Command Sergeant Major"
	name_short = "CSM"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/army/enlisted/e9_alt1)
	sort_order = 9

/datum/mil_rank/army/e9_alt2
	name = "Sergeant Major of the Army"
	name_short = "SMA"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/army/enlisted/e9_alt2)
	sort_order = 9

/datum/mil_rank/army/o1
	name = "Junior Lieutenant"
	name_short = "JLT"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/army/officer)
	sort_order = 11

/datum/mil_rank/army/o2
	name = "Lieutenant"
	name_short = "LT"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/army/officer/o2)
	sort_order = 12

/datum/mil_rank/army/o3
	name = "Captain"
	name_short = "CPT"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/army/officer/o3)
	sort_order = 13

/datum/mil_rank/army/o4
	name = "Major"
	name_short = "MAJ"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/army/officer/o4)
	sort_order = 14

/datum/mil_rank/army/o5
	name = "Lieutenant Colonel"
	name_short = "LTC"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/army/officer/o5)
	sort_order = 15

/datum/mil_rank/army/o6
	name = "Colonel"
	name_short = "COL"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/army/officer/o6)
	sort_order = 16

/datum/mil_rank/army/o7
	name = "Minor Praetor"
	name_short = "MPRT"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/army/flag)
	sort_order = 17

/datum/mil_rank/army/o8
	name = "Praetor Second Grade"
	name_short = "PRT2"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/army/flag/o8)
	sort_order = 18

/datum/mil_rank/army/o9
	name = "Praetor First Grade"
	name_short = "PRT1"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/army/flag/o9)
	sort_order = 19

/datum/mil_rank/army/o10
	name = "Grand Praetor"
	name_short = "GPRT"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/army/flag/o10)
	sort_order = 20

/datum/mil_rank/army/o10_alt
	name = "Grand Praetor of the Army"
	name_short = "GPTRA"
	accessory = list(/obj/item/clothing/accessory/solgov/rank/army/flag/o10_alt)
	sort_order = 20

/*
 *  Civilians
 *  =========
 */

/datum/mil_rank/civ/civ
	name = "Civilian"

/datum/mil_rank/civ/od
	name = "Off-Duty"

/datum/mil_rank/civ/sv
	name = "Ship Personnel"

/datum/mil_rank/civ/sc
	name = "Ship Command"

/datum/mil_rank/civ/contractor
	name = "Contractor"

/datum/mil_rank/civ/synthetic
	name = "Synthetic"

/*
 *  SolGov Employees
 *  ====== =========
 */

/datum/mil_rank/sol/gov
	name = "SolGov Representative"
	name_short = "SGR"
	accessory = list(/obj/item/clothing/accessory/badge/solgov/representative)

/datum/mil_rank/sol/agent
	name = "OCIE Agent"
	name_short = "AGT"
	accessory = list(/obj/item/clothing/accessory/badge/ocieagent)

/datum/mil_rank/sol/scientist
	name = "Government Scientist"
	name_short = "GOVT"

/*
 *  Terrans
 *  =======
 */

/datum/mil_rank/terran/e1
	name = "Sailor Recruit"
	name_short = "SlrRct"
	accessory = list(/obj/item/clothing/accessory/terran/rank/navy/enlisted)
	sort_order = 1

/datum/mil_rank/terran/e3
	name = "Sailor"
	name_short = "Slr"
	accessory = list(/obj/item/clothing/accessory/terran/rank/navy/enlisted/e3)
	sort_order = 3

/datum/mil_rank/terran/e4
	name = "Bosman"
	name_short = "Bsn"
	accessory = list(/obj/item/clothing/accessory/terran/rank/navy/enlisted/e4)
	sort_order = 4

/datum/mil_rank/terran/e6
	name = "Starszy Bosman"
	name_short = "SBsn"
	accessory = list(/obj/item/clothing/accessory/terran/rank/navy/enlisted/e6)
	sort_order = 6

/datum/mil_rank/terran/e7
	name = "Glavny Starshina"
	name_short = "GStr"
	accessory = list(/obj/item/clothing/accessory/terran/rank/navy/enlisted/e7)
	sort_order = 7

/datum/mil_rank/terran/e9
	name = "Michman"
	name_short = "Mch"
	accessory = list(/obj/item/clothing/accessory/terran/rank/navy/enlisted/e9)
	sort_order = 9

/datum/mil_rank/terran/e9_alt1
	name = "Michman of the Independent Navy"
	name_short = "MchNvy"
	accessory = list(/obj/item/clothing/accessory/terran/rank/navy/enlisted/e9_alt1)
	sort_order = 9

/datum/mil_rank/terran/o1
	name = "Ensign"
	name_short = "ENS"
	accessory = list(/obj/item/clothing/accessory/terran/rank/navy/officer)
	sort_order = 11

/datum/mil_rank/terran/o2
	name = "Leytenant"
	name_short = "Lyt"
	accessory = list(/obj/item/clothing/accessory/terran/rank/navy/officer/o2)
	sort_order = 12

/datum/mil_rank/terran/o3
	name = "Starshy Leytenant"
	name_short = "SLyt"
	accessory = list(/obj/item/clothing/accessory/terran/rank/navy/officer/o3)
	sort_order = 13

/datum/mil_rank/terran/o4
	name = "Corvette-Komandor"
	name_short = "CvtKdr"
	accessory = list(/obj/item/clothing/accessory/terran/rank/navy/officer/o4)
	sort_order = 14

/datum/mil_rank/terran/o5
	name = "Komandor"
	name_short = "Kdr"
	accessory = list(/obj/item/clothing/accessory/terran/rank/navy/officer/o5)
	sort_order = 15

/datum/mil_rank/terran/o6
	name = "Kapitan"
	name_short = "Kpt"
	accessory = list(/obj/item/clothing/accessory/terran/rank/navy/officer/o6)
	sort_order = 16

/datum/mil_rank/terran/o7
	name = "Kontradmiral"
	name_short = "KtrAdm"
	accessory = list(/obj/item/clothing/accessory/terran/rank/navy/flag)
	sort_order = 17

/datum/mil_rank/terran/o8
	name = "Wiceadmiral"
	name_short = "WcAdm"
	accessory = list(/obj/item/clothing/accessory/terran/rank/navy/flag/o8)
	sort_order = 18

/datum/mil_rank/terran/o9
	name = "Admiral"
	name_short = "Adm"
	accessory = list(/obj/item/clothing/accessory/terran/rank/navy/flag/o9)
	sort_order = 19

/datum/mil_rank/terran/o10
	name = "Admiral of the Independent Navy"
	name_short = "AdmNvy"
	accessory = list(/obj/item/clothing/accessory/terran/rank/navy/flag/o10)
	sort_order = 20