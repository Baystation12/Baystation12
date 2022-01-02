//bizarro alien code for dispenser_cartridges
/decl/hierarchy/supply_pack/dispenser_cartridges
	name = "Dispenser Cartridges"

#define SEC_PACK(_tname, _type, _name, _cname, _cost, _access)\
	decl/hierarchy/supply_pack/dispenser_cartridges{\
		_tname {\
			name = _name ;\
			containername = _cname ;\
			containertype = /obj/structure/closet/crate/secure;\
			access = list( _access );\
			cost = _cost ;\
			contains = list( _type , _type );\
		}\
	}
#define PACK(_tname, _type, _name, _cname, _cost)\
	decl/hierarchy/supply_pack/dispenser_cartridges{\
		_tname {\
			name = _name ;\
			containername = _cname ;\
			containertype = /obj/structure/closet/crate;\
			cost = _cost ;\
			contains = list( _type , _type );\
		}\
	}

// Chemistry-restricted (raw reagents excluding sugar/water)
//      Datum path  Contents type                                                       Supply pack name                  Container name                         Cost  Container access
SEC_PACK(hydrazine, /obj/item/reagent_containers/chem_disp_cartridge/hydrazine,  "Reagent refill - Hydrazine",     "hydrazine reagent cartridge crate",     15, access_chemistry)
SEC_PACK(lithium,   /obj/item/reagent_containers/chem_disp_cartridge/lithium,    "Reagent refill - Lithium",       "lithium reagent cartridge crate",       15, access_chemistry)
SEC_PACK(carbon,    /obj/item/reagent_containers/chem_disp_cartridge/carbon,     "Reagent refill - Carbon",        "carbon reagent cartridge crate",        15, access_chemistry)
SEC_PACK(ammonia,   /obj/item/reagent_containers/chem_disp_cartridge/ammonia,    "Reagent refill - Ammonia",       "ammonia reagent cartridge crate",       15, access_chemistry)
SEC_PACK(oxygen,    /obj/item/reagent_containers/chem_disp_cartridge/acetone,    "Reagent refill - Acetone",       "acetone reagent cartridge crate",       15, access_chemistry)
SEC_PACK(sodium,    /obj/item/reagent_containers/chem_disp_cartridge/sodium,     "Reagent refill - Sodium",        "sodium reagent cartridge crate",        15, access_chemistry)
SEC_PACK(aluminium, /obj/item/reagent_containers/chem_disp_cartridge/aluminium,   "Reagent refill - Aluminium",      "aluminium reagent cartridge crate",      15, access_chemistry)
SEC_PACK(silicon,   /obj/item/reagent_containers/chem_disp_cartridge/silicon,    "Reagent refill - Silicon",       "silicon reagent cartridge crate",       15, access_chemistry)
SEC_PACK(phosphorus,/obj/item/reagent_containers/chem_disp_cartridge/phosphorus, "Reagent refill - Phosphorus",    "phosphorus reagent cartridge crate",    15, access_chemistry)
SEC_PACK(sulfur,    /obj/item/reagent_containers/chem_disp_cartridge/sulfur,     "Reagent refill - Sulfur",        "sulfur reagent cartridge crate",        15, access_chemistry)
SEC_PACK(hclacid,   /obj/item/reagent_containers/chem_disp_cartridge/hclacid,    "Reagent refill - Hydrochloric Acid", "hydrochloric acid reagent cartridge crate", 15, access_chemistry)
SEC_PACK(potassium, /obj/item/reagent_containers/chem_disp_cartridge/potassium,  "Reagent refill - Potassium",     "potassium reagent cartridge crate",     15, access_chemistry)
SEC_PACK(iron,      /obj/item/reagent_containers/chem_disp_cartridge/iron,       "Reagent refill - Iron",          "iron reagent cartridge crate",          15, access_chemistry)
SEC_PACK(copper,    /obj/item/reagent_containers/chem_disp_cartridge/copper,     "Reagent refill - Copper",        "copper reagent cartridge crate",        15, access_chemistry)
SEC_PACK(mercury,   /obj/item/reagent_containers/chem_disp_cartridge/mercury,    "Reagent refill - Mercury",       "mercury reagent cartridge crate",       15, access_chemistry)
SEC_PACK(radium,    /obj/item/reagent_containers/chem_disp_cartridge/radium,     "Reagent refill - Radium",        "radium reagent cartridge crate",        15, access_chemistry)
SEC_PACK(ethanol,   /obj/item/reagent_containers/chem_disp_cartridge/ethanol,    "Reagent refill - Ethanol",       "ethanol reagent cartridge crate",       15, access_chemistry)
SEC_PACK(sacid,     /obj/item/reagent_containers/chem_disp_cartridge/sacid,      "Reagent refill - Sulfuric Acid", "sulfuric acid reagent cartridge crate", 15, access_chemistry)
SEC_PACK(tungsten,  /obj/item/reagent_containers/chem_disp_cartridge/tungsten,   "Reagent refill - Tungsten",      "tungsten reagent cartridge crate",      15, access_chemistry)

