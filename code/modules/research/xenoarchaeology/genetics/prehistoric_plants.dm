
/obj/item/seeds/telriis
	name = "pack of telriis seeds"
	desc = "These seeds grow into telriis grass. Not recommended for consumption by sentient species."
	icon_state = "seed-alien1"
	mypath = "/obj/item/seeds/telriis"
	species = "telriis"
	plantname = "Telriis grass"
	productname = "/obj/item/weapon/telriis_clump"
	lifespan = 50		//number of ticks
	endurance = 50		//
	maturation = 5		//ticks to full growth stage
	production = 5		//ticks till ready to harvest
	yield = 4			//number produced when harvest
	potency = 5
	plant_type = 1		//1=weed, 2=shroom, 0=normal
	growthstages = 4

/obj/item/weapon/reagent_containers/food/snacks/grown/telriis_clump
	name = "telriis grass"
	desc = "A clump of telriis grass, not recommended for consumption by sentients."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "telriisclump"
	New(var/loc, var/potency)
		..()
		reagents.add_reagent("pwine", potency * 5)
		reagents.add_reagent("nutriment", potency)
		bitesize = 1+round(reagents.total_volume / 2, 1)


/obj/item/seeds/thaadra
	name = "pack of thaa'dra seeds"
	desc = "These seeds grow into Thaa'dra lichen. Likes the cold."
	icon_state = "seed-alien3"
	mypath = "/obj/item/seeds/thaadra"
	species = "thaadra"
	plantname = "Thaa'dra lichen"
	productname = "/obj/item/weapon/reagent_containers/food/snacks/grown/thaadra"
	lifespan = 20
	endurance = 10
	maturation = 5
	production = 9
	yield = 2
	potency = 5
	plant_type = 2
	growthstages = 4

/obj/item/weapon/reagent_containers/food/snacks/grown/thaadrabloom
	name = "thaa'dra bloom"
	desc = "Looks chewy, might be good to eat."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "thaadrabloom"
	New(var/loc, var/potency)
		..()
		reagents.add_reagent("frostoil", potency * 1.5 + 5)
		reagents.add_reagent("nutriment", potency)
		bitesize = 1+round(reagents.total_volume / 2, 1)


/obj/item/seeds/jurlmah
	name = "pack of jurl'mah seeds"
	desc = "These seeds grow into jurl'mah reeds, which produce large syrupy pods."
	icon_state = "seed-alien3"
	mypath = "/obj/item/seeds/jurlmah"
	species = "jurlmah"
	plantname = "jurl'mah reeds"
	productname = "/obj/item/weapon/reagent_containers/food/snacks/grown/jurlmah"
	lifespan = 20
	endurance = 12
	maturation = 8
	production = 9
	yield = 3
	potency = 10
	growthstages = 5

/obj/item/weapon/reagent_containers/food/snacks/grown/jurlmah
	name = "jurl'mah pod"
	desc = "Bulbous and veiny, it appears to pulse slightly as you look at it."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "jurlmahpod"
	New(var/loc, var/potency)
		..()
		reagents.add_reagent("serotrotium", potency)
		reagents.add_reagent("nutriment", potency)
		bitesize = 1+round(reagents.total_volume / 2, 1)


/obj/item/seeds/amauri
	name = "pack of amauri seeds"
	desc = "Grows into a straight, dark plant with small round fruit."
	icon_state = "seed-alien3"
	mypath = "/obj/item/seeds/amauri"
	species = "amauri"
	plantname = "amauri plant"
	productname = "/obj/item/weapon/reagent_containers/food/snacks/grown/amauri"
	lifespan = 30
	endurance = 10
	maturation = 8
	production = 9
	yield = 4
	potency = 10
	growthstages = 3

/obj/item/weapon/reagent_containers/food/snacks/grown/amauri
	name = "amauri fruit"
	desc = "It is small, round and hard. Its skin is a thick dark purple."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "amaurifruit"
	New(var/loc, var/potency)
		..()
		reagents.add_reagent("zombiepowder", potency * 10)
		reagents.add_reagent("condensedcapsaicin", potency * 5)
		reagents.add_reagent("nutriment", potency)
		bitesize = 1+round(reagents.total_volume / 2, 1)


/obj/item/seeds/gelthi
	name = "pack of gelthi seeds"
	desc = "Grows into a bright, wavy plant with many small fruits."
	icon_state = "seed-alien2"
	mypath = "/obj/item/seeds/gelthi"
	species = "gelthi"
	plantname = "gelthi plant"
	productname = "/obj/item/weapon/reagent_containers/food/snacks/grown/gelthi"
	lifespan = 20
	endurance = 15
	maturation = 6
	production = 6
	yield = 2
	potency = 1
	growthstages = 3

/obj/item/weapon/reagent_containers/food/snacks/grown/gelthi
	name = "gelthi berries"
	desc = "They feel fluffy and slightly warm to the touch."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "gelthiberries"
	New(var/loc, var/potency)
		..()
		//this may prove a little strong
		reagents.add_reagent("stoxin", (potency * potency) / 5)
		reagents.add_reagent("capsaicin", (potency * potency) / 5)
		reagents.add_reagent("nutriment", potency)
		bitesize = 1+round(reagents.total_volume / 2, 1)


/obj/item/seeds/vale
	name = "pack of vale seeds"
	desc = "The vale bush is often depicted in ancient heiroglyphs and is similar to cherry blossoms."
	icon_state = "seed-alien2"
	mypath = "/obj/item/seeds/vale"
	species = "vale"
	plantname = "vale bush"
	productname = "/obj/item/weapon/reagent_containers/food/snacks/grown/vale"
	lifespan = 25
	endurance = 15
	maturation = 8
	production = 10
	yield = 3
	potency = 3
	growthstages = 4

/obj/item/weapon/reagent_containers/food/snacks/grown/vale
	name = "vale leaves"
	desc = "Small, curly leaves covered in a soft pale fur."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "valeleaves"
	New(var/loc, var/potency)
		..()
		reagents.add_reagent("paracetamol", potency * 5)
		reagents.add_reagent("dexalin", potency * 2)
		reagents.add_reagent("nutriment", potency)
		bitesize = 1+round(reagents.total_volume / 2, 1)


/obj/item/seeds/surik
	name = "pack of surik seeds"
	desc = "A spiky blue vine with large fruit resembling pig ears."
	icon_state = "seed-alien3"
	mypath = "/obj/item/seeds/surik"
	species = "surik"
	plantname = "surik vine"
	productname = "/obj/item/weapon/reagent_containers/food/snacks/grown/surik"
	lifespan = 30
	endurance = 18
	maturation = 7
	production = 7
	yield = 3
	potency = 3
	growthstages = 4

/obj/item/weapon/reagent_containers/food/snacks/grown/surik
	name = "surik fruit"
	desc = "Multiple layers of blue skin peeling away to reveal a spongey core, vaguely resembling an ear."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "surikfruit"
	New(var/loc, var/potency)
		..()
		reagents.add_reagent("impedrezene", potency * 3)
		reagents.add_reagent("synaptizine", potency * 2)
		reagents.add_reagent("nutriment", potency)
		bitesize = 1+round(reagents.total_volume / 2, 1)
