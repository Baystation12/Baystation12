/obj/screen/movable/ability_master/changeling/sting/false_armblade
	name = "False Armblade Sting"
	desc = "We silently sting a human, injecting a retrovirus that mutates their arm to temporarily appear as an armblade."
	helptext = "The victim will form an armblade much like a changeling would, except the armblade is dull and useless."
	sting_icon = "sting_armblade"
	chemical_cost = 20
	dna_cost = 1

/obj/item/melee/arm_blade/false
	desc = "A grotesque mass of flesh that used to be your arm. Although it looks dangerous at first, you can tell it's actually quite dull and useless."
	force = 5 //Basically as strong as a punch
	fake = TRUE

/obj/screen/movable/ability_master/changeling/sting/false_armblade/can_sting(mob/user, mob/target)
	if(!..())
		return
	if(isliving(target))
		var/mob/living/L = target
		if((MUTATION_HUSK in L.mutations) || !L.has_dna())
			to_chat(user, "<span class='warning'>Our sting appears ineffective against its DNA.</span>")
			return 0
	return 1

/obj/screen/movable/ability_master/changeling/sting/false_armblade/sting_action(mob/user, mob/target)
	add_logs(user, target, "stung", object="false armblade sting")

	var/obj/item/held = target.get_active_held_item()
	if(held && !target.dropItemToGround(held))
		to_chat(user, "<span class='warning'>[held] is stuck to [target.p_their()] hand, you cannot grow a false armblade over it!</span>")
		return

	if(islesserform(target))
		to_chat(user, "<span class='notice'>Our genes cry out as we sting [target.name]!</span>")

	var/obj/item/melee/arm_blade/false/blade = new(target,1)
	target.put_in_hands(blade)
	target.visible_message("<span class='warning'>A grotesque blade forms around [target.name]\'s arm!</span>", "<span class='userdanger'>Your arm twists and mutates, transforming into a horrific monstrosity!</span>", "<span class='italics'>You hear organic matter ripping and tearing!</span>")
	playsound(target, 'sound/effects/blobattack.ogg', 30, 1)

	addtimer(CALLBACK(src, .proc/remove_fake, target, blade), 600)
	return TRUE

/obj/screen/movable/ability_master/changeling/sting/false_armblade/proc/remove_fake(mob/target, obj/item/melee/arm_blade/false/blade)
	playsound(target, 'sound/effects/blobattack.ogg', 30, 1)
	target.visible_message("<span class='warning'>With a sickening crunch, \
	[target] reforms [target.p_their()] [blade.name] into an arm!</span>",
	"<span class='warning'>[blade] reforms back to normal.</span>",
	"<span class='italic'>You hear organic matter ripping and tearing!</span>")

	qdel(blade)
	target.update_inv_hands()
