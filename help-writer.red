Red [
    Title:   ["Help Writer"]
    Author:  ["Greg Tewalt"]
    File: %help-writer.red
    Usage: {
        /red help-writer.red function! asciidoc
        /red help-writer.red native! markdown
        /red help-writer.red -a markdown
    }
]

#include %/home/gt/Desktop/Help-Writer/help.red       ;  to compile

opts: to block! trim/with system/script/args #"'"  ; multiple args are a weird string format, we need words in a block

; for command-line input validation - used in main
; ----------------------------------------------------------------------------------------------------------------------
valid-func: [action! function! native! op! routine!]
valid-template: [asciidoc markdown html]
usage: ["Usage: ./help-writer <function> <template>"]
all-usage: ["Usage: ./help-writer -a <template>"]

contains?: func [thing [block!] value [word!]][
    either find thing value [true][false]
]
;---------------------------------------------------------------------------------------------------------------------------

get-help-text: func [w][help-string :w]

gather-function-names: func [txt] [
    ws: charset reduce [space tab cr lf]
    fnames: copy []
    rule: [s: collect into fnames any [ahead [any ws "=>" e:] b: keep (copy/part s b) :e | ws s: | skip]] ; rule by toomasv
    parse txt rule  ; grab all function names and put them in fnames block to loop through
]

; templates
asciidoc: ["===" space n crlf "[source, red]" crlf "----" crlf help-string (to-word :n) crlf "----"]
markdown: ["###" space n crlf "```red" crlf help-string (to-word :n) crlf "```"]
html:     [] 

write-help: func [template [block!] /local ext][
    ext: case [
        template = asciidoc ['.adoc]
        template = markdown ['.md]
        template = html     ['.html]
    ]
    foreach n fnames [
        ; may not work - windows doesn't like ? and * in dir names
        if system/platform = 'Windows [parse n [some [change #"?" "_q" | change #"*" "_asx" | skip]]] 
        either n = "is" [continue][write to-file rejoin [dest n ext] rejoin compose template]  ; can't write 'is' op! to file
        write to-file rejoin [dest n ext] rejoin compose template
    ] 
]

main-all: does [
    either all [contains? valid-template opts/2 2 = length? opts][
        foreach f valid-func [
            gather-function-names get-help-text :f 
            ; remove -a from opts/1, replace it with function category 
            dest: make-dir to-file rejoin compose [(replace mold opts/1 "-a" f) '- opts/2] 
            write-help reduce opts/2
        ]
    ][print all-usage exit]
]

main: does [
    either opts/1 = '-a [main-all][
    either all [
                contains? valid-func opts/1 
                contains? valid-template opts/2
                2 = length? opts
                ][
                    gather-function-names get-help-text :opts/1
                    ; remove ! from any-function word, pluralize it with 's', combine with template word to create dir name
                    dest: make-dir to-file rejoin compose [(replace mold opts/1 "!" "s") '- opts/2] 
                    write-help reduce opts/2][print usage exit]
    ]
]

main 