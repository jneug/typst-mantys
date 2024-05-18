#import "/src/component/table-of-contents.typ": make-table-of-contents

#make-table-of-contents()

#pagebreak()

#set heading(numbering: "1.")

= Chapter
== Section
=== Subsection

#counter(page).update(9999)
#counter(heading).update(8)

= Chapter
#counter(heading).update((8, 22))
== Section
=== Subsection
