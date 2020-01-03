///////////////////////////////////
// POWERS
///////////////////////////////////

/datum/dna/gene/basic/nobreath
	name="No Breathing"
	activation_messages=list("You feel no need to breathe.")
	mutation=mNobreath

/datum/dna/gene/basic/nobreath/New()
	..()
	block=GLOB.NOBREATHBLOCK

/datum/dna/gene/basic/remoteview
	name="Remote Viewing"
	activation_messages=list("Your mind expands.")
	mutation=mRemote

/datum/dna/gene/basic/remoteview/New()
	..()
	block=GLOB.REMOTEVIEWBLOCK

/datum/dna/gene/basic/remoteview/activate(var/mob/M, var/connected, var/flags)
	..(M,connected,flags)
	M.verbs += /mob/living/carbon/human/proc/remoteobserve

/datum/dna/gene/basic/regenerate
	name="Regenerate"
	activation_messages=list("You feel better.")
	mutation=mRegen

/datum/dna/gene/basic/regenerate/New()
	..()
	block=GLOB.REGENERATEBLOCK

/datum/dna/gene/basic/regenerate
	name="Super Speed"
	activation_messages=list("Your leg muscles pulsate.")
	mutation=mRun

/datum/dna/gene/basic/nobreath/New()
	..()
	block=GLOB.INCREASERUNBLOCK

/datum/dna/gene/basic/remotetalk
	name="Telepathy"
	activation_messages=list("You expand your mind outwards.")
	mutation=mRemotetalk

/datum/dna/gene/basic/remotetalk/New()
	..()
	block=GLOB.REMOTETALKBLOCK

/datum/dna/gene/basic/remotetalk/activate(var/mob/M, var/connected, var/flags)
	..(M,connected,flags)
	M.verbs += /mob/living/carbon/human/proc/remotesay

/datum/dna/gene/basic/morph
	name="Morph"
	activation_messages=list("Your skin feels strange.")
	mutation=mMorph

/datum/dna/gene/basic/morph/New()
	..()
	block=GLOB.MORPHBLOCK

/datum/dna/gene/basic/morph/activate(var/mob/M)
	..(M)
	M.verbs += /mob/living/carbon/human/proc/morph

/datum/dna/gene/basic/cold_resist
	name="Cold Resistance"
	activation_messages=list("Your body is filled with warmth.")
	mutation=MUTATION_COLD_RESISTANCE

/datum/dna/gene/basic/cold_resist/New()
	..()
	block=GLOB.FIREBLOCK

/datum/dna/gene/basic/cold_resist/can_activate(var/mob/M,var/flags)
	if(flags & MUTCHK_FORCED)
		return 1
	//	return !(/datum/dna/gene/basic/heat_resist in M.active_genes)
	// Probability check
	var/_prob=30
	//if(mHeatres in M.mutations)
	//	_prob=5
	if(probinj(_prob,(flags&MUTCHK_FORCED)))
		return 1

/datum/dna/gene/basic/cold_resist/OnDrawUnderlays(var/mob/M,var/g,var/fat)
	return "fire[fat]_s"

/datum/dna/gene/basic/noprints
	name="No Prints"
	activation_messages=list("Your fingers feel numb.")
	mutation=mFingerprints

/datum/dna/gene/basic/noprints/New()
	..()
	block=GLOB.NOPRINTSBLOCK

/datum/dna/gene/basic/noshock
	name="Shock Immunity"
	activation_messages=list("Your skin feels strange.")
	mutation=mShock

/datum/dna/gene/basic/noshock/New()
	..()
	block=GLOB.SHOCKIMMUNITYBLOCK

/datum/dna/gene/basic/midget
	name="Midget"
	activation_messages=list("Your skin feels rubbery.")
	mutation=mSmallsize

/datum/dna/gene/basic/midget/New()
	..()
	block=GLOB.SMALLSIZEBLOCK

/datum/dna/gene/basic/midget/can_activate(var/mob/M,var/flags)
	// Can't be big and small.
	if(MUTATION_HULK in M.mutations)
		return 0
	return ..(M,flags)

/datum/dna/gene/basic/midget/activate(var/mob/M, var/connected, var/flags)
	..(M,connected,flags)
	M.pass_flags |= 1

/datum/dna/gene/basic/midget/deactivate(var/mob/M, var/connected, var/flags)
	..(M,connected,flags)
	M.pass_flags &= ~PASS_FLAG_TABLE

/datum/dna/gene/basic/hulk
	name="Hulk"
	activation_messages=list("Your muscles hurt.")
	mutation=MUTATION_HULK

/datum/dna/gene/basic/hulk/New()
	..()
	block=GLOB.HULKBLOCK

/datum/dna/gene/basic/hulk/can_activate(var/mob/M,var/flags)
	// Can't be big and small.
	if(mSmallsize in M.mutations)
		return 0
	return ..(M,flags)

/datum/dna/gene/basic/hulk/OnDrawUnderlays(var/mob/M,var/g,var/fat)
	if(fat)
		return "hulk_[fat]_s"
	else
		return "hulk_[g]_s"
	return 0

/datum/dna/gene/basic/hulk/OnMobLife(var/mob/living/carbon/human/M)
	if(!istype(M)) return
	if(M.health <= 25)
		M.mutations.Remove(MUTATION_HULK)
		M.update_mutations()		//update our mutation overlays
		to_chat(M, "<span class='warning'>You suddenly feel very weak.</span>")
		M.Weaken(3)
		M.emote("collapse")

/datum/dna/gene/basic/xray
	name="X-Ray Vision"
	activation_messages=list("The walls suddenly disappear.")
	mutation=MUTATION_XRAY

/datum/dna/gene/basic/xray/New()
	..()
	block=GLOB.XRAYBLOCK
