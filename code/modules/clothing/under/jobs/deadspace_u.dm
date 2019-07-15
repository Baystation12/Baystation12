//Dead Space//
/*
 * Command
 */
/obj/item/clothing/under/captain/deadspace
	name = "captain's uniform"
	item_state = "ds_captain"
	worn_state = "ds_captain"
	icon_state = "ds_captain"

/obj/item/clothing/under/first_officer
	name = "first lieutenant's uniform"
	item_state = "ds_firstlieutenant"
	worn_state = "ds_firstlieutenant"
	icon_state = "ds_firstlieutenant"

/obj/item/clothing/under/bridge_officer
	name = "ensign's uniform"
	item_state = "ds_bridgeensign"
	worn_state = "ds_bridgeensign"
	icon_state = "ds_bridgeensign"

/*
 * Medical
 */
/obj/item/clothing/under/chief_medical_officer/deadspace
	name = "chief medical officer's uniform"
	item_state = "ds_chief_med_officer"
	worn_state = "ds_chief_med_officer"
	icon_state = "ds_chief_med_officer"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/medical_doctor
	name = "medical doctor's uniform"
	item_state = "ds_med_doctor"
	worn_state = "ds_med_doctor"
	icon_state = "ds_med_doctor"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/surgeon
	name = "surgeon's uniform"
	item_state = "ds_surgeon"
	worn_state = "ds_surgeon"
	icon_state = "ds_surgeon"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 10, rad = 0)

/*
 * Research
 */
/obj/item/clothing/under/chief_science_officer
	name = "chief science officer's uniform"
	item_state = "ds_chief_sci_officer"
	worn_state = "ds_chief_sci_officer"
	icon_state = "ds_chief_sci_officer"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/research_assistant
	name = "research assistant's uniform"
	item_state = "ds_research_assistant"
	worn_state = "ds_research_assistant"
	icon_state = "ds_research_assistant"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 10, rad = 0)

/*
 * Spare Crew
 */
/obj/item/clothing/under/dsspareishimura1
	name = "crew uniform"
	item_state = "ds_spare1"
	worn_state = "ds_spare1"
	icon_state = "ds_spare1"
	
/obj/item/clothing/under/dsspareishimura2
	name = "crew uniform"
	item_state = "ds_spare2"
	worn_state = "ds_spare2"
	icon_state = "ds_spare2"

/*
 * Mining
 */
/obj/item/clothing/under/miner/deadspace
	name = "miner's overalls"
	item_state = "ds_miner"
	worn_state = "ds_miner"
	icon_state = "ds_miner"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS
	
/*
 * Security
 */
/obj/item/clothing/under/security/ds_securityundersuit
	name = "security jumpsuit"
	item_state = "ds_securityjumpsuit"
	worn_state = "ds_securityjumpsuit"
	icon_state = "ds_securityjumpsuit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	permeability_coefficient = 0.25
	armor = list(melee = 50, bullet = 65, laser = 20, energy = 20, bomb = 45, bio = 0, rad = 0)
