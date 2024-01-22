#define any2ref(x) "\ref[x]"

//Do (almost) nothing - indev placeholder for switch case implementations etc
#define NOOP (.=.);

#define PUBLIC_GAME_MODE SSticker.master_mode

#define CLAMP01(x) clamp(x, 0, 1)

/**
 * Get the turf that `A` resides in, regardless of any containers.
 *
 * Use in favor of `A.loc` or `src.loc` so that things work correctly when
 * stored inside an inventory, locker, or other container.
 */
#define get_turf(A) get_step(A,0)

/**
 * Get the ultimate area of `A`, similarly to [get_turf].
 *
 * Use instead of `A.loc.loc`.
 */
#define get_area(A) (isarea(A) ? A : get_step(A, 0)?.loc)

#define get_x(A) (get_step(A, 0)?.x || 0)

#define get_y(A) (get_step(A, 0)?.y || 0)

#define get_z(A) (get_step(A, 0)?.z || 0)

#define isAI(A) istype(A, /mob/living/silicon/ai)

#define isalien(A) istype(A, /mob/living/carbon/alien)

#define isanimal(A) istype(A, /mob/living/simple_animal)

#define isairlock(A) istype(A, /obj/machinery/door/airlock)

#define isatom(A) (isloc(A) && !isarea(A))

#define isprojectile(A) istype(A, /obj/item/projectile)

#define isbeam(A) istype(A, /obj/item/projectile/beam)

#define ismagazine(A) istype(A, /obj/item/ammo_magazine)

#define isbrain(A) istype(A, /mob/living/carbon/brain)

#define iscarbon(A) istype(A, /mob/living/carbon)

#define iscolorablegloves(A) (istype(A, /obj/item/clothing/gloves/color)||istype(A, /obj/item/clothing/gloves/insulated)||istype(A, /obj/item/clothing/gloves/thick))

#define isclient(A) istype(A, /client)

#define iscorgi(A) istype(A, /mob/living/simple_animal/passive/corgi)

#define isdatum(A) istype(A, /datum)

#define isdrone(A) istype(A, /mob/living/silicon/robot/drone)

#define isEye(A) istype(A, /mob/observer/eye)

#define ishuman(A) istype(A, /mob/living/carbon/human)

#define isid(A) istype(A, /obj/item/card/id)

#define isitem(A) istype(A, /obj/item)

#define isliving(A) istype(A, /mob/living)

#define ismouse(A) istype(A, /mob/living/simple_animal/passive/mouse)

#define isnewplayer(A) istype(A, /mob/new_player)

#define isobj(A) istype(A, /obj)

#define isghost(A) istype(A, /mob/observer/ghost)

#define isobserver(A) istype(A, /mob/observer)

#define isorgan(A) istype(A, /obj/item/organ/external)

#define isstack(A) istype(A, /obj/item/stack)

#define isspace(A) istype(A, /area/space)

#define isspaceturf(A) istype(A, /turf/space)

#define isopenturf(A) istype(A, /turf/simulated/open)

#define ispAI(A) istype(A, /mob/living/silicon/pai)

#define isrobot(A) istype(A, /mob/living/silicon/robot)

#define issilicon(A) istype(A, /mob/living/silicon)

#define ismachinerestricted(A) (issilicon(A) && A.machine_restriction)

#define isslime(A) istype(A, /mob/living/carbon/slime)

#define isunderwear(A) istype(A, /obj/item/underwear)

#define isvirtualmob(A) istype(A, /mob/observer/virtual)

#define isweakref(A) istype(A, /weakref)

#define attack_animation(A) if(istype(A)) A.do_attack_animation(src)

#define isopenspace(A) istype(A, /turf/simulated/open)

#define isplunger(A) istype(A, /obj/item/clothing/mask/plunger) || istype(A, /obj/item/device/plunger/robot)

#define isadmin(X) (check_rights(R_ADMIN, 0, (X)) != 0)

#define sequential_id(key) uniqueness_repository.Generate(/datum/uniqueness_generator/id_sequential, key)

#define random_id(key,min_id,max_id) uniqueness_repository.Generate(/datum/uniqueness_generator/id_random, key, min_id, max_id)

/// General I/O helpers
#define to_target(target, payload)            target << (payload)
#define from_target(target, receiver)         target >> (receiver)

