/obj/machinery/vending
	name = "Vendomat"
	desc = "A generic vending machine."
	icon = 'icons/obj/vending.dmi'
	icon_state = "generic"
	layer = 2.9
	anchored = 1
	density = 1
	var/active = 1 //No sales pitches if off!
	var/vend_ready = 1 //Are we ready to vend?? Is it time??
	var/vend_delay = 10 //How long does it take to vend?
	var/product_paths = "" //String of product paths separated by semicolons. No spaces!
	var/product_amounts = "" //String of product amounts separated by semicolons, must have amount for every path in product_paths
	var/product_slogans = "" //String of slogans separated by semicolons, optional
	var/product_ads = "" //String of small ad messages in the vending screen - random chance
	var/product_hidden = "" //String of products that are hidden unless hacked.
	var/product_hideamt = "" //String of hidden product amounts, separated by semicolons. Exact same as amounts. Must be left blank if hidden is.
	var/product_coin = ""
	var/product_coin_amt = ""
	var/list/product_records = list()
	var/list/hidden_records = list()
	var/list/coin_records = list()
	var/list/slogan_list = list()
	var/list/small_ads = list() // small ad messages in the vending screen - random chance of popping up whenever you open it
	var/vend_reply //Thank you for shopping!
	var/last_reply = 0
	var/last_slogan = 0 //When did we last pitch?
	var/slogan_delay = 600 //How long until we can pitch again?
	var/icon_vend //Icon_state when vending!
	var/icon_deny //Icon_state when vending!
	//var/emagged = 0 //Ignores if somebody doesn't have card access to that machine.
	var/seconds_electrified = 0 //Shock customers like an airlock.
	var/shoot_inventory = 0 //Fire items at customers! We're broken!
	var/shut_up = 1 //Stop spouting those godawful pitches!
	var/extended_inventory = 0 //can we access the hidden inventory?
	var/panel_open = 0 //Hacking that vending machine. Gonna get a free candy bar.
	var/wires = 15
	var/obj/item/weapon/coin/coin

/*

/obj/machinery/vending/[vendors name here]   // --vending machine template   :)
	name = ""
	desc = ""
	icon = ''
	icon_state = ""
	product_paths = ""
	product_amounts = ""
	vend_delay = 15
	product_hidden = ""
	product_hideamt = ""
	product_slogans = ""
	product_ads = ""

*/

/*
/obj/machinery/vending/atmospherics //Commenting this out until someone ponies up some actual working, broken, and unpowered sprites - Quarxink
	name = "Tank Vendor"
	desc = "A vendor with a wide variety of masks and gas tanks."
	icon = 'icons/obj/objects.dmi'
	icon_state = "dispenser"
	product_paths = "/obj/item/weapon/tank/oxygen;/obj/item/weapon/tank/plasma;/obj/item/weapon/tank/emergency_oxygen;/obj/item/weapon/tank/emergency_oxygen/engi;/obj/item/clothing/mask/breath"
	product_amounts = "10;10;10;5;25"
	vend_delay = 0
*/

