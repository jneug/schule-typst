/********************************\
|   Some convenience functions   |
|   for handling states          |
\********************************/

// identity function
#let ident(e) = { return  e }


/**
 * Creates a new state with an initial value.
 *
 * The initial value can't be `none`.
 *
 * - name (str): name of the state variable
 * - value (any but `none`): initial value
 */
#let new( name, value ) = state(name).update(value)

/**
 * Creates a new state with an empty array as inital value.
 *
 * - name (str): name of the state variable
 */
#let new-arr( name ) = {
	new(name, ())
}

/**
 * Creates a new state with an empty dict as inital value.
 *
 * - name (str): name of the state variable
 */
#let new-dict( name ) = {
	new(name, (:))
}

/**
 * Removes a state by setting its value to `none`.
 *
 * - name (str): name of the state variable
 */
#let del( name ) = update(name, v => none)

/**
 * Updates the value of a state.
 *
 * Value may be an update function of one argument
 * or a new value (see `state.update()`). Setting the
 * state to `none` is the same as calling `del()`.
 *
 * - name (str): name of the state variable
 * - value (any | any => any): new value
 */
#let update( name, value ) = {
	state(name).update(value)
}

/**
 * Pushes a new value into an array stored in a state.
 *
 * If the state is empty, a new array is created.
 * Fails, if the state currently does not hold an array.
 *
 * - name (str): name of the state variable
 * - value (any): value to push
 */
#let enq( name, value ) = {
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
 * Removes the last value from an array stored in a state.
 *
 * Fails, if the state currently does not hold an array or
 * the array is empty.
 *
 * - name (str): name of the state variable
 * - func (any => any, default: ident): function to pass the value to
 */
#let deq( name, func:ident ) = {
	state(name).update(arr => {
		let _ = func(arr.pop())
		arr
	})
}

/**
 *
 */
#let ins( name, key, value, func:ident ) = {
	state(name).update(arr => {
		arr.insert(key, value)
		arr
	})
}

/**
 *
 */
#let rem( name, key ) = {
	state(name).update(arr => {
		let _ = arr.remove(key)
		arr
	})
}


// #let insertDict( name, key, value ) = {
// 	state(name).update((dic) => {
// 		dic.insert(key, value)
// 		dic
// 	})
// }

// #let removeDict( name, key ) = {
// 	state(name).update((dic) => {
// 		let _ = dic.remove(key)
// 		dic
// 	})
// }


/**
 * Get value of a state variable.
 *
 * Get the value either at the specified location or
 * the final value.
 *
 * - name (str): name of the state variable
 * - loc (location): location from where to get the value
 * - func (any => any, default: ident): function to send the value to
 * - final (boolean, default: false): retrieve the final value
 */
#let __get( name, loc, func:ident, final:false, key:none, default:none ) = {
	let value = none
	if final {
		value = state(name).final(loc)
	} else {
		value = state(name).at(loc)
	}
	if value == none { value = default }
	else if key != none { value = value.at(key, default:default) }
	return func(value)
}

#let get( name, func, final:false, key:none, default:none ) = {
	locate(loc => {
		__get(name, loc, func:func, final:final, key:key, default:default)
	})
}

#let get-final( name, func, key:none, default:none ) = {
	locate(loc => {
		__get(name, loc, func:func, final:true, key:key, default:default)
	})
}

#let get-at( name, loc, func:ident, final:false, key:none, default:none ) = {
	__get(name, loc, func:func, final:final, key:key, default:default)
}

#let get-final-at( name, loc, func:ident, key:none, default:none ) = {
	__get(name, loc, func:func, final:true, key:key, default:default)
}

// #let getArr( name, i, func:ident, final:false ) = {
// 	locate(loc => {
// 		__get(name, loc, func:(arr) => {
// 			func(arr.at(i))
// 		}, final:final)
// 	})
// }

// #let getArrAt( name, i, loc, func:ident, final:false ) = {
// 	__get(name, loc, func:(arr) => {
// 		func(arr.at(i))
// 	}, final:final)
// }

#let get-first( name, func:ident, final:false ) = {
	locate(loc => {
		__get(name, loc, func:(arr) => {
			func(arr.first())
		}, final:final)
	})
}

// #let getFirstAt( name, i, loc, func:ident, final:false ) = {
// 	__get(name, loc, func:(arr) => {
// 		func(arr.first())
// 	}, final:final)
// }

#let get-last( name, func:ident, final:false ) = {
	locate(loc => {
		__get(name, loc, func:(arr) => {
			func(arr.last())
		}, final:final)
	})
}

// #let getLastAt( name, i, loc, func:ident, final:false ) = {
// 	__get(name, loc, func:(arr) => {
// 		func(arr.last())
// 	}, final:final)
// }

// #let getDict( name, key, func:ident, final:false ) = {
// 	locate(loc => {
// 		__get(name, loc, func: (dic) => {
// 			if dic != none {func(dic.at(key))}
// 			else {func(none)}
// 		}, final:final)
// 	})
// }

// #let getDictAt( name, key, loc, func:ident, final:false ) = {
// 	__get(name, loc, func: (dic) => {
// 		if dic != none {func(dic.at(key))}
// 		else {func(none)}
// 	}, final:final)
// }

// #let getDictFinal( name, key, func:ident ) = {
// 	locate(loc => {
// 		__get(name, loc, func: (dic) => {
// 			if dic != none {func(dic.at(key))}
// 			else {func(none)}
// 		}, final:true)
// 	})
// }

// #let getDictFinalAt( name, key, loc, func:ident ) = {
// 	__get(name, loc, func: (dic) => {
// 		if dic != none {func(dic.at(key))}
// 		else {func(none)}
// 	}, final:true)
// }
