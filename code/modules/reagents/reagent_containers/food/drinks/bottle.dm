/obj/item/reagent_containers/food/drinks/bottle
	amount_per_transfer_from_this = 10
	volume = 100
	item_state = "broken_beer"
	force = 5
	var/can_shatter = TRUE
	var/obj/item/reagent_containers/glass/rag/rag
	var/rag_underlay = "rag"

	/// Weaken duration for bonking heads
	var/smash_duration = 5


/obj/item/reagent_containers/food/drinks/bottle/Initialize()
	. = ..()
	if (can_shatter)
		unacidable = TRUE


/obj/item/reagent_containers/food/drinks/bottle/Destroy()
	if (rag)
		rag.forceMove(loc)
	rag = null
	return ..()


/obj/item/reagent_containers/food/drinks/bottle/throw_impact(atom/hit_atom, var/datum/thrownthing/TT)
	..()
	if (can_shatter && TT.thrower)
		if (TT.speed > throw_speed || smash_check(TT.dist_travelled))
			if (reagents)
				var/list/others = list()
				for (var/mob/living/L in range(1, get_turf(hit_atom)))
					others += L
				others -= hit_atom
				for (var/other in others)
					reagents.splash(other, reagents.total_volume * 0.2, copy = TRUE)
				reagents.splash(hit_atom, reagents.total_volume)
				hit_atom.visible_message(
					SPAN_WARNING("The contents of \the [src] splash all over \the [hit_atom]![length(others)?" Some gets on [english_list(others)] as well!":""]")
				)
			smash(loc, hit_atom)


/obj/item/reagent_containers/food/drinks/bottle/proc/smash_check(distance)
	if (!can_shatter || !smash_duration)
		return
	var/static/list/chance_table = list(95, 95, 90, 85, 75, 60, 40, 15)
	var/idx = max(distance + 1, 1)
	if (idx > chance_table.len)
		return
	return prob(chance_table[idx])


/obj/item/reagent_containers/food/drinks/bottle/proc/smash(newloc, atom/against)
	var/obj/item/broken_bottle/B = new (newloc)
	if (prob(33))
		new /obj/item/material/shard (newloc)
	B.icon_state = icon_state
	var/icon/I = new ('icons/obj/drinks.dmi', icon_state)
	I.Blend(B.broken_outline, ICON_OVERLAY, rand(5), 1)
	I.SwapColor(rgb(255, 0, 220, 255), rgb(0, 0, 0, 0))
	B.icon = I
	if (rag && rag.on_fire && isliving(against))
		var/mob/living/L = against
		L.IgniteMob()
	playsound(src, "shatter", 70, 1)
	transfer_fingerprints_to(B)
	qdel(src)
	return B


/obj/item/reagent_containers/food/drinks/bottle/attackby(obj/item/W, mob/user)
	if (!rag && istype(W, /obj/item/reagent_containers/glass/rag))
		insert_rag(W, user)
		return
	if (rag && isflamesource(W))
		rag.attackby(W, user)
		return
	..()


/obj/item/reagent_containers/food/drinks/bottle/attack_self(mob/user)
	if (rag)
		remove_rag(user)
	else
		..()


/obj/item/reagent_containers/food/drinks/bottle/proc/insert_rag(obj/item/reagent_containers/glass/rag/R, mob/user)
	if (!can_shatter || rag)
		return
	if (user.unEquip(R))
		to_chat(user, SPAN_NOTICE("You stuff \the [R] into \the [src]."))
		rag = R
		rag.forceMove(src)
		atom_flags &= ~ATOM_FLAG_OPEN_CONTAINER
		update_icon()


/obj/item/reagent_containers/food/drinks/bottle/proc/remove_rag(mob/user)
	if (!rag)
		return
	to_chat(user, SPAN_NOTICE("You pull \the [rag] out of \the [src]."))
	user.put_in_hands(rag)
	rag = null
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER
	update_icon()


/obj/item/reagent_containers/food/drinks/bottle/open(mob/user)
	if (rag)
		return
	..()


/obj/item/reagent_containers/food/drinks/bottle/on_update_icon()
	underlays.Cut()
	if (rag)
		var/underlay_image = image(icon='icons/obj/drinks.dmi', icon_state=rag.on_fire? "[rag_underlay]_lit" : rag_underlay)
		underlays += underlay_image
		set_light(rag.light_max_bright, 0.1, rag.light_outer_range, 2, rag.light_color)
	else
		set_light(0)


