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

Added the first two lines to Jinja code to put Home and Gallery (list) onto breadcrumb (allowing for depth which changes depending on where we're deployed):

```
      {% set depth, slash = (album.breadcrumb|length, 1) if album.breadcrumb else (0, 0) %}
      <a href="{{'..'*depth}}{{'/'*slash}}index.html">Home</a> » <a href="{{'..'*depth}}{{'/'*slash}}gallery.html">Galleries</a> » 
{% if album.breadcrumb %}
      {% for url, title in album.breadcrumb %}
        <a href="{{ url }}">{{ title }}</a>{% if not loop.last %} » {% endif %}
      {% endfor -%}
{% endif %}
```

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

### Showing tag colours and intro text on albums

`venv/Lib/sigal/themes/photoswipe/templates/album.html`

Changed the figcaption (which has a bug referenceing media_description instead of media.description) to add the tag colour blobs:
```
          <figcaption style="display: block;">
  {%- if media.meta.tags -%}
    {% set tags = media.meta.tags[0].split(';') %}
    {% for tag in tags %}
        <p class="tag-lozenge {{tag}}">&nbsp;&nbsp;&nbsp;</p>
    {% endfor %}
  {%- endif -%}
          </figcaption>
```
In this file and `album_list.html` (the root level) some intro text and the tag lozenges are added at the top.

### Styling tags and header

`tag.css`

Defines `.tag` class for tag styling as lozenge
Added to root of repo and referenced in `sigal.conf.py` as `user_css=`

Modifies the h1 style to reduce margin below

### Optional caption placement control

`venv/Lib/sigal/themes/photoswipe/templates/album.html`

Line 18: set caption plugin type config to below to make captions appear under videos

