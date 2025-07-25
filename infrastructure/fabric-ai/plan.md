## install command
```bash
go install github.com/danielmiessler/fabric/cmd/fabric@latest
```
fabric is a tool for managing AI models and their dependencies, making it easier to work with various AI frameworks and libraries.

## setup command
```bash
fabric --setup --env .env
```

## Helper Apps
Fabric also makes use of some core helper apps (tools) to make it easier to integrate with your various workflows. Here are some examples:

### to_pdf
to_pdf is a helper command that converts LaTeX files to PDF format. You can use it like this:
```bash
to_pdf input.tex
```
This will create a PDF file from the input LaTeX file in the same directory.

You can also use it with stdin which works perfectly with the write_latex pattern:

```bash
echo "ai security primer" | fabric --pattern write_latex | to_pdf
```

This will create a PDF file named output.pdf in the current directory.

to_pdf Installation
To install to_pdf, install it the same way as you install Fabric, just with a different repo name.

```bash
go install github.com/danielmiessler/fabric/cmd/to_pdf@latest
```
Make sure you have a LaTeX distribution (like TeX Live or MiKTeX) installed on your system, as to_pdf requires pdflatex to be available in your system's PATH.

### code_helper
code_helper is used in conjunction with the create_coding_feature pattern. It generates a json representation of a directory of code that can be fed into an AI model with instructions to create a new feature or edit the code in a specified way.

See the Create Coding Feature Pattern README for details.

Install it first using:

```bash
go install github.com/danielmiessler/fabric/cmd/code_helper@latest
```