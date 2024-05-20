#import "/src/util.typ"

#show heading.where(level: 1): it => pagebreak(weak: true) + it
#set page(width: 100pt, height: auto)

#util.alert[Alert]

#util.hint[Hint]
#util.info[Info]
#util.warn[Warn]
#util.error[Error]