// Bar-restricted (alcoholic drinks)
//      Datum path Contents type                                                     Supply pack name             Container name                    Cost  Container access
SEC_PACK(beer,     /obj/item/reagent_containers/chem_disp_cartridge/beer,     "Reagent refill - Beer",     "beer reagent cartridge crate",     15, access_kitchen)
SEC_PACK(kahlua,   /obj/item/reagent_containers/chem_disp_cartridge/kahlua,   "Reagent refill - Kahlua",   "kahlua reagent cartridge crate",   15, access_kitchen)
SEC_PACK(whiskey,  /obj/item/reagent_containers/chem_disp_cartridge/whiskey,  "Reagent refill - Whiskey",  "whiskey reagent cartridge crate",  15, access_kitchen)
SEC_PACK(wine,     /obj/item/reagent_containers/chem_disp_cartridge/wine,     "Reagent refill - Wine",     "wine reagent cartridge crate",     15, access_kitchen)
SEC_PACK(vodka,    /obj/item/reagent_containers/chem_disp_cartridge/vodka,    "Reagent refill - Vodka",    "vodka reagent cartridge crate",    15, access_kitchen)
SEC_PACK(gin,      /obj/item/reagent_containers/chem_disp_cartridge/gin,      "Reagent refill - Gin",      "gin reagent cartridge crate",      15, access_kitchen)
SEC_PACK(rum,      /obj/item/reagent_containers/chem_disp_cartridge/rum,      "Reagent refill - Rum",      "rum reagent cartridge crate",      15, access_kitchen)
SEC_PACK(tequila,  /obj/item/reagent_containers/chem_disp_cartridge/tequila,  "Reagent refill - Tequila",  "tequila reagent cartridge crate",  15, access_kitchen)
SEC_PACK(vermouth, /obj/item/reagent_containers/chem_disp_cartridge/vermouth, "Reagent refill - Vermouth", "vermouth reagent cartridge crate", 15, access_kitchen)
SEC_PACK(cognac,   /obj/item/reagent_containers/chem_disp_cartridge/cognac,   "Reagent refill - Cognac",   "cognac reagent cartridge crate",   15, access_kitchen)
SEC_PACK(ale,      /obj/item/reagent_containers/chem_disp_cartridge/ale,      "Reagent refill - Ale",      "ale reagent cartridge crate",      15, access_kitchen)
SEC_PACK(mead,     /obj/item/reagent_containers/chem_disp_cartridge/mead,     "Reagent refill - Mead",     "mead reagent cartridge crate",     15, access_kitchen)

// Engineering-restricted
//
SEC_PACK(boron,     /obj/item/reagent_containers/chem_disp_cartridge/boron,   "Reagent refill - Boron",    "boron reagent cartridge crate",    45, access_engine)

