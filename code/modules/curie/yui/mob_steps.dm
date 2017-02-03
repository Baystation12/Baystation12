/proc/isGroundedMob(mob/living/M)
  if(istype(M, /mob/living/carbon) || istype(M, /mob/living/silicon))
    for(var/B in FOOTSTEP_BLACKLISTED_MOBS) // Blacklist for things that should have footsteps but shouldn't
      if(istype(M, B))
        return 0
    return 1

  if(istype(M, /mob/living/carbon)) // Check if something that should have footsteps
    return 1
  else if(istype(M, /mob/living/silicon)) // Check if something that should have footsteps, but is not alive
    return 1

proc/isWalking(mob/living/M) // Gotta be sneaky
  if(M.m_intent == "walk")
    return 1
  return 0

/proc/getFootStepSound(T as turf, M as mob)
  if(!T) // Check if its a turf at all (sanity check)
    return
  if(!istype(T, /turf/simulated)) // Check if its a turf that isn't space and admin tile
    return
  if(istype(M, /mob/living/silicon))
    return HEAVY_FOOTSTEP_SOUNDS[rand(1, HEAVY_FOOTSTEP_SOUNDS.len)] // If silicon, use heavy
  for(var/O in T) // Each item on tile
    for(var/OT in itemStepsList) // Each item list in itemStepsList
      for(var/OT2 in OT) // Each item in itemlist
        if(istype(O, OT2))
          return itemStepsList[OT2]
  for(var/i in stepsList) // Choose a random sound associated with the turf type
    if(istype(T, i))
      var/t[] = stepsList[i]
      var/step = rand(1, t.len)
      return stepsList[i][step]
  return DEFAULT_FOOTSTEP_SOUNDS[rand(1, DEFAULT_FOOTSTEP_SOUNDS.len)] // If no type is specified, use default

/proc/playFootstep(atom/movable/A) // Main proc
  if(!A || !istype(A))
    return
  var/playSteps = isGroundedMob(A)
  if(isWalking(A))  // Check if the player is in sneak mode (walk mode)
    return
  if(playSteps) // Play the sound
    var/curTurf = get_turf(A)
    if(curTurf)
      var/stepSound = getFootStepSound(curTurf, A)
      if(stepSound)
        playsound(curTurf, "sound/footsteps/" + stepSound, footstepVol, footstepVarReq, footstepRange, 0, 0, footstepFreq)
