Red [
    Author: ["Greg Tewalt"]
    File: %help-writer.red
    Tabs: 4
]

; #include %/<your-path/help.red       ;  to compile

usage: ["Usage:" crlf "./help-writer <function> <template>" crlf "./help-writer -a , --all <template>"]

args: system/script/args    ; to parse one string for command-line options like "--all asciidoc"
options: to block! trim/with args #"'"  ; system/option/args is a block of strings - want words
valid-func-types: [action! function! native! op! routine!]

options-rule:       ["-a" | "--all"]
template-rule:      ["asciidoc" | "markdown" | "latex" | "html"] 
function-name-rule: ["action!" | "function!" | "native!" | "op!" | "routine!"]
pluralize-dir-rule: [some [change #"!" #"s" | skip]]

; templates
asciidoc: ["===" space n crlf "[source, red]" crlf "----" crlf help-string (to-word :n) crlf "----"]
latex:    ["\documentclass {article} \title{" n "} \begin{document}" help-string (to-word :n) "\end{document}"]
markdown: ["###" space n crlf "```red" crlf help-string (to-word :n) crlf "```"]

html: [{
    <!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><title>} n {</title>
    <style>
    html{font-family:times;-ms-text-size-adjust:100%;-webkit-text-size-adjust:100%}
    h3 {font-family:"Times New Roman",times;font-weight:300;font-style:normal;color:#ba3925}
    code{font-family:"Times New Roman",monospace;font-weight:400;color:rgba(0,0,0,.9)}
    pre{color:rgba(0,0,0,.9);font-family:"Times New Roman",monospace;line-height:1.45;text-rendering:optimizeSpeed}
    </style>
    </head><body><h3 id="">} n {</h3><pre><code>} help-string (to-word :n) {</code></pre></body></html>}]


gather-function-names: func [txt] [
    ws: charset reduce [space tab cr lf]
    fnames: copy []
    rule: [s: collect into fnames any [ahead [any ws "=>" e:] b: keep (copy/part s b) :e | ws s: | skip]] ; rule by toomasv
    parse txt rule  ; grab all function names and put them in fnames block to loop through
]

make-dir-name: func [w [word!] parse-rule [block!] /local o][
    o: mold w
    parse o parse-rule
    dest: make-dir to-file rejoin [o '- options/2]
]

write-help: func [template [block!] /local ext][
    ext: case [
        template = asciidoc ['.adoc]
        template = html     ['.html]
        template = markdown ['.md]
        template = latex    ['.tex]
    ]
    foreach n fnames [
        f: copy n
        parse f [some [change #"?" "_question_" | change #"*" "_asterisk_" | skip]]                        
        either f = "is" [continue][write to-file rejoin [dest f ext] rejoin compose template]  ; can't write 'is' to file
    ]
]

do-all: does [
    foreach type-name valid-func-types [
        make-dir-name type-name pluralize-dir-rule
        gather-function-names help-string :type-name
        write-help reduce options/2
    ]
]

do-one: does [
    make-dir-name options/1 pluralize-dir-rule
    gather-function-names help-string :options/1
    write-help reduce options/2
]

main: does [
    unless parse args [any options-rule skip some template-rule (do-all) 
                | some function-name-rule skip some template-rule (do-one)][print usage]
]

main
