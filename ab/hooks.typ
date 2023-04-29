#import "states.typ"


#let _name( name ) = { "@hook-" + name }

#let new( ..names ) = {
	for name in names.pos() [#states.newArr(_name(name))]
}

#let add( name, func ) = {
	states.pushArr(_name(name), func)
}

#let execute( name ) = {
	locate(loc => {
		let hooks = states.getFinalAt(_name(name), loc)
		if hooks != none {
			for func in hooks {func(loc)}
		}
	})
}
