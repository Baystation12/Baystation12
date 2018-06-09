/obj/item/clothing/under/solgov
	name = "master solgov uniform"
	desc = "You shouldn't be seeing this."
	icon = 'maps/torch/icons/obj/solgov-under.dmi'
	item_icons = list(slot_w_uniform_str = 'maps/torch/icons/mob/solgov-under.dmi')
	armor = list(melee = 5, bullet = 0, laser = 5, energy = 5, bomb = 0, bio = 5, rad = 5)
	siemens_coefficient = 0.8

//PT
/obj/item/clothing/under/solgov/pt
	name = "pt uniform"
	desc = "Shorts! Shirt! Miami! Sexy!"
	icon_state = "miami"
	worn_state = "miami"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/solgov/pt/expeditionary
	name = "expeditionary pt uniform"
	desc = "A baggy shirt bearing the seal of the SCG Expeditionary Corps and some dorky looking blue shorts."
	icon_state = "expeditionpt"
	worn_state = "expeditionpt"

/obj/item/clothing/under/solgov/pt/fleet
	name = "fleet pt uniform"
	desc = "A pair of black shorts and two tank tops, seems impractical. Looks good though."
	icon_state = "fleetpt"
	worn_state = "fleetpt"

/obj/item/clothing/under/solgov/pt/oac
	name = "orbital assault pt uniform"
	desc = "Does NOT leave much to the imagination."
	icon_state = "marinept"
	worn_state = "marinept"


//Utility

/obj/item/clothing/under/solgov/utility
	name = "utility uniform"
	desc = "A comfortable turtleneck and black utility trousers."
	icon_state = "blackutility"
	item_state = "bl_suit"
	worn_state = "blackutility"
	sprite_sheets = list(
		SPECIES_TAJARA = 'icons/mob/species/tajaran/uniform.dmi'
		)

/obj/item/clothing/under/solgov/utility/expeditionary
	name = "expeditionary uniform"
	desc = "The utility uniform of the SCG Expeditionary Corps, made from biohazard resistant material. This one has silver trim."
	icon_state = "blackutility_crew"
	worn_state = "blackutility_crew"
	sprite_sheets = list(
		SPECIES_TAJARA = 'icons/mob/species/tajaran/uniform.dmi'
		)

/obj/item/clothing/under/solgov/utility/expeditionary_skirt
	name = "expeditionary skirt"
	desc = "A black turtleneck and skirt, the elusive ladies' uniform of the Expeditionary Corps."
	icon_state = "blackservicef"
	worn_state = "blackservicef"
	sprite_sheets = list(
		SPECIES_TAJARA = 'icons/mob/species/tajaran/uniform.dmi'
		)

/obj/item/clothing/under/solgov/utility/expeditionary_skirt/officer
	name = "expeditionary officer skirt"
	desc = "A black turtleneck and skirt, the elusive ladies' uniform of the Expeditionary Corps. This one has gold trim."
	icon_state = "blackservicef_com"
	worn_state = "blackservicef_com"

/obj/item/clothing/under/solgov/utility/expeditionary/command
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/command)

/obj/item/clothing/under/solgov/utility/expeditionary/engineering
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/engineering)

/obj/item/clothing/under/solgov/utility/expeditionary/security
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/security)

/obj/item/clothing/under/solgov/utility/expeditionary/medical
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/medical)

/obj/item/clothing/under/solgov/utility/expeditionary/supply
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/supply)

/obj/item/clothing/under/solgov/utility/expeditionary/service
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/service)

/obj/item/clothing/under/solgov/utility/expeditionary/exploration
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/exploration)

/obj/item/clothing/under/solgov/utility/expeditionary/officer
	name = "expeditionary officer's uniform"
	desc = "The utility uniform of the SCG Expeditionary Corps, made from biohazard resistant material. This one has gold trim."
	icon_state = "blackutility_com"
	worn_state = "blackutility_com"

/obj/item/clothing/under/solgov/utility/expeditionary/officer/command
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/command)

/obj/item/clothing/under/solgov/utility/expeditionary/officer/engineering
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/engineering)

/obj/item/clothing/under/solgov/utility/expeditionary/officer/security
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/security)

/obj/item/clothing/under/solgov/utility/expeditionary/officer/medical
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/medical)