/obj/item/reagent_containers/food/drinks/bottle/apply_hit_effect(mob/living/target, mob/living/user, hit_zone)
	. = ..()
	if (user.a_intent != I_HURT)
		return
	if (!smash_check(1))
		return
	var/mob/living/carbon/human/H = target
	if (istype(H) && H.headcheck(hit_zone))
		var/obj/item/organ/affecting = H.get_organ(hit_zone)
		user.visible_message(SPAN_DANGER("\The [user] smashes \the [src] into \the [H]'s [affecting.name]!"))
		var/blocked = target.get_blocked_ratio(hit_zone, BRUTE, damage = 10) * 100
		var/weaken_duration = smash_duration + min(0, force - blocked + 10)
		if (weaken_duration)
			target.apply_effect(min(weaken_duration, 5), WEAKEN, blocked)
	else
		user.visible_message(SPAN_DANGER("\The [user] smashes [src] into [target]!"))
	if (reagents)
		user.visible_message(SPAN_NOTICE("The contents of \the [src] splash all over \the [target]!"))
		reagents.splash(target, reagents.total_volume)
	var/obj/item/broken_bottle/B = smash(get_turf(target), target)
	user.put_in_active_hand(B)


/obj/item/reagent_containers/food/drinks/bottle/gin
	name = "Griffeater Gin"
	desc = "A bottle of high quality gin, produced in the New London Space Station."
	icon_state = "ginbottle"
	center_of_mass = "x=16;y=4"


/obj/item/reagent_containers/food/drinks/bottle/gin/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/gin, 100)


/obj/item/reagent_containers/food/drinks/bottle/whiskey
	name = "Uncle Git's Special Reserve Whiskey"
	desc = "A premium single-malt whiskey, gently matured inside the tunnels of a nuclear shelter. TUNNEL WHISKEY RULES."
	icon_state = "whiskeybottle"
	center_of_mass = "x=16;y=3"


/obj/item/reagent_containers/food/drinks/bottle/whiskey/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/whiskey, 100)


/obj/item/reagent_containers/food/drinks/bottle/specialwhiskey
	name = "Special Blend Whiskey"
	desc = "Just when you thought regular whiskey was good... This silky, amber goodness has to come along and ruin everything."
	icon_state = "whiskeybottle2"
	center_of_mass = "x=16;y=3"


/obj/item/reagent_containers/food/drinks/bottle/specialwhiskey/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/specialwhiskey, 100)


/obj/item/reagent_containers/food/drinks/bottle/vodka
	name = "Tunguska Triple Distilled Vodka"
	desc = "Aah, vodka. Prime choice of drink AND fuel by Indies around the galaxy."
	icon_state = "vodkabottle"
	center_of_mass = "x=17;y=3"

/obj/item/reagent_containers/food/drinks/bottle/vodka/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/vodka, 100)


/obj/item/reagent_containers/food/drinks/bottle/tequilla
	name = "Caccavo Guaranteed Quality Tequilla"
	desc = "Made from premium petroleum distillates, pure thalidomide and other fine quality ingredients!"
	icon_state = "tequillabottle"
	center_of_mass = "x=16;y=3"


/obj/item/reagent_containers/food/drinks/bottle/tequilla/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/tequilla, 100)


/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing
	name = "Bottle of Nothing"
	desc = "A bottle filled with nothing."
	icon_state = "bottleofnothing"
	center_of_mass = "x=17;y=5"


/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/nothing, 100)


/obj/item/reagent_containers/food/drinks/bottle/patron
	name = "Wrapp Artiste Patron"
	desc = "Silver laced tequilla, served in space night clubs across the galaxy."
	icon_state = "patronbottle"
	center_of_mass = "x=16;y=6"


/obj/item/reagent_containers/food/drinks/bottle/patron/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/patron, 100)


/obj/item/reagent_containers/food/drinks/bottle/rum
	name = "Captain Pete's Cuban Spiced Rum"
	desc = "This isn't just rum, oh no. It's practically GRIFF in a bottle."
	icon_state = "rumbottle"
	center_of_mass = "x=16;y=8"


/obj/item/reagent_containers/food/drinks/bottle/rum/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/rum, 100)


/obj/item/reagent_containers/food/drinks/bottle/holywater
	name = "Flask of Holy Water"
	desc = "A flask of the chaplain's holy water."
	icon_state = "holyflask"
	center_of_mass = "x=17;y=10"


/obj/item/reagent_containers/food/drinks/bottle/holywater/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/water/holywater, 100)


