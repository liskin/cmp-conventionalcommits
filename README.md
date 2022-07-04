# cmp-conventionalcommits

**Alpha — Work *not* in progress**

See the [parent fork](https://github.com/davidsierradz/cmp-conventionalcommits)
for a more featureful plugin with commitlint and lerna integrations.

![example_1](https://user-images.githubusercontent.com/9190258/139169092-a44587c8-725c-4296-b2bf-24fb6dbc381a.png)

## Setup

Setup in `after/ftplugin/gitcommit.lua`

```lua
require'cmp'.setup.buffer {
  sources = require'cmp'.config.sources(
    {{ name = 'conventionalcommits' }},
    {{ name = 'buffer' }}
  ),
}
```
