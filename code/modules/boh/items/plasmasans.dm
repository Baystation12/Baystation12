//Phoron Restructurant suits
/obj/item/clothing/suit/space/plasmasans
	name = "Phoron Restructurant containment suit"
	icon = 'icons/obj/clothing/species/plasmasans/obj_suit_plasmasans.dmi'
	icon_state = "phorosiansuit"
	item_state = "phorosiansuit"
	item_flags = ITEM_FLAG_THICKMATERIAL | ITEM_FLAG_PHORONGUARD
	allowed = list(/obj/item/weapon/tank)
	desc = "A special containment suit designed to protect a Phoron Restructurant Human's volatile body from outside exposure."
	species_restricted = list(SPECIES_PLASMASANS)
	sprite_sheets = list(
		SPECIES_PLASMASANS = 'icons/mob/species/plasmasans/onmob_suit_plasmasans.dmi'
		)
	can_breach = 1
	breach_threshold = 100
	resilience = 0.08
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_SHIELDED,
		bomb = ARMOR_BOMB_PADDED,
		bio =  ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
	)


/obj/item/clothing/head/helmet/space/plasmasans
	name = "Phoron Restructurant helmet"
	desc = "A helmet made to connect with a Phoron Restructurant containment suit. Has a plasma-glass visor."
	icon = 'icons/obj/clothing/species/plasmasans/obj_head_plasmasans.dmi'
	icon_state = "phorosian_helmet0"
	item_state = "phorosian_helmet0"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	item_flags = ITEM_FLAG_THICKMATERIAL | ITEM_FLAG_AIRTIGHT | ITEM_FLAG_PHORONGUARD
	species_restricted = list(SPECIES_PLASMASANS)
	light_overlay = "helmet_light"
	sprite_sheets = list(
		SPECIES_PLASMASANS = 'icons/mob/species/plasmasans/onmob_head_plasmasans.dmi'
		)
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_SHIELDED,
		bomb = ARMOR_BOMB_PADDED,
		bio =  ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
	)

/obj/item/clothing/suit/space/plasmasans/assistant
	name = "Phoron Restructurant assistant suit"
	icon_state = "phorosianAssistant_suit"
	item_state = "phorosianAssistant_suit"
/obj/item/clothing/head/helmet/space/plasmasans/assistant
	name = "Phoron Restructurant assistant helmet"
	icon_state = "phorosianAssistant_helmet0"
	item_state = "phorosianAssistant_helmet0"

/obj/item/clothing/suit/space/plasmasans/atmostech
	name = "Phoron Restructurant atmospheric suit"
	icon_state = "phorosianAtmos_suit"
	item_state = "phorosianAtmos_suit"
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/head/helmet/space/plasmasans/atmostech
	name = "Phoron Restructurant atmospheric helmet"
	icon_state = "phorosianAtmos_helmet0"
	item_state = "phorosianAtmos_helmet0"
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/space/plasmasans/engineer
	name = "Phoron Restructurant engineer suit"
	icon_state = "phorosianEngineer_suit"
	item_state = "phorosianEngineer_suit"

/obj/item/clothing/head/helmet/space/plasmasans/engineer
	name = "Phoron Restructurant engineer helmet"
	icon_state = "phorosianEngineer_helmet0"
	item_state = "phorosianEngineer_helmet0"

/obj/item/clothing/suit/space/plasmasans/engineer/ce
	name = "Phoron Restructurant chief engineer suit"
	icon_state = "phorosianCE"
	item_state = "phorosianCE"
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/head/helmet/space/plasmasans/engineer/ce
	name = "Phoron Restructurant chief engineer helmet"
	icon_state = "phorosianCE_helmet0"
	item_state = "phorosianCE_helmet0"
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

//SERVICE

/obj/item/clothing/suit/space/plasmasans/botanist
	name = "Phoron Restructurant botanist suit"
	icon_state = "phorosianBotanist_suit"
	item_state = "phorosianBotanist_suit"

