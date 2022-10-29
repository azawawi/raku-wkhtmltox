# Wkhtmltox
[![Actions
Status](https://github.com/azawawi/raku-wkhtmltox/workflows/test/badge.svg)](https://github.com/azawawi/raku-wkhtmltox/actions)

This modules converts HTML code to PDF or Image files using [`libwkhtmltox`](https://wkhtmltopdf.org/libwkhtmltox/) (aka `wkhtmltopdf`, `wkhtmltoimage`). It does not run `wkhtmltopdf` or `wkhtmltoimage` binaries thus
no extra CPU/memory cost for each conversion operation. It is suitable for batch
HTML to PDF/Image conversions.

**Note: This is currently experimental and API may change. Please DO NOT use in
a production environment.**

## Example

```raku
use v6;
use Wkhtmltox::PDF;

# Print library version
my $version = Wkhtmltox::PDF.version;
say "wkhtmltopdf version: $version";

# Create pdf object
my $pdf = Wkhtmltox::PDF.new;

# Print global setting values
say $pdf.get-global-setting("size.pageSize");

# Set global settings values
$pdf.set-global-setting("size.pageSize", "A4");

# Convert HTML to PDF
my $html = "Raku rocks!";
my $pdf-blob = $pdf.render($html);
"sample.pdf".IO.spurt($pdf-blob) if $pdf-blob.defined;

# Call only once to cleanup resources
$pdf.destroy;
```

## Installation

- Please [download](https://wkhtmltopdf.org/downloads.html) & install
  `libwkhtmltox` binaries.

- Install this module using [zef](https://github.com/ugexe/zef):

```
$ zef install Wkhtmltox
```

## Testing

- To run tests:
```
$ prove --ext .rakutest -ve "raku -I."
```

- To run all tests including author tests (Please make sure
[Test::Meta](https://github.com/jonathanstowe/Test-META) is installed):
```
$ zef install Test::META
$ AUTHOR_TESTING=1 prove --ext .rakutest -ve "raku -I."

# On windows
$ $env:AUTHOR_TESTING=1; prove --ext .rakutest -ve "raku -I."
```

## Author

Ahmad M. Zawawi, azawawi on #raku, https://github.com/azawawi/

## License

MIT License
