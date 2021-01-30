# Help-Writer

Writes help-string content for different function types to asciidoc, markdown, or html files.

From the Red language help system.

### Usage

* Interpreted

```
./red help-writer.red function! asciidoc

./red help-writer.red action! markdown

./red help-writer.red -a markdown
```

* Compiled 

```
./help-writer native! asciidoc

./help-writer -a markdown
```
