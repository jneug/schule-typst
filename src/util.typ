/********************************\
*       Utility functions        *
\********************************/


#let if-arg( default, do:none, args, key ) = if key not in args.named() {
  return default
} else if do == none {
  args.named().at(key)
} else {
  do(args.named().at(key))
}

#let def-args(args) = (default, do:none, key) => if key not in args.named() {
  return default
} else if do == none {
  args.named().at(key)
} else {
  do(args.named().at(key))
}

#let as-arr( ..values ) = (..values.pos(),).flatten()

// Place a hidden label in the content
#let place-label( label ) = [#place(box(width:0pt, height:0pt, clip:true, ""))#label]