/obj/item/reagent_containers/food/drinks/bottle/vermouth
	name = "Goldeneye Vermouth"
	desc = "Sweet, sweet dryness~"
	icon_state = "vermouthbottle"
	center_of_mass = "x=17;y=3"


/obj/item/reagent_containers/food/drinks/bottle/vermouth/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/vermouth, 100)


/obj/item/reagent_containers/food/drinks/bottle/kahlua
	name = "Robert Robust's Coffee Liqueur"
	desc = "A widely known, Mexican coffee-flavoured liqueur. In production since 1936, HONK!"
	icon_state = "kahluabottle"
	center_of_mass = "x=17;y=3"


/obj/item/reagent_containers/food/drinks/bottle/kahlua/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/coffee/kahlua, 100)


/obj/item/reagent_containers/food/drinks/bottle/goldschlager
	name = "College Girl Goldschlager"
	desc = "Because they are the only ones who will drink 100 proof cinnamon schnapps."
	icon_state = "goldschlagerbottle"
	center_of_mass = "x=15;y=3"


/obj/item/reagent_containers/food/drinks/bottle/goldschlager/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/goldschlager, 100)


/obj/item/reagent_containers/food/drinks/bottle/cognac
	name = "Chateau De Baton Premium Cognac"
	desc = "A sweet and strongly alchoholic drink, made after numerous distillations and years of maturing. You might as well not scream 'SHITCURITY' this time."
	icon_state = "cognacbottle"
	center_of_mass = "x=16;y=6"


/obj/item/reagent_containers/food/drinks/bottle/cognac/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/cognac, 100)


/obj/item/reagent_containers/food/drinks/bottle/wine
	name = "Doublebeard Bearded Special Wine"
	desc = "A faint aura of unease and asspainery surrounds the bottle."
	icon_state = "winebottle"
	center_of_mass = "x=16;y=4"


/obj/item/reagent_containers/food/drinks/bottle/wine/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/wine, 100)


/obj/item/reagent_containers/food/drinks/bottle/absinthe
	name = "Jailbreaker Verte Absinthe"
	desc = "One sip of this and you just know you're gonna have a good time."
	icon_state = "absinthebottle"
	center_of_mass = "x=16;y=6"


/obj/item/reagent_containers/food/drinks/bottle/absinthe/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/absinthe, 100)


/obj/item/reagent_containers/food/drinks/bottle/melonliquor
	name = "Emeraldine Melon Liquor"
	desc = "A bottle of 46 proof Emeraldine Melon Liquor. Sweet and light."
	icon_state = "alco-green"
	center_of_mass = "x=16;y=6"


/obj/item/reagent_containers/food/drinks/bottle/melonliquor/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/melonliquor, 100)


/obj/item/reagent_containers/food/drinks/bottle/bluecuracao
	name = "Miss Blue Curacao"
	desc = "A fruity, exceptionally azure drink. Does not allow the imbiber to use the fifth magic."
	icon_state = "alco-blue"
	center_of_mass = "x=16;y=6"


/obj/item/reagent_containers/food/drinks/bottle/bluecuracao/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/bluecuracao, 100)


/obj/item/reagent_containers/food/drinks/bottle/herbal
	name = "Liqueur d'Herbe"
	desc = "A bottle of the seventh-finest herbal liquor sold under a generic name in the galaxy. The back label has a load of guff about the monks who traditionally made this particular variety."
	icon_state = "herbal"
	center_of_mass = "x=16;y=6"


/obj/item/reagent_containers/food/drinks/bottle/herbal/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/herbal, 100)


/obj/item/reagent_containers/food/drinks/bottle/grenadine
	name = "Briar Rose Grenadine Syrup"
	desc = "Sweet and tangy, a bar syrup used to add color or flavor to drinks."
	icon_state = "grenadinebottle"
	center_of_mass = "x=16;y=6"


/obj/item/reagent_containers/food/drinks/bottle/grenadine/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/grenadine, 100)


/obj/item/reagent_containers/food/drinks/bottle/cola
	name = "\improper Space Cola"
	desc = "Cola. in space."
	icon_state = "colabottle"
	center_of_mass = "x=16;y=6"


/obj/item/reagent_containers/food/drinks/bottle/cola/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/space_cola, 100)


/obj/item/reagent_containers/food/drinks/bottle/space_up
	name = "\improper Space-Up"
	desc = "Tastes like a hull breach in your mouth."
	icon_state = "space-up_bottle"
	center_of_mass = "x=16;y=6"