// Unrestricted (water, sugar, non-alcoholic drinks)
//  Datum path   Contents type                                                       Supply pack name                        Container name                                          Cost
PACK(water,      /obj/item/reagent_containers/chem_disp_cartridge/water,      "Reagent refill - Water",               "water reagent cartridge crate",                         15)
PACK(sugar,      /obj/item/reagent_containers/chem_disp_cartridge/sugar,      "Reagent refill - Sugar",               "sugar reagent cartridge crate",                         15)
PACK(ice,        /obj/item/reagent_containers/chem_disp_cartridge/ice,        "Reagent refill - Ice",                 "ice reagent cartridge crate",                           15)
PACK(tea,        /obj/item/reagent_containers/chem_disp_cartridge/tea,        "Reagent refill - Tea",                 "tea reagent cartridge crate",                           15)
PACK(green_tea,  /obj/item/reagent_containers/chem_disp_cartridge/green_tea,  "Reagent refill - Green Tea",           "green tea reagent cartridge crate",                     15)
PACK(chai_tea,   /obj/item/reagent_containers/chem_disp_cartridge/chai_tea,   "Reagent refill - Chai Tea",            "chai tea reagent cartridge crate",                      15)
PACK(red_tea,    /obj/item/reagent_containers/chem_disp_cartridge/red_tea,    "Reagent refill - Rooibos Tea",         "rooibos tea reagent cartridge crate",                   15)
PACK(cola,       /obj/item/reagent_containers/chem_disp_cartridge/cola,       "Reagent refill - Space Cola",          "\improper Space Cola reagent cartridge crate",          15)
PACK(smw,        /obj/item/reagent_containers/chem_disp_cartridge/smw,        "Reagent refill - Space Mountain Wind", "\improper Space Mountain Wind reagent cartridge crate", 15)
PACK(dr_gibb,    /obj/item/reagent_containers/chem_disp_cartridge/dr_gibb,    "Reagent refill - Dr. Gibb",            "\improper Dr. Gibb reagent cartridge crate",            15)
PACK(spaceup,    /obj/item/reagent_containers/chem_disp_cartridge/spaceup,    "Reagent refill - Space-Up",            "\improper Space-Up reagent cartridge crate",            15)
PACK(tonic,      /obj/item/reagent_containers/chem_disp_cartridge/tonic,      "Reagent refill - Tonic Water",         "tonic water reagent cartridge crate",                   15)
PACK(sodawater,  /obj/item/reagent_containers/chem_disp_cartridge/sodawater,  "Reagent refill - Soda Water",          "soda water reagent cartridge crate",                    15)
PACK(lemon_lime, /obj/item/reagent_containers/chem_disp_cartridge/lemon_lime, "Reagent refill - Lemon-Lime Juice",    "lemon-lime juice reagent cartridge crate",              15)
PACK(orange,     /obj/item/reagent_containers/chem_disp_cartridge/orange,     "Reagent refill - Orange Juice",        "orange juice reagent cartridge crate",                  15)
PACK(lime,       /obj/item/reagent_containers/chem_disp_cartridge/lime,       "Reagent refill - Lime Juice",          "lime juice reagent cartridge crate",                    15)
PACK(watermelon, /obj/item/reagent_containers/chem_disp_cartridge/watermelon, "Reagent refill - Watermelon Juice",    "watermelon juice reagent cartridge crate",              15)
PACK(coffee,     /obj/item/reagent_containers/chem_disp_cartridge/coffee,     "Reagent refill - Coffee",              "coffee reagent cartridge crate",                        15)
PACK(cafe_latte, /obj/item/reagent_containers/chem_disp_cartridge/cafe_latte, "Reagent refill - Cafe Latte",          "cafe latte reagent cartridge crate",                    15)
PACK(soy_latte,  /obj/item/reagent_containers/chem_disp_cartridge/soy_latte,  "Reagent refill - Soy Latte",           "soy latte reagent cartridge crate",                     15)
PACK(hot_coco,   /obj/item/reagent_containers/chem_disp_cartridge/hot_coco,   "Reagent refill - Hot Coco",            "hot coco reagent cartridge crate",                      15)
PACK(milk,       /obj/item/reagent_containers/chem_disp_cartridge/milk,       "Reagent refill - Milk",                "milk reagent cartridge crate",                          15)
PACK(cream,      /obj/item/reagent_containers/chem_disp_cartridge/cream,      "Reagent refill - Cream",               "cream reagent cartridge crate",                         15)
PACK(decaf_cof,  /obj/item/reagent_containers/chem_disp_cartridge/decaf_cof,  "Reagent refill - Decaf Coffee",        "decaf coffee reagent cartridge crate",                  15)
PACK(decaf_tea,  /obj/item/reagent_containers/chem_disp_cartridge/decaf_tea,  "Reagent refill - Decaf Tea",           "decaf tea reagent cartridge crate",                     15)
PACK(espresso,  /obj/item/reagent_containers/chem_disp_cartridge/espresso,    "Reagent refill - Espresso",           "espresso reagent cartridge crate",                       15)

PACK(syrup_chocolate, /obj/item/reagent_containers/chem_disp_cartridge/syrup_chocolate, "Reagent refill - Chocolate Syrup",     "chocolate syrup reagent cartridge crate", 15)
PACK(syrup_caramel,   /obj/item/reagent_containers/chem_disp_cartridge/syrup_caramel,   "Reagent refill - Caramel Syrup",       "caramel syrup reagent cartridge crate",   15)
PACK(syrup_vanilla,   /obj/item/reagent_containers/chem_disp_cartridge/syrup_vanilla,   "Reagent refill - Vanilla Syrup",       "vanilla syrup reagent cartridge crate",   15)
PACK(syrup_pumpkin,   /obj/item/reagent_containers/chem_disp_cartridge/syrup_pumpkin,   "Reagent refill - Pumpkin Spice Syrup", "pumpkin spice syrup reagent cartridge crate",   15)

#undef SEC_PACK
#undef PACK
