/obj/item/clothing/under/solgov
	name = "master solgov uniform"
	desc = "You shouldn't be seeing this."
	icon = 'maps/torch/icons/obj/obj_under_solgov.dmi'
	item_icons = list(slot_w_uniform_str = 'maps/torch/icons/mob/onmob_under_solgov.dmi')
	siemens_coefficient = 0.8
	gender_icons = 1

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
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_under_unathi.dmi'
		)

/obj/item/clothing/under/solgov/pt/fleet
	name = "fleet pt uniform"
	desc = "A tight-fitting navy blue shirt paired with black shorts. For when you need to 'get physical'."
	icon_state = "fleetpt"
	worn_state = "fleetpt"

/obj/item/clothing/under/solgov/pt/army
	name = "army pt uniform"
	desc = "Does NOT leave much to the imagination."
	icon_state = "armypt"
	worn_state = "armypt"


//Utility

/obj/item/clothing/under/solgov/utility
	name = "utility uniform"
	desc = "A comfortable turtleneck and black utility trousers."
	icon_state = "blackutility"
	item_state = "bl_suit"
	worn_state = "blackutility"
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_under_unathi.dmi'
		)
	armor = list(
		melee = ARMOR_MELEE_MINOR,
		energy = ARMOR_ENERGY_MINOR
		)

/obj/item/clothing/under/solgov/utility/expeditionary
	name = "expeditionary uniform"
	desc = "The utility uniform of the SCG Expeditionary Corps, made from biohazard resistant material. This one has silver trim."
	icon_state = "blackutility_crew"
	worn_state = "blackutility_crew"
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_under_unathi.dmi'
		)

/obj/item/clothing/under/solgov/utility/expeditionary_skirt
	name = "expeditionary skirt"
	desc = "A black turtleneck and skirt, the elusive ladies' uniform of the Expeditionary Corps."
	icon_state = "blackservicefem"
	worn_state = "blackservicefem"
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_under_unathi.dmi'
		)

/obj/item/clothing/under/solgov/utility/expeditionary_skirt/officer
	name = "expeditionary officer skirt"
	desc = "A black turtleneck and skirt, the elusive ladies' uniform of the Expeditionary Corps. This one has gold trim."
	icon_state = "blackservicefem_com"
	worn_state = "blackservicefem_com"

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

/obj/item/clothing/under/solgov/utility/expeditionary/research
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/research)

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

/obj/item/clothing/under/solgov/utility/expeditionary/officer/research
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/research)

/obj/item/clothing/under/solgov/utility/fleet
	name = "fleet coveralls"
	desc = "The utility uniform of the SCG Fleet, made from an insulated material."
	icon_state = "navyutility"
	item_state = "jensensuit"
	worn_state = "navyutility"

/obj/item/clothing/under/solgov/utility/fleet/command
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/command/fleet)

/obj/item/clothing/under/solgov/utility/fleet/command/pilot
	starting_accessories = list(/obj/item/clothing/accessory/solgov/specialty/pilot)

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

/obj/item/clothing/under/solgov/utility/fleet/polopants
	name = "fleet polo and pants"
	desc = "An utility uniform of the SCG Fleet, specially designed for engineering staff. The pants sports some yellow reflective stripes, and have knee pads."
	icon_state = "navypolopants"
	worn_state = "navypolopants"

/obj/item/clothing/under/solgov/utility/fleet/combat
	name = "fleet fatigues"
	desc = "Alternative utility uniform of the SCG Fleet, for when coveralls are impractical."
	icon_state = "navycombat"
	worn_state = "navycombat"

/obj/item/clothing/under/solgov/utility/fleet/combat/security
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/security/fleet)

/obj/item/clothing/under/solgov/utility/fleet/combat/medical
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/medical/fleet, /obj/item/clothing/accessory/armband/medblue)

/obj/item/clothing/under/solgov/utility/fleet/combat/command
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/command/fleet)

/obj/item/clothing/under/solgov/utility/fleet/combat/exploration
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/exploration/fleet)

/obj/item/clothing/under/solgov/utility/fleet/officer
	name = "fleet officer's coveralls"
	desc = "Alternative utility uniform of the SCG Fleet, for officers."
	icon_state = "navyutilityoff"
	worn_state = "navyutilityoff"

/obj/item/clothing/under/solgov/utility/fleet/officer/command
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/command/fleet)

/obj/item/clothing/under/solgov/utility/fleet/officer/engineering
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/engineering/fleet)

/obj/item/clothing/under/solgov/utility/fleet/officer/security
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/security/fleet)

