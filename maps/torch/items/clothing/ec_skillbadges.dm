
/obj/item/clothing/accessory/solgov/skillbadge
	name = "skill badge"
	desc = "An EC skill badge signifying that the bearer has passed the advanced training on spawning wrong types. Informally known as 'Shouldn't be seeing this'."
	slot = ACCESSORY_SLOT_INSIGNIA
	var/badgecolor //for on-mob sprite cause im not putting 9000 colored pixels in dmi

/obj/item/clothing/accessory/solgov/skillbadge/get_mob_overlay(mob/user_mob, slot)
	var/image/I = ..()
	if(!istype(loc,/obj/item/clothing))
		return I
	I.icon_state = "ec_spec_badge"
	I.color = badgecolor
	return I

/obj/item/clothing/accessory/solgov/skillbadge/botany
	name = "\improper Field Xenobotany Specialist badge"
	desc = "An EC skill badge signifying that the bearer has passed the advanced training on handling exotic xenoflora. Informally known as 'Vine Wrangler'."
	icon_state = "ec_badge_botany"
	badgecolor = "#387c4f"

/obj/item/clothing/accessory/solgov/skillbadge/netgun
	name = "\improper Xenofauna Acquisition Specialist badge"
	desc = "An EC skill badge signifying that the bearer has passed the advanced training on capturing alien wildlife with the netgun. Informally known as 'Xeno-Cowboy'."
	icon_state = "ec_badge_netgun"
	badgecolor = "#6a60a1"

/obj/item/clothing/accessory/solgov/skillbadge/eva
	name = "\improper Void Mobility Specialist badge"
	desc = "An EC skill badge signifying that the bearer has passed the advanced training on moving around in zero-g using a jetpack. Informally known as 'Zoomer'."
	icon_state = "ec_badge_eva"
	badgecolor = "#4d9799"

/obj/item/clothing/accessory/solgov/skillbadge/medical
	name = "\improper Advanced First Aid Specialist badge"
	desc = "An EC skill badge signifying that the bearer has passed the advanced training on CPR and basic medical tech. Informally known as 'Para-paramedic'."
	icon_state = "ec_badge_med"
	badgecolor = "#47799e"

/obj/item/clothing/accessory/solgov/skillbadge/mech
	name = "\improper Exosuit Specialist badge"
	desc = "An EC skill badge signifying that the bearer has passed the advanced training on piloting exosuits. Informally known as 'Exonaut'."
	icon_state = "ec_badge_exo"
	badgecolor = "#72763d"

/obj/item/clothing/accessory/solgov/skillbadge/electric
	name = "\improper Electrical Specialist badge"
	desc = "An EC skill badge signifying that the bearer has passed the advanced training on working with high-voltage electrical systems. Informally known as 'Jury-rigger'."
	icon_state = "ec_badge_electro"
	badgecolor = "#8e633f"

/obj/item/clothing/accessory/solgov/skillbadge/science
	name = "\improper Research Specialist badge"
	desc = "An EC skill badge signifying that the bearer has passed the advanced training on assisting in the labs and working the sensor suites. Informally known as 'Peeper'."
	icon_state = "ec_badge_sci"
	badgecolor = "#7876ad"

// Voidsuit accessory

/obj/item/clothing/accessory/solgov/skillstripe
	name = "specialist stripe"
	desc = "A thin stripe of spaceworthy material with vacuum-rated adhesive, for attaching to the voidsuit. Indicates some sort of specialist training."
	slot = ACCESSORY_SLOT_INSIGNIA
	on_rolled = list("down" = "none")
	accessory_flags = ACCESSORY_REMOVABLE | ACCESSORY_HIGH_VISIBILITY
	icon_state = "ec_stripe"

/obj/item/clothing/accessory/solgov/skillstripe/botany
	name = "xenobotanist stripe"
	desc = "A thin stripe of spaceworthy material with vacuum-rated adhesive, for attaching to the voidsuit. Indicates Field Xenobotany Specialist training."
	color = "#387c4f"

/obj/item/clothing/accessory/solgov/skillstripe/netgun
	name = "netgunner stripe"
	desc = "A thin stripe of spaceworthy material with vacuum-rated adhesive, for attaching to the voidsuit. Indicates Xenofauna Acquisition Specialist training."
	color = "#6a60a1"

/obj/item/clothing/accessory/solgov/skillstripe/eva
	name = "void stripe"
	desc = "A thin stripe of spaceworthy material with vacuum-rated adhesive, for attaching to the voidsuit. Indicates Void Mobility Specialist training."
	color = "#3d7172"

/obj/item/clothing/accessory/solgov/skillstripe/medical
	name = "medic stripe"
	desc = "A thin stripe of spaceworthy material with vacuum-rated adhesive, for attaching to the voidsuit. Indicates Advanced First Aid Specialist training."
	color = "#2d6295"

/obj/item/clothing/accessory/solgov/skillstripe/electric
	name = "electrician stripe"
	desc = "A thin stripe of spaceworthy material with vacuum-rated adhesive, for attaching to the voidsuit. Indicates Electrical Specialist training."
	color = "#8e633f"
