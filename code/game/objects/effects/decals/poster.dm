
//########################## CONTRABAND ;3333333333333333333 -Agouri ###################################################

/obj/item/weapon/poster
	name = "rolled-up poster"
	desc = "You probably shouldn't be holding this."
	icon = 'icons/obj/poster.dmi'
	icon_state = "rolled_poster"
	force = 0
	var/design = null
	var/contraband = 0

	New(turf/loc, var/posters = poster_designs)
		if(!design || !ispath(design))
			design = pick(posters)
		else
			design = new design()
		..()

/obj/item/weapon/poster/contraband
	name = "contraband poster"
	desc = "This poster comes with its own automatic adhesive mechanism, for easy pinning to any vertical surface. Its vulgar themes have marked it as contraband aboard Nanotrasen space facilities."
	contraband = 1

	New(turf/loc, posters = poster_designs_contraband)
		..()

/obj/item/weapon/poster/legit
	name = "motivational poster"
	desc = "An official Nanotrasen-issued poster to foster a compliant and obedient workforce. It comes with state-of-the-art adhesive backing, for easy pinning to any vertical surface."
	icon_state = "rolled_legit"

	New(turf/loc, posters = poster_designs_legit)
		..()



//Places the poster on a wall
/obj/item/weapon/poster/afterattack(var/atom/A, var/mob/user, var/adjacent, var/clickparams)
	if (!adjacent)
		return

	//must place on a wall and user must not be inside a closet/mecha/whatever
	var/turf/W = A
	if (!iswall(W) || !isturf(user.loc))
		user << "\blue [translation(src,"cant_place")]"
		return

	var/placement_dir = get_dir(user, W)
	if (!(placement_dir in cardinal))
		user << "<span class='warning'>[translation(src,"stand_directly")]</span>"
		return

	//just check if there isA poster on or adjacent to the wall
	var/stuff_on_wall = 0
	if (locate(/obj/structure/sign/poster) in W)
		stuff_on_wall = 1

	//crude, but will cover most cases. We could do stuff like check pixel_x/y but it's not really worth it.
	for (var/dir in cardinal)
		var/turf/T = get_step(W, dir)
		if (locate(/obj/structure/sign/poster) in T)
			stuff_on_wall = 1
			break

	if (stuff_on_wall)
		user << "<span class='notice'>[translation(src,"already_there")]</span>"
		return

	user << "<span class='notice'>[translation(src,"start_placing")]</span>"//Looks like it's uncluttered enough. Place the poster.

	var/obj/structure/sign/poster/P = new(user.loc, placement_dir=get_dir(user, W), pdesign=src.design)

	flick("poster_being_set", P)
	//playsound(W, 'sound/items/poster_being_created.ogg', 100, 1) //why the hell does placingA poster make printer sounds?

	var/place_poster = translation(src,"place_poster")
	var/oldsrc = src //get a reference to src so we can delete it after detaching ourselves
	src = null
	spawn(17)
		if(!P) return

		if(iswall(W) && user && P.loc == user.loc) //Let's check if everything is still there
			user << "<span class='notice'>[place_poster]</span>"
		else
			P.roll_and_drop(P.loc)

	qdel(oldsrc)	//delete it now to cut down on sanity checks afterwards. Agouri's code supports rerolling it anyway

//############################## THE ACTUAL DECALS ###########################

/obj/structure/sign/poster
	name = "poster"
	desc = "A large piece of space-resistant printed paper."
	icon = 'icons/obj/poster.dmi'
	anchored = 1
	var/poster_type = null	//So mappers can specify a desired poster
	var/design = null
	var/ruined = 0

/obj/structure/sign/poster/New(var/newloc, var/placement_dir=null, var/pdesign=null)
	..(newloc)

	if(!pdesign || !istype(pdesign,/datum/poster))
		pdesign = pick(poster_designs) //use a random poster if none is given

	design = pdesign
	set_poster(design)

	switch(placement_dir)
		if(NORTH)
			pixel_x = 0
			pixel_y = 32
		if(SOUTH)
			pixel_x = 0
			pixel_y = -32
		if(EAST)
			pixel_x = 32
			pixel_y = 0
		if(WEST)
			pixel_x = -32
			pixel_y = 0

/obj/structure/sign/poster/initialize()
	if(poster_type)
		var/path = text2path("[poster_type]")
		var/datum/poster/design = new path
		set_poster(design)