/obj/item/clothing/under/solgov/utility/fleet/officer/medical
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/medical/fleet)

/obj/item/clothing/under/solgov/utility/army
	name = "army fatigues"
	desc = "The utility uniform of the SCG Army, made from durable material."
	icon_state = "greenutility"
	item_state = "jensensuit"
	worn_state = "greenutility"

//obj/item/clothing/under/solgov/utility/army/command
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/command/army)

/obj/item/clothing/under/solgov/utility/army/engineering
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/engineering/army)

/obj/item/clothing/under/solgov/utility/army/security
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/security/army)

/obj/item/clothing/under/solgov/utility/army/medical
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/medical/army)

/obj/item/clothing/under/solgov/utility/army/medical/banded
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/medical/army, /obj/item/clothing/accessory/armband/medblue)

/obj/item/clothing/under/solgov/utility/army/supply
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/supply/army)

/obj/item/clothing/under/solgov/utility/army/service
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/service/army)

/obj/item/clothing/under/solgov/utility/army/exploration
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/exploration/army)

/obj/item/clothing/under/solgov/utility/army/urban
	name = "urban fatigues"
	desc = "An urban version of the SCG Army utility uniform, made from durable material."
	icon_state = "greyutility"
	item_state = "gy_suit"
	worn_state = "greyutility"

/obj/item/clothing/under/solgov/utility/army/tan
	name = "tan fatigues"
	desc = "A tan version of the SCG Army utility uniform, made from durable material."
	icon_state = "tanutility"
	item_state = "johnny"
	worn_state = "tanutility"

//Service

/obj/item/clothing/under/solgov/service
	name = "service uniform"
	desc = "A service uniform of some kind."
	icon_state = "whiteservice"
	worn_state = "whiteservice"
	siemens_coefficient = 0.9

/obj/item/clothing/under/solgov/service/expeditionary
	name = "expeditionary service uniform"
	desc = "The service uniform of the SCG Expeditionary Corps in silver trim."
	icon_state = "greydress"
	worn_state = "greydress"
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_under_unathi.dmi'
		)

/obj/item/clothing/under/solgov/service/expeditionary/command
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/command/jumper)

/obj/item/clothing/under/solgov/service/expeditionary/engineering
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/engineering/jumper)

/obj/item/clothing/under/solgov/service/expeditionary/security
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/security/jumper)

/obj/item/clothing/under/solgov/service/expeditionary/medical
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/medical/jumper)

/obj/item/clothing/under/solgov/service/expeditionary/supply
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/supply/jumper)

/obj/item/clothing/under/solgov/service/expeditionary/service
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/service/jumper)

/obj/item/clothing/under/solgov/service/expeditionary/exploration
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/exploration/jumper)

/obj/item/clothing/under/solgov/service/expeditionary/research
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/research/jumper)

/obj/item/clothing/under/solgov/service/expeditionary/skirt
	name = "expeditionary service skirt"
	desc = "A feminine version of the SCG Expeditionary Corps service uniform in silver trim."
	icon_state = "greydressfem"
	worn_state = "greydressfem"

/obj/item/clothing/under/solgov/service/expeditionary/skirt/command
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/command/jumper)

/obj/item/clothing/under/solgov/service/expeditionary/skirt/engineering
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/engineering/jumper)

/obj/item/clothing/under/solgov/service/expeditionary/skirt/security
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/security/jumper)

/obj/item/clothing/under/solgov/service/expeditionary/skirt/medical
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/medical/jumper)

/obj/item/clothing/under/solgov/service/expeditionary/skirt/supply
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/supply/jumper)

/obj/item/clothing/under/solgov/service/expeditionary/skirt/service
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/service/jumper)

/obj/item/clothing/under/solgov/service/expeditionary/skirt/exploration
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/exploration/jumper)

/obj/item/clothing/under/solgov/service/expeditionary/skirt/research
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/research/jumper)

/obj/item/clothing/under/solgov/service/expeditionary/command
	name = "expeditionary officer's service uniform"
	desc = "The service uniform of the SCG Expeditionary Corps in gold trim."
	icon_state = "greydress_com"
	worn_state = "greydress_com"

/obj/item/clothing/under/solgov/service/expeditionary/command/command
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/command/jumper)

/obj/item/clothing/under/solgov/service/expeditionary/command/engineering
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/engineering/jumper)

/obj/item/clothing/under/solgov/service/expeditionary/command/security
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/security/jumper)

/obj/item/clothing/under/solgov/service/expeditionary/command/medical
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/medical/jumper)

/obj/item/clothing/under/solgov/service/expeditionary/command/supply
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/supply/jumper)

