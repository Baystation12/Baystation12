//SolGov Uniforms - DO NOT ADD NEW UNIFORMS TO UNIFORM.DMI - SOLGOV UNIFORMS GO IN SOLGOV.DMI

//PT
/obj/item/clothing/under/pt
	name = "pt uniform"
	desc = "Shorts! Shirt! Miami! Sexy!"
	icon_state = "miami"
	worn_state = "miami"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	item_icons = list(slot_w_uniform_str = 'icons/mob/solgov.dmi')

/obj/item/clothing/under/pt/expeditionary
	name = "expeditionary pt uniform"
	desc = "A baggy shirt bearing the seal of the SCG Expeditionary Corps and some dorky looking blue shorts."
	icon_state = "expeditionpt"
	worn_state = "expeditionpt"

/obj/item/clothing/under/pt/fleet
	name = "fleet pt uniform"
	desc = "A pair of black shorts and two tank tops, seems impractical. Looks good though."
	icon_state = "fleetpt"
	worn_state = "fleetpt"

/obj/item/clothing/under/pt/marine
	name = "marine pt uniform"
	desc = "Does NOT leave much to the imagination."
	icon_state = "marinept"
	worn_state = "marinept"


//Utility

/obj/item/clothing/under/utility
	name = "utility uniform"
	desc = "A comfortable turtleneck and black utility trousers."
	icon_state = "blackutility"
	item_state = "bl_suit"
	worn_state = "blackutility"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	item_icons = list(slot_w_uniform_str = 'icons/mob/solgov.dmi')

/obj/item/clothing/under/utility/expeditionary
	name = "expeditionary uniform"
	desc = "The utility uniform of the SCG Expeditionary Corps, made from biohazard resistant material. This one has silver trim."
	icon_state = "blackutility_crew"
	worn_state = "blackutility_crew"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 10)

/obj/item/clothing/under/utility/expeditionary/command
	starting_accessories = list(/obj/item/clothing/accessory/department/command)

/obj/item/clothing/under/utility/expeditionary/engineering
	starting_accessories = list(/obj/item/clothing/accessory/department/engineering)

/obj/item/clothing/under/utility/expeditionary/security
	starting_accessories = list(/obj/item/clothing/accessory/department/security)

/obj/item/clothing/under/utility/expeditionary/medical
	starting_accessories = list(/obj/item/clothing/accessory/department/medical)

/obj/item/clothing/under/utility/expeditionary/supply
	starting_accessories = list(/obj/item/clothing/accessory/department/supply)

/obj/item/clothing/under/utility/expeditionary/service
	starting_accessories = list(/obj/item/clothing/accessory/department/service)

/obj/item/clothing/under/utility/expeditionary/exploration
	starting_accessories = list(/obj/item/clothing/accessory/department/exploration)

/obj/item/clothing/under/utility/expeditionary/officer
	name = "expeditionary officer's uniform"
	desc = "The utility uniform of the SCG Expeditionary Corps, made from biohazard resistant material. This one has gold trim."
	icon_state = "blackutility_com"
	worn_state = "blackutility_com"

/obj/item/clothing/under/utility/expeditionary/officer/command
	starting_accessories = list(/obj/item/clothing/accessory/department/command)

/obj/item/clothing/under/utility/expeditionary/officer/engineering
	starting_accessories = list(/obj/item/clothing/accessory/department/engineering)

/obj/item/clothing/under/utility/expeditionary/officer/security
	starting_accessories = list(/obj/item/clothing/accessory/department/security)

/obj/item/clothing/under/utility/expeditionary/officer/medical
	starting_accessories = list(/obj/item/clothing/accessory/department/medical)

/obj/item/clothing/under/utility/expeditionary/officer/supply
	starting_accessories = list(/obj/item/clothing/accessory/department/supply)

/obj/item/clothing/under/utility/expeditionary/officer/service
	starting_accessories = list(/obj/item/clothing/accessory/department/service)

/obj/item/clothing/under/utility/expeditionary/officer/exploration
	starting_accessories = list(/obj/item/clothing/accessory/department/exploration)


/obj/item/clothing/under/utility/fleet
	name = "fleet coveralls"
	desc = "The utility uniform of the SCG Fleet, made from an insulated material."
	icon_state = "navyutility"
	item_state = "jensensuit"
	worn_state = "navyutility"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 10, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/under/utility/fleet/command
	starting_accessories = list(/obj/item/clothing/accessory/department/command/fleet)

/obj/item/clothing/under/utility/fleet/engineering
	starting_accessories = list(/obj/item/clothing/accessory/department/engineering/fleet)

