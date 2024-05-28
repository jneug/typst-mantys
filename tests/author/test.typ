#import "/src/author.typ"

#show heading.where(level: 1): it => pagebreak(weak: true) + it
#set page(width: auto, height: auto)

= Name
#author.name("Knuth", short: 0)

#author.name("Donald", "Knuth", short: 0)

#author.name("Donald", "Ervin", "Knuth", short: 0)

#author.name("Knuth", short: 1)

#author.name("Donald", "Knuth", short: 1)

#author.name("Donald", "Ervin", "Knuth", short: 1)

#author.name("Knuth", short: 2)

#author.name("Donald", "Knuth", short: 2)

#author.name("Donald", "Ervin", "Knuth", short: 2)

= Author Inline
#author.author("Tinger", email: "me@tinger.dev")

#author.author("Tinger", label: <manual>)

#author.email(mark: sym.dagger, <manual>, "me AT tinger.dev")

#author.author("Tinger", label: <tinger>)

#author.author("John", "Doe", label: <univeristy>)

#author.email(<tinger>, "me@tinger.dev")

#author.email(<univeristy>, "john@university.edu")
