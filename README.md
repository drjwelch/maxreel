## Building the site

- Select the environment `venv\Scripts\activate`
- Build the site in the local repo: `sigal build --debug images/`
- Push to remote (github)
- Site will build in under 2 mins then refresh at github pages

## Sigal Configuration

`sigal.conf.py`

Non-default settings:
```
title = "Max's Football Highlights"
source = "images"
destination = '.'
theme = "photoswipe"
user_css = 'tags.css'
video_converter = 'C:\\Users\\jwelch\\AppData\\Local\\Microsoft\\WinGet\\Links\\ffmpeg.exe'
output_filename = 'gallery.html'
index_in_url = True
```

Root level `index.html` has to be provided as static file as `gallery.html` won't be served by default

## Metadata Automation

Added program `makemeta.py` with one command line argument (subdirectory of images/ to process)
Parses `meta.txt` to retrieve metadata for each image file
Builds `.md` file for each image so that sigal can consume it 

## Sigal Customisations

### Showing homepage on breadcrumbs

`venv/Lib/sigal/themes/default/templates/breadcrumb.html`

Added the first line to Jinja code:

```
      <a href="../index.html">Home</a> » <a href="../gallery.html">Galleries</a> » 
      {% for url, title in album.breadcrumb %}
        <a href="{{ url }}">{{ title }}</a>{% if not loop.last %} » {% endif %}
      {% endfor -%}
```

This will stop working if we ever have nested galleries because .. won't navigate to home.  We can't hard-code it as / because the root url depends on where it's hosted (local is / but on github pages it's /maxreel).

### Defining image tags

Added `.md` file per video containing the metadata

Format is `tags:tag;tag;tag` followed by blank line then free text description 

### Showing tags by images

`venv/Lib/sigal/themes/default/templates/description.html`

Added the following Jinja code to show tags under captions:

```
  {%- if media.meta.tags -%}
    {% set tags = media.meta.tags[0].split(';') %}
    {% for tag in tags %}
        <p class="tag-lozenge">{{tag}}</p>
    {% endfor %}
  {%- endif -%}
```

### Styling tags

`tag.css`

Defines `.tag` class for tag styling as lozenge
Added to root of repo and referenced in `sigal.conf.py` as `user_css=`

### Optional caption placement control

`venv/Lib/sigal/themes/photoswipe/templates/album.html`

Line 18: set caption plugin type config to below to make captions appear under videos

