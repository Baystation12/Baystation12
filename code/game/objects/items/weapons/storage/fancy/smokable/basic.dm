/obj/item/storage/fancy/smokable/case
	name = "cigarette case"
	desc = "A fancy little case for holding cigarettes. It has a spring-loaded click-open mechanism."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cigscase"
	item_state = "syringe_kit"
	open_sound = 'sound/effects/storage/pillbottle.ogg'
	max_storage_space = null
	sealed = FALSE
	storage_slots = 6
	key_type = list(/obj/item/clothing/mask/smokable/cigarette, /obj/item/material/coin)

/obj/item/storage/fancy/smokable/case/on_update_icon()
	ClearOverlays()
	icon_state = "[initial(icon_state)][opened ? "0" : ""]"
	if (!opened)
		return
	for (var/i = 1 to length(contents))
		if (istype(contents[i], /obj/item/clothing/mask/smokable/cigarette))
			AddOverlays(image(icon, "cig[i]"))
		else if (istype(contents[i], /obj/item/material/coin))
			var/obj/item/material/coin/C = contents[i]
			var/image/I = image(icon, "colorcoin[i]")
			if (C.applies_material_colour)
				var/material/M = C.material
				I.color = M.icon_colour
			else
				I.color = COLOR_GOLD
			AddOverlays(I)


/obj/item/storage/fancy/smokable/transstellar
	name = "pack of Trans-Stellar Duty-frees"
	desc = "A ubiquitous brand of cigarettes, found in the facilities of every major spacefaring corporation in the universe. As mild and flavorless as it gets."
	startswith = list(
		/obj/item/clothing/mask/smokable/cigarette = 6
	)


/obj/item/storage/fancy/smokable/dromedaryco
	name = "pack of Dromedary Co. cigarettes"
	desc = "A packet of six imported Dromedary Company cancer sticks. A label on the packaging reads, \"Wouldn't a slow death make a change?\"."
	icon_state = "Dpacket"
	startswith = list(
		/obj/item/clothing/mask/smokable/cigarette/dromedaryco = 6
	)


/obj/item/storage/fancy/smokable/killthroat
	name = "pack of Acme Co. cigarettes"
	desc = "A packet of six Acme Company cigarettes. For those who somehow want to obtain the record for the most amount of cancerous tumors."
	icon_state = "Bpacket"
	startswith = list(
		/obj/item/clothing/mask/smokable/cigarette/killthroat = 6
	)


/obj/item/storage/fancy/smokable/luckystars
	name = "pack of Lucky Stars"
	desc = "A mellow blend made from synthetic, pod-grown tobacco. The commercial jingle is guaranteed to get stuck in your head."
	icon_state = "LSpacket"
	item_state = "Dpacket"
	startswith = list(
		/obj/item/clothing/mask/smokable/cigarette/luckystars = 6
	)


/obj/item/storage/fancy/smokable/jerichos
	name = "pack of Jerichos"
	desc = "Typically seen dangling from the lips of Martian soldiers and border world hustlers. Tastes like hickory smoke, feels like warm liquid death down your lungs."
	icon_state = "Jpacket"
	item_state = "Dpacket"
	startswith = list(
		/obj/item/clothing/mask/smokable/cigarette/jerichos = 6
	)


/obj/item/storage/fancy/smokable/menthols
	name = "pack of Temperamento Menthols"
	desc = "With a sharp and natural organic menthol flavor, these Temperamentos are a favorite of NDV crews. Hardly anyone knows they make 'em in non-menthol!"
	icon_state = "TMpacket"
	item_state = "Dpacket"
	startswith = list(
		/obj/item/clothing/mask/smokable/cigarette/menthol = 6
	)


/obj/item/storage/fancy/smokable/carcinomas
	name = "pack of Carcinoma Angels"
	desc = "This unknown brand was slated for the chopping block, until they were publicly endorsed by an old Earthling gonzo journalist. The rest is history. They sell a variety for cats, too. Yes, actual cats."
	icon_state = "CApacket"
	item_state = "Dpacket"
	startswith = list(
		/obj/item/clothing/mask/smokable/cigarette/carcinomas = 6
	)


/obj/item/storage/fancy/smokable/professionals
	name = "pack of Professional 120s"
	desc = "Let's face it - if you're smoking these, you're either trying to look upper-class or you're 80 years old. That's the only excuse. They taste disgusting, too."
	icon_state = "P100packet"
	item_state = "Dpacket"
	startswith = list(
		/obj/item/clothing/mask/smokable/cigarette/professionals = 6
	)


/obj/item/storage/fancy/smokable/trident
	name = "pack of Trident Original cigars"
	desc = "The Trident brand's wood tipped little cigar, favored by the Sol corps diplomatique for their pleasant aroma. Machine made on Mars for over 100 years."
	icon_state = "CRpacket"
	item_state = "Dpacket"
	max_storage_space = 5
	startswith = list(
		/obj/item/clothing/mask/smokable/cigarette/trident = 5
	)


/obj/item/storage/fancy/smokable/trident_fruit
	name = "pack of Trident Fruit cigars"
	desc = "The Trident brand's wood tipped little cigar, favored by the Sol corps diplomatique for their pleasant aroma. Machine made on Mars for over 100 years. This is a fruit variety pack."
	icon_state = "CRFpacket"
	item_state = "Dpacket"
	max_storage_space = 5
	startswith = list(
		/obj/item/clothing/mask/smokable/cigarette/trident/watermelon,
		/obj/item/clothing/mask/smokable/cigarette/trident/orange,
		/obj/item/clothing/mask/smokable/cigarette/trident/grape,
		/obj/item/clothing/mask/smokable/cigarette/trident/cherry,
		/obj/item/clothing/mask/smokable/cigarette/trident/berry
	)


/obj/item/storage/fancy/smokable/trident_mint
	name = "pack of Trident Menthol cigars"
	desc = "The Trident brand's wood tipped little cigar, favored by the Sol corps diplomatique for their pleasant aroma. Machine made on Mars for over 100 years. These are the menthol variety."
	icon_state = "CRMpacket"
	item_state = "Dpacket"
	max_storage_space = 5
	startswith = list(
		/obj/item/clothing/mask/smokable/cigarette/trident/mint = 5
	)


/obj/item/storage/fancy/smokable/cigar
	name = "cigar case"
	desc = "A case for holding your cigars, in the short interstice before you smoke them."
	icon_state = "cigarcase"
	item_state = "cigpacket"
	max_storage_space = null
	storage_slots = 7
	slot_flags = SLOT_BELT
	sealed = FALSE
	key_type = list(/obj/item/clothing/mask/smokable/cigarette/cigar)
	startswith = list(
		/obj/item/clothing/mask/smokable/cigarette/cigar = 6
	)
