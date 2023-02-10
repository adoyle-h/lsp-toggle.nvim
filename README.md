# lsp-toggle.nvim

Disable/Enable LSP clients for buffers.

![preview.gif](https://raw.githubusercontent.com/adoyle-h/_imgs/master/github/lsp-toggle/preview.gif)

## Dependencies

- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig): It is required.
- [null-ls.nvim](https://github.com/jose-elias-alvarez/null-ls.nvim): It is optional.
- [telescope](https://github.com/nvim-telescope/telescope.nvim): It is optional.
- [telescope-find-pickers.nvim](https://github.com/keyvchan/telescope-find-pickers.nvim): It is optional. If you use [telescope](https://github.com/nvim-telescope/telescope.nvim), it's highly recommended to install the plugin.

## Versions

Read the [tags][]. The versions follows the rules of [SemVer 2.0.0](http://semver.org/).

## Installation

### Using vim-plug

```lua
Plug 'neovim/nvim-lspconfig'
Plug 'adoyle-h/lsp-toggle.nvim'
```

### Using packer.nvim

```lua
use { 'neovim/nvim-lspconfig' }
use { 'adoyle-h/lsp-toggle.nvim' }
```

### Using dein

```lua
call dein#add('neovim/nvim-lspconfig')
call dein#add('adoyle-h/lsp-toggle.nvim')
```

## Usage

```lua
require('lsp-toggle').setup()
```

or

```lua
require('lsp-toggle').setup {
  create_cmds = true, -- Whether to create user commands
  telescope = true, -- Whether to load telescope extensions
}
```

It provides two commands:

- `ToggleLSP`: Disable/Enable LSP for current buffer.
- `ToggleNullLSP`: Disable/Enable NullLS source for all buffers.

These commands use `vim.ui.select` to open a select window for LSPs.

If telescope enabled, it will load two telescope extensions which named `ToggleLSP` and `ToggleNullLSP`.

## Suggestion, Bug Reporting, Contributing

**Before opening new Issue/Discussion/PR and posting any comments**, please read [Contributing Guidelines](https://gcg.adoyle.me/CONTRIBUTING).

## Copyright and License

Copyright 2022-2023 ADoyle (adoyle.h@gmail.com). Some Rights Reserved.
The project is licensed under the **Apache License Version 2.0**.

See the [LICENSE][] file for the specific language governing permissions and limitations under the License.

See the [NOTICE][] file distributed with this work for additional information regarding copyright ownership.

## Other Projects

- [one.nvim](https://github.com/adoyle-h/one.nvim): All-in-one neovim configuration framework implemented with Lua.
- [Other lua projects](https://github.com/adoyle-h?tab=repositories&q=&type=source&language=lua&sort=stargazers) created by me.


<!-- Links -->

[LICENSE]: ./LICENSE
[NOTICE]: ./NOTICE
[tags]: https://github.com/adoyle-h/lsp-toggle.nvim/tags
