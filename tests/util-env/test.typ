#import "@local/schule:1.0.0": ab
#import ab: *

#let test-env(name) = context if marks.in-env(name) [
  In "#name".
] else [
  Not in "#name"
]

#test-env("content")

#show: arbeitsblatt(titel: "Environments test")

#test-env("content")

#test-env("appendix")

#test-env("test-env")
#marks.env-open("test-env")

#test-env("test-env")

#marks.env-close("test-env")
#test-env("test-env")

#anhang[
  #test-env("content")

  #test-env("appendix")
]

#test-env("content")

#test-env("appendix")
