/**
* SpacemanDMM dreamchecker extensions for suite 1.9
* <https://github.com/SpaceManiac/SpacemanDMM/tree/suite-1.9/crates/dreamchecker>
*/

#ifdef SPACEMAN_DMM

	/**
	 * Sets a return type expression for a proc. The return type can take the forms:
	 * - `/typepath` - a raw typepath. The return type of the proc is the type named.
	 * - `param` - a typepath given as a parameter, for procs which return an instance of the passed-in type.
	 * - `param.type` - the static type of a passed-in parameter, for procs which return their input or otherwise
	 * another value of the same type.
	 * - `param[_].type` - the static type of a passed-in parameter, with one level of `/list` stripped, for procs which
	 * select one item from a list. The `[_]` may be repeated to strip more levels of `/list`.
	 */
	#define RETURN_TYPE(X) set SpacemanDMM_return_type = X

	/**
	 * If `TRUE`, enables a diagnostic on children of the proc which do not contain any `..()` parent calls. T
	 * his can help with finding situations where a signal or other important handling in the parent proc is being
	 * skipped.
	 *
	 * Child procs may set this setting to `FALSE` instead to override the check.
	 */
	#define SHOULD_CALL_PARENT(X) set SpacemanDMM_should_call_parent = X

	/// Escape hatch for cases like `src` in macros used in global procs.
	#define UNLINT(X) SpacemanDMM_unlint(X)

	/**
	 * If `TRUE`, raises a warning for any child procs that override this one, regardless of if it calls parent or not.
	 * This functions in a similar way to the `final` keyword in some languages.
	 *
	 * This cannot be disabled by child overrides.
	 */
	#define SHOULD_NOT_OVERRIDE(X) set SpacemanDMM_should_not_override = X

	/**
	 * If `TRUE`, Raises a warning if the proc or one of the sub-procs it calls uses a blocking call, such as `sleep()`
	 * or `input()` without using `set waitfor = 0`.
	 */
	#define SHOULD_NOT_SLEEP(X) set SpacemanDMM_should_not_sleep = X

	/**
	 * If `TRUE`, ensures a proc is 'pure', such that it does not make any changes outside itself or its output. This
	 * also checks to make sure anything using this proc doesn't invoke it without making use of the return value.
	 *
	 * This cannot be disabled by child overrides.
	 */
	#define SHOULD_BE_PURE(X) set SpacemanDMM_should_be_pure = X

	/// If `TRUE`, this proc can only be called by things of exactly the same type. Cannot be overridden.
	#define PRIVATE_PROC(X) set SpacemanDMM_private_proc = X

	/// If `TRUE`, this proc can only be called by things of the same type or subtypes.
	#define PROTECTED_PROC(X) set SpacemanDMM_protected_proc = X

	/// If `TRUE`, allows this proc to be redefined multiple times.
	#define CAN_BE_REDEFINED(X) set SpacemanDMM_can_be_redefined = X

	/// Overriding this variables value isn't permitted by types that inherit it.
	#define VAR_FINAL var/SpacemanDMM_final

	/// Can only be accessed/updated by things of exactly the same type. Cannot be overridden.
	#define VAR_PRIVATE var/SpacemanDMM_private

	/// Can only be accessed/updated by things of the same type or subtypes.
	#define VAR_PROTECTED var/SpacemanDMM_protected

#else

	#define RETURN_TYPE(X)
	#define SHOULD_CALL_PARENT(X)
	#define UNLINT(X) X
	#define SHOULD_NOT_OVERRIDE(X)
	#define SHOULD_NOT_SLEEP(X)
	#define SHOULD_BE_PURE(X)
	#define PRIVATE_PROC(X)
	#define PROTECTED_PROC(X)
	#define CAN_BE_REDEFINED(X)
	#define VAR_FINAL var
	#define VAR_PRIVATE var
	#define VAR_PROTECTED var

#endif