/obj/item/reagent_containers/food/drinks/bottle/space_up/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/space_up, 100)


/obj/item/reagent_containers/food/drinks/bottle/space_mountain_wind
	name = "\improper Space Mountain Wind"
	desc = "Blows right through you like a space wind."
	icon_state = "space_mountain_wind_bottle"
	center_of_mass = "x=16;y=6"


/obj/item/reagent_containers/food/drinks/bottle/space_mountain_wind/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/spacemountainwind, 100)


/obj/item/reagent_containers/food/drinks/bottle/pwine
	name = "Warlock's Velvet"
	desc = "What a delightful packaging for a surely high quality wine! The vintage must be amazing!"
	icon_state = "pwinebottle"
	center_of_mass = "x=16;y=4"


/obj/item/reagent_containers/food/drinks/bottle/pwine/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/pwine, 100)


/obj/item/reagent_containers/food/drinks/bottle/blackstrap
	name = "Two Brothers Blackstrap"
	desc = "A bottle of Blackstrap, distilled in Two Brothers, Tersten."
	icon_state = "blackstrap"
	center_of_mass = "x=16;y=4"


/obj/item/reagent_containers/food/drinks/bottle/blackstrap/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/blackstrap, 100)


/obj/item/reagent_containers/food/drinks/bottle/sake
	name = "Takeo Sadow's Combined Sake"
	desc = "Finest Sake allowed for import in the SCG."
	icon_state = "sake"
	center_of_mass = "x=16;y=4"


/obj/item/reagent_containers/food/drinks/bottle/sake/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/sake, 100)


/obj/item/reagent_containers/food/drinks/bottle/lordaniawine
	name = "New Aresian Vintage 2230"
	desc = "The kind of wine that just demands attention, and a big wallet."
	icon_state = "lordaniawine"
	center_of_mass = "x=16;y=4"


/obj/item/reagent_containers/food/drinks/bottle/lordaniawine/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/lordaniawine, 100)


/obj/item/reagent_containers/food/drinks/bottle/champagne
	name = "Murcelano Vinyard's Premium Champagne"
	desc = "The regal drink of celebrities and royalty."
	icon_state = "champagne"
	center_of_mass = "x=16;y=4"


/obj/item/reagent_containers/food/drinks/bottle/champagne/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/champagne, 100)


/obj/item/reagent_containers/food/drinks/bottle/prosecco
	name = "2280 Vintage Prosecco."
	desc = "A delicious prosecco, ideal for long days at work. This one proudly advertises itself as 2280 Vintage. Must have been a special year."
	icon_state = "prosecco"
	center_of_mass = "x=16;y=4"


/obj/item/reagent_containers/food/drinks/bottle/prosecco/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/prosecco, 100)


/obj/item/reagent_containers/food/drinks/bottle/llanbrydewhiskey
	name = "Pritchard's Wisgi Ucheldirol"
	desc = "The bottle is covered in strange archaic markings... Oh wait, that's just Welsh."
	icon_state = "whiskeybottle3"
	center_of_mass = "x=16;y=4"


/obj/item/reagent_containers/food/drinks/bottle/llanbrydewhiskey/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/llanbrydewhiskey, 100)


/obj/item/reagent_containers/food/drinks/bottle/jagermeister
	name = "Kaisermeister Deluxe Jagermeister"
	desc = "Jagermeister. This drink just demands a party."
	icon_state = "herbal"
	center_of_mass = "x=16;y=6"


/obj/item/reagent_containers/food/drinks/bottle/jagermeister/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/jagermeister, 100)


/obj/item/reagent_containers/food/drinks/bottle/cachaca
	name = "Acacara Cachaca"
	desc = "Cachaca, distilled from fermented sugarcane.  This one was bottled in Acacara, Yuklid."
	icon_state = "cachaca"
	center_of_mass = "x=16;y=6"


/obj/item/reagent_containers/food/drinks/bottle/cachaca/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/cachaca, 100)


/obj/item/reagent_containers/food/drinks/bottle/baijiu
	name = "Huangjin Bay Baijiu"
	desc = "A large bottle of Baijiu with a beautiful looking sunset on the cover."
	icon_state = "baijiu"
	center_of_mass = "x=16;y=6"


/obj/item/reagent_containers/food/drinks/bottle/baijiu/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/baijiu, 100)


/obj/item/reagent_containers/food/drinks/bottle/soju
	name = "Sol Hyonjun's Soju"
	desc = "A clear, see-through bottle of Soju."
	icon_state = "soju"
	center_of_mass = "x=16;y=6"


