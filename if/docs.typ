#import "../informatik.typ": mdoku

#let doc-data = yaml("./docs.yaml")

#let __content( string ) = {
	eval("[" + string + "]")
}

#let __d_classheader( scheme ) = {
	if "generic" in scheme and scheme.generic == true [
		=== Die generische Klasse #scheme.name
	] else [
		=== Die Klasse #scheme.name
	]
}

#let __d_methodheader( scheme ) = {
	if "generic" in scheme and scheme.generic == true [
		==== Dokumentation der Klasse #scheme.name<#scheme.generic-type>
	] else [
		==== Dokumentation der Klasse #scheme.name
	]
}

#let display( name, descr:true ) = {
	if name not in doc-data {
		panic("No docs for name " + name)
	}

	let scheme = doc-data.at(name)

	if descr and "descr" in scheme {
		__d_classheader( scheme )
		__content(scheme.descr)
	}

	__d_methodheader( scheme )
	for m in scheme.methods {
		mdoku[#m.signature][
			#__content(m.descr)
		]
	}
}