/obj/machinery/vending/boozeomat
	name = "Booze-O-Mat"
	desc = "A technological marvel, supposedly able to mix just the mixture you'd like to drink the moment you ask for one."
	icon_state = "boozeomat"        //////////////18 drink entities below, plus the glasses, in case someone wants to edit the number of bottles
	icon_deny = "boozeomat-deny"
	product_paths = "/obj/item/weapon/reagent_containers/food/drinks/bottle/gin;/obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey;/obj/item/weapon/reagent_containers/food/drinks/bottle/tequilla;/obj/item/weapon/reagent_containers/food/drinks/bottle/vodka;/obj/item/weapon/reagent_containers/food/drinks/bottle/vermouth;/obj/item/weapon/reagent_containers/food/drinks/bottle/rum;/obj/item/weapon/reagent_containers/food/drinks/bottle/wine;/obj/item/weapon/reagent_containers/food/drinks/bottle/cognac;/obj/item/weapon/reagent_containers/food/drinks/bottle/kahlua;/obj/item/weapon/reagent_containers/food/drinks/beer;/obj/item/weapon/reagent_containers/food/drinks/ale;/obj/item/weapon/reagent_containers/food/drinks/bottle/orangejuice;/obj/item/weapon/reagent_containers/food/drinks/bottle/tomatojuice;/obj/item/weapon/reagent_containers/food/drinks/bottle/limejuice;/obj/item/weapon/reagent_containers/food/drinks/bottle/cream;/obj/item/weapon/reagent_containers/food/drinks/tonic;/obj/item/weapon/reagent_containers/food/drinks/cola;/obj/item/weapon/reagent_containers/food/drinks/sodawater;/obj/item/weapon/reagent_containers/food/drinks/drinkingglass;/obj/item/weapon/reagent_containers/food/drinks/ice"
	product_amounts = "5;5;5;5;5;5;5;5;5;6;6;4;4;4;4;8;8;15;30;9"
	vend_delay = 15
	product_hidden = "/obj/item/weapon/reagent_containers/food/drinks/tea"
	product_hideamt = "10"
	product_slogans = "I hope nobody asks me for a bloody cup o' tea...;Alcohol is humanity's friend. Would you abandon a friend?;Quite delighted to serve you!;Is nobody thirsty on this station?"
	product_ads = "Drink up!;Booze is good for you!;Alcohol is humanity's best friend.;Quite delighted to serve you!;Care for a nice, cold beer?;Nothing cures you like booze!;Have a sip!;Have a drink!;Have a beer!;Beer is good for you!;Only the finest alcohol!;Best quality booze since 2053!;Award-winning wine!;Maximum alcohol!;Man loves beer.;A toast for progress!"
	req_access_txt = "25"

/obj/machinery/vending/assist
	product_amounts = "5;3;4;1;4"
	product_hidden = "/obj/item/device/flashlight;obj/item/device/assembly/timer"
	product_paths = "/obj/item/device/assembly/prox_sensor;/obj/item/device/assembly/igniter;/obj/item/device/assembly/signaler;/obj/item/weapon/wirecutters;/obj/item/weapon/cartridge/signal"
	product_hideamt = "5;2"
	product_ads = "Only the finest!;Have some tools.;The most robust equipment.;The finest gear in space!"

/obj/machinery/vending/coffee
	name = "Hot Drinks machine"
	desc = "A vending machine which dispenses hot drinks."
	icon_state = "coffee"
	icon_vend = "coffee-vend"
	product_paths = "/obj/item/weapon/reagent_containers/food/drinks/coffee;/obj/item/weapon/reagent_containers/food/drinks/tea;/obj/item/weapon/reagent_containers/food/drinks/h_chocolate"
	product_amounts = "25;25;25"
	vend_delay = 34
	product_hidden = "/obj/item/weapon/reagent_containers/food/drinks/ice"
	product_ads = "Have a drink!;Drink up!;It's good for you!;Would you like a hot joe?;I'd kill for some coffee!;The best beans in the galaxy.;Only the finest brew for you.;Mmmm. Nothing like a coffee.;I like coffee, don't you?;Coffee helps you work!;Try some tea.;We hope you like the best!;Try our new chocolate!;Admin conspiracies"
	product_hideamt = "10"

/obj/machinery/vending/snack
	name = "Getmore Chocolate Corp"
	desc = "A snack machine courtesy of the Getmore Chocolate Corporation, based out of Mars"
	icon_state = "snack"
	product_paths = "/obj/item/weapon/reagent_containers/food/snacks/candy;/obj/item/weapon/reagent_containers/food/drinks/dry_ramen;/obj/item/weapon/reagent_containers/food/snacks/chips;/obj/item/weapon/reagent_containers/food/snacks/sosjerky;/obj/item/weapon/reagent_containers/food/snacks/no_raisin;/obj/item/weapon/reagent_containers/food/snacks/spacetwinkie;/obj/item/weapon/reagent_containers/food/snacks/cheesiehonkers"
	product_amounts = "6;6;6;6;6;6;6"
	product_slogans = "Try our new nougat bar!;Twice the calories for half the price!"
	product_hidden = "/obj/item/weapon/reagent_containers/food/snacks/syndicake"
	product_hideamt = "6"
	product_ads = "The healthiest!;Award-winning chocolate bars!;Mmm! So good!;Oh my god it's so juicy!;Have a snack.;Snacks are good for you!;Have some more Getmore!;Best quality snacks straight from mars.;We love chocolate!;Try our new jerky!"


