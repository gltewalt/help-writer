![writer](assets/write.png) 

# help-writer

Writes interactive help content for `any-function!` types to HTML, Asciidoc, or Markdown files.

### Usage

* Interpreted

```red
./red help-writer.red function! asciidoc

./red help-writer.red action! latex

./red help-writer.red -a, --all markdown

./red help-writer.red op! html
```

* Compiled 

```red
./help-writer native! asciidoc

./help-writer routine! latex

./help-writer -a, --all markdown

./help-writer op! html
```

----
![command line](assets/screen1.png)

----
![folders](assets/screen2.png)

----
![files](assets/screen3.png)