/// Common use
#define legacy_chat(target, message)          to_target(target, message)
#define to_world(message)                     to_chat(world, message)
#define to_world_log(message)                 to_target(world.log, message)
#define sound_to(target, sound)               to_target(target, sound)
#define image_to(target, image)               to_target(target, image)
#define show_browser(target, content, title)  to_target(target, browse(content, title))
#define close_browser(target, title)          to_target(target, browse(null, title))
#define send_rsc(target, content, title)      to_target(target, browse_rsc(content, title))
#define send_link(target, url)                to_target(target, link(url))
#define send_output(target, msg, control)     to_target(target, output(msg, control))
#define to_file(handle, value)                to_target(handle, value)
#define to_save(handle, value)                to_target(handle, value) //semantics
#define from_save(handle, target_var)         from_target(handle, target_var)

#define MAP_IMAGE_PATH "nano/images/[GLOB.using_map.path]/"

#define map_image_file_name(z_level) "[GLOB.using_map.path]-[z_level].png"

#define RANDOM_BLOOD_TYPE pick(4;"O-", 36;"O+", 3;"A-", 28;"A+", 1;"B-", 20;"B+", 1;"AB-", 5;"AB+")

#define CanInteract(user, state) (CanUseTopic(user, state) == STATUS_INTERACTIVE)

#define CanDefaultInteract(user) (CanUseTopic(user, DefaultTopicState()) == STATUS_INTERACTIVE)

#define CanInteractWith(user, target, state) (target.CanUseTopic(user, state) == STATUS_INTERACTIVE)

#define CanPhysicallyInteract(user) (CanUseTopicPhysical(user) == STATUS_INTERACTIVE)

#define CanPhysicallyInteractWith(user, target) (target.CanUseTopicPhysical(user) == STATUS_INTERACTIVE)

#define QDEL_NULL_LIST(x) if(x) { for(var/y in x) { qdel(y) }}; if(x) {x.Cut(); x = null; } // Second x check to handle items that LAZYREMOVE on qdel.

#define QDEL_NULL_ASSOC_LIST(x) if(x) { for(var/y in x) { qdel(x[y]) }}; if(x) {x.Cut(); x = null; }

#define QDEL_NULL(x) if(x) { qdel(x) ; x = null }

#define QDEL_IN(item, time) addtimer(new Callback(item, /datum/proc/qdel_self), time, TIMER_STOPPABLE)

#define DROP_NULL(x) if(x) { x.dropInto(loc); x = null; }

#define DROP_NULL_LIST(x) if(x) { for(var/atom/movable/y in x) { y.dropInto(loc) }}; x.Cut(); x = null;

#define ARGS_DEBUG log_debug("[__FILE__] - [__LINE__]") ; for(var/arg in args) { log_debug("\t[log_info_line(arg)]") }

// Insert an object A into a sorted list using cmp_proc (/code/_helpers/cmp.dm) for comparison.
#define ADD_SORTED(list, A, cmp_proc) if(!length(list)) {list.Add(A)} else {list.Insert(FindElementIndex(A, list, cmp_proc), A)}

// Spawns multiple objects of the same type
#define cast_new(type, num, args...) if((num) == 1) { new type(args) } else { for(var/i=0;i<(num),i++) { new type(args) } }

#define JOINTEXT(X) jointext(X, null)

#define SPAN_CLASS(class, X) "<span class='[class]'>[X]</span>"

#define SPAN_STYLE(style, X) "<span style=\"[style]\">[X]</span>"

#define SPAN_ITALIC(X) SPAN_CLASS("italic", "[X]")

#define SPAN_BOLD(X) SPAN_CLASS("bold", "[X]")

#define SPAN_NOTICE(X) SPAN_CLASS("notice", "[X]")

#define SPAN_WARNING(X) SPAN_CLASS("warning", "[X]")

#define SPAN_GOOD(X) SPAN_CLASS("good", "[X]")

#define SPAN_BAD(X) SPAN_CLASS("bad", "[X]")

#define SPAN_DANGER(X) SPAN_CLASS("danger", "[X]")

#define SPAN_OCCULT(X) SPAN_CLASS("cult", "[X]")

#define SPAN_LEGION(X) SPAN_CLASS("legion", "[X]")

#define SPAN_MFAUNA(X) SPAN_CLASS("mfauna", "[X]")