/obj/item/reagent_containers/food/drinks/bottle/soju/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/soju, 100)


/obj/item/reagent_containers/food/drinks/bottle/rakia
	name = "Sadmir Cumani's Rakia"
	desc = "A polite looking man on the label promises you this is 100 percent Albanian."
	icon_state = "rakia"
	center_of_mass = "x=16;y=6"


/obj/item/reagent_containers/food/drinks/bottle/rakia/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/rakia, 100)


/obj/item/reagent_containers/food/drinks/bottle/premiumvodka
	name = "Four Stripes Quadruple Distilled"
	desc = "Premium distilled vodka imported directly from the Gilgamesh Colonial Confederation."
	icon_state = "premiumvodka"
	center_of_mass = "x=17;y=3"


/obj/item/reagent_containers/food/drinks/bottle/premiumvodka/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/vodka/premium, 100)
	var/namepick = pick("Four Stripes","Gilgamesh","Novaya Zemlya","Indie","STS-35")
	var/typepick = pick("Absolut","Gold","Quadruple Distilled","Platinum","Standard")
	name = "[namepick] [typepick]"


/obj/item/reagent_containers/food/drinks/bottle/premiumwine
	name = "Uve De Blanc"
	desc = "You feel pretentious just looking at it."
	icon_state = "premiumwine"
	center_of_mass = "x=16;y=4"


/obj/item/reagent_containers/food/drinks/bottle/premiumwine/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/wine/premium, 100)
	var/namepick = pick("Calumont","Sciacchemont","Recioto","Torcalota")
	var/agedyear = rand(GLOB.using_map.game_year - 150, GLOB.using_map.game_year)
	name = "Chateau [namepick] De Blanc"
	desc += " This bottle is marked as [agedyear] Vintage."


/obj/item/reagent_containers/food/drinks/bottle/brandy
	name = "New Amsterdam Deluxe Brandy"
	desc = "A bottle of premium Lunar brandy."
	icon_state = "lunabrandy"
	center_of_mass = "x=16;y=4"


/obj/item/reagent_containers/food/drinks/bottle/brandy/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/lunabrandy, 100)
	var/namepick = pick("Selenian","New Vegas","Yueliang","Gideon","New Amsterdam","Saurian")
	var/typepick = pick("Deluxe Brandy","Premium Brandy","Luxury Brandy","Expensive Brandy","Special Brandy")
	SetName("[namepick] [typepick]")


//////////////////////////JUICES AND STUFF ///////////////////////

/obj/item/reagent_containers/food/drinks/bottle/orangejuice
	name = "Orange Juice"
	desc = "Full of vitamins and deliciousness!"
	icon_state = "orangejuice"
	item_state = "carton"
	center_of_mass = "x=16;y=7"
	can_shatter = FALSE


/obj/item/reagent_containers/food/drinks/bottle/orangejuice/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/juice/orange, 100)


/obj/item/reagent_containers/food/drinks/bottle/cream
	name = "Milk Cream"
	desc = "It's cream. Made from milk. What else did you think you'd find in there?"
	icon_state = "cream"
	item_state = "carton"
	center_of_mass = "x=16;y=8"
	can_shatter = FALSE


/obj/item/reagent_containers/food/drinks/bottle/cream/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/milk/cream, 100)


/obj/item/reagent_containers/food/drinks/bottle/tomatojuice
	name = "Tomato Juice"
	desc = "Well, at least it LOOKS like tomato juice. You can't tell with all that redness."
	icon_state = "tomatojuice"
	item_state = "carton"
	center_of_mass = "x=16;y=8"
	can_shatter = FALSE


/obj/item/reagent_containers/food/drinks/bottle/tomatojuice/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/juice/tomato, 100)


/obj/item/reagent_containers/food/drinks/bottle/limejuice
	name = "Lime Juice"
	desc = "Sweet-sour goodness."
	icon_state = "limejuice"
	item_state = "carton"
	center_of_mass = "x=16;y=8"
	can_shatter = FALSE


/obj/item/reagent_containers/food/drinks/bottle/limejuice/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/juice/lime, 100)


/obj/item/reagent_containers/food/drinks/bottle/unathijuice
	name = "Hrukhza Leaf Extract"
	desc = "Hrukhza Leaf, a vital component of any Moghes drinks."
	icon_state = "hrukhzaextract"
	item_state = "carton"
	center_of_mass = "x=16;y=8"
	can_shatter = FALSE


