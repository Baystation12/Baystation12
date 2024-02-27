/* CARDS
 * ========
 */

/obj/item/card/id/hand
	desc = "An identification card issued to corporate laborers across countless frontier facilities and vessels."
	detail_color = COLOR_BROWN
	access = list(access_away_hand)

/obj/item/card/id/hand/captain
	desc = "An identification card issued to corporate pilot crew."
	icon_state = "base"
	color = COLOR_GRAY40
	extra_details = list("goldstripe")
	detail_color = COLOR_COMMAND_BLUE
	access = list(access_away_hand, access_away_hand_captain)

/obj/item/card/id/hand/captain/ftu
	desc = "An identification card issued to Free Trade Union personnel."
	color = COLOR_OFF_WHITE
	detail_color = COLOR_BEIGE

/obj/item/card/id/hand/captain/fifth_fleet
	desc = "An identification card issued to SCGN Flight Crew. This one was issued to personnel of Fifth Fleet's Battlegroup 'Alpha'."
	icon_state = "base"
	extra_details = null
	color = COLOR_GRAY40
	detail_color = "#447ab1"
	access = list(access_away_hand, access_away_hand_captain)

/obj/item/card/id/hand/medic
	desc = "An identification card issued to corporate medical personnel across countless frontier facilities and vessels."
	icon_state = "base"
	detail_color = COLOR_PALE_BLUE_GRAY
	access = list(access_away_hand, access_away_hand_med, access_away_hand_captain)

/obj/item/card/id/hand/medic/fifth_fleet
	desc = "An identification card issued to corporate medical personnel across countless frontier facilities and vessels."
	icon_state = "base"
	detail_color = COLOR_PALE_BLUE_GRAY
	access = list(access_away_hand, access_away_hand_med, access_away_hand_captain)

/* CLOTHING
 * ========
 */

/obj/item/clothing/under/fa/vacsuit/hand/guardsman
	accessories = list(/obj/item/clothing/accessory/fa_badge/guardsman)

/obj/item/clothing/under/solgov/utility/fleet/command/pilot/fifth_fleet
	accessories = list(
		/obj/item/clothing/accessory/solgov/specialty/pilot,
		/obj/item/clothing/accessory/solgov/rank/fleet/officer/o3,
		/obj/item/clothing/accessory/solgov/fleet_patch/fifth
	)

/obj/item/clothing/under/solgov/utility/fleet/medical/hand
	accessories = list(
		/obj/item/clothing/accessory/solgov/department/medical/fleet,
		/obj/item/clothing/accessory/solgov/rank/fleet/officer,
		/obj/item/clothing/accessory/solgov/fleet_patch/fifth
	)

/obj/item/clothing/suit/bio_suit/anomaly/lethal
	name = "cheap anomaly suit"
	desc = "A cheap suit that should protect against exotic alien energies and biological contamination."
	icon = 'mods/_maps/hand/icons/obj/obj_hand.dmi'
	item_icons = list(slot_wear_suit_str = 'mods/_maps/hand/icons/mob/onmob_hand.dmi')
	icon_state = "lethal_suit"

/obj/item/clothing/head/bio_hood/anomaly/lethal
	name = "cheap anomaly mask"
	desc = "A hood that should protect the head and face from exotic alien energies and biological contamination."
	icon = 'mods/_maps/hand/icons/obj/obj_hand.dmi'
	item_icons = list(slot_head_str = 'mods/_maps/hand/icons/mob/onmob_hand.dmi')
	icon_state = "lethal_helm"

// Fluff

/obj/item/paper/hand/pods
	name = "Pods Usage"
	icon_state = "paper_words"
	language = LANGUAGE_SPACER
	info = {"
		<div style="text-align: center;">
			<p>Техника безопасности при работе со шлюзовыми камерами капсул EE S-class 18-24:</p>
			<p>1. Вручную откройте дверь шлюза. Войдите в шлюз</p>
			<p>2. Закройте внутреннюю дверь. Убедитесь что капсула пристыкована. Откройте обе двери</p>
			<p>3. Опустите болты шлюза капсулы. Начинайте проводить погрузку</p>
			<p>4. Завершив погрузку, закройте внутреннюю дверь шлюза. Закройте внешнюю дверь шлюза, находясь в шлюзе капсулы</p>
			<p>5. Переключите шлюз капсулы на удержание воздуха. Убедитесь что он закроется. После этого начинайте отстыковку</p>
		</div>
	"}

/obj/item/paper/hand/engineer
	name = "To stupid ones"
	language = LANGUAGE_SPACER
	info = {"<h1>Капсулы, ещё раз.</h1>
			<p>Если ещё раз кто-то из вас, кривых и косых недолюдей забудет нормально пристыковать эйнштейновскую капсулу перед тем, как давать команду на открытие шлюза</p>
			<h1>То я этого умника привяжу снаружи перед мостиком на день.</h1>
		"}
