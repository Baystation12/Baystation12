/obj/item/storage/pill_bottle/dice	//7d6
	name = "bag of dice"
	desc = "It's a small bag with dice inside."
	icon = 'icons/obj/dice.dmi'
	icon_state = "dicebag"

/obj/item/storage/pill_bottle/dice/New()
	..()
	for(var/i = 1 to 7)
		new /obj/item/dice( src )

/obj/item/storage/pill_bottle/dice_nerd	//DnD dice
	name = "bag of gaming dice"
	desc = "It's a small bag with gaming dice inside."
	icon = 'icons/obj/dice.dmi'
	icon_state = "magicdicebag"

/obj/item/storage/pill_bottle/dice_nerd/New()
	..()
	new /obj/item/dice/d4( src )
	new /obj/item/dice( src )
	new /obj/item/dice/d8( src )
	new /obj/item/dice/d10( src )
	new /obj/item/dice/d12( src )
	new /obj/item/dice/d20( src )
	new /obj/item/dice/d100( src )


/obj/item/storage/box/donut
	icon = 'icons/obj/food.dmi'
	icon_state = "donutbox"
	name = "donut box"
	can_hold = list(/obj/item/reagent_containers/food/snacks/donut)
	foldable = /obj/item/stack/material/cardboard

	startswith = list(/obj/item/reagent_containers/food/snacks/donut/normal = 6)

/obj/item/storage/box/donut/on_update_icon()
	overlays.Cut()
	var/i = 0
	for(var/obj/item/reagent_containers/food/snacks/donut/D in contents)
		overlays += image('icons/obj/food.dmi', "[i][D.overlay_state]")
		i++

/obj/item/storage/box/donut/empty
	startswith = null

//misc tobacco nonsense
/obj/item/storage/cigpaper
	name = "\improper Gen. Eric cigarette paper"
	desc = "A ubiquitous brand of cigarette paper, allegedly endorsed by 24th century war hero General Eric Osmundsun for rolling your own cigarettes. Osmundsun died in a freak kayak accident. As it ate him alive during his last campaign. It was pretty freaky."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cigpaperbook"
	item_state = "cigpacket"
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = 10
	throwforce = 2
	slot_flags = SLOT_BELT
	startswith = list(/obj/item/paper/cig = 10)

/obj/item/storage/cigpaper/fancy
	name = "\improper Trident cigarette paper"
	desc = "A fancy brand of Trident cigarette paper, for rolling your own cigarettes. Like a person who appreciates the finer things in life."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "fancycigpaperbook"
	startswith = list(/obj/item/paper/cig/fancy = 10)

/obj/item/storage/cigpaper/filters
	name = "box of cigarette filters"
	desc = "A box of generic cigarette filters for those who rolls their own but prefers others to inhale the fumes. Not endorsed by Late General Osmundsun."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "filterbin"
	startswith = list(/obj/item/paper/cig/filter = 10)

/obj/item/storage/chewables
	name = "box of chewing wads master"
	desc = "A generic brands of Waffle Co Wads, unflavored chews. Why do these exist?"
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "placeholder"
	item_state = "cigpacket"
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = 6
	throwforce = 2
	slot_flags = SLOT_BELT
	startswith = list(/obj/item/clothing/mask/chewable/tobacco = 6)

/obj/item/storage/chewables/Initialize()
	. = ..()
	make_exact_fit()

//loose leaf
/obj/item/storage/chewables/rollable
	name = "bag of tobacco"
	max_storage_space = 8

/obj/item/storage/chewables/rollable/bad
	name = "bag of Men at Arms tobacco"
	desc = "A bag of coarse gritty tobacco marketed towards leather-necks."
	startswith = list(/obj/item/reagent_containers/food/snacks/grown/dried_tobacco/bad = 8)
	icon_state = "rollcoarse"

/obj/item/storage/chewables/rollable/generic
	name = "bag of BluSpace tobacco"
	desc = "Decent quality tobacco for mid-income earners and long haul space sailors."
	startswith = list(/obj/item/reagent_containers/food/snacks/grown/dried_tobacco = 8)
	icon_state = "rollgeneric"

/obj/item/storage/chewables/rollable/fine
	name = "bag of Golden Sol tobacco"
	desc = "A exclusive brand of overpriced tobacco, allegedly grown at a lagrange point station in Sol system."
	startswith = list(/obj/item/reagent_containers/food/snacks/grown/dried_tobacco/fine = 8)
	icon_state = "rollfine"

//chewing tobacco
/obj/item/storage/chewables/tobacco
	name = "tin of Lenny's brand chewing tobacco"
	desc = "A generic brand of chewing tobacco, for when you can't even be assed to light up."
	icon_state = "chew_levi"
	item_state = "Dpacket"
	startswith = list(/obj/item/clothing/mask/chewable/tobacco/lenni = 6)

/obj/item/storage/chewables/tobacco2
	name = "tin of Red Lady chewing tobacco"
	desc = "A finer grade of chewing tobacco."
	icon_state = "chew_redman"
	item_state = "redlady"
	startswith = list(/obj/item/clothing/mask/chewable/tobacco/redlady = 6)

/obj/item/storage/chewables/tobacco3
	name = "box of Nico-Tine gum"
	desc = "A Sol-approved brand of nicotine gum. Cut out the middleman for your addiction fix."
	icon_state = "chew_nico"
	startswith = list(/obj/item/clothing/mask/chewable/tobacco/nico = 6)

//non-tobacco
/obj/item/storage/chewables/candy/cookies
	name = "pack of Getmore Cookies"
	desc = "A pack of delicious cookies, and possibly the only product in Getmores Chocolate Corp lineup that has any trace of chocolate in it."
	icon_state = "cookiebag"
	max_storage_space = 6
	startswith = list(/obj/item/reagent_containers/food/snacks/cookie = 6)

/obj/item/storage/chewables/candy/gum
	name = "pack of Rainbo-Gums"
	desc = "A mixed pack of delicious fruit flavored bubble-gums!"
	icon_state = "gumpack"
	max_storage_space = 8
	startswith = list(/obj/item/clothing/mask/chewable/candy/gum = 8)

/obj/item/storage/chewables/candy/medicallollis
	name = "pack of medicinal lollipops"
	desc = "A mixed pack of medicinal flavored lollipops. These have no business being on store shelves."
	icon_state = "lollipack"
	max_storage_space = 20
	startswith = list(/obj/item/clothing/mask/chewable/candy/lolli/meds = 20)

/obj/item/storage/medical_lolli_jar
	name = "lollipops jar"
	desc = "A mixed pack of flavored medicinal lollipops. Perfect for small boo-boos."
	icon_state = "lollijar"
	max_storage_space = 20
	startswith = list(/obj/item/clothing/mask/chewable/candy/lolli/weak_meds = 15)

/obj/item/storage/medical_lolli_jar/on_update_icon()
	. = ..()
	if(contents.len)
		icon_state = "lollijar"
	else
		icon_state = "lollijar_empty"