/obj/machinery/vending/cola
	name = "Robust Softdrinks"
	desc = "A softdrink vendor provided by Robust Industries, LLC."
	icon_state = "Cola_Machine"
	product_paths = "/obj/item/weapon/reagent_containers/food/drinks/cola;/obj/item/weapon/reagent_containers/food/drinks/space_mountain_wind;/obj/item/weapon/reagent_containers/food/drinks/dr_gibb;/obj/item/weapon/reagent_containers/food/drinks/starkist;/obj/item/weapon/reagent_containers/food/drinks/space_up"
	product_amounts = "10;10;10;10;10"
	product_slogans = "Robust Softdrinks: More robust than a toolbox to the head!"
	product_hidden = "/obj/item/weapon/reagent_containers/food/drinks/thirteenloko"
	product_hideamt = "5"
	product_ads = "Refreshing!;Hope you're thirsty!;Over 1 million drinks sold!;Thirsty? Why not cola?;Please, have a drink!;Drink up!;The best drinks in space."

//This one's from bay12
/obj/machinery/vending/cart
	name = "PTech"
	desc = "Cartridges for PDAs"
	icon_state = "cart"
	icon_deny = "cart-deny"
	product_paths = "/obj/item/weapon/cartridge/medical;/obj/item/weapon/cartridge/engineering;/obj/item/weapon/cartridge/security;/obj/item/weapon/cartridge/janitor;/obj/item/weapon/cartridge/signal/toxins;/obj/item/device/pda/heads;/obj/item/weapon/cartridge/captain;/obj/item/weapon/cartridge/quartermaster"
	product_amounts = "10;10;10;10;10;10;3;10"
	product_slogans = "Carts to go!"
	product_hidden = ""
	product_hideamt = ""
	product_coin = ""
	product_coin_amt = ""

/obj/machinery/vending/cigarette
	name = "Cigarette machine" //OCD had to be uppercase to look nice with the new formating
	desc = "If you want to get cancer, might as well do it in style"
	icon_state = "cigs"
	product_paths = "/obj/item/weapon/cigpacket;/obj/item/weapon/storage/matchbox;/obj/item/weapon/lighter/random"
	product_amounts = "10;10;4"
	product_slogans = "Space cigs taste good like a cigarette should.;I'd rather toolbox than switch.;Smoke!;Don't believe the reports - smoke today!"
	vend_delay = 34
	product_hidden = "/obj/item/weapon/lighter/zippo"
	product_hideamt = "4"
	product_coin = "/obj/item/clothing/mask/cigarette/cigar/havana"
	product_coin_amt = "2"
	product_ads = "Probably not bad for you!;Don't believe the scientists!;It's good for you!;Don't quit, buy more!;Smoke!;Nicotine heaven.;Best cigarettes since 2150.;Award-winning cigs."

/obj/machinery/vending/medical
	name = "NanoMed Plus"
	desc = "Medical drug dispenser."
	icon_state = "med"
	icon_deny = "med-deny"
	req_access_txt = "5"
	product_paths = "/obj/item/weapon/reagent_containers/glass/bottle/antitoxin;/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline;/obj/item/weapon/reagent_containers/glass/bottle/stoxin;/obj/item/weapon/reagent_containers/glass/bottle/toxin;/obj/item/weapon/reagent_containers/syringe/antiviral;/obj/item/weapon/reagent_containers/syringe;/obj/item/device/healthanalyzer;/obj/item/weapon/reagent_containers/glass/beaker;/obj/item/weapon/reagent_containers/dropper"
	product_amounts = "4;4;4;4;4;12;5;4;2"
	product_hidden = "/obj/item/weapon/reagent_containers/pill/tox;/obj/item/weapon/reagent_containers/pill/stox;/obj/item/weapon/reagent_containers/pill/antitox"
	product_hideamt = "3;4;6"
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?;Ping!"

//This one's from bay12
/obj/machinery/vending/plasmaresearch
	name = "Toximate 3000"
	desc = "All the fine parts you need in one vending machine!"
	product_paths = "/obj/item/clothing/under/rank/scientist;/obj/item/clothing/suit/bio_suit;/obj/item/clothing/head/bio_hood;/obj/item/device/transfer_valve;/obj/item/device/assembly/signaler;/obj/item/device/assembly/prox_sensor;/obj/item/device/assembly/igniter;/obj/item/device/assembly/timer"
	product_amounts = "6;6;6;6;6"
	product_hidden = ""
	product_hideamt = ""
	product_coin = ""
	product_coin_amt = ""

