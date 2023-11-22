# A outline.nvim external provider for asciidoc filetype

A Lazy.nvim example to use this provider.

```lua
  {
    'hedyhli/outline.nvim',
    config = function()
      require('outline').setup({
        providers = {
          priority = { 'lsp', 'coc', 'markdown', 'norg', 'asciidoc' },
        },
      })
    end,
    event = "VeryLazy",
    dependencies = {
      'msr1k/outline-asciidoc-provider.nvim'
    }
  },
```

## LICENSE

[MIT](./LICENSE)

And this provider is based on outline.nvim's markdown provider. 

[outline.nvim LICENSE](./LICENSE_outline.nvim)