/obj/item/clothing/head/helmet/space/plasmasans/botanist
	name = "Phoron Restructurant botanist helmet"
	icon_state = "phorosianBotanist_helmet0"
	item_state = "phorosianBotanist_helmet0"

/obj/item/clothing/suit/space/plasmasans/chaplain
	name = "Phoron Restructurant chaplain suit"
	icon_state = "phorosianChaplain_suit"
	item_state = "phorosianChaplain_suit"

/obj/item/clothing/head/helmet/space/plasmasans/chaplain
	name = "Phoron Restructurant chaplain helmet"
	icon_state = "phorosianChaplain_helmet0"
	item_state = "phorosianChaplain_helmet0"

/obj/item/clothing/suit/space/plasmasans/clown
	name = "Phoron Restructurant clown suit"
	icon_state = "phorosianClown"
	item_state = "phorosianClown"

/obj/item/clothing/head/helmet/space/plasmasans/clown
	name = "Phoron Restructurant clown helmet"
	icon_state = "phorosianClown_helmet0"
	item_state = "phorosianClown_helmet0"

/obj/item/clothing/suit/space/plasmasans/mime
	name = "Phoron Restructurant mime suit"
	icon_state = "phorosianMime"
	item_state = "phorosianMime"

/obj/item/clothing/head/helmet/space/plasmasans/mime
	name = "Phoron Restructurant mime helmet"
	icon_state = "phorosianMime_helmet0"
	item_state = "phorosianMime_helmet0"

/obj/item/clothing/suit/space/plasmasans/service
	name = "Phoron Restructurant service suit"
	icon_state = "phorosianService_suit"
	item_state = "phorosianService_suit"

/obj/item/clothing/head/helmet/space/plasmasans/service
	name = "Phoron Restructurant service helmet"
	icon_state = "phorosianService_helmet0"
	item_state = "phorosianService_helmet0"

/obj/item/clothing/suit/space/plasmasans/janitor
	name = "Phoron Restructurant janitor suit"
	icon_state = "phorosianJanitor_suit"
	item_state = "phorosianJanitor_suit"

/obj/item/clothing/head/helmet/space/plasmasans/janitor
	name = "Phoron Restructurant janitor helmet"
	icon_state = "phorosianJanitor_helmet0"
	item_state = "phorosianJanitor_helmet0"


//CARGO

/obj/item/clothing/suit/space/plasmasans/cargo
	name = "Phoron Restructurant cargo suit"
	icon_state = "phorosianCargo_suit"
	item_state = "phorosianCargo_suit"

/obj/item/clothing/head/helmet/space/plasmasans/cargo
	name = "Phoron Restructurant cargo helmet"
	icon_state = "phorosianCargo_helmet0"
	item_state = "phorosianCargo_helmet0"

/obj/item/clothing/suit/space/plasmasans/miner
	name = "Phoron Restructurant miner suit"
	icon_state = "phorosianMiner_suit"
	item_state = "phorosianMiner_suit"

/obj/item/clothing/head/helmet/space/plasmasans/miner
	name = "Phoron Restructurant miner helmet"
	icon_state = "phorosianMiner_helmet0"
	item_state = "phorosianMiner_helmet0"

/obj/item/clothing/suit/space/plasmasans/miner/alt
	icon_state = "phorosianMiner_suit_alt"
	item_state = "phorosianMiner_suit_alt"

/obj/item/clothing/head/helmet/space/plasmasans/miner/alt
	icon_state = "phorosianMiner_helmet_alt0"
	item_state = "phorosianMiner_helmet_alt0"

// MEDSCI

/obj/item/clothing/suit/space/plasmasans/medical
	name = "Phoron Restructurant medical suit"
	icon_state = "phorosianMedical_suit"
	item_state = "phorosianMedical_suit"

/obj/item/clothing/head/helmet/space/plasmasans/medical
	name = "Phoron Restructurant medical helmet"
	icon_state = "phorosianMedical_helmet0"
	item_state = "phorosianMedical_helmet0"

/obj/item/clothing/suit/space/plasmasans/medical/paramedic
	name = "Phoron Restructurant paramedic suit"
	icon_state = "phorosianParamedic"
	item_state = "phorosianParamedic"

