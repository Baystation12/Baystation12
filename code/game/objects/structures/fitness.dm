/obj/structure/fitness
	icon = 'icons/obj/stationobjs.dmi'
	anchored = 1
	var/being_used = 0

/obj/structure/fitness/punchingbag
	name = "punching bag"
	desc = "A punching bag."
	icon_state = "punchingbag"
	density = 1
	var/list/hit_message = list("hit", "punch", "kick", "robust")

/obj/structure/fitness/punchingbag/attack_hand(var/mob/living/carbon/human/user)
	if(!istype(user))
		..()
		return
	if(user.nutrition < 20)
		to_chat(user, "<span class='warning'>You need more energy to use the punching bag. Go eat something.</span>")
	else
		if(user.a_intent == I_HURT)
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			flick("[icon_state]_hit", src)
			playsound(src.loc, 'sound/effects/woodhit.ogg', 25, 1, -1)
			user.do_attack_animation(src)
			user.nutrition = user.nutrition - 5
			to_chat(user, "<span class='warning'>You [pick(hit_message)] \the [src].</span>")

/obj/structure/fitness/weightlifter
	name = "weightlifting machine"
	desc = "A machine used to lift weights."
	icon_state = "weightlifter"
	var/weight = 1
	var/list/qualifiers = list("with ease", "without any trouble", "with great effort")

/obj/structure/fitness/weightlifter/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(isWrench(W))
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 75, 1)
		weight = ((weight) % qualifiers.len) + 1
		to_chat(user, "You set the machine's weight level to [weight].")

/obj/structure/fitness/weightlifter/attack_hand(var/mob/living/carbon/human/user)
	if(!istype(user))
		return
	if(user.loc != src.loc)
		to_chat(user, "<span class='warning'>You must be on the weight machine to use it.</span>")
		return
	if(user.nutrition < 50)
		to_chat(user, "<span class='warning'>You need more energy to lift weights. Go eat something.</span>")
		return
	if(being_used)
		to_chat(user, "<span class='warning'>The weight machine is already in use by somebody else.</span>")
		return
	else
		being_used = 1
		playsound(src.loc, 'sound/effects/weightlifter.ogg', 50, 1)
		user.set_dir(SOUTH)
		flick("[icon_state]_[weight]", src)
		if(do_after(user, 20 + (weight * 10)))
			playsound(src.loc, 'sound/effects/weightdrop.ogg', 25, 1)
			user.nutrition -= weight * 10
			to_chat(user, "<span class='notice'>You lift the weights [qualifiers[weight]].</span>")
			being_used = 0
		else
			to_chat(user, "<span class='notice'>Against your previous judgement, perhaps working out is not for you.</span>")
			being_used = 0
