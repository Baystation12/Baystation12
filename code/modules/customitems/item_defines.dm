// Add custom items you give to people here, and put their icons in custom_items.dmi
// Remember to change 'icon = 'custom_items.dmi'' for items not using /obj/item/fluff as a base
// Clothing item_state doesn't use custom_items.dmi. Just add them to the normal clothing files.

/obj/item/fluff // so that they don't spam up the object tree
	icon = 'custom_items.dmi'
	w_class = 1.0

//////////// Clothing

/obj/item/clothing/glasses/meson/fluff/book_berner_1
	name = "bespectacled mesonic surveyors"
	desc = "One of the older meson scanner models retrofitted to perform like its modern counterparts."
	icon = 'custom_items.dmi'
	icon_state = "book_berner_1"

/obj/item/clothing/glasses/fluff/serithi_artalis_1
	name = "extranet HUD"
	desc = "A heads-up display with limited connectivity to the NanoTrasen Extranet, capable of displaying information from official NanoTrasen records."
	icon = 'custom_items.dmi'
	icon_state = "serithi_artalis_1"

/obj/item/clothing/head/helmet/hardhat/fluff/greg_anderson_1
	name = "old hard hat"
	desc = "An old dented hard hat with the nametag \"Anderson\". It seems to be backwards."
	icon_state = "hardhat0_dblue" //Already an in-game sprite
	item_state = "hardhat0_dblue"
	color = "dblue"

/obj/item/clothing/under/rank/virologist/fluff/cdc_jumpsuit
	name = "\improper CDC jumpsuit"
	desc = "A modified standard-issue CDC jumpsuit made of a special fiber that gives special protection against biohazards.  It has a biohazard symbol sewn into the back."
	icon = 'custom_items.dmi'
	icon_state = "cdc_jumpsuit"
	color = "cdc_jumpsuit"

/obj/item/clothing/suit/storage/labcoat/fluff/cdc_labcoat
	name = "\improper CDC labcoat"
	desc = "A standard-issue CDC labcoat that protects against minor chemical spills.  It has the name \"Wiles\" sewn on to the breast pocket."
	icon = 'custom_items.dmi'
	icon_state = "labcoat_cdc_open"

/obj/item/clothing/suit/storage/labcoat/fluff/pink
	name = "pink labcoat"
	desc = "A suit that protects against minor chemical spills. Has a pink stripe down from the shoulders."
	icon = 'custom_items.dmi'
	icon_state = "labcoat_pink_open"

/obj/item/clothing/suit/storage/labcoat/fluff/red
	name = "red labcoat"
	desc = "A suit that protects against minor chemical spills. Has a red stripe on the shoulders and rolled up sleeves."
	icon = 'custom_items.dmi'
	icon_state = "labcoat_red_open"

/obj/item/clothing/under/rank/medical/fluff/short
	name = "short sleeve medical jumpsuit"
	desc = "Made of a special fiber that gives special protection against biohazards. Has a cross on the chest denoting that the wearer is trained medical personnel and short sleeves."
	icon = 'custom_items.dmi'
	icon_state = "medical_short"
	color = "medical_short"

/obj/item/clothing/under/fluff/jumpsuitdown
	name = "rolled down jumpsuit"
	desc = "A rolled down jumpsuit. Great for mechanics."
	icon = 'custom_items.dmi'
	icon_state = "jumpsuitdown"
	item_state = "jumpsuitdown"
	color = "jumpsuitdown"

/obj/item/clothing/under/fluff/olddressuniform
	name = "retired dress uniform"
	desc = "A retired Station Head of Staff uniform, phased out twenty years ago for the newer jumpsuit design, but still acceptable dress. Lovingly maintained."
	icon = 'custom_items.dmi'
	icon_state = "olddressuniform"
	item_state = "olddressuniform"
	color = "olddressuniform"

/obj/item/clothing/suit/storage/det_suit/fluff/graycoat
	name = "gray coat"
	desc = "Old, worn out coat. It's seen better days."
	icon = 'custom_items.dmi'
	icon_state = "graycoat"
	item_state = "graycoat"
	color = "graycoat"

//////////// Useable Items

/obj/item/weapon/pen/fluff/multi
	name = "multicolor pen"
	desc = "It's a cool looking pen. Lots of colors!"