/obj/item/clothing/head/helmet/space/plasmasans/medical/paramedic
	name = "Phoron Restructurant paramedic helmet"
	icon_state = "phorosianParamedic_helmet0"
	item_state = "phorosianParamedic_helmet0"

/obj/item/clothing/suit/space/plasmasans/medical/chemist
	name = "Phoron Restructurant chemist suit"
	icon_state = "phorosianChemist"
	item_state = "phorosianChemist"

/obj/item/clothing/head/helmet/space/plasmasans/medical/chemist
	name = "Phoron Restructurant chemist helmet"
	icon_state = "phorosianChemist_helmet0"
	item_state = "phorosianChemist_helmet0"

/obj/item/clothing/suit/space/plasmasans/medical/cmo
	name = "Phoron Restructurant chief medical officer suit"
	icon_state = "phorosianCMO"
	item_state = "phorosianCMO"

/obj/item/clothing/head/helmet/space/plasmasans/medical/cmo
	name = "Phoron Restructurant chief medical officer helmet"
	icon_state = "phorosianCMO_helmet0"
	item_state = "phorosianCMO_helmet0"

/obj/item/clothing/suit/space/plasmasans/science
	name = "Phoron Restructurant scientist suit"
	icon_state = "phorosianScience_suit"
	item_state = "phorosianScience_suit"

/obj/item/clothing/head/helmet/space/plasmasans/science
	name = "Phoron Restructurant scientist helmet"
	icon_state = "phorosianScience_helmet0"
	item_state = "phorosianScience_helmet0"

/obj/item/clothing/suit/space/plasmasans/science/rd
	name = "Phoron Restructurant research director suit"
	icon_state = "phorosianRD"
	item_state = "phorosianRD"

/obj/item/clothing/head/helmet/space/plasmasans/science/rd
	name = "Phoron Restructurant research director helmet"
	icon_state = "phorosianRD_helmet0"
	item_state = "phorosianRD_helmet0"

//MAGISTRATE
/obj/item/clothing/suit/space/plasmasans/magistrate
	name = "Phoron Restructurant magistrate suit"
	icon_state = "phorosianHoS"
	item_state = "phorosianHoS"

/obj/item/clothing/head/helmet/space/plasmasans/magistrate
	name = "Phoron Restructurant magistrate helmet"
	icon_state = "phorosianHoS_helmet0"
	item_state = "phorosianHoS_helmet0"

//SECURITY

/obj/item/clothing/suit/space/plasmasans/security
	name = "Phoron Restructurant security suit"
	icon_state = "phorosianSecurity_suit"
	item_state = "phorosianSecurity_suit"

/obj/item/clothing/head/helmet/space/plasmasans/security
	name = "Phoron Restructurant security helmet"
	icon_state = "phorosianSecurity_helmet0"
	item_state = "phorosianSecurity_helmet0"

/obj/item/clothing/suit/space/plasmasans/security/hos
	name = "Phoron Restructurant head of security suit"
	icon_state = "phorosianHoS"
	item_state = "phorosianHoS"

/obj/item/clothing/head/helmet/space/plasmasans/security/hos
	name = "Phoron Restructurant head of security helmet"
	icon_state = "phorosianHoS_helmet0"
	item_state = "phorosianHoS_helmet0"

/obj/item/clothing/suit/space/plasmasans/hop
	name = "Phoron Restructurant head of personnel suit"
	icon_state = "phorosianHoP"
	item_state = "phorosianHoP"

/obj/item/clothing/head/helmet/space/plasmasans/hop
	name = "Phoron Restructurant head of personnel helmet"
	icon_state = "phorosianHoP_helmet0"
	item_state = "phorosianHoP_helmet0"

/obj/item/clothing/suit/space/plasmasans/security/captain
	name = "Phoron Restructurant captain suit"
	icon_state = "phorosianCaptain"
	item_state = "phorosianCaptain"

