/obj/item/weapon/dnainjector
	name = "\improper DNA injector"
	desc = "This injects the person with DNA."
	icon = 'icons/obj/items.dmi'
	icon_state = "dnainjector"
	var/block=0
	var/datum/dna2/record/buf=null
	var/s_time = 10.0
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	var/uses = 1
	var/nofail
	var/is_bullet = 0
	var/inuse = 0

	// USE ONLY IN PREMADE SYRINGES.  WILL NOT WORK OTHERWISE.
	var/datatype=0
	var/value=0

/obj/item/weapon/dnainjector/New()
	if(datatype && block)
		buf=new
		buf.dna=new
		buf.types = datatype
		buf.dna.ResetSE()
		//testing("[name]: DNA2 SE blocks prior to SetValue: [english_list(buf.dna.SE)]")
		SetValue(src.value)
		//testing("[name]: DNA2 SE blocks after SetValue: [english_list(buf.dna.SE)]")

/obj/item/weapon/dnainjector/proc/GetRealBlock(var/selblock)
	if(selblock==0)
		return block
	else
		return selblock

/obj/item/weapon/dnainjector/proc/GetState(var/selblock=0)
	var/real_block=GetRealBlock(selblock)
	if(buf.types&DNA2_BUF_SE)
		return buf.dna.GetSEState(real_block)
	else
		return buf.dna.GetUIState(real_block)

/obj/item/weapon/dnainjector/proc/SetState(var/on, var/selblock=0)
	var/real_block=GetRealBlock(selblock)
	if(buf.types&DNA2_BUF_SE)
		return buf.dna.SetSEState(real_block,on)
	else
		return buf.dna.SetUIState(real_block,on)

/obj/item/weapon/dnainjector/proc/GetValue(var/selblock=0)
	var/real_block=GetRealBlock(selblock)
	if(buf.types&DNA2_BUF_SE)
		return buf.dna.GetSEValue(real_block)
	else
		return buf.dna.GetUIValue(real_block)

/obj/item/weapon/dnainjector/proc/SetValue(var/val,var/selblock=0)
	var/real_block=GetRealBlock(selblock)
	if(buf.types&DNA2_BUF_SE)
		return buf.dna.SetSEValue(real_block,val)
	else
		return buf.dna.SetUIValue(real_block,val)

/obj/item/weapon/dnainjector/proc/inject(mob/M as mob, mob/user as mob)
	if(istype(M,/mob/living))
		var/mob/living/L = M
		L.apply_effect(rand(5,20), IRRADIATE, blocked = 0)

	if (!(NOCLONE in M.mutations)) // prevents drained people from having their DNA changed
		if (buf.types & DNA2_BUF_UI)
			if (!block) //isolated block?
				M.UpdateAppearance(buf.dna.UI.Copy())
				if (buf.types & DNA2_BUF_UE) //unique enzymes? yes
					M.real_name = buf.dna.real_name
					M.name = buf.dna.real_name
				uses--
			else
				M.dna.SetUIValue(block,src.GetValue())
				M.UpdateAppearance()
				uses--
		if (buf.types & DNA2_BUF_SE)
			if (!block) //isolated block?
				M.dna.SE = buf.dna.SE.Copy()
				M.dna.UpdateSE()
			else
				M.dna.SetSEValue(block,src.GetValue())
			domutcheck(M, null, block!=null)
			uses--
			if(prob(5))
				trigger_side_effect(M)

	spawn(0)//this prevents the collapse of space-time continuum
		if (user)
			user.drop_from_inventory(src)
		qdel(src)
	return uses

/obj/item/weapon/dnainjector/attack(mob/M as mob, mob/user as mob)
	if (!istype(M, /mob))
		return
	if (!usr.IsAdvancedToolUser())
		return
	if(inuse)
		return 0

	user.visible_message("<span class='danger'>\The [user] is trying to inject \the [M] with \the [src]!</span>")
	inuse = 1
	s_time = world.time
	spawn(50)
		inuse = 0

	if(!do_after(user,50,M))
		return

	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user.do_attack_animation(M)

	M.visible_message("<span class='danger'>\The [M] has been injected with \the [src] by \the [user].</span>")

	var/mob/living/carbon/human/H = M
	if(!istype(H))
		to_chat(user, "<span class='warning'>Apparently it didn't work...</span>")
		return

	// Used by admin log.
	var/injected_with_monkey = ""
	if((buf.types & DNA2_BUF_SE) && (block ? (GetState() && block == MONKEYBLOCK) : GetState(MONKEYBLOCK)))
		injected_with_monkey = " <span class='danger'>(MONKEY)</span>"
	admin_attack_log(user, M, "Injected using \the [src]", "Has been injected with \the [src]", "used \the [src][injected_with_monkey] to inject into")

	// Apply the DNA shit.
	inject(M, user)
	return