/obj/item/clothing/under/solgov/utility/expeditionary/officer/supply
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/supply)

/obj/item/clothing/under/solgov/utility/expeditionary/officer/service
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/service)

/obj/item/clothing/under/solgov/utility/expeditionary/officer/exploration
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/exploration)

/obj/item/clothing/under/solgov/utility/fleet
	name = "fleet coveralls"
	desc = "The utility uniform of the SCG Fleet, made from an insulated material."
	icon_state = "navyutility"
	item_state = "jensensuit"
	worn_state = "navyutility"

/obj/item/clothing/under/solgov/utility/fleet/command
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/command/fleet)

/obj/item/clothing/under/solgov/utility/fleet/command/pilot
	starting_accessories = list(/obj/item/clothing/accessory/solgov/speciality/pilot)

/obj/item/clothing/under/solgov/utility/fleet/engineering
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/engineering/fleet)

/obj/item/clothing/under/solgov/utility/fleet/security
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/security/fleet)

/obj/item/clothing/under/solgov/utility/fleet/medical
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/medical/fleet)

/obj/item/clothing/under/solgov/utility/fleet/supply
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/supply/fleet)

/obj/item/clothing/under/solgov/utility/fleet/service
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/service/fleet)

/obj/item/clothing/under/solgov/utility/fleet/exploration
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/exploration/fleet)

/obj/item/clothing/under/solgov/utility/fleet/combat
	name = "fleet fatigues"
	desc = "Alternative utility uniform of the SCG Fleet, for when coveralls are impractical."
	icon_state = "navycombat"
	worn_state = "navycombat"

/obj/item/clothing/under/solgov/utility/fleet/combat/security
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/security/fleet)

/obj/item/clothing/under/solgov/utility/fleet/combat/medical
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/medical/fleet, /obj/item/clothing/accessory/armband/medblue)


/obj/item/clothing/under/solgov/utility/oac
	name = "orbital assault fatigues"
	desc = "The utility uniform of the SCG Orbital Assault Corps, made from durable material."
	icon_state = "greenutility"
	item_state = "jensensuit"
	worn_state = "greenutility"

/obj/item/clothing/under/solgov/utility/oac/command
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/command/oac)

/obj/item/clothing/under/solgov/utility/oac/engineering
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/engineering/oac)

/obj/item/clothing/under/solgov/utility/oac/security
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/security/oac)

/obj/item/clothing/under/solgov/utility/oac/medical
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/medical/oac)

/obj/item/clothing/under/solgov/utility/oac/medical/banded
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/medical/oac, /obj/item/clothing/accessory/armband/medblue)

/obj/item/clothing/under/solgov/utility/oac/supply
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/supply/oac)

/obj/item/clothing/under/solgov/utility/oac/service
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/service/oac)

/obj/item/clothing/under/solgov/utility/oac/exploration
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/exploration/oac)

/obj/item/clothing/under/solgov/utility/oac/urban
	name = "urban fatigues"
	desc = "An urban version of the SCG OAC utility uniform, made from durable material."
	icon_state = "greyutility"
	item_state = "gy_suit"
	worn_state = "greyutility"

/obj/item/clothing/under/solgov/utility/oac/tan
	name = "tan fatigues"
	desc = "A tan version of the SCG OAC utility uniform, made from durable material."
	icon_state = "tanutility"
	item_state = "johnny"
	worn_state = "tanutility"

//Service

