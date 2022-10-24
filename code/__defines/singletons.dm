/*
* Performance behaviors for acessing the Singletons global.
*/

/// Fetch a single singleton, resolving it if necessary. Null if abstract or not a singleton path.
#define GET_SINGLETON(P) (ispath(P, /singleton) ? (Singletons.resolved_instances[P] ? Singletons.instances[P] : Singletons.GetInstance(P)) : null)
