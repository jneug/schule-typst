/********************************\
*   Some convenience functions   *
*   for handling states          *
\********************************/

// Identity function
#let ident(e) = e


/**
 * get a state of counter value,
 * wither at the specified location
 * or the final value.
 */
#let __get( name, loc, func:ident, final:false ) = {
	if final {
		func(state(name).final(loc))
	} else {
		func(state(name).at(loc))
	}
}


/**
 * Creates a new state with an initial value.
 *
 * The initial value can't be `none`.
 */
#let new( name, value ) = state(name).update(value)

/**
 * Creates a new state with an empty array.
 */
#let newArr( name ) = {
	new(name, ())
}

/**
 * Creates a new state with an empty dict.
 */
#let newDict( name ) = {
	new(name, (:))
}

/**
 * "Deletes" a state by setting its
 * value to `none`.
 */
#let del( name ) = update(name, v => none)

/**
 * Sets the value of a state to a new value.
 *
 * Value may be an update function of one argument
 * or a new value (see `state.update()`).
 */
#let update( name, func ) = {
	state(name).update(func)
}

/**
 * Pushes a new value onto an array stored
 * in a state.
 * If the state is empty, a new array is created.
 * Fails, if the state does not store an array.
 */
#let pushArr( name, value ) = {
	state(name).update(arr => {
		if arr == none {
			arr = (value,)
		} else {
			arr.push(value)
		}
		arr
	})
}

/**
 *
 */
#let popArr( name, func:ident ) = {
	state(name).update(arr => {
		let _ = arr.pop()
		arr
	})
}

/**
 *
 */
#let insertArr( name, i, value, func:ident ) = {
	state(name).update(arr => {
		arr.insert(i, value)
		arr
	})
}

/**
 *
 */
#let removeArr( name, i, value ) = {
	state(name).update(arr => {
		let _ = arr.remove(i)
		arr
	})
}


#let insertDict( name, key, value ) = {
	state(name).update((dic) => {
		dic.insert(key, value)
		dic
	})
}

#let removeDict( name, key ) = {
	state(name).update((dic) => {
		let _ = dic.remove(key)
		dic
	})
}


#let get( name, func, final:false ) = {
	locate(loc => {
		__get(name, loc, func:func, final:final)
	})
}

#let getFinal( name, func ) = {
	locate(loc => {
		__get(name, loc, func:func, final:true)
	})
}

#let getAt( name, loc, func:ident, final:false ) = {
	__get(name, loc, func:func, final:final)
}

#let getFinalAt( name, loc, func:ident ) = {
	__get(name, loc, func:func, final:true)
}

#let getArr( name, i, func:ident, final:false ) = {
	locate(loc => {
		__get(name, loc, func:(arr) => {
			func(arr.at(i))
		}, final:final)
	})
}

#let getArrAt( name, i, loc, func:ident, final:false ) = {
	__get(name, loc, func:(arr) => {
		func(arr.at(i))
	}, final:final)
}

#let getFirst( name, i, func:ident, final:false ) = {
	locate(loc => {
		__get(name, loc, func:(arr) => {
			func(arr.first())
		}, final:final)
	})
}

#let getFirstAt( name, i, loc, func:ident, final:false ) = {
	__get(name, loc, func:(arr) => {
		func(arr.first())
	}, final:final)
}

#let getLast( name, i, func:ident, final:false ) = {
	locate(loc => {
		__get(name, loc, func:(arr) => {
			func(arr.last())
		}, final:final)
	})
}

#let getLastAt( name, i, loc, func:ident, final:false ) = {
	__get(name, loc, func:(arr) => {
		func(arr.last())
	}, final:final)
}

#let getDict( name, key, func:ident, final:false ) = {
	locate(loc => {
		__get(name, loc, func: (dic) => {
			if dic != none {func(dic.at(key))}
			else {func(none)}
		}, final:final)
	})
}

#let getDictAt( name, key, loc, func:ident, final:false ) = {
	__get(name, loc, func: (dic) => {
		if dic != none {func(dic.at(key))}
		else {func(none)}
	}, final:final)
}

#let getDictFinal( name, key, func:ident ) = {
	locate(loc => {
		__get(name, loc, func: (dic) => {
			if dic != none {func(dic.at(key))}
			else {func(none)}
		}, final:true)
	})
}

#let getDictFinalAt( name, key, loc, func:ident ) = {
	__get(name, loc, func: (dic) => {
		if dic != none {func(dic.at(key))}
		else {func(none)}
	}, final:true)
}