/obj/item/clothing/under/utility/fleet/security
	starting_accessories = list(/obj/item/clothing/accessory/department/security/fleet)

/obj/item/clothing/under/utility/fleet/medical
	starting_accessories = list(/obj/item/clothing/accessory/department/medical/fleet)

/obj/item/clothing/under/utility/fleet/supply
	starting_accessories = list(/obj/item/clothing/accessory/department/supply/fleet)

/obj/item/clothing/under/utility/fleet/service
	starting_accessories = list(/obj/item/clothing/accessory/department/service/fleet)

/obj/item/clothing/under/utility/fleet/exploration
	starting_accessories = list(/obj/item/clothing/accessory/department/exploration/fleet)

/obj/item/clothing/under/utility/fleet/exploration/pilot
	starting_accessories = list(/obj/item/clothing/accessory/department/exploration/fleet, /obj/item/clothing/accessory/speciality/pilot)

/obj/item/clothing/under/utility/fleet/combat
	name = "fleet fatigues"
	desc = "Alternative utility uniform of the SCG Fleet, for when coveralls are impractical."
	icon_state = "navycombat"
	worn_state = "navycombat"
	armor = list(melee = 10, bullet = 0, laser = 10,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/utility/fleet/combat/security
	starting_accessories = list(/obj/item/clothing/accessory/department/security/fleet)

/obj/item/clothing/under/utility/fleet/combat/medical
	starting_accessories = list(/obj/item/clothing/accessory/department/medical/fleet, /obj/item/clothing/accessory/armband/medblue)


/obj/item/clothing/under/utility/marine
	name = "marine fatigues"
	desc = "The utility uniform of the SCG Marine Corps, made from durable material."
	icon_state = "greenutility"
	item_state = "jensensuit"
	worn_state = "greenutility"
	armor = list(melee = 10, bullet = 0, laser = 10,energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/under/utility/marine/command
	starting_accessories = list(/obj/item/clothing/accessory/department/command/marine)

/obj/item/clothing/under/utility/marine/engineering
	starting_accessories = list(/obj/item/clothing/accessory/department/engineering/marine)

/obj/item/clothing/under/utility/marine/security
	starting_accessories = list(/obj/item/clothing/accessory/department/security/marine)

/obj/item/clothing/under/utility/marine/medical
	starting_accessories = list(/obj/item/clothing/accessory/department/medical/marine)

/obj/item/clothing/under/utility/marine/medical/banded
	starting_accessories = list(/obj/item/clothing/accessory/department/medical/marine, /obj/item/clothing/accessory/armband/medblue)

/obj/item/clothing/under/utility/marine/supply
	starting_accessories = list(/obj/item/clothing/accessory/department/supply/marine)

/obj/item/clothing/under/utility/marine/service
	starting_accessories = list(/obj/item/clothing/accessory/department/service/marine)

/obj/item/clothing/under/utility/marine/exploration
	starting_accessories = list(/obj/item/clothing/accessory/department/exploration/marine)

/obj/item/clothing/under/utility/marine/urban
	name = "urban fatigues"
	desc = "An urban version of the SCG marine utility uniform, made from durable material."
	icon_state = "greyutility"
	item_state = "gy_suit"
	worn_state = "greyutility"

/obj/item/clothing/under/utility/marine/tan
	name = "tan fatigues"
	desc = "A tan version of the SCG marine utility uniform, made from durable material."
	icon_state = "tanutility"
	item_state = "johnny"
	worn_state = "tanutility"

//Service

/obj/item/clothing/under/service
	name = "service uniform"
	desc = "A service uniform of some kind."
	icon_state = "whiteservice"
	worn_state = "whiteservice"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	item_icons = list(slot_w_uniform_str = 'icons/mob/solgov.dmi')

/obj/item/clothing/under/service/expeditionary_skirt
	name = "expeditionary service skirt"
	desc = "A black turtleneck and skirt, the optional ladies' service uniform of the Expeditionary Corps."
	icon_state = "blackservicef"
	worn_state = "blackservicef"

/obj/item/clothing/under/service/expeditionary_skirt/officer
	name = "expeditionary officer service skirt"
	desc = "A black turtleneck and skirt, the optional ladies' service uniform of the Expeditionary Corps. This one has gold trim."
	icon_state = "blackservicef_com"
	worn_state = "blackservicef_com"

/obj/item/clothing/under/service/fleet
	name = "fleet service uniform"
	desc = "The service uniform of the SCG Fleet, made from immaculate white fabric."
	icon_state = "whiteservice"
	item_state = "nursesuit"
	worn_state = "whiteservice"
	starting_accessories = list(/obj/item/clothing/accessory/navy)

/obj/item/clothing/under/service/fleet/skirt
	name = "fleet service skirt"
	desc = "The service uniform skirt of the SCG Fleet, made from immaculate white fabric."
	icon_state = "whiteservicefem"
	worn_state = "whiteservicefem"

/obj/item/clothing/under/service/marine
	name = "marine service uniform"
	desc = "The service uniform of the SCG Marine Corps. Slimming."
	icon_state = "greenservice"
	item_state = "johnny"
	worn_state = "greenservice"
	starting_accessories = list(/obj/item/clothing/accessory/brown)

/obj/item/clothing/under/service/marine/skirt
	name = "marine service skirt"
	desc = "The service uniform skirt of the SCG Marine Corps. Slimming."
	icon_state = "greenservicefem"
	worn_state = "greenservicefem"

/obj/item/clothing/under/service/marine/command
	name = "marine officer's service uniform"
	desc = "The service uniform of the SCG Marine Corps. Slimming and stylish."
	icon_state = "greenservice_com"
	item_state = "johnny"
	worn_state = "greenservice_com"
	starting_accessories = list(/obj/item/clothing/accessory/brown)

/obj/item/clothing/under/service/marine/command/skirt
	name = "marine officer's service skirt"
	desc = "The service uniform skirt of the SCG Marine Corps. Slimming and stylish."
	icon_state = "greenservicefem_com"
	worn_state = "greenservicefem_com"

//Dress
/obj/item/clothing/under/mildress
	name = "dress uniform"
	desc = "A dress uniform of some kind."
	icon_state = "greydress"
	worn_state = "greydress"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	item_icons = list(slot_w_uniform_str = 'icons/mob/solgov.dmi')

/obj/item/clothing/under/mildress/expeditionary
	name = "expeditionary dress uniform"
	desc = "The dress uniform of the SCG Expeditionary Corps in silver trim."
	icon_state = "greydress"
	worn_state = "greydress"

/obj/item/clothing/under/mildress/expeditionary/skirt
	name = "expeditionary dress skirt"
	desc = "A feminine version of the SCG Expeditionary Corps dress uniform in silver trim."
	icon_state = "greydressfem"
	worn_state = "greydressfem"

/obj/item/clothing/under/mildress/expeditionary/command
	name = "expeditionary officer's dress uniform"
	desc = "The dress uniform of the SCG Expeditionary Corps in gold trim."
	icon_state = "greydress_com"
	worn_state = "greydress_com"

/obj/item/clothing/under/mildress/expeditionary/command/skirt
	name = "expeditionary officer's dress skirt"
	desc = "A feminine version of the SCG Expeditionary Corps dress uniform in gold trim."
	icon_state = "greydressfem_com"
	worn_state = "greydressfem_com"

/obj/item/clothing/under/mildress/marine
	name = "marine dress uniform"
	desc = "The dress uniform of the SCG Marine Corps, class given form."
	icon_state = "blackdress"
	worn_state = "blackdress"

/obj/item/clothing/under/mildress/marine/skirt
	name = "marine dress skirt"
	desc = "A  feminine version of the SCG Marine Corps dress uniform, class given form."
	icon_state = "blackdressfem"
	worn_state = "blackdressfem"

/obj/item/clothing/under/mildress/marine/command
	name = "marine officer's dress uniform"
	desc = "The dress uniform of the SCG Marine Corps, even classier in gold."
	icon_state = "blackdress"
	worn_state = "blackdress_com"

/obj/item/clothing/under/mildress/marine/command/skirt
	name = "marine officer's dress skirt"
	desc = "A feminine version of the SCG Marine Corps dress uniform, even classier in gold."
	icon_state = "blackdressfem"
	worn_state = "blackdressfem_com"


//Misc

/obj/item/clothing/under/hazard
	name = "hazard jumpsuit"
	desc = "A high visibility jumpsuit made from heat and radiation resistant materials."
	icon_state = "hazard"
	item_state = "engi_suit"
	worn_state = "hazard"
	siemens_coefficient = 0.8
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 20, bio = 0, rad = 20)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/under/sterile
	name = "sterile jumpsuit"
	desc = "A sterile white jumpsuit with medical markings. Protects against all manner of biohazards."
	icon_state = "sterile"
	item_state = "w_suit"
	worn_state = "sterile"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 30, rad = 0)
