/mob/living/simple_animal/hostile/retaliate/goose
	name = "goose"
	desc = "A large waterfowl, known for its beauty and quick temper when provoked."
	icon = 'icons/mob/simple_animal/goose.dmi'
	icon_state = "goose"
	icon_living = "goose"
	icon_dead = "goose_dead"
	speak_emote = list("honks")
	response_help =  "pets"
	response_disarm = "gently pushes aside"
	response_harm = "strikes"
	health = 45
	maxHealth = 45
	natural_weapon = /obj/item/natural_weapon/goosefeet
	pass_flags = PASS_FLAG_TABLE
	faction = "geese"
	pry_time = 8 SECONDS
	break_stuff_probability = 5

	meat_type = /obj/item/reagent_containers/food/snacks/meat/chicken/game
	meat_amount = 6
	bone_amount = 8
	skin_amount = 8
	skin_material = MATERIAL_SKIN_FEATHERS

	var/enrage_potency = 3
	var/enrage_potency_loose = 4
	var/loose_threshold = 15
	var/max_damage = 22
	var/loose = FALSE //goose loose status

	ai_holder = /datum/ai_holder/simple_animal/retaliate/goose
	say_list_type = /datum/say_list/goose


/datum/ai_holder/simple_animal/retaliate/goose/react_to_attack(atom/movable/attacker)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/goose/G = holder
	if(G.stat == CONSCIOUS)
		G.enrage(G.enrage_potency)

/obj/item/natural_weapon/goosefeet
	name = "goose feet"
	gender = PLURAL
	attack_verb = list("smacked around")
	force = 0
	damtype = DAMAGE_BRUTE
	canremove = FALSE

/mob/living/simple_animal/hostile/retaliate/goose/on_update_icon()
	if(stat == DEAD)
		icon_state = icon_dead
	else if(loose)
		icon_state = "goose_loose"
		icon_living = "goose_loose"

/mob/living/simple_animal/hostile/retaliate/goose/death(gibbed, deathmessage, show_dead_message)
	. = ..()
	update_icon()

/mob/living/simple_animal/hostile/retaliate/goose/proc/enrage(var/potency)
	var/obj/item/W = get_natural_weapon()
	if(W)
		W.force = min((W.force + potency), max_damage)
	if(!loose && prob(25) && (W && W.force >= loose_threshold)) //second wind
		loose = TRUE
		health = (initial(health) * 1.5)
		maxHealth = (initial(maxHealth) * 1.5)
		enrage_potency = enrage_potency_loose
		desc += " The [name] is loose! Oh no!"
		update_icon()

/mob/living/simple_animal/hostile/retaliate/goose/dire
	name = "dire goose"
	desc = "A large bird. It radiates destructive energy."
	icon_state = "dire"
	icon_living = "dire"
	icon_dead = "dire_dead"
	health = 250
	maxHealth = 250
	enrage_potency = 3
	loose_threshold = 20
	max_damage = 35
	skull_type = /obj/item/pen/fancy/quill

/mob/living/simple_animal/hostile/retaliate/goose/doctor
	name = "\improper Dr. Anatidae"
	desc = "A large waterfowl, known for its beauty and quick temper when provoked. This one has a nametag, 'Dr. Anatidae'. What an odd Pet.."
	icon_state = "goose_labcoat"
	icon_living = "goose_labcoat"
	icon_dead = "goose_labcoat_dead"

/datum/say_list/goose
	speak = list("Honk!")
	emote_hear = list("honks","flaps its wings","clacks")
	emote_see = list("flaps its wings", "scratches the ground")