/obj/item/weapon/pen/fluff/fancypen
	name = "fancy pen"
	desc = "A fancy metal pen. It uses blue ink. An inscription on one side reads,\"L.L. - L.R.\""
	icon = 'custom_items.dmi'
	icon_state = "fancypen"

/obj/item/fluff/victor_kaminsky_1
	name = "golden detective's badge"
	desc = "NanoTrasen Security Department detective's badge, made from gold. Badge number is 564."
	icon_state = "victor_kaminsky_1"

/obj/item/fluff/victor_kaminsky_1/attack_self(mob/user as mob)
	for(var/mob/O in viewers(user, null))
		O.show_message(text("[] shows you: \icon[] [].", user, src, src.name), 1)
	src.add_fingerprint(user)

/obj/item/weapon/clipboard/fluff/smallnote
	name = "small notebook"
	desc = "A generic small spiral notebook that flips upwards."
	icon = 'custom_items.dmi'
	icon_state = "smallnotetext"

/obj/item/weapon/storage/fluff/maye_daye_1
	name = "pristine lunchbox"
	desc = "A pristine stainless steel lunch box. The initials M.D. are engraved on the inside of the lid."
	icon = 'custom_items.dmi'
	icon_state = "maye_daye_1"

/obj/item/weapon/reagent_containers/food/drinks/flask/fluff/johann_erzatz_1
	name = "vintage thermos"
	desc = "An older thermos with a faint shine."
	icon = 'custom_items.dmi'
	icon_state = "johann_erzatz_1"
	volume = 50

/obj/item/weapon/lighter/zippo/fluff/li_tsun_1
	name = "blue zippo lighter"
	desc = "A zippo lighter made of some blue metal."
	icon = 'custom_items.dmi'
	icon_state = "bluezippo"
	icon_on = "bluezippoon"
	icon_off = "bluezippo"

/obj/item/weapon/fluff/cado_keppel_1
	name = "purple comb"
	desc = "A pristine purple comb made from flexible plastic. It has a small K etched into its side."
	w_class = 1.0
	icon = 'custom_items.dmi'
	icon_state = "purplecomb"
	item_state = "purplecomb"

	attack_self(mob/user)
		if(user.r_hand == src || user.l_hand == src)
			for(var/mob/O in viewers(user, null))
				O.show_message(text("\red [] uses their [] to comb their hair with incredible style and sophistication. What a guy.", user, src), 1)
		return

//////////// Misc Items

/obj/item/fluff/wes_solari_1
	name = "family photograph"
	desc = "A family photograph of a couple and a young child, Written on the back it says \"See you soon Dad -Roy\"."
	icon_state = "wes_solari_1"

/obj/item/fluff/sarah_calvera_1
	name = "old photo"
	desc = "Looks like it was made on a really old, cheap camera. Low quality. The camera shows a young hispanic looking girl with red hair wearing a white dress is standing in front of an old looking wall. On the back there is a note in black marker that reads \"Sara, Siempre pensé que eras tan linda con ese vestido. Tu hermano, Carlos.\""
	icon_state = "sarah_calvera_1"

/obj/item/fluff/angelo_wilkerson_1
	name = "fancy watch"
	desc = "An old and expensive pocket watch. Engraved on the bottom is \"Odium est Source De Dolor\". On the back, there is an engraving that does not match the bottom and looks more recent. \"Angelo, If you find this, you shall never see me again. Please, for your sake, go anywhere and do anything but stay. I'm proud of you and I will always love you. Your father, Jacob Wilkerson.\" Jacob Wilkerson... Wasn't he that serial killer?"
	icon_state = "angelo_wilkerson_1"

/obj/item/fluff/sarah_carbrokes_1
	name = "locket"
	desc = "A grey locket with a picture of a black haired man in it. The text above it reads: \"Edwin Carbrokes\"."
	icon_state = "sarah_carbrokes_1"

/obj/item/fluff/ethan_way_1
	name = "old ID"
	desc = "A scratched and worn identification card; it appears too damaged to inferface with any technology. You can almost make out \"Tom Cabinet\" in the smeared ink."
	icon_state = "ethan_way_1"

/obj/item/fluff/val_mcneil_1
	name = "rosary pendant"
	desc = "A cross on a ring of beads, has McNeil etched onto the back."
	icon_state = "val_mcneil_1"
