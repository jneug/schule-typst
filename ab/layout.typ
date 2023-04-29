#import "./options.typ"
#import "./theme.typ"
#import "./typo.typ": small, luecke


#let docstart() = [#hide[] <body-start>]
#let docend()   = [#hide[] <body-end>]


#let __seitenzahl( current, body, total, loc ) = {
	// let total = int(counter(page).final(loc).at(0))
	if body > 1 {
		text(fill:theme.text.default)[#counter(page).display()]
	}
	if body > 2 {
		text(fill:theme.text.default)[
von #body]
	}
}
#let d_seitenzahl( func: __seitenzahl ) = locate(loc => {
	let bodyend = query(<body-end>, loc).first()
	func(
		counter(page).at(loc).at(0),    //current page
		counter(page).at(bodyend.location()).at(0),      // last content page
		counter(page).final(loc).at(0), // total
		loc
	)
})

#let kopfLinks() = [#options.display("fach", final:true) #options.display("kurs", final:true) #options.display("kuerzel", format: v=>{if v != none [(#v)]}, final:true)]
#let kopfMitte() = [Datum: #options.display("datum", format: v=>{if v != none [#v] else [#luecke()]}, final:true)]
#let kopfRechts() = [#options.display("typ", final:true) #options.display("nummer", format: v=>{if v != none [Nr. #v]}, final:true)]
#let kopfzeile( links: kopfLinks, mitte: kopfMitte, rechts:kopfRechts ) = locate(loc => [
	#set text(fill: theme.text.header)
	#small[
		#links()
		#h(1fr)
		#mitte()
		#h(1fr)
		#rechts()
	]
	#move(dy:-.4em, line(length:100%, stroke:.5pt))
])

#let fussLinks() = [#options.display("version", format: v=>{if v != none [ver.#v]}, final:true)]
#let fussMitte() = [cc-by-sa-4]
#let fussRechts() = d_seitenzahl()
#let fusszeile( links: fussLinks, mitte: fussMitte, rechts:fussRechts ) = locate(loc => [
	#set text(fill: theme.text.footer)
	#small[
		#links()
		#h(1fr)
		#mitte()
		#h(1fr)
		#rechts()
	]
])