/obj/item/weapon/dnainjector/hulkmut
	name = "\improper DNA injector (Hulk)"
	desc = "This will make you big and strong, but give you a bad skin condition."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2
	New()
		block = HULKBLOCK
		..()

/obj/item/weapon/dnainjector/antihulk
	name = "\improper DNA injector (Anti-Hulk)"
	desc = "Cures green skin."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2
	New()
		block = HULKBLOCK
		..()

/obj/item/weapon/dnainjector/xraymut
	name = "\improper DNA injector (Xray)"
	desc = "Finally you can see what the Captain does."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 8
	New()
		block = XRAYBLOCK
		..()

/obj/item/weapon/dnainjector/antixray
	name = "\improper DNA injector (Anti-Xray)"
	desc = "It will make you see harder."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 8
	New()
		block = XRAYBLOCK
		..()

/obj/item/weapon/dnainjector/firemut
	name = "\improper DNA injector (Fire)"
	desc = "Gives you fire."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 10
	New()
		block = FIREBLOCK
		..()

/obj/item/weapon/dnainjector/antifire
	name = "\improper DNA injector (Anti-Fire)"
	desc = "Cures fire."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 10
	New()
		block = FIREBLOCK
		..()

/obj/item/weapon/dnainjector/telemut
	name = "\improper DNA injector (Tele.)"
	desc = "Super brain man!"
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 12
	New()
		block = TELEBLOCK
		..()

/obj/item/weapon/dnainjector/antitele
	name = "\improper DNA injector (Anti-Tele.)"
	desc = "Will make you not able to control your mind."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 12
	New()
		block = TELEBLOCK
		..()

/obj/item/weapon/dnainjector/nobreath
	name = "\improper DNA injector (No Breath)"
	desc = "Hold your breath and count to infinity."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2
	New()
		block = NOBREATHBLOCK
		..()

/obj/item/weapon/dnainjector/antinobreath
	name = "\improper DNA injector (Anti-No Breath)"
	desc = "Hold your breath and count to 100."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2
	New()
		block = NOBREATHBLOCK
		..()

/obj/item/weapon/dnainjector/remoteview
	name = "\improper DNA injector (Remote View)"
	desc = "Stare into the distance for a reason."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2
	New()
		block = REMOTEVIEWBLOCK
		..()

/obj/item/weapon/dnainjector/antiremoteview
	name = "\improper DNA injector (Anti-Remote View)"
	desc = "Cures green skin."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2
	New()
		block = REMOTEVIEWBLOCK
		..()

/obj/item/weapon/dnainjector/regenerate
	name = "\improper DNA injector (Regeneration)"
	desc = "Healthy but hungry."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2
	New()
		block = REGENERATEBLOCK
		..()

/obj/item/weapon/dnainjector/antiregenerate
	name = "\improper DNA injector (Anti-Regeneration)"
	desc = "Sickly but sated."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2
	New()
		block = REGENERATEBLOCK
		..()

/obj/item/weapon/dnainjector/runfast
	name = "\improper DNA injector (Increase Run)"
	desc = "Running Man."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2
	New()
		block = INCREASERUNBLOCK
		..()

/obj/item/weapon/dnainjector/antirunfast
	name = "\improper DNA injector (Anti-Increase Run)"
	desc = "Walking Man."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2
	New()
		block = INCREASERUNBLOCK
		..()

/obj/item/weapon/dnainjector/morph
	name = "\improper DNA injector (Morph)"
	desc = "A total makeover."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2
	New()
		block = MORPHBLOCK
		..()

/obj/item/weapon/dnainjector/antimorph
	name = "\improper DNA injector (Anti-Morph)"
	desc = "Cures identity crisis."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2
	New()
		block = MORPHBLOCK
		..()

/* No COLDBLOCK on bay
/obj/item/weapon/dnainjector/cold
	name = "\improper DNA injector (Cold)"
	desc = "Feels a bit chilly."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2
	New()
		block = COLDBLOCK
		..()

/obj/item/weapon/dnainjector/anticold
	name = "\improper DNA injector (Anti-Cold)"
	desc = "Feels room-temperature."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2
	New()
		block = COLDBLOCK
		..()
*/

/obj/item/weapon/dnainjector/noprints
	name = "\improper DNA injector (No Prints)"
	desc = "Better than a pair of budget insulated gloves."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2
	New()
		block = NOPRINTSBLOCK
		..()

/obj/item/weapon/dnainjector/antinoprints
	name = "\improper DNA injector (Anti-No Prints)"
	desc = "Not quite as good as a pair of budget insulated gloves."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2
	New()
		block = NOPRINTSBLOCK
		..()

/obj/item/weapon/dnainjector/insulation
	name = "\improper DNA injector (Shock Immunity)"
	desc = "Better than a pair of real insulated gloves."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2
	New()
		block = SHOCKIMMUNITYBLOCK
		..()