/obj/machinery/vending/wallmed1
	name = "NanoMed"
	desc = "Wall-mounted Medical Equipment dispenser."
	icon_state = "wallmed"
	icon_deny = "wallmed-deny"
	req_access_txt = "5"
	product_paths = "/obj/item/stack/medical/bruise_pack;/obj/item/stack/medical/ointment;/obj/item/weapon/reagent_containers/syringe/inaprovaline;/obj/item/device/healthanalyzer"
	product_amounts = "2;2;4;1"
	product_hidden = "/obj/item/weapon/reagent_containers/syringe/antitoxin;/obj/item/weapon/reagent_containers/syringe/antiviral;/obj/item/weapon/reagent_containers/pill/tox"
	product_hideamt = "4;4;1"
	density = 0 //It is wall-mounted, and thus, not dense. --Superxpdude
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?"

/obj/machinery/vending/wallmed2
	name = "NanoMed"
	desc = "Wall-mounted Medical Equipment dispenser."
	icon_state = "wallmed"
	icon_deny = "wallmed-deny"
	req_access_txt = "5"
	product_paths = "/obj/item/weapon/reagent_containers/syringe/inaprovaline;/obj/item/weapon/reagent_containers/syringe/antitoxin;/obj/item/stack/medical/bruise_pack;/obj/item/stack/medical/ointment;/obj/item/device/healthanalyzer"
	product_amounts = "5;3;3;3;3"
	product_hidden = "/obj/item/weapon/reagent_containers/pill/tox"
	product_hideamt = "3"
	density = 0 //It is wall-mounted, and thus, not dense. --Superxpdude

/obj/machinery/vending/security
	name = "SecTech"
	desc = "A security equipment vendor"
	icon_state = "sec"
	icon_deny = "sec-deny"
	req_access_txt = "1"
	product_paths = "/obj/item/weapon/handcuffs;/obj/item/weapon/grenade/flashbang;/obj/item/device/flash;/obj/item/weapon/reagent_containers/food/snacks/donut/normal;/obj/item/weapon/storage/box/evidence"
	product_amounts = "8;4;5;12;6"
	product_hidden = "/obj/item/clothing/glasses/sunglasses;/obj/item/weapon/storage/fancy/donut_box"
	product_hideamt = "2;2"
	product_ads = "Crack capitalist skulls!;Beat some heads in!;Don't forget - harm is good!;Your weapons are right here.;Handcuffs!;Freeze, scumbag!;Don't tase me bro!;Tase them, bro.;Why not have a donut?"

/obj/machinery/vending/hydronutrients
	name = "NutriMax"
	desc = "A plant nutrients vendor"
	icon_state = "nutri"
	icon_deny = "nutri-deny"
	product_paths = "/obj/item/nutrient/ez;/obj/item/nutrient/l4z;/obj/item/nutrient/rh;/obj/item/weapon/pestspray;/obj/item/weapon/reagent_containers/syringe;/obj/item/weapon/plantbag"
	product_amounts = "35;25;15;20;5;5"
	product_slogans = "Aren't you glad you don't have to fertilize the natural way?;Now with 50% less stink!;Plants are people too!"
	product_hidden = "/obj/item/weapon/reagent_containers/glass/bottle/ammonia;/obj/item/weapon/reagent_containers/glass/bottle/diethylamine"
	product_hideamt = "10;5"
	product_ads = "We like plants!;Don't you want some?;The greenest thumbs ever.;We like big plants.;Soft soil..."