/obj/item/clothing/head/helmet/space/plasmasans/security/captain
	name = "Phoron Restructurant captain helmet"
	icon_state = "phorosianCaptain_helmet0"
	item_state = "phorosianCaptain_helmet0"

//NUKEOPS

/obj/item/clothing/suit/space/plasmasans/nuclear
	name = "blood red Phoron Restructurant suit"
	icon_state = "phorosianNukeops"
	item_state = "phorosianNukeops"
	w_class = ITEM_SIZE_LARGE
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_RIFLES,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
		)
	siemens_coefficient = 0.3
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/melee/energy/sword,/obj/item/weapon/handcuffs)
	breach_threshold = 200

/obj/item/clothing/head/helmet/space/plasmasans/nuclear
	name = "blood red Phoron Restructurant helmet"
	icon_state = "phorosianNukeops_helmet0"
	item_state = "phorosianNukeops_helmet0"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_RIFLES,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
		)
	siemens_coefficient = 0.3
	camera = /obj/machinery/camera/network/mercenary

/obj/item/device/plasmasanssuit_changer //Can be used to change the type of plasmaman suit.
	var/used = 0
	name = "Phoron Restructurant suit adapter kit"
	desc = "A device used to recolor and adapt a Phoron Restructurant containment suit to be more suited for the job they are assigned to."
	icon='icons/obj/storage.dmi'
	icon_state = "purple"
	w_class = 2
	force = 0
	throwforce = 0
	var/chosensuit
	var/list/suits= list("Scientist" , "Research Director", "Engineer", "Chief Engineer", "Atmospheric Technician", "Security Officer", "Warden", "Captain", "Head of Personnel", "Medical Doctor", "Paramedic", "Chemist", "Chief Medical Officer", "Chef", "Cargo Technician", "Shaft Miner", "Shaft Miner (alt)", "Gardener", "Chaplain", "Janitor", "Civilian")

/obj/item/device/plasmasanssuit_changer/traitor
	name = "Modified Phoron Restructurant suit adapter kit"
	desc = "A device used to recolor and adapt a Phoron Restructurant containment suit to be more suited for the job they are assigned to, this one seems to be modified."

/obj/item/device/plasmasanssuit_changer/attack_self(mob/living/user)
	chosensuit = input(user, "Pick the type of suit you would like to wear.") as null|anything in suits

/obj/item/device/plasmasanssuit_changer/traitor/attack_self(mob/living/user)
	suits= list("Modified")
	chosensuit = input(user, "Pick the type of suit you would like to wear.") as null|anything in suits

#define USED_ADAPT_HELM 1
#define USED_ADAPT_SUIT 2