/obj/item/reagent_containers/food/drinks/bottle/unathijuice/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/alien/unathijuice, 100)


/obj/item/reagent_containers/food/drinks/bottle/lemonjuice
	name = "Lemon Juice"
	desc = "Sweet-sour goodness."
	icon_state = "lemonjuice"
	item_state = "carton"
	center_of_mass = "x=16;y=8"
	can_shatter = FALSE


/obj/item/reagent_containers/food/drinks/bottle/lemonjuice/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/juice/lemon, 100)


/obj/item/reagent_containers/food/drinks/bottle/maplesyrup
	name = "maple syrup bottle"
	desc = "Sweet, syrupy goodness."
	icon_state = "maplesyrup"
	center_of_mass = "x=16;y=8"


/obj/item/reagent_containers/food/drinks/bottle/maplesyrup/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/maplesyrup, 100)


/obj/item/reagent_containers/food/drinks/bottle/small
	volume = 50
	smash_duration = 1
	atom_flags = 0
	rag_underlay = "rag_small"


/obj/item/reagent_containers/food/drinks/bottle/small/beer
	name = "space beer"
	desc = "Contains only water, malt and hops."
	icon_state = "beer"
	center_of_mass = "x=16;y=12"


/obj/item/reagent_containers/food/drinks/bottle/small/beer/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/beer, 30)


/obj/item/reagent_containers/food/drinks/bottle/small/ale
	name = "\improper Magm-Ale"
	desc = "A true dorf's drink of choice."
	icon_state = "alebottle"
	item_state = "beer"
	center_of_mass = "x=16;y=10"


/obj/item/reagent_containers/food/drinks/bottle/small/ale/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/ale, 30)


/obj/item/reagent_containers/food/drinks/bottle/small/hellshenpa
	name = "Hellshen Pale Ale"
	desc = "The best ale on Mars, according to the label."
	icon_state = "hellshenbeer"
	center_of_mass = "x=16;y=12"


/obj/item/reagent_containers/food/drinks/bottle/small/hellshenpa/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/hellshenpa, 30)


/obj/item/reagent_containers/food/drinks/bottle/small/gingerbeer
	name = "Ginger Beer"
	desc = "A delicious non-alcoholic beverage enjoyed across Sol space."
	icon_state = "gingerbeer"
	center_of_mass = "x=16;y=12"


/obj/item/reagent_containers/food/drinks/bottle/small/gingerbeer/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/gingerbeer, 50)


/obj/item/reagent_containers/food/drinks/bottle/small/dandelionburdock
	name = "Dandelion and Burdock"
	desc = "A bottle of dandelion and burdock. Not actually made from either of the two."
	icon_state = "dnb"
	center_of_mass = "x=16;y=12"


/obj/item/reagent_containers/food/drinks/bottle/small/dandelionburdock/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/dandelionburdock, 50)


/obj/item/reagent_containers/food/drinks/bottle/small/alcoholfreebeer
	name = "Alcohol-Free Beer"
	desc = "A bottle of alcohol-free beer. Finally, you can drink on duty."
	icon_state = "alcoholfreebeer"
	center_of_mass = "x=16;y=12"


/obj/item/reagent_containers/food/drinks/bottle/small/alcoholfreebeer/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/alcoholfreebeer, 50)


/obj/item/reagent_containers/food/drinks/bottle/small/lager
	name = "Hans' Original Lager"
	desc = "A bottle of premium lager. Has Hans' seal of approval, apparently."
	icon_state = "lager"
	center_of_mass = "x=16;y=12"


/obj/item/reagent_containers/food/drinks/bottle/small/lager/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/lager, 50)


/obj/item/reagent_containers/food/drinks/bottle/oiljug
	name = "oil jug"
	desc = "A plastic jug of engine oil. Not for human consumption."
	icon_state = "oil"
	can_shatter = FALSE


/obj/item/reagent_containers/food/drinks/bottle/oiljug/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/oil, 100)


/obj/item/broken_bottle
	name = "Broken Bottle"
	desc = "A bottle with a sharp broken bottom."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "broken_bottle"
	force = 9
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	item_state = "beer"
	attack_verb = list("stabbed", "slashed", "attacked")
	sharp = TRUE
	var/icon/broken_outline = icon('icons/obj/drinks.dmi', "broken")


/obj/item/broken_bottle/attack(mob/living/carbon/M, mob/living/carbon/user)
	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
	return ..()
