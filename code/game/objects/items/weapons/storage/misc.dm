/obj/item/weapon/storage/pill_bottle/dice	//7d6
	name = "bag of dice"
	desc = "It's a small bag with dice inside."
	icon = 'icons/obj/dice.dmi'
	icon_state = "dicebag"

/obj/item/weapon/storage/pill_bottle/dice/New()
	..()
	for(var/i = 1 to 7)
		new /obj/item/weapon/dice( src )

/obj/item/weapon/storage/pill_bottle/dice_nerd	//DnD dice
	name = "bag of gaming dice"
	desc = "It's a small bag with gaming dice inside."
	icon = 'icons/obj/dice.dmi'
	icon_state = "magicdicebag"

/obj/item/weapon/storage/pill_bottle/dice_nerd/New()
	..()
	new /obj/item/weapon/dice/d4( src )
	new /obj/item/weapon/dice( src )
	new /obj/item/weapon/dice/d8( src )
	new /obj/item/weapon/dice/d10( src )
	new /obj/item/weapon/dice/d12( src )
	new /obj/item/weapon/dice/d20( src )
	new /obj/item/weapon/dice/d100( src )

/*
 * Donut Box
 */

/obj/item/weapon/storage/box/donut
	icon = 'icons/obj/food.dmi'
	icon_state = "donutbox"
	name = "donut box"
	can_hold = list(/obj/item/weapon/reagent_containers/food/snacks/donut)
	foldable = /obj/item/stack/material/cardboard

	startswith = list(/obj/item/weapon/reagent_containers/food/snacks/donut/normal = 6)

/obj/item/weapon/storage/box/donut/on_update_icon()
	overlays.Cut()
	var/i = 0
	for(var/obj/item/weapon/reagent_containers/food/snacks/donut/D in contents)
		overlays += image('icons/obj/food.dmi', "[i][D.overlay_state]")
		i++

/obj/item/weapon/storage/box/donut/empty
	startswith = null

//putting this here instead of in fancy because these are not fancy. This may change in future updates if I feel like it. But until then, simple storage for simple devices.

/obj/item/weapon/storage/cigpaper
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

/obj/item/weapon/storage/cigpaper/fancy
	name = "\improper Trident cigarette paper"
	desc = "A fancy brand of Trident cigarette paper, for rolling your own cigarettes. Like a person who appreciates the finer things in life."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "fancycigpaperbook"

	startswith = list(/obj/item/paper/cig/fancy = 10)


/obj/item/weapon/storage/cigpaper/filters
	name = "box of cigarette filters"
	desc = "A box of generic cigarette filters for those who rolls their own but prefers others to inhale the fumes. Not endorsed by Late General Osmundsun."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "filterbin"

	startswith = list(/obj/item/paper/cig/filter = 10)

/obj/item/weapon/storage/chewables
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
	make_exact_fit()



//tobacco for rolling cigs, stored seperately.

/obj/item/weapon/storage/chewables/rollable
	name = "bag of tobacco"
	max_storage_space = 8

/obj/item/weapon/storage/chewables/rollable/bad
	name = "\improper MenAtArms"
	desc = "A bag of coarse gritty tobacco marketed towards leather-necks, "
	startswith = list(/obj/item/weapon/reagent_containers/terrbacco/bad = 8)
	icon_state = "rollcoarse"

/obj/item/weapon/storage/chewables/rollable/generic
	name = "\improper BlueSpess"
	desc = "Decent quality tobacco for mid-income earners and long haul space sailors."
	startswith = list(/obj/item/weapon/reagent_containers/terrbacco = 8)
	icon_state = "rollgeneric"

/obj/item/weapon/storage/chewables/rollable/fine
	name = "\improper Golden Sol"
	desc = "A exclusive brand of overpriced tobacco, allegedly grown at a lagrange point station in Sol system."
	startswith = list(/obj/item/weapon/reagent_containers/terrbacco/fine = 8)
	icon_state = "rollfine"

//chewing tobacco storage units and nicotine gum
/obj/item/weapon/storage/chewables/tobacco
	name = "\improper Lenny's chewing tobacco"
	desc = "A generic brand of chewing tobacco, for when you can't even be assed to light up."
	icon_state = "chew_levi"
	item_state = "Dpacket"

	startswith = list(/obj/item/clothing/mask/chewable/tobacco/lenni = 6)

/obj/item/weapon/storage/chewables/tobacco2
	name = "\improper RougeLady chewing tobacco"
	desc = "A finer grade of chewing tobacco, fit for a woman. Whom chews tobacco."
	icon_state = "chew_redman"
	item_state = "redlady"

	startswith = list(/obj/item/clothing/mask/chewable/tobacco/redlady = 6)

/obj/item/weapon/storage/chewables/tobacco3
	name = "\improper Nico Tine Gum"
	desc = "Cut out the middleman for your addiction fix."
	icon_state = "chew_nico"

	startswith = list(/obj/item/clothing/mask/chewable/tobacco/nico = 6)

/obj/item/weapon/storage/chewables/candy
	name = "master candy box, courtesy of candy cadet"
	desc = "a master type so I don't have to define where to derive the icons every time//that conked out, boxes are now in cigarette.dmi"

/obj/item/weapon/storage/chewables/candy/cookies
	name = "\improper Getmore Cookies"
	desc = "A pack of delicious cookies, and possibly the only product in Getmores Chocolate Corp lineup that has any trace of chocolate in it."
	icon_state = "cookiebag"
	max_storage_space = 6
	startswith = list(/obj/item/weapon/reagent_containers/food/snacks/cookie = 6)
	make_exact_fit()


/obj/item/weapon/storage/chewables/candy/gum
	name = "\improper Rainbo-Gums"
	desc = "A mixed pack of delicious fruit (and trace amounts of fuel) flavored bubble-gums!"
	icon_state = "gumpack"
	max_storage_space = 8
	startswith = list(/obj/item/clothing/mask/chewable/candy/gum = 8)
	make_exact_fit()


/obj/item/weapon/storage/chewables/candy/medicallollis
	name = "\improper Medibay-lols"
	desc = "A mixed pack of medicinal flavored lollipops. These have no business being on store shelves."
	icon_state = "lollipack"
	max_storage_space = 20
	startswith = list(/obj/item/clothing/mask/chewable/candy/lolli/meds = 20)
	make_exact_fit()