/obj/item/device/plasmasanssuit_changer/afterattack(atom/target, mob/user, proximity)
	if(!proximity || !ishuman(user) || user.lying)
		return
	var/mob/living/carbon/human/H = user
	var/suit=/obj/item/clothing/suit/space/plasmasans
	var/helm=/obj/item/clothing/head/helmet/space/plasmasans
	switch(chosensuit)
		if("Scientist")
			suit=/obj/item/clothing/suit/space/plasmasans/science
			helm=/obj/item/clothing/head/helmet/space/plasmasans/science
		if("Research Director")
			suit=/obj/item/clothing/suit/space/plasmasans/science/rd
			helm=/obj/item/clothing/head/helmet/space/plasmasans/science/rd
		if("Engineer")
			suit=/obj/item/clothing/suit/space/plasmasans/engineer/
			helm=/obj/item/clothing/head/helmet/space/plasmasans/engineer/
		if("Chief Engineer")
			suit=/obj/item/clothing/suit/space/plasmasans/engineer/ce
			helm=/obj/item/clothing/head/helmet/space/plasmasans/engineer/ce
		if("Atmospheric Technician")
			suit=/obj/item/clothing/suit/space/plasmasans/atmostech
			helm=/obj/item/clothing/head/helmet/space/plasmasans/atmostech
		if("Security Officer")
			suit=/obj/item/clothing/suit/space/plasmasans/security/
			helm=/obj/item/clothing/head/helmet/space/plasmasans/security/
		if("Warden")
			suit=/obj/item/clothing/suit/space/plasmasans/security/hos
			helm=/obj/item/clothing/head/helmet/space/plasmasans/security/hos
		if("Captain","nano","blueshield")
			suit=/obj/item/clothing/suit/space/plasmasans/security/captain
			helm=/obj/item/clothing/head/helmet/space/plasmasans/security/captain
		if("Head of Personnel")
			suit=/obj/item/clothing/suit/space/plasmasans/hop
			helm=/obj/item/clothing/head/helmet/space/plasmasans/hop
		if("Medical Doctor")
			suit=/obj/item/clothing/suit/space/plasmasans/medical
			helm=/obj/item/clothing/head/helmet/space/plasmasans/medical
		if("Paramedic")
			suit=/obj/item/clothing/suit/space/plasmasans/medical/paramedic
			helm=/obj/item/clothing/head/helmet/space/plasmasans/medical/paramedic
		if("Chemist")
			suit=/obj/item/clothing/suit/space/plasmasans/medical/chemist
			helm=/obj/item/clothing/head/helmet/space/plasmasans/medical/chemist
		if("Chief Medical Officer")
			suit=/obj/item/clothing/suit/space/plasmasans/medical/cmo
			helm=/obj/item/clothing/head/helmet/space/plasmasans/medical/cmo
		if("Chef")
			suit=/obj/item/clothing/suit/space/plasmasans/service
			helm=/obj/item/clothing/head/helmet/space/plasmasans/service
		if("Cargo Technician")
			suit=/obj/item/clothing/suit/space/plasmasans/cargo
			helm=/obj/item/clothing/head/helmet/space/plasmasans/cargo
		if("Shaft Miner")
			suit=/obj/item/clothing/suit/space/plasmasans/miner
			helm=/obj/item/clothing/head/helmet/space/plasmasans/miner
		if("Shaft Miner (alt)")
			suit=/obj/item/clothing/suit/space/plasmasans/miner/alt
			helm=/obj/item/clothing/head/helmet/space/plasmasans/miner/alt
		if("Gardener")
			suit=/obj/item/clothing/suit/space/plasmasans/botanist
			helm=/obj/item/clothing/head/helmet/space/plasmasans/botanist
		if("Chaplain")
			suit=/obj/item/clothing/suit/space/plasmasans/chaplain
			helm=/obj/item/clothing/head/helmet/space/plasmasans/chaplain
		if("Janitor")
			suit=/obj/item/clothing/suit/space/plasmasans/janitor
			helm=/obj/item/clothing/head/helmet/space/plasmasans/janitor
		if("Civilian")
			suit=/obj/item/clothing/suit/space/plasmasans/assistant
			helm=/obj/item/clothing/head/helmet/space/plasmasans/assistant
		if("Modified")
			suit=/obj/item/clothing/suit/space/plasmasans/nuclear
			helm=/obj/item/clothing/head/helmet/space/plasmasans/nuclear

	if(istype(target, /obj/item/clothing/head/helmet/space/plasmasans))
		if(used & USED_ADAPT_HELM)
			to_chat(H, "<span class='notice'>The kit's helmet modifier has already been used.</span>")
			return
		H.equip_to_slot(new helm(H), slot_head)
		qdel(target)
		to_chat(H, "<span class='notice'>You use the kit on [target], adapting it to suit your current job.</span>")
		used |= USED_ADAPT_HELM
	if (istype(target, /obj/item/clothing/suit/space/plasmasans))
		if(used & USED_ADAPT_SUIT)
			to_chat(user, "<span class='notice'>The kit's suit modifier has already been used.</span>")
			return
		H.equip_to_slot(new suit(H), slot_wear_suit)
		qdel(target)
		to_chat(H, "<span class='notice'>You use the kit on [target], adapting it to suit your current job.</span>")
		used |= USED_ADAPT_SUIT
	return
	to_chat(user, "<span class='warning'>You can't modify [target]!</span>")

#undef USED_ADAPT_HELM
#undef USED_ADAPT_SUIT