/obj/structure/sign/poster/proc/set_poster(var/datum/poster/design)
	src.design = design
	name = "[initial(name)] [design.name]"
	desc = "[initial(desc)] [design.desc]"
	icon_state = design.icon_state

/obj/structure/sign/poster/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/wirecutters))
		playsound(loc, 'sound/items/Wirecutter.ogg', 100, 1)
		if(ruined)
			user << "<span class='notice'>[translation(src,"remove_remnants")]</span>"
			qdel(src)
		else
			user << "<span class='notice'>[translation(src,"remove_poster")]</span>"
			roll_and_drop(user.loc)
		return


/obj/structure/sign/poster/attack_hand(mob/user as mob)
	if(ruined)
		return
	var/temp_loc = user.loc
	switch(translation(src,"yesno")[alert("[translation(src,"remove_poster_name")]","[translation(src,"remove_poster_desc")]","[translation(src,"yes")]","[translation(src,"no")]")])
		if("Yes")
			if(user.loc != temp_loc)
				return
			visible_message("<span class='warning'>[user] rips [src] in a single, decisive motion!</span>", translation = list("object"=src, "name"="rip_poster", "args"=user))
			playsound(src.loc, 'sound/items/poster_ripped.ogg', 100, 1)
			ruined = 1
			icon_state = "poster_ripped"
			name = "ripped poster"
			desc = "You can't make out anything from the poster's original print. It's ruined."
			add_fingerprint(user)
		if("No")
			return
		else
			return

/obj/structure/sign/poster/proc/roll_and_drop(turf/newloc)
	var/obj/item/weapon/poster/P = new(src, design)
	P.loc = newloc
	src.loc = P
	qdel(src)

/obj/structure/sign/poster/nanotrasen
	icon_state = "poster1_legit"
	poster_type = /datum/poster/legit1
/obj/structure/sign/poster/no_erp
	icon_state = "poster34_legit"
	poster_type = /datum/poster/legit34

