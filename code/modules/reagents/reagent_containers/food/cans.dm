/obj/item/weapon/reagent_containers/food/drinks/cans
	volume = 40 //just over one and a half cups
	amount_per_transfer_from_this = 5
	atom_flags = 0 //starts closed

//DRINKS

/obj/item/weapon/reagent_containers/food/drinks/cans/cola
	name = "\improper Space Cola"
	desc = "Cola. in space."
	icon_state = "cola"
	center_of_mass = "x=16;y=10"

/obj/item/weapon/reagent_containers/food/drinks/cans/cola/New()
	..()
	reagents.add_reagent(/datum/reagent/drink/space_cola, 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle
	name = "bottled water"
	desc = "Pure drinking water, imported from the Martian poles."
	icon_state = "waterbottle"
	center_of_mass = "x=15;y=8"

/obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle/New()
	..()
	reagents.add_reagent(/datum/reagent/water, 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle/open(mob/user)
	playsound(loc,'sound/effects/bonebreak1.ogg', rand(10,50), 1)
	to_chat(user, "<span class='notice'>You twist open \the [src], destroying the safety seal!</span>")
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER

/obj/item/weapon/reagent_containers/food/drinks/cans/space_mountain_wind
	name = "\improper Space Mountain Wind"
	desc = "Blows right through you like a space wind."
	icon_state = "space_mountain_wind"
	center_of_mass = "x=16;y=10"

/obj/item/weapon/reagent_containers/food/drinks/cans/space_mountain_wind/New()
	..()
	reagents.add_reagent(/datum/reagent/drink/spacemountainwind, 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/thirteenloko
	name = "\improper Thirteen Loko"
	desc = "The CMO has advised crew members that consumption of Thirteen Loko may result in seizures, blindness, drunkeness, or even death. Please Drink Responsibly."
	icon_state = "thirteen_loko"
	center_of_mass = "x=16;y=8"

/obj/item/weapon/reagent_containers/food/drinks/cans/thirteenloko/New()
	..()
	reagents.add_reagent(/datum/reagent/ethanol/thirteenloko, 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/dr_gibb
	name = "\improper Dr. Gibb"
	desc = "A delicious mixture of 42 different flavors."
	icon_state = "dr_gibb"
	center_of_mass = "x=16;y=10"

/obj/item/weapon/reagent_containers/food/drinks/cans/dr_gibb/New()
	..()
	reagents.add_reagent(/datum/reagent/drink/dr_gibb, 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/starkist
	name = "\improper Star-kist"
	desc = "The taste of a star in liquid form. And, a bit of tuna...?"
	icon_state = "starkist"
	center_of_mass = "x=16;y=10"
/obj/item/weapon/reagent_containers/food/drinks/cans/starkist/New()
	..()
	reagents.add_reagent(/datum/reagent/drink/brownstar, 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/space_up
	name = "\improper Space-Up"
	desc = "Tastes like a hull breach in your mouth."
	icon_state = "space-up"
	center_of_mass = "x=16;y=10"

/obj/item/weapon/reagent_containers/food/drinks/cans/space_up/New()
	..()
	reagents.add_reagent(/datum/reagent/drink/space_up, 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/lemon_lime
	name = "\improper Lemon-Lime"
	desc = "You wanted ORANGE. It gave you Lemon Lime."
	icon_state = "lemon-lime"
	center_of_mass = "x=16;y=10"

/obj/item/weapon/reagent_containers/food/drinks/cans/lemon_lime/New()
	..()
	reagents.add_reagent(/datum/reagent/drink/lemon_lime, 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/iced_tea
	name = "\improper Vrisk Serket Iced Tea"
	desc = "That sweet, refreshing southern earthy flavor. That's where it's from, right? South Earth?"
	icon_state = "ice_tea_can"
	center_of_mass = "x=16;y=10"

/obj/item/weapon/reagent_containers/food/drinks/cans/iced_tea/New()
	..()
	reagents.add_reagent(/datum/reagent/drink/tea/icetea, 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/grape_juice
	name = "\improper Grapel Juice"
	desc = "500 pages of rules of how to appropriately enter into a combat with this juice!"
	icon_state = "purple_can"
	center_of_mass = "x=16;y=10"

/obj/item/weapon/reagent_containers/food/drinks/cans/grape_juice/New()
	..()
	reagents.add_reagent(/datum/reagent/drink/juice/grape, 30)

/obj/item/weapon/reagent_containers/food/drinks/cans/tonic
	name = "\improper T-Borg's Tonic Water"
	desc = "Quinine tastes funny, but at least it'll keep that Space Malaria away."
	icon_state = "tonic"
	center_of_mass = "x=16;y=10"

/obj/item/weapon/reagent_containers/food/drinks/cans/tonic/New()
	..()
	reagents.add_reagent(/datum/reagent/drink/tonic, 50)

/obj/item/weapon/reagent_containers/food/drinks/cans/sodawater
	name = "soda water"
	desc = "A can of soda water. Still water's more refreshing cousin."
	icon_state = "sodawater"
	center_of_mass = "x=16;y=10"

/obj/item/weapon/reagent_containers/food/drinks/cans/sodawater/New()
	..()
	reagents.add_reagent(/datum/reagent/drink/sodawater, 50)