/obj/item/weapon/dnainjector/antiinsulation
	name = "\improper DNA injector (Anti-Shock Immunity)"
	desc = "Not quite as good as a pair of real insulated gloves."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2
	New()
		block = SHOCKIMMUNITYBLOCK
		..()

/obj/item/weapon/dnainjector/midgit
	name = "\improper DNA injector (Small Size)"
	desc = "Makes you shrink."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2
	New()
		block = SMALLSIZEBLOCK
		..()

/obj/item/weapon/dnainjector/antimidgit
	name = "\improper DNA injector (Anti-Small Size)"
	desc = "Makes you grow. But not too much."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2
	New()
		block = SMALLSIZEBLOCK
		..()

/////////////////////////////////////
/obj/item/weapon/dnainjector/antiglasses
	name = "\improper DNA injector (Anti-Glasses)"
	desc = "Toss away those glasses!"
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 1
	New()
		block = GLASSESBLOCK
		..()

/obj/item/weapon/dnainjector/glassesmut
	name = "\improper DNA injector (Glasses)"
	desc = "Will make you need dorkish glasses."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 1
	New()
		block = GLASSESBLOCK
		..()

/obj/item/weapon/dnainjector/epimut
	name = "\improper DNA injector (Epi.)"
	desc = "Shake shake shake the room!"
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 3
	New()
		block = HEADACHEBLOCK
		..()

/obj/item/weapon/dnainjector/antiepi
	name = "\improper DNA injector (Anti-Epi.)"
	desc = "Will fix you up from shaking the room."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 3
	New()
		block = HEADACHEBLOCK
		..()

/obj/item/weapon/dnainjector/anticough
	name = "\improper DNA injector (Anti-Cough)"
	desc = "Will stop that awful noise."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 5
	New()
		block = COUGHBLOCK
		..()

/obj/item/weapon/dnainjector/coughmut
	name = "\improper DNA injector (Cough)"
	desc = "Will bring forth a sound of horror from your throat."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 5
	New()
		block = COUGHBLOCK
		..()

/obj/item/weapon/dnainjector/clumsymut
	name = "\improper DNA injector (Clumsy)"
	desc = "Makes clumsy minions."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 6
	New()
		block = CLUMSYBLOCK
		..()

/obj/item/weapon/dnainjector/anticlumsy
	name = "\improper DNA injector (Anti-Clumy)"
	desc = "Cleans up confusion."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 6
	New()
		block = CLUMSYBLOCK
		..()

/obj/item/weapon/dnainjector/antitour
	name = "\improper DNA injector (Anti-Tour.)"
	desc = "Will cure tourrets."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 7
	New()
		block = TWITCHBLOCK
		..()

/obj/item/weapon/dnainjector/tourmut
	name = "\improper DNA injector (Tour.)"
	desc = "Gives you a nasty case off tourrets."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 7
	New()
		block = TWITCHBLOCK
		..()

/obj/item/weapon/dnainjector/stuttmut
	name = "\improper DNA injector (Stutt.)"
	desc = "Makes you s-s-stuttterrr."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 9
	New()
		block = NERVOUSBLOCK
		..()

/obj/item/weapon/dnainjector/antistutt
	name = "\improper DNA injector (Anti-Stutt.)"
	desc = "Fixes that speaking impairment."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 9
	New()
		block = NERVOUSBLOCK
		..()

/obj/item/weapon/dnainjector/blindmut
	name = "\improper DNA injector (Blind)"
	desc = "Makes you not see anything."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 11
	New()
		block = BLINDBLOCK
		..()

/obj/item/weapon/dnainjector/antiblind
	name = "\improper DNA injector (Anti-Blind)"
	desc = "ITS A MIRACLE!!!"
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 11
	New()
		block = BLINDBLOCK
		..()

/obj/item/weapon/dnainjector/deafmut
	name = "\improper DNA injector (Deaf)"
	desc = "Sorry, what did you say?"
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 13
	New()
		block = DEAFBLOCK
		..()

/obj/item/weapon/dnainjector/antideaf
	name = "\improper DNA injector (Anti-Deaf)"
	desc = "Will make you hear once more."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 13
	New()
		block = DEAFBLOCK
		..()

/obj/item/weapon/dnainjector/hallucination
	name = "\improper DNA injector (Halluctination)"
	desc = "What you see isn't always what you get."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2
	New()
		block = HALLUCINATIONBLOCK
		..()

/obj/item/weapon/dnainjector/antihallucination
	name = "\improper DNA injector (Anti-Hallucination)"
	desc = "What you see is what you get."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2
	New()
		block = HALLUCINATIONBLOCK
		..()

/obj/item/weapon/dnainjector/h2m
	name = "\improper DNA injector (Human > Monkey)"
	desc = "Will make you a flea bag."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 14
	New()
		block = MONKEYBLOCK
		..()

/obj/item/weapon/dnainjector/m2h
	name = "\improper DNA injector (Monkey > Human)"
	desc = "Will make you...less hairy."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 14
	New()
		block = MONKEYBLOCK
		..()