/obj/machinery/vending/hydroseeds
	name = "MegaSeed Servitor"
	desc = "When you need seeds fast!"
	icon_state = "seeds"
	product_paths = "/obj/item/seeds/bananaseed;/obj/item/seeds/berryseed;/obj/item/seeds/carrotseed;/obj/item/seeds/chantermycelium;/obj/item/seeds/chiliseed;/obj/item/seeds/cornseed;/obj/item/seeds/eggplantseed;/obj/item/seeds/potatoseed;/obj/item/seeds/replicapod;/obj/item/seeds/soyaseed;/obj/item/seeds/sunflowerseed;/obj/item/seeds/tomatoseed;/obj/item/seeds/towermycelium;/obj/item/seeds/wheatseed;/obj/item/seeds/appleseed;/obj/item/seeds/poppyseed;/obj/item/seeds/ambrosiavulgarisseed;/obj/item/seeds/whitebeetseed;/obj/item/seeds/watermelonseed;/obj/item/seeds/limeseed;/obj/item/seeds/lemonseed;/obj/item/seeds/orangeseed;/obj/item/seeds/grassseed;/obj/item/seeds/cocoapodseed;/obj/item/seeds/cabbageseed;/obj/item/seeds/grapeseed;/obj/item/seeds/pumpkinseed"
	product_amounts = "3;2;2;2;2;2;2;2;3;2;2;2;2;2;3;5;4;3;3;3;3;3;3;3;3;3;3"
	product_slogans = "THIS'S WHERE TH' SEEDS LIVE! GIT YOU SOME!;Hands down the best seed selection on the station!;Also certain mushroom varieties available, more for experts! Get certified today!"
	product_hidden = "/obj/item/seeds/amanitamycelium;/obj/item/seeds/glowshroom;/obj/item/seeds/libertymycelium;/obj/item/seeds/nettleseed;/obj/item/seeds/plumpmycelium;/obj/item/seeds/reishimycelium"
	product_hideamt = "2;2;2;2;2;2"
	product_coin = "/obj/item/toy/waterflower"
	product_coin_amt = "1"
	product_ads = "We like plants!;Grow some crops!;Grow, baby, growww!;Aw h'yeah son!"

/obj/machinery/vending/liquid
	name = "LiquidRation Dispenser"
	desc = "All the food you'll ever need to survive!"
	icon_state = "liquidfood"
	product_paths = "/obj/item/weapon/reagent_containers/food/snacks/liquidfood;/obj/item/weapon/flavor/red;/obj/item/weapon/flavor/blue"
	product_amounts = "20;10;10"
	product_slogans = "Enjoy your NanoTrasen \"LiquidFood\" Ration! Now with a choice of TWO delicious flavors!"
	product_ads = "Think of it as free survival!;It's even healthy!;Take a quick break, enjoy your ration!"

/obj/machinery/vending/magivend
	name = "MagiVend"
	desc = "A magic vending machine."
	icon_state = "MagiVend"
	product_amounts = "1;1;1;1;1;2"
	product_slogans = "Sling spells the proper way with MagiVend!;Be your own Houdini! Use MagiVend!"
	product_paths = "/obj/item/clothing/head/wizard;/obj/item/clothing/suit/wizrobe;/obj/item/clothing/head/wizard/red;/obj/item/clothing/suit/wizrobe/red;/obj/item/clothing/shoes/sandal;/obj/item/weapon/staff"
	vend_delay = 15
	vend_reply = "Have an enchanted evening!"
	product_hidden = "/obj/item/weapon/reagent_containers/glass/bottle/wizarditis" //No one can get to the machine to hack it anyways
	product_hideamt = "1" //Just one, for the lulz, not like anyone can get it - Microwave
	product_ads = "FJKLFJSD;AJKFLBJAKL;1234 LOONIES LOL!;>MFW;Kill them fuckers!;GET DAT FUKKEN DISK;HONK!;EI NATH;Destroy the station!;Admin conspiracies since forever!;Space-time bending hardware!"

/obj/machinery/vending/dinnerware
	name = "Dinnerware"
	desc = "A kitchen and restaurant equipment vendor"
	icon_state = "dinnerware"
	product_paths = "/obj/item/weapon/tray;/obj/item/weapon/kitchen/utensil/fork;/obj/item/weapon/kitchenknife;/obj/item/weapon/reagent_containers/food/drinks/drinkingglass;/obj/item/clothing/suit/chef/classic"
	product_amounts = "8;6;3;8;2"
	//product_amounts = "8;5;4" Old totals
	product_hidden = "/obj/item/weapon/kitchen/utensil/spoon;/obj/item/weapon/kitchen/utensil/knife;/obj/item/weapon/kitchen/rollingpin;/obj/item/weapon/butch"
	product_hideamt = "2;2;2;2"
	product_ads = "Mm, food stuffs!;Food and food accessories.;Get your plates!;You like forks?;I like forks.;Woo, utensils.;You don't really need these..."


/obj/machinery/vending/sovietsoda
	name = "BODA"
	desc = "Old sweet water vending machine"
	icon_state = "sovietsoda"
	product_paths = "/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/soda"
	product_amounts = "30"
	//product_amounts = "8;5;4" Old totals
	product_hidden = "/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/cola"
	product_hideamt = "20"
	product_ads = "For Tsar and Country.;Have you fulfilled your nutrition quota today?;Very nice!;We are simple people, for this is all we eat.;If there is a person, there is a problem. If there is no person, then there is no problem."

