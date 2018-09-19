# Licensing
Baystation12 is licensed under the GNU Affero General Public License version 3, which can be found in full in LICENSE-AGPL3.txt.

Commits with a git authorship date prior to `1420675200 +0000` (2015/01/08 00:00) are licensed under the GNU General Public License version 3, which can be found in full in LICENSE-GPL3.txt.

All commits whose authorship dates are not prior to `1420675200 +0000` are assumed to be licensed under AGPL v3, if you wish to license under GPL v3 please make this clear in the commit message and any added files.

# Coding Standards

## Responsibilities and formatting
### Changelogs
Changelog entries shall be descriptive, unbiased (_Changed..._ instead of _Upgraded..._), written with proper punctuation and grammar, and in the past tense.

```
// These are good changelog entries
rscadd: Added Wrench 2.0, which acts faster, to supply and the autolathe.
maptweak: Removed the screwdriver that spawned in the bar.

// These are bad
rscadd: Adds a new wrench.
maptweak: removed a screwdriver from the bar
```

It is _encouraged_ that all player-facing changes are given an appropriate, descriptive changelog entry. The following changes in particular shall have a changelog entry:
* Adding, modifying or removing objects that players can obtain and interact with.
* Adding, modifying or removing staff tools.
* Modifying any map file.
* Gameplay changes, such as jobs and access.
* Adding or removing items in non-map files, such as in lockers or vendors.

The following changes typically will not require a changelog:
* Minor cosmetic changes, such as editing descriptions, icons, or adding sound effects.
* Minor bug fixes.

Developers may require that a changelog be added for any change, either by commenting as such, or by labelling the PR with the 'Needs Changelog' tag.

### Testing
All PRs must be tested by their author. The author is responsible for fixing issues directly caused by their changes under penalty of reversion. 

### Absolute Pathing
All new pathing shall be absolute. If a change is being made to a code block using relative pathing, it should be converted.
````
// This is an example of absolute pathing
/obj/item/thing/New()
    do_work()

// This is an example of relative pathing
/obj/item/thing
    New()
        do_work()
````

### Spaces
Tabs shall be used for indentation.

### Style sheet
[Span classes](https://github.com/Baystation12/Baystation12/blob/dev/code/stylesheet.dm) shall be used instead of `\red` and so on.

### Map formatting
Maps shall be merged/formatted with the mapmerge2 TGM map format.

## Logic
### Initialize() v. New()
For new implementations, Initialize() should be used instead of New(), when possible.

### Destroy/qdel()
```del()``` is no longer used. When you wish to delete an object instead use ```qdel()```. Keep in mind that unlike ```del(src)```, ```qdel(src)``` does not automatically terminate the current execution context and you must manually ```return``` or otherwise handle the rest of the proc flow.
When an instance is deleted the ```Destroy()``` proc is automatically called.  In the ```Destroy()``` proc any referenced instances the deleted instance is responsible for shall also be deleted, and all references shall always be cleared. When you implement ```Destroy()``` also remember to return the result of the the base proc, i.e:
```` 
/obj/example
	var/created_instance
	var/outside_instance
	var/list/list_of_references
	
/obj/example/Initialize(var/outside_instance)
	. = ..()
	src.created_instance = new()
	src.outside_instance = outside_instance
	list_of_references = list(created_instance, outside_instance)

/obj/example/Destroy()
	qdel(created_instance)		// Because we created this instance we are also responsible for deleting it in this particular case. This may not always be the case.
	created_instance = null
	outside_instance = null		// Because we were given this instance from the outside, we can simply null it in this particular case. This may not always be the case.
	list_of_references.Cut()	// Lists shall always be Cut(), never nulled or len set to 0 as this may cause reference leaks. 
	return ..()					// Always call the base proc and return the result, unless you have a clear reason not to.
```` 

### Paths as text
Typing paths as text (in quotation marks) will rarely be accepted, as the compiler will not error if the path as text changes.
```
// This is correct and good
var/path_type = /obj/item/example

// This is incorrect and bad
var/path_type = "/obj/item/example"
```

### Hex colour codes
Hex colour codes with alphabetic characters shall be typed in lower case.

### isTool() macros
[isTool()](https://github.com/Baystation12/Baystation12/blob/dev/code/_macros.dm) macros shall be used instead of the relevant `istype(W, /path/to/tool)`

### update_icon()
The `icon_state`, `item_state`, and `worn_state` variables shall, with the exception of type definitions, `New()` or `Initialize()`, only be updated in `update_icon()`, or the relevant proc for the type.

## Var-setter procs
| Var           | Proc                |
|---------------|---------------------|
| dir           | set_dir()           |
| density       | set_density()       |
| loc           | forceMove()         |
| name          | SetName()           |
| opacity       | set_opacity()       |
| see_in_dark   | set_see_in_dark()   |
| see_invisible | set_see_invisible() |
| invisibility  | set_invisibility()  |
| sight         | set_sight()         |
| stat          | set_stat()          |