#define SPAN_SUBTLE(X) SPAN_CLASS("subtle", "[X]")

#define SPAN_INFO(X) SPAN_CLASS("info", "[X]")

#define STYLE_SMALLFONTS(X, S, C1) SPAN_STYLE("font-family: 'Small Fonts'; color: [C1]; font-size: [S]px", "[X]")

#define STYLE_SMALLFONTS_OUTLINE(X, S, C1, C2) SPAN_STYLE("font-family: 'Small Fonts'; color: [C1]; -dm-text-outline: 1 [C2]; font-size: [S]px", "[X]")

#define SPAN_DEBUG(X) SPAN_CLASS("debug", "[X]")

#define SPAN_COLOR(color, text) SPAN_STYLE("color: [color]", "[text]")

#define SPAN_SIZE(size, text) SPAN_STYLE("font-size: [size]", "[text]")

#define FONT_SMALL(X) SPAN_SIZE("10px", "[X]")

#define FONT_NORMAL(X) SPAN_SIZE("13px", "[X]")

#define FONT_LARGE(X) SPAN_SIZE("16px", "[X]")

#define FONT_HUGE(X) SPAN_SIZE("18px", "[X]")

#define FONT_GIANT(X) SPAN_SIZE("24px", "[X]")

#define crash_with(X) crash_at(X, __FILE__, __LINE__)

#define TO_HEX_DIGIT(n) ascii2text((n&15) + ((n&15)<10 ? 48 : 87))


/// Semantic define for a 0 int intended for use as a bitfield
#define EMPTY_BITFIELD 0


/// Right-shift of INT by BITS
#define SHIFTR(INT, BITS) ((INT) >> (BITS))


/// Left-shift of INT by BITS
#define SHIFTL(INT, BITS) ((INT) << (BITS))


/// Convenience define for nth-bit flags, 0-indexed
#define FLAG(BIT) SHIFTL(1, BIT)


/// Test bit at index BIT is set in FIELD
#define GET_BIT(FIELD, BIT) ((FIELD) & FLAG(BIT))


/// Test bit at index BIT is set in FIELD; semantic alias of GET_BIT
#define HAS_BIT(FIELD, BIT) GET_BIT(FIELD, BIT)


/// Set bit at index BIT in FIELD
#define SET_BIT(FIELD, BIT) ((FIELD) |= FLAG(BIT))


/// Unset bit at index BIT in FIELD
#define CLEAR_BIT(FIELD, BIT) ((FIELD) &= ~FLAG(BIT))


/// Flip bit at index BIT in FIELD
#define FLIP_BIT(FIELD, BIT) ((FIELD) ^= FLAG(BIT))


/// Test any bits of MASK are set in FIELD
#define GET_FLAGS(FIELD, MASK) ((FIELD) & (MASK))


/// Test all bits of MASK are set in FIELD
#define HAS_FLAGS(FIELD, MASK) (((FIELD) & (MASK)) == (MASK))


/// Set bits of MASK in FIELD
#define SET_FLAGS(FIELD, MASK) ((FIELD) |= (MASK))


/// Unset bits of MASK in FIELD
#define CLEAR_FLAGS(FIELD, MASK) ((FIELD) &= ~(MASK))


/// Flip bits of MASK in FIELD
#define FLIP_FLAGS(FIELD, MASK) ((FIELD) ^= (MASK))


#define hex2num(hex) (text2num(hex, 16) || 0)


#define num2hex(num) num2text(num, 1, 16)


/// Generate random hex up to char length nibbles
/proc/randhex(nibbles)
	for (var/i = 1 to nibbles)
		. += num2text(rand(0, 15), 1, 16)


/// Increase the size of L by 1 at the end. Is the old last entry index.
#define LIST_INC(L) ((L).len++)

/// Increase the size of L by 1 at the end. Is the new last entry index.
#define LIST_PRE_INC(L) (++(L).len)

/// Decrease the size of L by 1 from the end. Is the old last entry index.
#define LIST_DEC(L) ((L).len--)

/// Decrease the size of L by 1 from the end. Is the new last entry index.
#define LIST_PRE_DEC(L) (--(L).len)

/// Explicitly set the length of L to NEWLEN, adding nulls or dropping entries. Is the same value as NEWLEN.
#define LIST_RESIZE(L, NEWLEN) ((L).len = (NEWLEN))