/obj/machinery/vending/tool
	name = "YouTool"
	desc = "Tools for tools."
	icon_state = "tool"
	icon_deny = "tool-deny"
	req_access_txt = "12" //Maintenance access
	product_paths = "/obj/item/weapon/cable_coil/random;/obj/item/weapon/crowbar;/obj/item/weapon/weldingtool;/obj/item/weapon/wirecutters;/obj/item/weapon/wrench;/obj/item/device/analyzer;/obj/item/device/t_scanner"
	product_amounts = "10;5;3;5;5;5;5"
	product_hidden = "/obj/item/weapon/weldingtool/hugeetank;/obj/item/clothing/gloves/fyellow"
	product_hideamt = "2;2"
	product_coin = "/obj/item/clothing/gloves/yellow"
	product_coin_amt = "1"

/obj/machinery/vending/engivend
	name = "Engi-Vend"
	desc = "Spare tool vending. What? Did you expect some witty description?"
	icon_state = "engivend"
	icon_deny = "engivend-deny"
	req_access_txt = "10" //Engineering access
	product_paths = "/obj/item/clothing/glasses/meson;/obj/item/device/multitool;/obj/item/weapon/airlock_electronics;/obj/item/weapon/module/power_control;/obj/item/weapon/cell/high"
	product_amounts = "2;4;10;10;10"
	product_hidden = "/obj/item/weapon/cell/potato"
	product_hideamt = "3"
	product_coin = "/obj/item/weapon/storage/belt/utility"
	product_coin_amt = "3"

//This one's from bay12
/obj/machinery/vending/engineering
	name = "Robco Tool Maker"
	desc = "Everything you need for do-it-yourself station repair."
	icon_state = "engi"
	icon_deny = "engi-deny"
	req_access_txt = "10"
	product_paths = "/obj/item/clothing/under/rank/chief_engineer;/obj/item/clothing/under/rank/engineer;/obj/item/clothing/shoes/orange;/obj/item/clothing/head/helmet/hardhat;/obj/item/weapon/storage/belt/utility;/obj/item/clothing/glasses/meson;/obj/item/clothing/gloves/yellow;/obj/item/weapon/screwdriver;/obj/item/weapon/crowbar;/obj/item/weapon/wirecutters;/obj/item/device/multitool;/obj/item/weapon/wrench;/obj/item/device/t_scanner;/obj/item/weapon/CableCoil/power;/obj/item/weapon/circuitry;/obj/item/weapon/cell;/obj/item/weapon/weldingtool;/obj/item/clothing/head/helmet/welding;/obj/item/weapon/light/tube;/obj/item/clothing/suit/fire;/obj/item/weapon/stock_parts/scanning_module;/obj/item/weapon/stock_parts/micro_laser;/obj/item/weapon/stock_parts/matter_bin;/obj/item/weapon/stock_parts/manipulator;/obj/item/weapon/stock_parts/console_screen"
//	product_amounts = "4;4;4;4;4;4;4;12;12;12;12;12;12;8;4;8;8;8;10;4"
	product_hidden = ""
	product_hideamt = ""
	product_coin = ""
	product_coin_amt = ""

//This one's from bay12
/obj/machinery/vending/robotics
	name = "Robotech Deluxe"
	desc = "All the tools you need to create your own robot army."
	icon_state = "robotics"
	icon_deny = "robotics-deny"
	req_access_txt = "29"
	product_paths = "/obj/item/clothing/suit/storage/labcoat;/obj/item/clothing/under/rank/roboticist;/obj/item/weapon/cable_coil;/obj/item/device/flash;/obj/item/weapon/cell/high;/obj/item/device/assembly/prox_sensor;/obj/item/device/assembly/signaler;/obj/item/device/healthanalyzer;/obj/item/weapon/scalpel;/obj/item/weapon/circular_saw;/obj/item/weapon/tank/anesthetic;/obj/item/clothing/mask/medical;/obj/item/weapon/screwdriver;/obj/item/weapon/crowbar"
	product_amounts = "4;4;4;4;12"
	product_hidden = ""
	product_hideamt = ""
	product_coin = ""
	product_coin_amt = ""
