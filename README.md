## Building the site

- Select the environment `venv\Scripts\activate`
- Build the site in the local repo: `sigal build --debug images/`
- Push to remote (github)
- Site will build in under 2 mins then refresh at github pages

## Sigal Customisation for Tagging

### Defining image tags

Added `.md` file per video containing the metadata

Format is `tags:tag;tag;tag` followed by blank line then free text description 

### Showing tags by images

`venv/Lib/sigal/themes/default/templates/description.html`

Added the folloing Jinja code to show tags under captions:

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

