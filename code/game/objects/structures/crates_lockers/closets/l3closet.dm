/obj/structure/closet/l3closet
	name = "level-3 biohazard suit closet"
	desc = "It's a storage unit for level-3 biohazard gear."
	closet_appearance = /decl/closet_appearance/bio

/obj/structure/closet/l3closet/general/WillContain()
	return list(
		/obj/item/clothing/suit/bio_suit/general,
		/obj/item/clothing/head/bio_hood/general,
		/obj/item/clothing/mask/gas/half,
		/obj/item/tank/oxygen_emergency_extended,
	)

/obj/structure/closet/l3closet/general/multi/WillContain()
	return MERGE_ASSOCS_WITH_NUM_VALUES(..(), list(
		/obj/item/clothing/head/bio_hood/general = 5,
		/obj/item/clothing/mask/gas/half = 5,
		/obj/item/clothing/suit/bio_suit/general = 5,
		/obj/item/tank/oxygen_emergency_extended = 5
	))


/obj/structure/closet/l3closet/virology
	closet_appearance = /decl/closet_appearance/bio/virology

/obj/structure/closet/l3closet/virology/WillContain()
	return list(
		/obj/item/clothing/suit/bio_suit/virology,
		/obj/item/clothing/head/bio_hood/virology,
		/obj/item/clothing/mask/gas,
		/obj/item/tank/oxygen
	)

/obj/structure/closet/l3closet/security
	closet_appearance = /decl/closet_appearance/bio/security

/obj/structure/closet/l3closet/security/WillContain()
	return list(
		/obj/item/clothing/suit/bio_suit/security,
		/obj/item/clothing/head/bio_hood/security,
		/obj/item/clothing/mask/gas/half,
		/obj/item/tank/oxygen_emergency_extended
	)

/obj/structure/closet/l3closet/janitor
	closet_appearance = /decl/closet_appearance/bio/janitor

/obj/structure/closet/l3closet/janitor/WillContain()
	return list(
		/obj/item/clothing/suit/bio_suit/janitor,
		/obj/item/clothing/head/bio_hood/janitor,
		/obj/item/clothing/mask/gas/half,
		/obj/item/tank/oxygen_emergency_extended
	)

/obj/structure/closet/l3closet/scientist
	closet_appearance = /decl/closet_appearance/bio/science


/obj/structure/closet/l3closet/scientist/WillContain()
	return list(
		/obj/item/clothing/suit/bio_suit/scientist,
		/obj/item/clothing/head/bio_hood/scientist,
		/obj/item/clothing/mask/gas,
		/obj/item/tank/oxygen_emergency_double,
	)

/obj/structure/closet/l3closet/scientist/multi/WillContain()
	return MERGE_ASSOCS_WITH_NUM_VALUES(..(), list(
		/obj/item/clothing/head/bio_hood/scientist = 5,
		/obj/item/clothing/suit/bio_suit/scientist = 5,
		/obj/item/clothing/mask/gas = 5,
		/obj/item/tank/oxygen_emergency_double = 5,
	))

/obj/structure/closet/l3closet/command
	closet_appearance = /decl/closet_appearance/bio/command


/obj/structure/closet/l3closet/command/WillContain()
	return list(
		/obj/item/clothing/suit/bio_suit/cmo,
		/obj/item/clothing/head/bio_hood/cmo,
		/obj/item/clothing/mask/gas/half,
		/obj/item/tank/oxygen_emergency_extended
	)
