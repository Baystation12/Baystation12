/obj/item/clothing/mask/gas
	name = "gas mask"
	desc = "A face-covering mask that can be connected to an air supply. Filters harmful gases from the air."
	icon_state = "fullgas"
	item_state = "fullgas"
	item_flags = ITEM_FLAG_BLOCK_GAS_SMOKE_EFFECT | ITEM_FLAG_AIRTIGHT
	flags_inv = HIDEEARS|HIDEEYES|HIDEFACE
	body_parts_covered = FACE|EYES
	w_class = ITEM_SIZE_NORMAL
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	siemens_coefficient = 0.9
	armor = list(
		melee = ARMOR_MELEE_MINOR,
		bio = ARMOR_BIO_STRONG
		)
	filtered_gases = list(
		GAS_PHORON,
		GAS_N2O,
		GAS_CHLORINE,
		GAS_AMMONIA,
		GAS_CO,
		GAS_METHYL_BROMIDE,
		GAS_METHANE
	)
	var/clogged
	var/filter_water
	var/gas_filter_strength = 1			//For gas mask filters


/obj/item/clothing/mask/gas/examine(mob/user)
	. = ..()
	if(clogged)
		to_chat(user, "<span class='warning'>The intakes are clogged with [clogged]!</span>")

/obj/item/clothing/mask/gas/filters_water()
	return (filter_water && !clogged)

/obj/item/clothing/mask/gas/attack_self(var/mob/user)
	if(clogged)
		user.visible_message("<span class='notice'>\The [user] begins unclogging the intakes of \the [src].</span>")
		if(do_after(user, 10 SECONDS, src, DO_PUBLIC_UNIQUE) && clogged)
			user.visible_message("<span class='notice'>\The [user] has unclogged \the [src].</span>")
			clogged = FALSE
		return
	. = ..()

/obj/item/clothing/mask/gas/filter_air(datum/gas_mixture/air)
	var/datum/gas_mixture/filtered = new

	for(var/g in filtered_gases)
		if(air.gas[g])
			filtered.gas[g] = air.gas[g] * gas_filter_strength
			air.gas[g] -= filtered.gas[g]

	air.update_values()
	filtered.update_values()

	return filtered

/obj/item/clothing/mask/gas/half
	name = "face mask"
	desc = "A compact, durable gas mask that can be connected to an air supply."
	icon_state = "halfgas"
	item_state = "halfgas"
	siemens_coefficient = 0.7
	body_parts_covered = FACE
	w_class = ITEM_SIZE_SMALL
	down_gas_transfer_coefficient = 1
	down_body_parts_covered = null
	down_item_flags = null
	down_icon_state = "halfgasdown"
	pull_mask = TRUE
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		bio = ARMOR_BIO_RESISTANT
		)

//In scaling order of utility and seriousness

/obj/item/clothing/mask/gas/radical
	name = "gas mask"
	desc = "A face-covering mask that can be connected to an air supply. Filters harmful gases from the air. This one has additional filters to remove radioactive particles."
	icon_state = "gas_mask"
	item_state = "gas_mask"
	body_parts_covered = FACE|EYES
	armor = list(
		melee = ARMOR_MELEE_MINOR,
		bio = ARMOR_BIO_STRONG,
		rad = ARMOR_RAD_SMALL
		)

/obj/item/clothing/mask/gas/budget
	name = "gas mask"
	desc = "A face-covering mask that can be connected to an air supply. Filters harmful gases from the air. This one looks pretty dodgy. Are you sure it works?"
	icon_state = "gas_alt"
	item_state = "gas_alt"
	body_parts_covered = FACE|EYES
	armor = list(
		melee = ARMOR_MELEE_MINOR,
		bio = ARMOR_BIO_SMALL
		)