/obj/item/clothing/under/solgov/service
	name = "service uniform"
	desc = "A service uniform of some kind."
	icon_state = "whiteservice"
	worn_state = "whiteservice"
	armor = list(melee = 5, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 5, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/solgov/service/expeditionary
	name = "expeditionary service uniform"
	desc = "The service uniform of the SCG Expeditionary Corps in silver trim."
	icon_state = "greydress"
	worn_state = "greydress"

/obj/item/clothing/under/solgov/service/expeditionary/skirt
	name = "expeditionary service skirt"
	desc = "A feminine version of the SCG Expeditionary Corps service uniform in silver trim."
	icon_state = "greydressfem"
	worn_state = "greydressfem"

/obj/item/clothing/under/solgov/service/expeditionary/command
	name = "expeditionary officer's service uniform"
	desc = "The service uniform of the SCG Expeditionary Corps in gold trim."
	icon_state = "greydress_com"
	worn_state = "greydress_com"

/obj/item/clothing/under/solgov/service/expeditionary/command/skirt
	name = "expeditionary officer's service skirt"
	desc = "A feminine version of the SCG Expeditionary Corps service uniform in gold trim."
	icon_state = "greydressfem_com"
	worn_state = "greydressfem_com"

/obj/item/clothing/under/solgov/service/fleet
	name = "fleet service uniform"
	desc = "The service uniform of the SCG Fleet, made from immaculate white fabric."
	icon_state = "whiteservice"
	item_state = "nursesuit"
	worn_state = "whiteservice"
	starting_accessories = list(/obj/item/clothing/accessory/black)

/obj/item/clothing/under/solgov/service/fleet/skirt
	name = "fleet service skirt"
	desc = "The service uniform skirt of the SCG Fleet, made from immaculate white fabric."
	icon_state = "whiteservicefem"
	worn_state = "whiteservicefem"

/obj/item/clothing/under/solgov/service/oac
	name = "orbital assault service uniform"
	desc = "The service uniform of the SCG Orbital Assault Corps. Slimming."
	icon_state = "greenservice"
	item_state = "johnny"
	worn_state = "greenservice"
	starting_accessories = list(/obj/item/clothing/accessory/brown)

/obj/item/clothing/under/solgov/service/oac/skirt
	name = "orbital assault service skirt"
	desc = "The service uniform skirt of the SCG Orbital Assault Corps. Slimming."
	icon_state = "greenservicefem"
	worn_state = "greenservicefem"

/obj/item/clothing/under/solgov/service/oac/command
	name = "orbital assault officer's service uniform"
	desc = "The service uniform of the SCG Orbital Assault Corps. Slimming and stylish."
	icon_state = "greenservice_com"
	item_state = "johnny"
	worn_state = "greenservice_com"
	starting_accessories = list(/obj/item/clothing/accessory/brown)

/obj/item/clothing/under/solgov/service/oac/command/skirt
	name = "orbital assault officer's service skirt"
	desc = "The service uniform skirt of the SCG Orbital Assault Corps. Slimming and stylish."
	icon_state = "greenservicefem_com"
	worn_state = "greenservicefem_com"

//Dress
/obj/item/clothing/under/solgov/mildress
	name = "dress uniform"
	desc = "A dress uniform of some kind."
	icon_state = "greydress"
	worn_state = "greydress"
	armor = list(melee = 5, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 5, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/solgov/mildress/oac
	name = "orbital assault dress uniform"
	desc = "The dress uniform of the SCG Orbital Assault Corps, class given form."
	icon_state = "blackdress"
	worn_state = "blackdress"

/obj/item/clothing/under/solgov/mildress/oac/skirt
	name = "orbital assault dress skirt"
	desc = "A  feminine version of the SCG Orbital Assault Corps dress uniform, class given form."
	icon_state = "blackdressfem"
	worn_state = "blackdressfem"

/obj/item/clothing/under/solgov/mildress/oac/command
	name = "orbital assault officer's dress uniform"
	desc = "The dress uniform of the SCG Orbital Assault Corps, even classier in gold."
	icon_state = "blackdress"
	worn_state = "blackdress_com"

/obj/item/clothing/under/solgov/mildress/oac/command/skirt
	name = "orbital assault officer's dress skirt"
	desc = "A feminine version of the SCG Orbital Assault Corps dress uniform, even classier in gold."
	icon_state = "blackdressfem"
	worn_state = "blackdressfem_com"

//misc garbage
/obj/item/clothing/under/rank/internalaffairs/plain/solgov
	desc = "A plain shirt and pair of pressed black pants."
	name = "formal outfit"
	starting_accessories = list(/obj/item/clothing/accessory/blue_clip)

/obj/item/clothing/under/solgov/utility/expeditionary/monkey
	name = "adjusted expeditionary uniform"
	desc = "The utility uniform of the SCG Expeditionary Corps, made from biohazard resistant material. This one has silver trim. It was also mangled to fit a monkey. This better be worth the NJP you'll get for making it."
	species_restricted = list("Monkey")
	sprite_sheets = list("Monkey" = 'icons/mob/species/monkey/uniform.dmi')
	starting_accessories = list(/obj/item/clothing/accessory/solgov/rank/fleet/officer/wo1_monkey)
