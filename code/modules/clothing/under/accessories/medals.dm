/obj/item/clothing/accessory/medal
	name = ACCESSORY_SLOT_MEDAL
	desc = "A simple medal."
	icon_state = "bronze"
	slot = ACCESSORY_SLOT_MEDAL
	on_rolled_down = ACCESSORY_ROLLED_NONE


/obj/item/clothing/accessory/medal/iron
	name = "iron medal"
	desc = "A simple iron medal."
	icon_state = "iron"
	item_state = "iron"


/obj/item/clothing/accessory/medal/bronze
	name = "bronze medal"
	desc = "A simple bronze medal."
	icon_state = "bronze"
	item_state = "bronze"


/obj/item/clothing/accessory/medal/silver
	name = "silver medal"
	desc = "A simple silver medal."
	icon_state = "silver"
	item_state = "silver"


/obj/item/clothing/accessory/medal/gold
	name = "gold medal"
	desc = "A simple gold medal."
	icon_state = "gold"
	item_state = "gold"


/obj/item/clothing/accessory/medal/gold/nanotrasen
	name = "corporate command medal"
	desc = "A gold medal awarded to employees for service as the Captain of a corporate facility, station, or vessel."
	icon_state = "gold_nt"


/obj/item/clothing/accessory/medal/silver/nanotrasen
	name = "corporate service medal"
	desc = "A silver medal awarded to employees for distinguished service in support of corporate interests."
	icon_state = "silver_nt"


/obj/item/clothing/accessory/medal/bronze/nanotrasen
	name = "corporate sciences medal"
	desc = "A bronze medal awarded to employees for signifigant contributions to the fields of science or engineering."
	icon_state = "bronze_nt"


/obj/item/clothing/accessory/medal/iron/nanotrasen
	name = "corporate merit medal"
	desc = "An iron medal awarded to employees for merit."
	icon_state = "iron_nt"

//fancy boxes for fancy storage purposes
/obj/item/storage/medalbox
	name = "medal box"
	desc = "A small lacquered wooden box for holding decorations."
	icon = 'icons/obj/medalbox.dmi'
	icon_state = "medalbox"
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_SMALL
	max_storage_space = 3
	contents_allowed = list(
		/obj/item/clothing/accessory/medal,
		/obj/item/clothing/accessory/ribbon,
		/obj/item/clothing/accessory/solgov/specialty
	)

/obj/item/storage/medalbox/corp_command
	startswith = list(/obj/item/clothing/accessory/medal/gold/nanotrasen)

/obj/item/storage/medalbox/corp_service
	startswith = list(/obj/item/clothing/accessory/medal/silver/nanotrasen)

/obj/item/storage/medalbox/corp_science
	startswith = list(/obj/item/clothing/accessory/medal/bronze/nanotrasen)

/obj/item/storage/medalbox/corp_merit
	startswith = list(/obj/item/clothing/accessory/medal/iron/nanotrasen)
