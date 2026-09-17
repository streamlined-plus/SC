# Streamlined Content — site

Static site for **streamlinedcontent.com**. No build step, no dependencies.

```
index.html                     homepage
services/index.html            services hub
services/websites/             \
services/local-search/          |  one page per service
services/content-systems/       |
services/lead-automation/      /
robots.txt, sitemap.xml
build.sh                       assembles ./dist (selects what ships)
wix.config.json                links this repo to the live Wix headless project
```

All internal links are **relative** and name `index.html` explicitly, so the
site works whether or not it is served from the domain root.

## Deploying

The site is a **Wix-managed headless project**. `wix.config.json` links this
repo to it, so `wix release` updates the *existing* site in place.

```bash
npm install           # installs @wix/cli (once)
npm run login         # browser auth, once per machine
npm run deploy        # build + deploy + publish + clear CDN cache
```

Requires **Node 20.11.0 or higher** (`node -v` to check).

Without `npm install`, `npx wix` fails with *"could not determine executable
to run"* — npx looks for a package called `wix`, but the binary ships in
`@wix/cli`. To run it without installing, name the package in full:
`npx @wix/cli@latest release`.

`wix release` prints the live URL when it finishes. If you deploy and still see
the old content, run `npx wix release` again — it clears the site cache.

### Deploying from CI or an AI agent

`wix login` also takes an API key, so no browser is needed:

```bash
npm install
npx wix login --api-key "$WIX_API_KEY"
npm run deploy
```

Create the key in the Wix dashboard under **Settings → API Keys**. Keep it in
an environment variable or secret store — never commit it.

### Do not use the drop page for updates

https://www.wix.com/headless/drop creates a **brand new site every time**. It
is for the first upload only. Updating an existing site is `wix release`.

## The live project

| | |
|---|---|
| Site ID | `43940c7f-f343-4fb6-a32a-27a1fa3ccee9` |
| OAuth client (`appId`) | `b40a1002-9c0a-41ad-99ca-d17a046f829f` |
| Domain | www.streamlinedcontent.com (Premium) |
| Editor type | Editorless (Wix-managed headless) |

> **Note:** this is *not* the Wix Git Integration / Velo setup. That is a
> different mechanism for editor-built sites, and it reads only `src/pages`,
> `src/backend` and `src/public` — it ignores root HTML files entirely. An
> earlier `wix.config.json` in this repo pointed at the old Wix Studio site
> (`7a44fe51-…`) through that system, which is why pushing HTML here never
> changed anything.

## Editing

Every page is a self-contained HTML file. Edit, then `npm run deploy`.
