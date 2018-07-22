//Medals!

/obj/item/clothing/accessory/medal
	name = ACCESSORY_SLOT_MEDAL
	desc = "A simple medal."
	icon_state = "bronze"
	slot = ACCESSORY_SLOT_MEDAL

/obj/item/clothing/accessory/medal/proc/set_desc(var/mob/living/carbon/human/H)

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

//NT medals

/obj/item/clothing/accessory/medal/gold/corporate

/obj/item/clothing/accessory/medal/gold/corporate/Initialize()
	. = ..()
	var/mob/living/carbon/human/H
	H = get_holder_of_type(src, /mob/living/carbon/human)
	if(H)
		set_desc(H)
	if(H.personal_faction == "NanoTrasen")
		icon_state = "gold_nt"
	if(H.personal_faction == "None")
		name = "corporate command medal"
		desc = "A gold medal awarded to corporate employees for service as the Captain of a corporate facility, station, or vessel."
	else return

/obj/item/clothing/accessory/medal/gold/corporate/set_desc(var/mob/living/carbon/human/H)
	if(!istype(H))
		return
	name = "\improper [H.personal_faction] command medal"
	desc = "A gold medal awarded to [H.personal_faction] employees for service as the Captain of a [H.personal_faction] facility, station, or vessel."

/obj/item/clothing/accessory/medal/silver/corporate

/obj/item/clothing/accessory/medal/silver/corporate/Initialize()
	. = ..()
	var/mob/living/carbon/human/H
	H = get_holder_of_type(src, /mob/living/carbon/human)
	if(H)
		set_desc(H)
	if(H.personal_faction == "NanoTrasen")
		icon_state = "silver_nt"
	if(H.personal_faction == "None")
		name = "corporate service medal"
		desc = "A silver medal awarded to corporate employees for distinguished service in support of corporate interests."
	else return

/obj/item/clothing/accessory/medal/silver/corporate/set_desc(var/mob/living/carbon/human/H)
	if(!istype(H))
		return
	name = "\improper [H.personal_faction] service medal"
	desc = "A silver medal awarded to [H.personal_faction] employees for distinguished service in support of corporate interests."

/obj/item/clothing/accessory/medal/bronze/corporate

/obj/item/clothing/accessory/medal/bronze/corporate/Initialize()
	. = ..()
	var/mob/living/carbon/human/H
	H = get_holder_of_type(src, /mob/living/carbon/human)
	if(H)
		set_desc(H)
	if(H.personal_faction == "NanoTrasen")
		icon_state = "bronze_nt"
	if(H.personal_faction == "None")
		name = "\improper corporate service medal"
		desc = "A silver medal awarded to corporate employees for distinguished service in support of corporate interests."
	else return

/obj/item/clothing/accessory/medal/bronze/corporate/set_desc(var/mob/living/carbon/human/H)
	if(!istype(H))
		return
	name = "\improper [H.personal_faction] sciences medal"
	desc = "A bronze medal awarded to [H.personal_faction] employees for significant contributions to the fields of science or engineering."

/obj/item/clothing/accessory/medal/iron/corporate
	name = "\improper NanoTrasen merit medal"
	desc = "An iron medal awarded to NanoTrasen employees for merit."
	icon_state = "iron_nt"

/obj/item/clothing/accessory/medal/iron/corporate/Initialize()
	. = ..()
	var/mob/living/carbon/human/H
	H = get_holder_of_type(src, /mob/living/carbon/human)
	if(H)
		set_desc(H)
	if(H.personal_faction == "NanoTrasen")
		icon_state = "iron_nt"
	if(H.personal_faction == "None")
		name = "\improper corporate merit medal"
		desc = "An iron medal awarded to corporate employees for merit."
	else return

/obj/item/clothing/accessory/medal/iron/corporate/set_desc(var/mob/living/carbon/human/H)
	if(!istype(H))
		return
	name = "\improper [H.personal_faction] merit medal"
	desc = "An iron medal awarded to [H.personal_faction] employees for merit."