/obj/item/clothing/mask/gas/swat
	name = "\improper SWAT mask"
	desc = "A close-fitting tactical mask that can be connected to an air supply."
	icon_state = "swat"
	item_state = "swat"
	siemens_coefficient = 0.7
	body_parts_covered = FACE|EYES
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		bio = ARMOR_BIO_STRONG
		)

/obj/item/clothing/mask/gas/syndicate
	name = "tactical mask"
	desc = "A close-fitting tactical mask that can be connected to an air supply."
	icon_state = "swat"
	item_state = "swat"
	siemens_coefficient = 0.7
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_MINOR,
		bio = ARMOR_BIO_STRONG
		)

/obj/item/clothing/mask/gas/death_commando
	name = "\improper Death Commando Mask"
	desc = "A grim tactical mask worn by the fictional Death Commandos, elites of the also fictional Space Syndicate. Saturdays at 10!"
	icon_state = "death"
	item_state = "death"
	siemens_coefficient = 0.2

/obj/item/clothing/mask/gas/cyborg
	name = "cyborg visor"
	desc = "Beep boop!"
	icon_state = "death"
	item_state = "death"

//Plague Dr suit can be found in clothing/suits/bio.dm
/obj/item/clothing/mask/gas/plaguedoctor
	name = "plague doctor mask"
	desc = "A modernised version of the classic design, this mask will not only filter out phoron but it can also be connected to an air supply."
	icon_state = "plaguedoctor"
	item_state = "plaguedoctor"
	armor = list(
		bio = ARMOR_BIO_SHIELDED
		)
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/gas/clown_hat
	name = "clown wig and mask"
	desc = "A true prankster's facial attire. A clown is incomplete without their wig and mask."
	icon_state = "clown"
	item_state = "clown"

/obj/item/clothing/mask/gas/sexyclown
	name = "sexy-clown wig and mask"
	desc = "A feminine clown mask for the dabbling crossdressers or female entertainers."
	icon_state = "sexyclown"
	item_state = "sexyclown"

/obj/item/clothing/mask/gas/mime
	name = "mime mask"
	desc = "The traditional mime's mask. It has an eerie facial posture."
	icon_state = "mime"
	item_state = "mime"

/obj/item/clothing/mask/gas/monkeymask
	name = "monkey mask"
	desc = "A mask used when acting as a monkey."
	icon_state = "monkeymask"
	item_state = "monkeymask"
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/gas/sexymime
	name = "sexy mime mask"
	desc = "A traditional female mime's mask."
	icon_state = "sexymime"
	item_state = "sexymime"

/obj/item/clothing/mask/gas/owl_mask
	name = "owl mask"
	desc = "Twoooo!"
	icon_state = "owl"
	item_state = "owl"
	body_parts_covered = HEAD|FACE|EYES

//Vox Unique Masks

/obj/item/clothing/mask/gas/vox
	name = "vox breathing mask"
	desc = "A small oxygen filter for use by Vox."
	icon_state = "respirator"
	item_state = "respirator"
	flags_inv = 0
	body_parts_covered = 0
	species_restricted = list(SPECIES_VOX, SPECIES_VOX_ARMALIS)
	filtered_gases = list(GAS_OXYGEN)


/obj/item/clothing/mask/gas/swat/vox
	name = "alien mask"
	desc = "Clearly not designed for a human face."
	icon_state = "voxswat"
	item_state = "voxswat"
	body_parts_covered = EYES
	species_restricted = list(SPECIES_VOX, SPECIES_VOX_ARMALIS)
	filtered_gases = list(
		GAS_OXYGEN,
		GAS_PHORON,
		GAS_N2O,
		GAS_CHLORINE,
		GAS_AMMONIA,
		GAS_CO,
		GAS_METHYL_BROMIDE,
		GAS_METHANE
		)

/obj/item/clothing/mask/gas/aquabreather
	name = "aquabreather"
	desc = "A compact CO2 scrubber and breathing apparatus that draws oxygen from water."
	icon_state = "halfgas"
	filter_water = TRUE
	body_parts_covered = FACE
	w_class = 2