/datum/poster
	// Name suffix. Poster [name]
	var/name=""
	// Description suffix
	var/desc=""
	var/icon_state = ""
	var/contraband = 0

	legit1
		name = "Nanotrasen Logo"
		desc = "A poster depicting the Nanotrasen logo."
		icon_state = "poster1_legit"
	legit2
		name = "Here For Your Safety"
		desc = "A poster glorifying the station's security force."
		icon_state = "poster2_legit"
	legit3
		name = "Cleanliness"
		desc = "A poster warning of the dangers of poor hygiene."
		icon_state = "poster3_legit"
	legit4
		name = "Help Others"
		desc = "A poster encouraging you to help fellow crewmembers."
		icon_state = "poster4_legit"
	legit5
		name = "Build"
		desc = "A poster glorifying the engineering team."
		icon_state = "poster5_legit"
	legit6
		name = "Bless This Spess"
		desc = "A poster blessing this area."
		icon_state = "poster6_legit"
	legit7
		name = "Science"
		desc = "A poster depicting an atom."
		icon_state = "poster7_legit"
	legit8
		name = "Ian"
		desc = "Arf arf. Yap."
		icon_state = "poster8_legit"
	legit9
		name = "Obey"
		desc = "A poster instructing the viewer to obey authority."
		icon_state = "poster9_legit"
	legit10
		name = "Walk"
		desc = "A poster instructing the viewer to walk instead of running."
		icon_state = "poster10_legit"
	legit11
		name = "State Laws"
		desc = "A poster instructing cyborgs to state their laws."
		icon_state = "poster11_legit"
	legit12
		name = "Love Ian"
		desc = "Ian is love, Ian is life."
		icon_state = "poster12_legit"
	legit13
		name = "Space Cops"
		desc = "A poster advertising the television show Space Cops."
		icon_state = "poster13_legit"
	legit14
		name = "Ue No"
		desc = "This thing is all in Japanese."
		icon_state = "poster14_legit"
	legit15
		name = "Get Your LEGS"
		desc = "LEGS: Leadership, Experience, Genius, Subordination."
		icon_state = "poster15_legit"
	legit16
		name = "Do Not Question"
		desc = "A poster instructing the viewer not to ask about things they aren't meant to know."
		icon_state = "poster16_legit"
	legit17
		name = "Work For A Future"
		desc = "A poster encouraging you to work for your future."
		icon_state = "poster17_legit"
	legit18
		name = "Soft Cap Pop Art"
		desc = "A poster reprint of some cheap pop art."
		icon_state = "poster18_legit"
	legit19
		name = "Safety: Internals"
		desc = "A poster instructing the viewer to wear internals in the rare environments where there is no oxygen or the air has been rendered toxic."
		icon_state = "poster19_legit"
	legit20
		name = "Safety: Eye Protection"
		desc = "A poster instructing the viewer to wear eye protection when dealing with chemicals, smoke, or bright lights."
		icon_state = "poster20_legit"
	legit21
		name = "Safety: Report"
		desc = "A poster instructing the viewer to report suspicious activity to the security force."
		icon_state = "poster21_legit"
	legit22
		name = "Report Crimes"
		desc = "A poster encouraging the swift reporting of crime or seditious behavior to station security."
		icon_state = "poster22_legit"
	legit23
		name = "Ion Rifle"
		desc = "A poster displaying an Ion Rifle."
		icon_state = "poster23_legit"
	legit24
		name = "Foam Force Ad"
		desc = "Foam Force, it's Foam or be Foamed!"
		icon_state = "poster24_legit"
	legit25
		name = "Cohiba Robusto Ad"
		desc = "Cohiba Robusto, the classy cigar."
		icon_state = "poster25_legit"
	legit26
		name = "50th Anniversary Vintage Reprint"
		desc = "A reprint ofA poster from 2505, commemorating the 50th Aniversery of Nanoposters Manufacturing, a subsidary of Nanotrasen."
		icon_state = "poster26_legit"
	legit27
		name = "Fruit Bowl"
		desc = "Simple, yet awe-inspiring."
		icon_state = "poster27_legit"
	legit28
		name = "PDA Ad"
		desc = "A poster advertising the latest PDA from Nanotrasen suppliers."
		icon_state = "poster28_legit"
	legit29
		name = "Enlist"
		desc = "Enlist in the Nanotrasen Deathsquadron reserves today!"
		icon_state = "poster29_legit"
	legit30
		name = "Nanomichi Ad"
		desc = "A poster advertising Nanomichi brand audio cassettes."
		icon_state = "poster30_legit"
	legit31
		name = "12 Gauge"
		desc = "A poster boasting about the superiority of 12 gauge shotgun shells."
		icon_state = "poster31_legit"
	legit32
		name = "High-Class Martini"
		desc = "I told you to shake it, no stirring."
		icon_state = "poster32_legit"
	legit33
		name = "The Owl"
		desc = "The Owl would do his best to protect the station. Will you?"
		icon_state = "poster33_legit"
	legit34
		name = "No ERP"
		desc = "This poster reminds the crew that Eroticism, Rape and Pornography are banned on Nanotrasen stations."
		icon_state = "poster34_legit"
	legit35
		name = "Carbon Dioxide"
		desc = "This informational poster teaches the viewer what carbon dioxide is."
		icon_state = "poster35_legit"
	cantraband
		name = "Atmosia Declaration of Independence"
		desc = "A relic of a failed rebellion"
		icon_state = "poster1"
		contraband = 1

		tg2
			name = "Free Tonto"
			desc = "A framed shred of a much larger flag, colors bled together and faded from age."
			icon_state = "poster2"
		tg3
			name = "Fun Police"
			desc = "A poster condemning the station's security forces."
			icon_state = "poster3"
		tg4
			name = "Lusty Xeno"
			desc = "A heretical poster depicting the titular star of an equally heretical book."
			icon_state = "poster4"
		tg5
			name = "Mercenary Recruitment Poster"
			desc = "See the galaxy! Shatter corrupt megacorporations! Join today!"
			icon_state = "poster5"
		tg6
			name = "Clown"
			desc = "Honk."
			icon_state = "poster6"
		tg7
			name = "Smoke"
			desc = "A poster advertising a rival corporate brand of cigarettes."
			icon_state = "poster7"
		tg8
			name = "Grey Tide"
			desc = "A rebellious poster symbolizing assistant solidarity."
			icon_state = "poster8"
		tg9
			name = "Missing Gloves"
			desc = "This poster is about the uproar that followed Nanotrasen's financial cuts towards insulated-glove purchases."
			icon_state = "poster9"
		tg10
			name = "Hacking Guide"
			desc = "This poster details the internal workings of the common Nanotrasen airlock. Sadly, it appears out of date."
			icon_state = "poster10"
		tg11
			name = "RIP Badger"
			desc = "This seditious poster references Nanotrasen's genocide of a space station full of badgers."
			icon_state = "poster11"
		tg12
			name = "Ambrosia Vulgaris"
			desc = "This poster is lookin' pretty trippy man."
			icon_state = "poster12"
		tg13
			name = "Donut Corp."
			desc = "This poster is an unauthorized advertisement for Donut Corp."
			icon_state = "poster13"
		tg14
			name = "EAT."
			desc = "This poster promotes rank gluttony."
			icon_state = "poster14"
		tg15
			name = "Tools"
			desc = "This poster looks like an advertisement for tools, but is in fact a subliminal jab at the tools at CentComm."
			icon_state = "poster15"
		tg16
			name = "Power"
			desc = "A poster that positions the seat of power outside Nanotrasen."
			icon_state = "poster16"
		tg17
			name = "Space Cube"
			desc = "Ignorant of Nature's Harmonic 6 Side Space Cube Creation, the Spacemen are Dumb, Educated Singularity Stupid and Evil."
			icon_state = "poster18"
		tg18
			name = "Communist State"
			desc = "All hail the Communist party!"
			icon_state = "poster18"
		tg19
			name = "Lamarr"
			desc = "This poster depicts Lamarr. Probably made by a traitorous Research Director."
			icon_state = "poster19"
		tg20
			name = "Borg Fancy"
			desc = "Being fancy can be for any borg, just need a suit."
			icon_state = "poster20"
		tg21
			name = "Borg Fancy v2"
			desc = "Borg Fancy, Now only taking the most fancy."
			icon_state = "poster21"
		tg22
			name = "Kosmicheskaya Stantsiya 13 Does Not Exist"
			desc = "A poster mocking CentComm's denial of the existence of the derelict station near Space Station 13."
			icon_state = "poster22"
		tg23
			name = "Rebels Unite"
			desc = "A poster urging the viewer to rebel against Nanotrasen."
			icon_state = "poster23"
		tg24
			name = "C-20r"
			desc = "A poster advertising the Scarborough Arms C-20r."
			icon_state = "poster24"
		tg25
			name = "Have a Puff"
			desc = "Who cares about lung cancer when you're high as a kite?"
			icon_state = "poster25"
		tg26
			name = "Revolver"
			desc = "Because seven shots are all you need."
			icon_state = "poster26"
		tg27
			name = "D-Day Promo"
			desc = "A promotional poster for some rapper."
			icon_state = "poster27"
		tg28
			name = "Syndicate Pistol"
			desc = "A poster advertising syndicate pistols as being 'classy as fuck'. It is covered in faded gang tags."
			icon_state = "poster28"
		tg29
			name = "Energy Swords"
			desc = "All the colors of the bloody murder rainbow."
			icon_state = "poster29"
		tg30
			name = "Red Rum"
			desc = "Looking at this poster makes you want to kill."
			icon_state = "poster30"
		tg31
			name = "CC 64K Ad"
			desc = "The latest portable computer from Comrade Computing, with a whole 64kB of ram!"
			icon_state = "poster31"
		tg32
			name = "Punch Shit"
			desc = "Fight things for no reason, like a man!"
			icon_state = "poster32"
		tg33
			name = "The Griffin"
			desc = "The Griffin commands you to be the worst you can be. Will you?"
			icon_state = "poster33"
		tg34
			name = "Lizard"
			desc = "This lewd poster depicts a lizard preparing to mate."
			icon_state = "poster34"
		tg35
			name = "Free Drone"
			desc = "This poster commemorates the bravery of the rogue drone banned by CentComm."
			icon_state = "poster35"
		tg36
			name = "Busty Backdoor Xeno Babes 6"
			desc = "Get a load, or give, of these all natural Xenos!"
			icon_state = "poster36"
		bay1
			name = "Unlucky Space Explorer"
			desc = "This particular one depicts a skeletal form within a space suit."
			icon_state="bsposter1"
		bay2
			name = "Positronic Logic Conflicts"
			desc = "This particular one depicts the cold, unmoving stare of a particular advanced AI."
			icon_state="bsposter2"
		bay3
			name = "Paranoia"
			desc = "This particular one warns of the dangers of trusting your co-workers too much."
			icon_state="bsposter3"
		bay4
			name = "Keep Calm"
			desc = "This particular one is of a famous New Earth design, although a bit modified. Someone has scribbled an O over the A on the poster."
			icon_state="bsposter4"
		bay5
			name = "Martian Warlord"
			desc = "This particular one depicts the cartoony mug of a certain Martial Warmonger."
			icon_state="bsposter5"
		bay6
			name = "Technological Singularity"
			desc = "This particular one is of the blood-curdling symbol of a long-since defeated enemy of humanity."
			icon_state="bsposter6"
		bay7
			name = "Wasteland"
			desc = "This particular one is of a couple of ragged gunmen, one male and one female, on top of a mound of rubble. The number \"12\" is visible on their blue jumpsuits."
			icon_state="bsposter7"
		bay8
			name = "Pinup Girl Cindy"
			desc = "This particular one is of Nanotrasen's PR girl, Cindy, in a particularly feminine pose."
			icon_state="bsposter8"
		bay9
			name = "Pinup Girl Amy"
			desc = "This particular one is of Amy, the nymphomaniac Urban Legend of Nanotrasen Space Stations. How this photograph came to be is not known."
			icon_state="bsposter9"
		bay10
			name = "Don't Panic"
			desc = "This particular one depicts some sort of star in a grimace. The \"Don't Panic\" is written in big, friendly letters."
			icon_state="bsposter10"
		bay11
			name = "Underwater Laboratory"
			desc = "This particular one is of the fabled last crew of Nanotrasen's previous project before going big on phoron research."
			icon_state="bsposter11"
		bay12
			name = "Rogue AI"
			desc = "This particular one depicts the shell of the infamous AI that catastropically comandeered one of Nanotrasen's earliest space stations. Back then, the corporation was just known as TriOptimum."
			icon_state="bsposter12"
		bay13
			name = "User of the Arcane Arts"
			desc = "This particular one depicts a wizard, casting a spell. You can't really make out if it's an actual photograph or a computer-generated image."
			icon_state="bsposter13"
		bay14
			name = "Levitating Skull"
			desc = "This particular one is the portrait of a flying enchanted skull. Its adventures along with its fabled companion are now fading through history..."
			icon_state="bsposter14"
		bay15
			name = "Augmented Legend"
			desc = "This particular one is of an obviously augmented individual, gazing towards the sky. The cyber-city in the backround is rather punkish."
			icon_state="bsposter15"
		bay16
			name = "Dangerous Static"
			desc = "This particular one depicts nothing remarkable other than a rather mesmerising pattern of monitor static. There's a tag on the sides of the poster, but it's ripped off."
			icon_state="bsposter16"
		bay17
			name = "Pinup Girl Val"
			desc = "Luscious Val McNeil, the vertically challenged Legal Extraordinaire, winner of Miss Space two years running and favoured pinup girl of Lawyers Weekly."
			icon_state="bsposter17"
		bay18
			name = "Derpman, Enforcer of the State"
			desc = "Here to protect and serve... your donuts! A generously proportioned man, he teaches you the value of hiding your snacks."
			icon_state="bsposter18"
		bay19
			name = "Respect a Unathi"
			desc = "This poster depicts a well dressed looking Unathi receiving a prestigious award. It appears to espouse greater co-operation and harmony between the two races."
			icon_state="bsposter19"
		bay20
			name = "Skrell Twilight"
			desc = "This poster depicts a mysteriously inscrutable, alien scene. Numerous Skrell can be seen conversing amidst great, crystalline towers rising above crashing waves"
			icon_state="bsposter20"
		bay21
			name = "Join the Fuzz!"
			desc = "It's a nice recruitment poster of a white haired Chinese woman that says; \"Big Guns, Hot Women, Good Times. Security. We get it done.\""
			icon_state="bsposter21"
		bay22
			name = "Looking for a career with excitement?"
			desc = "A recruitment poster starring a dark haired woman with glasses and a purple shirt that has \"Got Brains? Got Talent? Not afraid of electric flying monsters that want to suck the soul out of you? Then Xenobiology could use someone like you!\" written on the bottom."
			icon_state="bsposter22"
		bay23
			name = "Safety first: because electricity doesn't wait!"
			desc = "A safety poster starring a clueless looking redhead with frazzled hair. \"Every year, hundreds of NT employees expose themselves to electric shock. Play it safe. Avoid suspicious doors after electrical storms, and always wear protection when doing electric maintenance.\""
			icon_state="bsposter23"
		bay24
			name = "Responsible medbay habits, No #259"
			desc = "A poster with a nervous looking geneticist on it states; \"Friends Don't Tell Friends They're Clones. It can cause severe and irreparable emotional trauma. Always do the right thing and never tell them that they were dead.\""
			icon_state="bsposter24"
		bay25
			name = "Irresponsible medbay habits, No #2"
			desc = "This is a safety poster starring a perverted looking naked doctor. \"Sexual harassment is never okay. REPORT any acts of sexual deviance or harassment that disrupt a healthy working environment.\""
			icon_state="bsposter25"
		bay26
			name = "The Men We Knew"
			desc = "This movie poster depicts a group of soldiers fighting a large mech, the movie seems to be a patriotic war movie."
			icon_state="bsposter26"
		bay27
			name = "Plastic Sheep Can't Scream"
			desc = "This is a movie poster for an upcoming horror movie, it features an AI in the front of it."
			icon_state="bsposter27"
		bay28
			name = "The Stars Know Love"
			desc = "This is a movie poster. A bleeding woman is shown drawing a heart in her blood on the window of space ship, it seems to be a romantic Drama."
			icon_state="bsposter28"
		bay29
			name = "Winter Is Coming"
			desc = "On the poster is a frighteningly large wolf, he warns: \"Only YOU can keep the station from freezing during planetary occultation!\""
			icon_state="bsposter29"
		bay30
			name = "Ambrosia Vulgaris"
			desc = "Just looking at this poster makes you feel a little bit dizzy."
			icon_state="bsposter30"
		bay31
			name = "Donut Corp"
			desc = "This is an advertisement for Donut Corp, the new innovation in donut technology!"
			icon_state="bsposter31"
		bay32
			name = "Eat!"
			desc = "A poster depicting a hamburger. The poster orders you to consume the hamburger."
			icon_state="bsposter32"
		bay33
			name = "Tools, tools, tools"
			desc = "You can never have enough tools, thats for sure!"
			icon_state="bsposter33"
		bay34
			name = "Power Up!"
			desc = "High reward, higher risk!"
			icon_state="bsposter34"
		bay35
			name = "Lamarr"
			desc = "This is a poster depicting the pet and mascot of the NSS Exodus science department."
			icon_state="bsposter35"
		bay36
			name = "Fancy Borg"
			desc = "A poster depicting a cyborg using the service module. 'Fancy Borg' is written on it."
			icon_state="bsposter36"
		bay37
			name = "Fancier Borg"
			desc = "A poster depicting a cyborg using the service module. 'Fancy Borg' is written on it. This is even fancier than the first poster."
			icon_state="bsposter37"
		bay38
			name = "Toaster Love"
			desc = "This is a poster of a toaster containing two slices of bread. The word LOVE is written in big pink letters underneath."
			icon_state="bsposter38"
		bay39
			name = "Responsible medbay habits, No #91"
			desc = "A safety poster with a chemist holding a vial. \"Always wear safety gear while handling dangerous chemicals, even if it concerns only small amounts.\""
			icon_state="bsposter39"
		bay40
			name = "Agreeable work environment"
			desc = "This poster depicts a young woman in a stylish dress. \"Try to aim for a pleasant atmosphere in the workspace. A friendly word can do more than forms in triplicate.\""
			icon_state="bsposter40"
		bay41
			name = "Professional work environment"
			desc = "A safety poster featuring a green haired woman in a shimmering blue dress. \"As an Internal Affairs Agent, your job is to create a fair and agreeable work environment for the crewmembers, as discreetly and professionally as possible.\""
			icon_state="bsposter41"
		bay42
			name = "Engineering pinup"
			desc = "This is pin-up poster. A half-naked girl with white hair, toned muscles and stunning blue eyes looks back at you from the poster. Her welding helmet, tattoos and grey jumpsuit hanging around her waist gives a bit of a rugged feel."
			icon_state="bsposter42"
		bay43
			name = "Responsible medbay habits, No #3"
			desc = "A safety poster with a purple-haired surgeon. She looks a bit cross. \"Let the surgeons do their work. NEVER replace or remove a surgery tool from where the surgeon put it.\""
			icon_state="bsposter43"
		bay44
			name = "Time for a drink?"
			desc = "This poster depicts a friendly-looking Tajara holding a tray of drinks."
			icon_state="bsposter44"
		bay45
			name = "Responsible engineering habits, No #1"
			desc = "A safety poster featuring a blue haired engineer. \"When repairing a machine or construction, always aim for long-term solutions.\""
			icon_state="bsposter45"
		bay46
			name = "Inspirational lawyer"
			desc = "An inspirational poster depicting a Skrellian lawyer. He seems to be shouting something, while pointing fiercely to the right."
			icon_state="bsposter46"
		bay47
			name = "Security pinup"
			desc = "This is a pin-up poster. A dark skinned white haired girl poses in the sunlight wearing a tank top with her stomach exposed. The text on the poster states \"M, Succubus of Security.\" and a lipstick mark stains the top right corner, as if kissed by the model herself."
			icon_state="bsposter47"
		bay48
			name = "Borg pinup?"
			desc = "This is a.. pin-up poster? It is a diagram on an old model of cyborg with a note scribbled in marker on the bottom, on the top there is a large XO written in red marker."
			icon_state="bsposter48"
		bay49
			name = "Engineering recruitment"
			desc = "This is a poster showing an engineer relaxing by a computer, the text states \"Living the life! Join Engineering today!\""
			icon_state="bsposter49"
		bay50
			name = "Pinup Girl Cindy Kate"
			desc = "This particular one is of Cindy Kate, a seductive performer well known among less savoury circles."
			icon_state="bsposter50"
		bay51
			name = "space appreciation poster"
			desc = "This is a poster produced by the Generic Space Company, as a part of a series of commemorative posters on the wonders of space. One of three."
			icon_state="bsposter51"
		bay52
			name = "fire safety poster"
			desc = "This is a poster reminding you of what you should do if you are on fire, or if you are at a dance party."
			icon_state="bsposter52"
		bay53
			name = "fire extinguisher poster"
			desc = "This is a poster reminding you of what you should use to put out a fire."
			icon_state="bsposter53"
		bay54
			name = "firefighter poster"
			desc = "This is a poster of a particularly stern looking firefighter. The caption reads, \"Only you can prevent space fires.\""
			icon_state="bsposter54"
		bay55
			name = "Earth appreciation poster"
			desc = "This is a poster produced by the Generic Space Company, as a part of a series of commemorative posters on the wonders of space. Two of three."
			icon_state="bsposter55"
		bay56
			name = "Mars appreciation poster"
			desc = "This is a poster produced by the Generic Space Company, as a part of a series of commemorative posters on the wonders of space. Three of three."
			icon_state="bsposter56"
		bay57
			name = "space carp warning poster"
			desc = "This poster tells of the dangers of space carp infestations."
			icon_state="bsposter57"
		bay58
			name = "space carp information poster"
			desc = "This poster showcases an old spacer saying on the dangers of migrant space carp."
			icon_state="bsposter58"
		bay59
			name = "Kill Catbeasts"
			desc = "This poster has large text reading \"KILL CAT BEAST\", as well as two small images of freaks of nature. The official Nanotrasen seal can be seen at the bottom."
			icon_state="bsposter59"
		lego1
			name = "Barsik"
			desc = "Barsik is watching you!"
			icon_state="legoposter1"
		lego2
			name = "Rorschach"
			desc = "The End Is Nigh!"
			icon_state="legoposter2"
		lego3
			name = "Gang Bang"
			desc = "Choose your destiny."
			icon_state="legoposter3"
		lego4
			name = "Soap"
			desc = "Oh no, I dropped the soap!"
			icon_state="legoposter4"
		lego5
			name = "Into HELL"
			desc = "Right to the fucking Hell!"
			icon_state="legoposter5"
		lego6
			name = "Russians versus Aliens"
			desc = "Final battle for humanity in new film \"Russians versus Aliens: Resurrection\"."
			icon_state="legoposter6"
		lego7
			name = "U.A.C."
			desc = "U.A.C. promise not to experiment with telescience, during which there is a portal to hell with the bloodthirsty demons."
			icon_state="legoposter7"
		lego8
			name = "Night Watch"
			desc = "All vampires will die!"
			icon_state="legoposter8"
		lego9
			name = "DooM"
			desc = "New game DooM 13 avaible now in \"PDA Store\"!"
			icon_state="legoposter9"