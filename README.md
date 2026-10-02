# cooklang.org

Source for [cooklang.org](https://cooklang.org): the Cooklang language docs, the CookCLI reference, guides and the blog. Built with [Hugo](https://gohugo.io) and Tailwind CSS.

Fixes and new guides are welcome. Open a pull request against `main`.

## Run locally

You need **Hugo extended** (CI uses 0.139.4) and **Node 20**.

```sh
# Build the CSS once (re-run after changing layouts or classes)
cd themes/cooklang-tw
npm ci
npm run build-css      # or: npm run watch-css
cd ../..

hugo server
```

Then open [localhost:1313](http://localhost:1313/).

The built CSS (`themes/cooklang-tw/static/css/style.css`) is committed, so rebuild it whenever you change Tailwind classes in templates. Restart `hugo server` after editing templates.

## Where things live

| Path | Contents |
|---|---|
| `content/docs/` | Language docs and spec |
| `content/cli/` | CookCLI reference |
| `content/guides/` | How-to guides |
| `content/blog/` | Blog posts |
| `themes/cooklang-tw/` | Site theme: layouts, Tailwind config, CSS |

## Deploy

Every push to `main` builds the site and publishes it to the `gh-pages` branch (`.github/workflows/gh-pages.yml`). Pull requests get a build check (`pr-build.yml`).
