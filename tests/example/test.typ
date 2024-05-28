#import "/src/example.typ"

#show heading.where(level: 1): it => pagebreak(weak: true) + it
#set page(height: auto, header: counter(footnote).update(0))

= Code
#example.frame(
  ```typst
  #block(inset: 1em, stroke: red)[Hello World]
  ```,
)

= Eval
#example.code-result(
  ```typst
  #block(inset: 1em, stroke: red)[Hello World]
  ```,
)
