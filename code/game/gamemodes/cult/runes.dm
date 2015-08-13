var/list/sacrificed = list()

/obj/effect/rune/cultify()
	return

/obj/effect/rune

/*
 * Use as a general guideline for this and related files:
 *  * <span class='warning'>...</span> - when something non-trivial or an error happens, so something similar to "Sparks come out of the machine!"
 *  * <span class='danger'>...</span>  - when something that is fit for 'warning' happens but there is some damage or pain as well.
 *  * <span class='cult'>...</span>    - when there is a private message to the cultists. This guideline is very arbitrary but there has to be some consistency!
 */


/////////////////////////////////////////FIRST RUNE
	proc
		teleport(var/key)
			var/mob/living/user = usr
			var/allrunesloc[]
			allrunesloc = new/list()
			var/index = 0
		//	var/tempnum = 0
			for(var/obj/effect/rune/R in world)
				if(R == src)
					continue
				if(R.word1 == cultwords["travel"] && R.word2 == cultwords["self"] && R.word3 == key && isPlayerLevel(R.z))
					index++
					allrunesloc.len = index
					allrunesloc[index] = R.loc
			if(index >= 5)
				user << "<span class='danger'>You feel pain, as rune disappears in reality shift caused by too much wear of space-time fabric.</span>"
				if (istype(user, /mob/living))
					user.take_overall_damage(5, 0)
				qdel(src)
			if(allrunesloc && index != 0)
				if(istype(src,/obj/effect/rune))
					user.say("Sas[pick("'","`")]so c'arta forbici!")//Only you can stop auto-muting
				else
					user.whisper("Sas[pick("'","`")]so c'arta forbici!")
				user.visible_message("<span class='danger'>[user] disappears in a flash of red light!</span>", \
				"<span class='danger'>You feel as your body gets dragged through the dimension of Nar-Sie!</span>", \
				"<span class='danger'>You hear a sickening crunch and sloshing of viscera.</span>")
				user.loc = allrunesloc[rand(1,index)]
				return
			if(istype(src,/obj/effect/rune))
				return	fizzle() //Use friggin manuals, Dorf, your list was of zero length.
			else
				call(/obj/effect/rune/proc/fizzle)()
				return


		itemport(var/key)
//			var/allrunesloc[]
//			allrunesloc = new/list()
//			var/index = 0
		//	var/tempnum = 0
			var/culcount = 0
			var/runecount = 0
			var/obj/effect/rune/IP = null
			var/mob/living/user = usr
			for(var/obj/effect/rune/R in world)
				if(R == src)
					continue
				if(R.word1 == cultwords["travel"] && R.word2 == cultwords["other"] && R.word3 == key)
					IP = R
					runecount++
			if(runecount >= 2)
				user << "<span class='danger'>You feel pain, as rune disappears in reality shift caused by too much wear of space-time fabric.</span>"
				if (istype(user, /mob/living))
					user.take_overall_damage(5, 0)
				qdel(src)
			for(var/mob/living/carbon/C in orange(1,src))
				if(iscultist(C) && !C.stat)
					culcount++
			if(culcount>=3)
				user.say("Sas[pick("'","`")]so c'arta forbici tarem!")
				user.visible_message("<span class='warning'>You feel air moving from the rune - like as it was swapped with somewhere else.</span>", \
				"<span class='warning'>You feel air moving from the rune - like as it was swapped with somewhere else.</span>", \
				"<span class='warning'>You smell ozone.</span>")
				for(var/obj/O in src.loc)
					if(!O.anchored)
						O.loc = IP.loc
				for(var/mob/M in src.loc)
					M.loc = IP.loc
				return

			return fizzle()


/////////////////////////////////////////SECOND RUNE

		tomesummon()
			if(istype(src,/obj/effect/rune))
				usr.say("N[pick("'","`")]ath reth sh'yro eth d'raggathnor!")
			else
				usr.whisper("N[pick("'","`")]ath reth sh'yro eth d'raggathnor!")
			usr.visible_message("<span class='warning'>Rune disappears with a flash of red light, and in its place now a book lies.</span>", \
			"<span class='warning'>You are blinded by the flash of red light! After you're able to see again, you see that now instead of the rune there's a book.</span>", \
			"<span class='warning'>You hear a pop and smell ozone.</span>")
			if(istype(src,/obj/effect/rune))
				new /obj/item/weapon/book/tome(src.loc)
			else
				new /obj/item/weapon/book/tome(usr.loc)
			qdel(src)
			return



/////////////////////////////////////////THIRD RUNE

		convert()
			var/mob/attacker = usr
			var/mob/living/carbon/target = null
			for(var/mob/living/carbon/M in src.loc)
				if(!iscultist(M) && M.stat < DEAD && !(M in converting))
					target = M
					break

			if(!target) //didn't find any new targets
				if(!converting.len)
					fizzle()
				else
					usr << "<span class='danger'>You sense that the power of the dark one is already working away at them.</span>"
				return

			usr.say("Mah[pick("'","`")]weyh pleggh at e'ntrath!")

			converting |= target
			var/list/waiting_for_input = list(target = 0) //need to box this up in order to be able to reset it again from inside spawn, apparently
			var/initial_message = 0
			while(target in converting)
				if(target.loc != src.loc || target.stat == DEAD)
					converting -= target
					if(target.getFireLoss() < 100)
						target.hallucination = min(target.hallucination, 500)
					return 0

				target.take_overall_damage(0, rand(5, 20)) // You dirty resister cannot handle the damage to your mind. Easily. - even cultists who accept right away should experience some effects
				// Resist messages go!
				if(initial_message) //don't do this stuff right away, only if they resist or hesitate.
					admin_attack_log(attacker, target, "Used a convert rune", "Was subjected to a convert rune", "used a convert rune on")
					switch(target.getFireLoss())
						if(0 to 25)
							target << "<span class='cult'>Your blood boils as you force yourself to resist the corruption invading every corner of your mind.</span>"
						if(25 to 45)
							target << "<span class='cult'>Your blood boils and your body burns as the corruption further forces itself into your body and mind.</span>"
						if(45 to 75)
							target << "<span class='cult'>You begin to hallucinate images of a dark and incomprehensible being and your entire body feels like its engulfed in flame as your mental defenses crumble.</span>"
							target.apply_effect(rand(1,10), STUTTER)
						if(75 to 100)
							target << "<span class='cult'>Your mind turns to ash as the burning flames engulf your very soul and images of an unspeakable horror begin to bombard the last remnants of mental resistance.</span>"
							//broken mind - 5000 may seem like a lot I wanted the effect to really stand out for maxiumum losing-your-mind-spooky
							//hallucination is reduced when the step off as well, provided they haven't hit the last stage...
							target.hallucination += 5000
							target.apply_effect(10, STUTTER)
							target.adjustBrainLoss(1)
						if(100 to INFINITY)
							target << "<span class='cult'>Your entire broken soul and being is engulfed in corruption and flames as your mind shatters away into nothing.</span>"
							target.hallucination += 5000
							target.apply_effect(15, STUTTER)
							target.adjustBrainLoss(rand(1,5))

				initial_message = 1
				if (target.species && (target.species.flags & NO_PAIN))
					target.visible_message("<span class='warning'>The markings below [target] glow a bloody red.</span>")
				else
					target.visible_message("<span class='warning'>[target] writhes in pain as the markings below \him glow a bloody red.</span>", "<span class='danger'>AAAAAAHHHH!</span>", "<span class='warning'>You hear an anguished scream.</span>")

				if(!waiting_for_input[target]) //so we don't spam them with dialogs if they hesitate
					waiting_for_input[target] = 1

					if(!cult.can_become_antag(target.mind) || jobban_isbanned(target, "cultist"))//putting jobban check here because is_convertable uses mind as argument
						//waiting_for_input ensures this is only shown once, so they basically auto-resist from here on out. They still need to find a way to get off the freaking rune if they don't want to burn to death, though.
						target << "<span class='cult'>Your blood pulses. Your head throbs. The world goes red. All at once you are aware of a horrible, horrible truth. The veil of reality has been ripped away and in the festering wound left behind something sinister takes root.</span>"
						target << "<span class='danger'>And you were able to force it out of your mind. You now know the truth, there's something horrible out there, stop it and its minions at all costs.</span>"

					else spawn()
						var/choice = alert(target,"Do you want to join the cult?","Submit to Nar'Sie","Resist","Submit")
						waiting_for_input[target] = 0
						if(choice == "Submit") //choosing 'Resist' does nothing of course.
							cult.add_antagonist(target.mind)
							converting -= target
							target.hallucination = 0 //sudden clarity

				sleep(100) //proc once every 10 seconds
			return 1

/////////////////////////////////////////FOURTH RUNE

		tearreality()
			if(!cult.allow_narsie)
				return fizzle()

			var/list/cultists = new()
			for(var/mob/M in range(1,src))
				if(iscultist(M) && !M.stat)
					M.say("Tok-lyr rqa'nap g[pick("'","`")]lt-ulotf!")
					cultists += 1
			if(cultists.len >= 9)
				log_and_message_admins_many(cultists, "summoned Nar-sie.")
				new /obj/singularity/narsie/large(src.loc)
				return
			else
				return fizzle()

/////////////////////////////////////////FIFTH RUNE

		emp(var/U,var/range_red) //range_red - var which determines by which number to reduce the default emp range, U is the source loc, needed because of talisman emps which are held in hand at the moment of using and that apparently messes things up -- Urist
			log_and_message_admins("activated an EMP rune.")
			if(istype(src,/obj/effect/rune))
				usr.say("Ta'gh fara[pick("'","`")]qha fel d'amar det!")
			else
				usr.whisper("Ta'gh fara[pick("'","`")]qha fel d'amar det!")
			playsound(U, 'sound/items/Welder2.ogg', 25, 1)
			var/turf/T = get_turf(U)
			if(T)
				T.hotspot_expose(700,125)
			var/rune = src // detaching the proc - in theory
			empulse(U, (range_red - 2), range_red)
			qdel(rune)
			return

/////////////////////////////////////////SIXTH RUNE

		drain()
			var/drain = 0
			for(var/obj/effect/rune/R in world)
				if(R.word1==cultwords["travel"] && R.word2==cultwords["blood"] && R.word3==cultwords["self"])
					for(var/mob/living/carbon/D in R.loc)
						if(D.stat!=2)
							admin_attack_log(usr, D, "Used a blood drain rune.", "Was victim of a blood drain rune.", "used a blood drain rune on")
							var/bdrain = rand(1,25)
							D << "<span class='warning'>You feel weakened.</span>"
							D.take_overall_damage(bdrain, 0)
							drain += bdrain
			if(!drain)
				return fizzle()
			usr.say ("Yu[pick("'","`")]gular faras desdae. Havas mithum javara. Umathar uf'kal thenar!")
			usr.visible_message("<span class='danger'>Blood flows from the rune into [usr]!</span>", \
			"<span class='danger'>The blood starts flowing from the rune and into your frail mortal body. You feel... empowered.</span>", \
			"<span class='warning'>You hear a liquid flowing.</span>")
			var/mob/living/user = usr
			if(user.bhunger)
				user.bhunger = max(user.bhunger-2*drain,0)
			if(drain>=50)
				user.visible_message("<span class='danger'>[user]'s eyes give off eerie red glow!</span>", \
				"<span class='danger'>...but it wasn't nearly enough. You crave, crave for more. The hunger consumes you from within.</span>", \
				"<span class='warning'>You hear a heartbeat.</span>")
				user.bhunger += drain
				src = user
				spawn()
					for (,user.bhunger>0,user.bhunger--)
						sleep(50)
						user.take_overall_damage(3, 0)
				return
			user.heal_organ_damage(drain%5, 0)
			drain-=drain%5
			for (,drain>0,drain-=5)
				sleep(2)
				user.heal_organ_damage(5, 0)
			return






/////////////////////////////////////////SEVENTH RUNE

		seer()
			if(usr.loc==src.loc)
				if(usr.seer==1)
					usr.say("Rash'tla sektath mal[pick("'","`")]zua. Zasan therium viortia.")
					usr << "<span class='danger'>The world beyond fades from your vision.</span>"
					usr.see_invisible = SEE_INVISIBLE_LIVING
					usr.seer = 0
				else if(usr.see_invisible!=SEE_INVISIBLE_LIVING)
					usr << "<span class='warning'>The world beyond flashes your eyes but disappears quickly, as if something is disrupting your vision.</span>"
					usr.see_invisible = SEE_INVISIBLE_CULT
					usr.seer = 0
				else
					usr.say("Rash'tla sektath mal[pick("'","`")]zua. Zasan therium vivira. Itonis al'ra matum!")
					usr << "<span class='warning'>The world beyond opens to your eyes.</span>"
					usr.see_invisible = SEE_INVISIBLE_CULT
					usr.seer = 1
				return
			return fizzle()

/////////////////////////////////////////EIGHTH RUNE

		raise()
			var/mob/living/carbon/human/corpse_to_raise
			var/mob/living/carbon/human/body_to_sacrifice

			var/is_sacrifice_target = 0
			for(var/mob/living/carbon/human/M in src.loc)
				if(M.stat == DEAD)
					if(cult && M.mind == cult.sacrifice_target)
						is_sacrifice_target = 1
					else
						corpse_to_raise = M
						if(M.key)
							M.ghostize(1)	//kick them out of their body
						break
			if(!corpse_to_raise)
				if(is_sacrifice_target)
					usr << "<span class='warning'>The Geometer of blood wants this mortal for himself.</span>"
				return fizzle()


			is_sacrifice_target = 0
			find_sacrifice:
				for(var/obj/effect/rune/R in world)
					if(R.word1==cultwords["blood"] && R.word2==cultwords["join"] && R.word3==cultwords["hell"])
						for(var/mob/living/carbon/human/N in R.loc)
							if(cult && N.mind && N.mind == cult.sacrifice_target)
								is_sacrifice_target = 1
							else
								if(N.stat!= DEAD)
									body_to_sacrifice = N
									break find_sacrifice

			if(!body_to_sacrifice)
				if (is_sacrifice_target)
					usr << "<span class='warning'>The Geometer of Blood wants that corpse for himself.</span>"
				else
					usr << "<span class='warning'>The sacrifical corpse is not dead. You must free it from this world of illusions before it may be used.</span>"
				return fizzle()

			var/mob/dead/observer/ghost
			for(var/mob/dead/observer/O in loc)
				if(!O.client)	continue
				if(O.mind && O.mind.current && O.mind.current.stat != DEAD)	continue
				ghost = O
				break

			if(!ghost)
				usr << "<span class='warning'>You require a restless spirit which clings to this world. Beckon their prescence with the sacred chants of Nar-Sie.</span>"
				return fizzle()

			corpse_to_raise.revive()

			corpse_to_raise.key = ghost.key	//the corpse will keep its old mind! but a new player takes ownership of it (they are essentially possessed)
											//This means, should that player leave the body, the original may re-enter
			usr.say("Pasnar val'keriam usinar. Savrae ines amutan. Yam'toth remium il'tarat!")
			corpse_to_raise.visible_message("<span class='warning'>[corpse_to_raise]'s eyes glow with a faint red as he stands up, slowly starting to breathe again.</span>", \
			"<span class='warning'>Life... I'm alive again...</span>", \
			"<span class='warning'>You hear a faint, slightly familiar whisper.</span>")
			body_to_sacrifice.visible_message("<span class='danger'>[body_to_sacrifice] is torn apart, a black smoke swiftly dissipating from \his remains!</span>", \
			"<span class='danger'>You feel as your blood boils, tearing you apart.</span>", \
			"<span class='danger'>You hear a thousand voices, all crying in pain.</span>")
			body_to_sacrifice.gib()

//			if(ticker.mode.name == "cult")
//				ticker.mode:add_cultist(corpse_to_raise.mind)
//			else
//				ticker.mode.cult |= corpse_to_raise.mind

			corpse_to_raise << "<span class='cult'>Your blood pulses. Your head throbs. The world goes red. All at once you are aware of a horrible, horrible truth. The veil of reality has been ripped away and in the festering wound left behind something sinister takes root.</span>"
			corpse_to_raise << "<span class='cult'>Assist your new compatriots in their dark dealings. Their goal is yours, and yours is theirs. You serve the Dark One above all else. Bring It back.</span>"
			return





/////////////////////////////////////////NINETH RUNE

		obscure(var/rad)
			var/S=0
			for(var/obj/effect/rune/R in orange(rad,src))
				if(R!=src)
					R.invisibility=INVISIBILITY_OBSERVER
				S=1
			if(S)
				if(istype(src,/obj/effect/rune))
					usr.say("Kla[pick("'","`")]atu barada nikt'o!")
					for (var/mob/V in viewers(src))
						V.show_message("<span class='warning'>The rune turns into gray dust, veiling the surrounding runes.</span>", 3)
					qdel(src)
				else
					usr.whisper("Kla[pick("'","`")]atu barada nikt'o!")
					usr << "<span class='warning'>Your talisman turns into gray dust, veiling the surrounding runes.</span>"
					for (var/mob/V in orange(1,src))
						if(V!=usr)
							V.show_message("<span class='warning'>Dust emanates from [usr]'s hands for a moment.</span>", 3)

				return
			if(istype(src,/obj/effect/rune))
				return	fizzle()
			else
				call(/obj/effect/rune/proc/fizzle)()
				return

/////////////////////////////////////////TENTH RUNE

		ajourney() //some bits copypastaed from admin tools - Urist
			if(usr.loc==src.loc)
				var/mob/living/carbon/human/L = usr
				usr.say("Fwe[pick("'","`")]sh mah erl nyag r'ya!")
				usr.visible_message("<span class='warning'>[usr]'s eyes glow blue as \he freezes in place, absolutely motionless.</span>", \
				"<span class='warning'>The shadow that is your spirit separates itself from your body. You are now in the realm beyond. While this is a great sight, being here strains your mind and body. Hurry...</span>", \
				"<span class='warning'>You hear only complete silence for a moment.</span>")
				announce_ghost_joinleave(usr.ghostize(1), 1, "You feel that they had to use some [pick("dark", "black", "blood", "forgotten", "forbidden")] magic to [pick("invade","disturb","disrupt","infest","taint","spoil","blight")] this place!")
				L.ajourn = 1
				while(L)
					if(L.key)
						L.ajourn=0
						return
					else
						L.take_organ_damage(10, 0)
					sleep(100)
			return fizzle()




/////////////////////////////////////////ELEVENTH RUNE

		manifest()
			var/obj/effect/rune/this_rune = src
			src = null
			if(usr.loc!=this_rune.loc)
				return this_rune.fizzle()
			var/mob/dead/observer/ghost
			for(var/mob/dead/observer/O in this_rune.loc)
				if(!O.client)	continue
				if(!O.MayRespawn()) continue
				if(O.mind && O.mind.current && O.mind.current.stat != DEAD)	continue
				ghost = O
				break
			if(!ghost)
				return this_rune.fizzle()
			if(jobban_isbanned(ghost, "cultist"))
				return this_rune.fizzle()

			usr.say("Gal'h'rfikk harfrandid mud[pick("'","`")]gib!")
			var/mob/living/carbon/human/dummy/D = new(this_rune.loc)
			usr.visible_message("<span class='warning'>A shape forms in the center of the rune. A shape of... a man.</span>", \
			"<span class='warning'>A shape forms in the center of the rune. A shape of... a man.</span>", \
			"<span class='warning'>You hear liquid flowing.</span>")
			D.real_name = "Unknown"
			var/chose_name = 0
			for(var/obj/item/weapon/paper/P in this_rune.loc)
				if(P.info)
					D.real_name = copytext(P.info, findtext(P.info,">")+1, findtext(P.info,"<",2) )
					chose_name = 1
					break
			D.universal_speak = 1
			D.status_flags &= ~GODMODE
			D.s_tone = 35
			D.b_eyes = 200
			D.r_eyes = 200
			D.g_eyes = 200
			D.update_eyes()
			D.underwear = 0
			D.key = ghost.key
			cult.add_antagonist(D.mind)

			if(!chose_name)
				D.real_name = pick("Anguished", "Blasphemous", "Corrupt", "Cruel", "Depraved", "Despicable", "Disturbed", "Exacerbated", "Foul", "Hateful", "Inexorable", "Implacable", "Impure", "Malevolent", "Malignant", "Malicious", "Pained", "Profane", "Profligate", "Relentless", "Resentful", "Restless", "Spiteful", "Tormented", "Unclean", "Unforgiving", "Vengeful", "Vindictive", "Wicked", "Wronged")
				D.real_name += " "
				D.real_name += pick("Apparition", "Aptrgangr", "Dis", "Draugr", "Dybbuk", "Eidolon", "Fetch", "Fylgja", "Ghast", "Ghost", "Gjenganger", "Haint", "Phantom", "Phantasm", "Poltergeist", "Revenant", "Shade", "Shadow", "Soul", "Spectre", "Spirit", "Spook", "Visitant", "Wraith")

			log_and_message_admins("used a manifest rune.")
			var/mob/living/user = usr
			while(this_rune && user && user.stat==CONSCIOUS && user.client && user.loc==this_rune.loc)
				user.take_organ_damage(1, 0)
				sleep(30)
			if(D)
				D.visible_message("<span class='danger'>[D] slowly dissipates into dust and bones.</span>", \
				"<span class='danger'>You feel pain, as bonds formed between your soul and this homunculus break.</span>", \
				"<span class='warning'>You hear faint rustle.</span>")
				D.dust()
			return





/////////////////////////////////////////TWELFTH RUNE

		talisman()//only hide, emp, teleport, deafen, blind and tome runes can be imbued atm
			var/obj/item/weapon/paper/newtalisman
			var/unsuitable_newtalisman = 0
			for(var/obj/item/weapon/paper/P in src.loc)
				if(!P.info)
					newtalisman = P
					break
				else
					unsuitable_newtalisman = 1
			if (!newtalisman)
				if (unsuitable_newtalisman)
					usr << "<span class='warning'>The blank is tainted. It is unsuitable.</span>"
				return fizzle()

			var/obj/effect/rune/imbued_from
			var/obj/item/weapon/paper/talisman/T
			for(var/obj/effect/rune/R in orange(1,src))
				if(R==src)
					continue
				if(R.word1==cultwords["travel"] && R.word2==cultwords["self"])  //teleport
					T = new(src.loc)
					T.imbue = "[R.word3]"
					T.info = "[R.word3]"
					imbued_from = R
					break
				if(R.word1==cultwords["see"] && R.word2==cultwords["blood"] && R.word3==cultwords["hell"]) //tome
					T = new(src.loc)
					T.imbue = "newtome"
					imbued_from = R
					break
				if(R.word1==cultwords["destroy"] && R.word2==cultwords["see"] && R.word3==cultwords["technology"]) //emp
					T = new(src.loc)
					T.imbue = "emp"
					imbued_from = R
					break
				if(R.word1==cultwords["blood"] && R.word2==cultwords["see"] && R.word3==cultwords["destroy"]) //conceal
					T = new(src.loc)
					T.imbue = "conceal"
					imbued_from = R
					break
				if(R.word1==cultwords["hell"] && R.word2==cultwords["destroy"] && R.word3==cultwords["other"]) //armor
					T = new(src.loc)
					T.imbue = "armor"
					imbued_from = R
					break
				if(R.word1==cultwords["blood"] && R.word2==cultwords["see"] && R.word3==cultwords["hide"]) //reveal
					T = new(src.loc)
					T.imbue = "revealrunes"
					imbued_from = R
					break
				if(R.word1==cultwords["hide"] && R.word2==cultwords["other"] && R.word3==cultwords["see"]) //deafen
					T = new(src.loc)
					T.imbue = "deafen"
					imbued_from = R
					break
				if(R.word1==cultwords["destroy"] && R.word2==cultwords["see"] && R.word3==cultwords["other"]) //blind
					T = new(src.loc)
					T.imbue = "blind"
					imbued_from = R
					break
				if(R.word1==cultwords["self"] && R.word2==cultwords["other"] && R.word3==cultwords["technology"]) //communicat
					T = new(src.loc)
					T.imbue = "communicate"
					imbued_from = R
					break
				if(R.word1==cultwords["join"] && R.word2==cultwords["hide"] && R.word3==cultwords["technology"]) //communicat
					T = new(src.loc)
					T.imbue = "runestun"
					imbued_from = R
					break
			if (imbued_from)
				for (var/mob/V in viewers(src))
					V.show_message("<span class='warning'>The runes turn into dust, which then forms into an arcane image on the paper.</span>", 3)
				usr.say("H'drak v[pick("'","`")]loso, mir'kanas verbot!")
				qdel(imbued_from)
				qdel(newtalisman)
			else
				return fizzle()

/////////////////////////////////////////THIRTEENTH RUNE

		mend()
			var/mob/living/user = usr
			src = null
			user.say("Uhrast ka'hfa heldsagen ver[pick("'","`")]lot!")
			user.take_overall_damage(200, 0)
			runedec+=10
			user.visible_message("<span class='danger'>\The [user] keels over dead, \his blood glowing blue as it escapes \his body and dissipates into thin air.</span>", \
			"<span class='danger'>In the last moment of your humble life, you feel an immense pain as fabric of reality mends... with your blood.</span>", \
			"<span class='warning'>You hear faint rustle.</span>")
			for(,user.stat==2)
				sleep(600)
				if (!user)
					return
			runedec-=10
			return


/////////////////////////////////////////FOURTEETH RUNE

		// returns 0 if the rune is not used. returns 1 if the rune is used.
		communicate()
			. = 1 // Default output is 1. If the rune is deleted it will return 1
			var/input = input(usr, "Please choose a message to tell to the other acolytes.", "Voice of Blood", "")//sanitize() below, say() and whisper() have their own
			if(!input)
				if (istype(src))
					fizzle()
					return 0
				else
					return 0

			if(istype(src,/obj/effect/rune))
				usr.say("O bidai nabora se[pick("'","`")]sma!")
				usr.say("[input]")
			else
				usr.whisper("O bidai nabora se[pick("'","`")]sma!")
				usr.whisper("[input]")

			input = sanitize(input)
			log_and_message_admins("used a communicate rune to say '[input]'")
			for(var/datum/mind/H in cult.current_antagonists)
				if (H.current)
					H.current << "<span class='cult'>[input]</span>"
			qdel(src)
			return 1

/////////////////////////////////////////FIFTEENTH RUNE

		sacrifice()
			var/list/mob/living/carbon/human/cultsinrange = list()
			var/list/mob/living/carbon/human/victims = list()
			for(var/mob/living/carbon/human/V in src.loc)//Checks for non-cultist humans to sacrifice
				if(ishuman(V))
					if(!(iscultist(V)))
						victims += V//Checks for cult status and mob type
			for(var/obj/item/I in src.loc)//Checks for MMIs/brains/Intellicards
				if(istype(I,/obj/item/organ/brain))
					var/obj/item/organ/brain/B = I
					victims += B.brainmob
				else if(istype(I,/obj/item/device/mmi))
					var/obj/item/device/mmi/B = I
					victims += B.brainmob
				else if(istype(I,/obj/item/device/aicard))
					for(var/mob/living/silicon/ai/A in I)
						victims += A
			for(var/mob/living/carbon/C in orange(1,src))
				if(iscultist(C) && !C.stat)
					cultsinrange += C
					C.say("Barhah hra zar[pick("'","`")]garis!")

			for(var/mob/H in victims)

				var/worth = 0
				if(istype(H,/mob/living/carbon/human))
					var/mob/living/carbon/human/lamb = H
					if(lamb.species.rarity_value > 3)
						worth = 1

				if (ticker.mode.name == "cult")
					if(H.mind == cult.sacrifice_target)
						if(cultsinrange.len >= 3)
							sacrificed += H.mind
							if(isrobot(H))
								H.dust()//To prevent the MMI from remaining
							else
								H.gib()
							usr << "<span class='cult'>The Geometer of Blood accepts this sacrifice, your objective is now complete.</span>"
						else
							usr << "<span class='warning'>Your target's earthly bonds are too strong. You need more cultists to succeed in this ritual.</span>"
					else
						if(cultsinrange.len >= 3)
							if(H.stat !=2)
								if(prob(80) || worth)
									usr << "<span class='cult'>The Geometer of Blood accepts this [worth ? "exotic " : ""]sacrifice.</span>"
									cult.grant_runeword(usr)
								else
									usr << "<span class='cult'>The Geometer of Blood accepts this sacrifice.</span>"
									usr << "<span class='warning'>However, this soul was not enough to gain His favor.</span>"
								if(isrobot(H))
									H.dust()//To prevent the MMI from remaining
								else
									H.gib()
							else
								if(prob(40) || worth)
									usr << "<span class='cult'>The Geometer of Blood accepts this [worth ? "exotic " : ""]sacrifice.</span>"
									cult.grant_runeword(usr)
								else
									usr << "<span class='cult'>The Geometer of Blood accepts this sacrifice.</span>"
									usr << "<span class='warning'>However, a mere dead body is not enough to satisfy Him.</span>"
								if(isrobot(H))
									H.dust()//To prevent the MMI from remaining
								else
									H.gib()
						else
							if(H.stat !=2)
								usr << "<span class='warning'>The victim is still alive, you will need more cultists chanting for the sacrifice to succeed.</span>"
							else
								if(prob(40))

									usr << "<span class='cult'>The Geometer of Blood accepts this sacrifice.</span>"
									cult.grant_runeword(usr)
								else
									usr << "<span class='cult'>The Geometer of Blood accepts this sacrifice.</span>"
									usr << "<span class='warning'>However, a mere dead body is not enough to satisfy Him.</span>"
								if(isrobot(H))
									H.dust()//To prevent the MMI from remaining
								else
									H.gib()
				else
					if(cultsinrange.len >= 3)
						if(H.stat !=2)
							if(prob(80))
								usr << "<span class='cult'>The Geometer of Blood accepts this sacrifice.</span>"
								cult.grant_runeword(usr)
							else
								usr << "<span class='cult'>The Geometer of Blood accepts this sacrifice.</span>"
								usr << "<span class='warning'>However, this soul was not enough to gain His favor.</span>"
							if(isrobot(H))
								H.dust()//To prevent the MMI from remaining
							else
								H.gib()
						else
							if(prob(40))
								usr << "<span class='cult'>The Geometer of Blood accepts this sacrifice.</span>"
								cult.grant_runeword(usr)
							else
								usr << "<span class='cult'>The Geometer of Blood accepts this sacrifice.</span>"
								usr << "<span class='warning'>However, a mere dead body is not enough to satisfy Him.</span>"
							if(isrobot(H))
								H.dust()//To prevent the MMI from remaining
							else
								H.gib()
					else
						if(H.stat !=2)
							usr << "<span class='warning'>The victim is still alive, you will need more cultists chanting for the sacrifice to succeed.</span>"
						else
							if(prob(40))
								usr << "<span class='cult'>The Geometer of Blood accepts this sacrifice.</span>"
								cult.grant_runeword(usr)
							else
								usr << "<span class='cult'>The Geometer of Blood accepts this sacrifice.</span>"
								usr << "<span class='warning'>However, a mere dead body is not enough to satisfy Him.</span>"
							if(isrobot(H))
								H.dust()//To prevent the MMI from remaining
							else
								H.gib()

/////////////////////////////////////////SIXTEENTH RUNE

		revealrunes(var/obj/W as obj)
			var/go=0
			var/rad
			var/S=0
			if(istype(W,/obj/effect/rune))
				rad = 6
				go = 1
			if (istype(W,/obj/item/weapon/paper/talisman))
				rad = 4
				go = 1
			if (istype(W,/obj/item/weapon/nullrod))
				rad = 1
				go = 1
			if(go)
				for(var/obj/effect/rune/R in orange(rad,src))
					if(R!=src)
						R:visibility=15
					S=1
			if(S)
				if(istype(W,/obj/item/weapon/nullrod))
					usr << "<span class='warning'>Arcane markings suddenly glow from underneath a thin layer of dust!</span>"
					return
				if(istype(W,/obj/effect/rune))
					usr.say("Nikt[pick("'","`")]o barada kla'atu!")
					for (var/mob/V in viewers(src))
						V.show_message("<span class='warning'>The rune turns into red dust, reveaing the surrounding runes.</span>", 3)
					qdel(src)
					return
				if(istype(W,/obj/item/weapon/paper/talisman))
					usr.whisper("Nikt[pick("'","`")]o barada kla'atu!")
					usr << "<span class='warning'>Your talisman turns into red dust, revealing the surrounding runes.</span>"
					for (var/mob/V in orange(1,usr.loc))
						if(V!=usr)
							V.show_message("<span class='warning'>Red dust emanates from [usr]'s hands for a moment.</span>", 3)
					return
				return
			if(istype(W,/obj/effect/rune))
				return	fizzle()
			if(istype(W,/obj/item/weapon/paper/talisman))
				call(/obj/effect/rune/proc/fizzle)()
				return

/////////////////////////////////////////SEVENTEENTH RUNE

		wall()
			usr.say("Khari[pick("'","`")]d! Eske'te tannin!")
			src.density = !src.density
			var/mob/living/user = usr
			user.take_organ_damage(2, 0)
			if(src.density)
				usr << "<span class='danger'>Your blood flows into the rune, and you feel that the very space over the rune thickens.</span>"
			else
				usr << "<span class='danger'>Your blood flows into the rune, and you feel as the rune releases its grasp on space.</span>"
			return

/////////////////////////////////////////EIGHTTEENTH RUNE

		freedom()
			var/mob/living/user = usr
			var/list/mob/living/carbon/cultists = new
			for(var/datum/mind/H in cult.current_antagonists)
				if (istype(H.current,/mob/living/carbon))
					cultists+=H.current
			var/list/mob/living/carbon/users = new
			for(var/mob/living/carbon/C in orange(1,src))
				if(iscultist(C) && !C.stat)
					users+=C
			var/dam = round(15 / users.len)
			if(users.len>=3)
				var/mob/living/carbon/cultist = input("Choose the one who you want to free", "Followers of Geometer") as null|anything in (cultists - users)
				if(!cultist)
					return fizzle()
				if (cultist == user) //just to be sure.
					return
				if(!(cultist.buckled || \
					cultist.handcuffed || \
					istype(cultist.wear_mask, /obj/item/clothing/mask/muzzle) || \
					(istype(cultist.loc, /obj/structure/closet)&&cultist.loc:welded) || \
					(istype(cultist.loc, /obj/structure/closet/secure_closet)&&cultist.loc:locked) || \
					(istype(cultist.loc, /obj/machinery/dna_scannernew)&&cultist.loc:locked) \
				))
					user << "<span class='warning'>The [cultist] is already free.</span>"
					return
				cultist.buckled = null
				if (cultist.handcuffed)
					cultist.drop_from_inventory(cultist.handcuffed)
				if (cultist.legcuffed)
					cultist.drop_from_inventory(cultist.legcuffed)
				if (istype(cultist.wear_mask, /obj/item/clothing/mask/muzzle))
					cultist.drop_from_inventory(cultist.wear_mask)
				if(istype(cultist.loc, /obj/structure/closet)&&cultist.loc:welded)
					cultist.loc:welded = 0
				if(istype(cultist.loc, /obj/structure/closet/secure_closet)&&cultist.loc:locked)
					cultist.loc:locked = 0
				if(istype(cultist.loc, /obj/machinery/dna_scannernew)&&cultist.loc:locked)
					cultist.loc:locked = 0
				for(var/mob/living/carbon/C in users)
					user.take_overall_damage(dam, 0)
					C.say("Khari[pick("'","`")]d! Gual'te nikka!")
				qdel(src)
			return fizzle()

/////////////////////////////////////////NINETEENTH RUNE

		cultsummon()
			var/mob/living/user = usr
			var/list/mob/living/carbon/cultists = new
			for(var/datum/mind/H in cult.current_antagonists)
				if (istype(H.current,/mob/living/carbon))
					cultists+=H.current
			var/list/mob/living/carbon/users = new
			for(var/mob/living/carbon/C in orange(1,src))
				if(iscultist(C) && !C.stat)
					users += C
			if(users.len>=3)
				var/mob/living/carbon/cultist = input("Choose the one who you want to summon", "Followers of Geometer") as null|anything in (cultists - user)
				if(!cultist)
					return fizzle()
				if (cultist == user) //just to be sure.
					return
				if(cultist.buckled || cultist.handcuffed || (!isturf(cultist.loc) && !istype(cultist.loc, /obj/structure/closet)))
					user << "<span class='warning'>You cannot summon \the [cultist], for \his shackles of blood are strong.</span>"
					return fizzle()
				cultist.loc = src.loc
				cultist.lying = 1
				cultist.regenerate_icons()

				var/dam = round(25 / (users.len/2))	//More people around the rune less damage everyone takes. Minimum is 3 cultists

				for(var/mob/living/carbon/human/C in users)
					if(iscultist(C) && !C.stat)
						C.say("N'ath reth sh'yro eth d[pick("'","`")]rekkathnor!")
						C.take_overall_damage(dam, 0)
						if(users.len <= 4)				// You did the minimum, this is going to hurt more and we're going to stun you.
							C.apply_effect(rand(3,6), STUN)
							C.apply_effect(1, WEAKEN)
				user.visible_message("<span class='warning'>Rune disappears with a flash of red light, and in its place now a body lies.</span>", \
				"<span class='warning'>You are blinded by the flash of red light! After you're able to see again, you see that now instead of the rune there's a body.</span>", \
				"<span class='warning'>You hear a pop and smell ozone.</span>")
				qdel(src)
			return fizzle()

/////////////////////////////////////////TWENTIETH RUNES

		deafen()
			if(istype(src,/obj/effect/rune))
				var/list/affected = new()
				for(var/mob/living/carbon/C in range(7,src))
					if (iscultist(C))
						continue
					var/obj/item/weapon/nullrod/N = locate() in C
					if(N)
						continue
					C.ear_deaf += 50
					C.show_message("<span class='warning'>The world around you suddenly becomes quiet.</span>", 3)
					affected += C
					if(prob(1))
						C.sdisabilities |= DEAF
				if(affected.len)
					usr.say("Sti[pick("'","`")] kaliedir!")
					usr << "<span class='warning'>The world becomes quiet as the deafening rune dissipates into fine dust.</span>"
					admin_attacker_log_many_victims(usr, affected, "Used a deafen rune.", "Was victim of a deafen rune.", "used a deafen rune on")
					qdel(src)
				else
					return fizzle()
			else
				var/list/affected = new()
				for(var/mob/living/carbon/C in range(7,usr))
					if (iscultist(C))
						continue
					var/obj/item/weapon/nullrod/N = locate() in C
					if(N)
						continue
					C.ear_deaf += 30
					//talismans is weaker.
					C.show_message("<span class='warning'>The world around you suddenly becomes quiet.</span>", 3)
					affected += C
				if(affected.len)
					usr.whisper("Sti[pick("'","`")] kaliedir!")
					usr << "<span class='warning'>Your talisman turns into gray dust, deafening everyone around.</span>"
					admin_attacker_log_many_victims(usr, affected, "Used a deafen rune.", "Was victim of a deafen rune.", "used a deafen rune on")
					for (var/mob/V in orange(1,src))
						if(!(iscultist(V)))
							V.show_message("<span class='warning'>Dust flows from [usr]'s hands for a moment, and the world suddenly becomes quiet..</span>", 3)
			return

		blind()
			if(istype(src,/obj/effect/rune))
				var/list/affected = new()
				for(var/mob/living/carbon/C in viewers(src))
					if (iscultist(C))
						continue
					var/obj/item/weapon/nullrod/N = locate() in C
					if(N)
						continue
					C.eye_blurry += 50
					C.eye_blind += 20
					if(prob(5))
						C.disabilities |= NEARSIGHTED
						if(prob(10))
							C.sdisabilities |= BLIND
					C.show_message("<span class='warning'>Suddenly you see a red flash that blinds you.</span>", 3)
					affected += C
				if(affected.len)
					usr.say("Sti[pick("'","`")] kaliesin!")
					usr << "<span class='warning'>The rune flashes, blinding those who not follow the Nar-Sie, and dissipates into fine dust.</span>"
					admin_attacker_log_many_victims(usr, affected, "Used a blindness rune.", "Was victim of a blindness rune.", "used a blindness rune on")
					qdel(src)
				else
					return fizzle()
			else
				var/list/affected = new()
				for(var/mob/living/carbon/C in view(2,usr))
					if (iscultist(C))
						continue
					var/obj/item/weapon/nullrod/N = locate() in C
					if(N)
						continue
					C.eye_blurry += 30
					C.eye_blind += 10
					//talismans is weaker.
					affected += C
					C.show_message("<span class='warning'>You feel a sharp pain in your eyes, and the world disappears into darkness..</span>", 3)
				if(affected.len)
					usr.whisper("Sti[pick("'","`")] kaliesin!")
					usr << "<span class='warning'>Your talisman turns into gray dust, blinding those who not follow the Nar-Sie.</span>"
					admin_attacker_log_many_victims(usr, affected, "Used a blindness rune.", "Was victim of a blindness rune.", "used a blindness rune on")
			return


		bloodboil() //cultists need at least one DANGEROUS rune. Even if they're all stealthy.
/*
			var/list/mob/living/carbon/cultists = new
			for(var/datum/mind/H in ticker.mode.cult)
				if (istype(H.current,/mob/living/carbon))
					cultists+=H.current
*/
			var/list/cultists = new //also, wording for it is old wording for obscure rune, which is now hide-see-blood.
			var/list/victims = new
//			var/list/cultboil = list(cultists-usr) //and for this words are destroy-see-blood.
			for(var/mob/living/carbon/C in orange(1,src))
				if(iscultist(C) && !C.stat)
					cultists+=C
			if(cultists.len>=3)
				for(var/mob/living/carbon/M in viewers(usr))
					if(iscultist(M))
						continue
					var/obj/item/weapon/nullrod/N = locate() in M
					if(N)
						continue
					M.take_overall_damage(51,51)
					M << "<span class='danger'>Your blood boils!</span>"
					victims += M
					if(prob(5))
						spawn(5)
							M.gib()
				for(var/obj/effect/rune/R in view(src))
					if(prob(10))
						explosion(R.loc, -1, 0, 1, 5)
				for(var/mob/living/carbon/human/C in orange(1,src))
					if(iscultist(C) && !C.stat)
						C.say("Dedo ol[pick("'","`")]btoh!")
						C.take_overall_damage(15, 0)
				admin_attacker_log_many_victims(usr, victims, "Used a blood boil rune.", "Was the victim of a blood boil rune.", "used a blood boil rune on")
				log_and_message_admins_many(cultists - usr, "assisted activating a blood boil rune.")
				qdel(src)
			else
				return fizzle()
			return

// WIP rune, I'll wait for Rastaf0 to add limited blood.

		burningblood()
			var/culcount = 0
			for(var/mob/living/carbon/C in orange(1,src))
				if(iscultist(C) && !C.stat)
					culcount++
			if(culcount >= 5)
				for(var/obj/effect/rune/R in world)
					if(R.blood_DNA == src.blood_DNA)
						for(var/mob/living/M in orange(2,R))
							M.take_overall_damage(0,15)
							if (R.invisibility>M.see_invisible)
								M << "<span class='danger'>Aargh it burns!</span>"
							else
								M << "<span class='danger'>Rune suddenly ignites, burning you!</span>"
							var/turf/T = get_turf(R)
							T.hotspot_expose(700,125)
				for(var/obj/effect/decal/cleanable/blood/B in world)
					if(B.blood_DNA == src.blood_DNA)
						for(var/mob/living/M in orange(1,B))
							M.take_overall_damage(0,5)
							M << "<span class='danger'>Blood suddenly ignites, burning you!</span>"
							var/turf/T = get_turf(B)
							T.hotspot_expose(700,125)
							qdel(B)
				qdel(src)

//////////             Rune 24 (counting burningblood, which kinda doesnt work yet.)

		runestun(var/mob/living/T as mob)
			if(istype(src,/obj/effect/rune))   ///When invoked as rune, flash and stun everyone around.
				usr.say("Fuu ma[pick("'","`")]jin!")
				for(var/mob/living/L in viewers(src))
					if(iscarbon(L))
						var/mob/living/carbon/C = L
						flick("e_flash", C.flash)
						if(C.stuttering < 1 && (!(HULK in C.mutations)))
							C.stuttering = 1
						C.Weaken(1)
						C.Stun(1)
						C.show_message("<span class='danger'>The rune explodes in a bright flash.</span>", 3)
						admin_attack_log(usr, C, "Used a stun rune.", "Was victim of a stun rune.", "used a stun rune on")

					else if(issilicon(L))
						var/mob/living/silicon/S = L
						S.Weaken(5)
						S.show_message("<span class='danger'>BZZZT... The rune has exploded in a bright flash.</span>", 3)
						admin_attack_log(usr, S, "Used a stun rune.", "Was victim of a stun rune.", "used a stun rune on")
				qdel(src)
			else                        ///When invoked as talisman, stun and mute the target mob.
				usr.say("Dream sign ''Evil sealing talisman'[pick("'","`")]!")
				var/obj/item/weapon/nullrod/N = locate() in T
				if(N)
					for(var/mob/O in viewers(T, null))
						O.show_message(text("<span class='warning'><B>[] invokes a talisman at [], but they are unaffected!</B></span>", usr, T), 1)
				else
					for(var/mob/O in viewers(T, null))
						O.show_message(text("<span class='warning'><B>[] invokes a talisman at []</B></span>", usr, T), 1)

					if(issilicon(T))
						T.Weaken(15)
						admin_attack_log(usr, T, "Used a stun rune.", "Was victim of a stun rune.", "used a stun rune on")
					else if(iscarbon(T))
						var/mob/living/carbon/C = T
						flick("e_flash", C.flash)
						if (!(HULK in C.mutations))
							C.silent += 15
						C.Weaken(25)
						C.Stun(25)
						admin_attack_log(usr, C, "Used a stun rune.", "Was victim of a stun rune.", "used a stun rune on")
				return

/////////////////////////////////////////TWENTY-FIFTH RUNE

		armor()
			var/mob/living/carbon/human/user = usr
			if(istype(src,/obj/effect/rune))
				usr.say("N'ath reth sh'yro eth d[pick("'","`")]raggathnor!")
			else
				usr.whisper("N'ath reth sh'yro eth d[pick("'","`")]raggathnor!")
			usr.visible_message("<span class='warning'>The rune disappears with a flash of red light, and a set of armor appears on [usr]...</span>", \
			"<span class='warning'>You are blinded by the flash of red light! After you're able to see again, you see that you are now wearing a set of armor.</span>")

			user.equip_to_slot_or_del(new /obj/item/clothing/head/culthood/alt(user), slot_head)
			user.equip_to_slot_or_del(new /obj/item/clothing/suit/cultrobes/alt(user), slot_wear_suit)
			user.equip_to_slot_or_del(new /obj/item/clothing/shoes/cult(user), slot_shoes)
			user.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/cultpack(user), slot_back)
			//the above update their overlay icons cache but do not call update_icons()
			//the below calls update_icons() at the end, which will update overlay icons by using the (now updated) cache
			user.put_in_hands(new /obj/item/weapon/melee/cultblade(user))	//put in hands or on floor

			qdel(src)
			return