/obj/item/clothing/under/solgov/service/expeditionary/command/service
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/service/jumper)

/obj/item/clothing/under/solgov/service/expeditionary/command/exploration
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/exploration/jumper)

/obj/item/clothing/under/solgov/service/expeditionary/command/research
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/research/jumper)

/obj/item/clothing/under/solgov/service/expeditionary/command/skirt
	name = "expeditionary officer's service skirt"
	desc = "A feminine version of the SCG Expeditionary Corps service uniform in gold trim."
	icon_state = "greydressfem_com"
	worn_state = "greydressfem_com"

/obj/item/clothing/under/solgov/service/expeditionary/command/skirt/command
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/command/jumper)

/obj/item/clothing/under/solgov/service/expeditionary/command/skirt/engineering
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/engineering/jumper)

/obj/item/clothing/under/solgov/service/expeditionary/command/skirt/security
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/security/jumper)

/obj/item/clothing/under/solgov/service/expeditionary/command/skirt/medical
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/medical/jumper)

/obj/item/clothing/under/solgov/service/expeditionary/command/skirt/supply
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/supply/jumper)

/obj/item/clothing/under/solgov/service/expeditionary/command/skirt/service
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/service/jumper)

/obj/item/clothing/under/solgov/service/expeditionary/command/skirt/exploration
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/exploration/jumper)

/obj/item/clothing/under/solgov/service/expeditionary/command/skirt/research
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/research/jumper)

/obj/item/clothing/under/solgov/service/fleet
	name = "fleet service uniform"
	desc = "The service uniform of the SCG Fleet, made from immaculate white fabric."
	icon_state = "whiteservice"
	item_state = "nursesuit"
	worn_state = "whiteservice"
	starting_accessories = list(/obj/item/clothing/accessory/navy)

/obj/item/clothing/under/solgov/service/fleet/skirt
	name = "fleet service skirt"
	desc = "The service uniform skirt of the SCG Fleet, made from immaculate white fabric."
	icon_state = "whiteservicefem"
	worn_state = "whiteservicefem"

/obj/item/clothing/under/solgov/service/army
	name = "army service uniform"
	desc = "The service uniform of the SCG Army. Slimming."
	icon_state = "greenservice"
	item_state = "johnny"
	worn_state = "greenservice"
	starting_accessories = list(/obj/item/clothing/accessory/brown)

/obj/item/clothing/under/solgov/service/army/skirt
	name = "army service skirt"
	desc = "The service uniform skirt of the SCG Army. Slimming."
	icon_state = "greenservicefem"
	worn_state = "greenservicefem"

/obj/item/clothing/under/solgov/service/army/command
	name = "marine officer's service uniform"
	desc = "The service uniform of the SCG Army. Slimming and stylish."
	icon_state = "greenservice_com"
	item_state = "johnny"
	worn_state = "greenservice_com"
	starting_accessories = list(/obj/item/clothing/accessory/brown)

/obj/item/clothing/under/solgov/service/army/command/skirt
	name = "marine officer's service skirt"
	desc = "The service uniform skirt of the SCG Army. Slimming and stylish."
	icon_state = "greenservicefem_com"
	worn_state = "greenservicefem_com"

//Dress
/obj/item/clothing/under/solgov/mildress
	name = "dress uniform"
	desc = "A dress uniform of some kind."
	icon_state = "greydress"
	worn_state = "greydress"
	siemens_coefficient = 0.9

/obj/item/clothing/under/solgov/mildress/army
	name = "army dress uniform"
	desc = "The dress uniform of the SCG Army, class given form."
	icon_state = "blackdress"
	worn_state = "blackdress"

/obj/item/clothing/under/solgov/mildress/army/skirt
	name = "army dress skirt"
	desc = "A  feminine version of the SCG Army dress uniform, class given form."
	icon_state = "blackdressfem"
	worn_state = "blackdressfem"

/obj/item/clothing/under/solgov/mildress/army/command
	name = "army officer's dress uniform"
	desc = "The dress uniform of the SCG Army, even classier in gold."
	icon_state = "blackdress"
	worn_state = "blackdress_com"

/obj/item/clothing/under/solgov/mildress/army/command/skirt
	name = "army officer's dress skirt"
	desc = "A feminine version of the SCG Army dress uniform, even classier in gold."
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
	sprite_sheets = list("Monkey" = 'icons/mob/species/monkey/onmob_under_monkey.dmi')
	starting_accessories = list(/obj/item/clothing/accessory/solgov/rank/fleet/officer/wo1_monkey)
