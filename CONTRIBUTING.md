# Licening
Baystation12 is licensed under the GNU Affero General Public License version 3, which can be found in full in LICENSE-AGPL3.txt.

Commits with a git authorship date prior to `1420675200 +0000` (2015/01/08 00:00) are licensed under the GNU General Public License version 3, which can be found in full in LICENSE-GPL3.txt.

All commits whose authorship dates are not prior to `1420675200 +0000` are assumed to be licensed under AGPL v3, if you wish to license under GPL v3 please make this clear in the commit message and any added files.

# Coding Standards

### Absolute Pathing
Absolute pathing shall always be used. This simplifies grepping and reduces indentation.
````
// This is an example of an absolute path.
/obj/example/path/proc/method()
	return 1

// This is an example of a relative path. Do NOT use.
/obj/example/path
	/proc/method()
		return 0
````

### Destroy/qdel()
```del()``` is no longer used. When you wish to delete an object instead use ```qdel()```. Keep in mind that unlike ```del(src)```, ```qdel(src)``` does not automatically terminate the current execution context and you must manually ```return``` or otherwise handle the rest of the proc flow.

When an instance is deleted the ```Destroy()``` proc is automatically called.  In the ```Destroy()``` proc any referenced instances the deleted instance is responsible for shall also be deleted, and all references shall always be cleared. When you implement ```Destroy()``` also remember to return the result of the the base proc, i.e:
```` 
/obj/example
	var/created_instance
	var/outside_instance
	var/list/list_of_references
	
/obj/example/New(var/outside_instance)
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

### Icon State Updates
The icon_state variable shall, with the exception of  type definitions and ```New()```, only be updated in ```update_icon()``` or relevant proc for the type. By conducting icon updates at a centralized location, it is simpler to ensure correct functionality.

### Naming
When naming objects, carefully consider the proper capitalization of the first letter. 

|  Naming | \improper | \proper |
| ------------- | ------------- | ------------- |
| lower-case  | Result  | Result |
| Upper-case  | Result  | Result |

### Movement/loc
Always set loc using forceMove().
