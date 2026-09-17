# Deploying this site

## The one command

```bash
npm run deploy
```

Builds `./dist` and pushes it to the live site. That's the whole routine.

## First time on a machine

```bash
git clone https://github.com/streamlined-plus/SC.git
cd SC
npm install        # installs @wix/cli
npm run login      # browser, one-time code
npm run deploy
```

`wix login` caches credentials **per machine**, in your home directory — not in
this repo. So:

- You do **not** have to deploy from any particular machine.
- Any machine with **Node 20.11.0+** and a clone works.
- A new machine costs one `npm install` + one `npm run login`. After that it's
  `npm run deploy` forever.

Check your Node version with `node -v` before the first login.

## What deploy actually does

1. `build.sh` wipes `dist/` and copies in the files that should be public —
   `index.html`, `services/`, `sitemap.xml`, `robots.txt`. Repo files (README,
   `package.json`, `.git`) are deliberately left out.
2. `wix release` uploads `dist/` to the Wix-managed headless project named in
   `wix.config.json`, publishes it, and clears the CDN cache.
3. The CLI prints the live URL when it finishes.

Deployed content still stale? Run `npm run deploy` again — that re-clears the
cache.

## The live project

| | |
|---|---|
| Site ID | `43940c7f-f343-4fb6-a32a-27a1fa3ccee9` |
| OAuth client (`appId`) | `b40a1002-9c0a-41ad-99ca-d17a046f829f` |
| Domain | www.streamlinedcontent.com (Premium) |
| Type | Editorless / Wix-managed headless |

Both IDs live in `wix.config.json`. That file is what makes `wix release` hit
*this* project instead of creating a new one.

## Never use the drop page to update

https://www.wix.com/headless/drop creates a **brand new site every time**. It
is for the very first upload and nothing else. Using it for updates is what
produced four near-identical sites and forced the domain to be reassigned by
hand each time.

Updating an existing site is `npm run deploy`. Always.

## Deploying from CI or an AI agent

```bash
npm install
npx wix login --api-key "$WIX_API_KEY"
npm run deploy
```

Create the key in the Wix dashboard under **Settings → API Keys**. Keep it in
an environment variable or secret store. Never commit it, never paste it into
a chat.

## Gotchas that already bit us

**`npx wix` fails with "could not determine executable to run."** npx looks for
a package named `wix`; the binary ships inside `@wix/cli`. Run `npm install`
first, or name it in full: `npx @wix/cli@latest release`.

**Links must be relative.** Every internal link is relative and names
`index.html` explicitly (`../local-search/index.html`). Site-absolute links
(`/services/...`) break the moment the site is served from anywhere other than
the domain root. Keep it that way.

**This is not Wix Git Integration / Velo.** That's a different system for
editor-built sites; it reads only `src/pages`, `src/backend` and `src/public`
and ignores root HTML entirely. An earlier config in this repo pointed there,
which is why pushing HTML changed nothing for days.
