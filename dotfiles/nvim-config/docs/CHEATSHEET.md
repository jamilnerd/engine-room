# neovim keymaps cheat sheet

## LSP

### Defaults

K         - vim.lsp.buf.hover()
grt       - vim.lsp.buf.type_definition()
grn       - vim.lsp.buf.rename()
gra       - vim.lsp.buf.code_action()
grr       - vim.lsp.buf.references()
gO        - vim.lsp.buf.document_symbol() (TOC, table of contents, outline in
Markdown files)

CTRL-W d  - Diagnostics under cursor in a floating window

gri       - vim.lsp.buf.implementation()
CTRL-S    - vim.lsp.buf.signature_help() -> insert mode only

### Customized (JAR)

grf    - vim.g.FormatCode()
grF    - vim.lsp.buf.format({timeout_ms = 20000})

[d     - previous diagnostic
]d     - next diagnostic

grd    - vim.lsp.buf.definition()

grl    - lopen
grL    - lclose

grs    - vim.lsp.buf.workspace_symbol()

## Diff (text and Git)

[c    - previous change
]c    - next change

## Location list

[l    - previous entry
]l    - next entry

[L    - first entry
]L    - last entry

## Quickfix

[q    - previous entry
]q    - next entry
:ccX  - go to Xth entry in quickfix list
:llX  - go to Xth entry in location list

[Q    - first entry
]Q    - last entry

## Visual selection between marks

Set a mark at the beginng with `m<` and at the end with `m>`, then use:

`'<` - go to beginning mark
`'>` - go to end mark
`:'<,'>` - select between marks in command mode
Press `gv` to select between the marks

## Rename terminal buffer

`:file term://myname`

## Histories

q: - command history
q/ - search history
q? - backward search history
gQ - Ex mode (exit with :vi)

## Spelling

`zg` - add word under cursor to dictionary
`zG` - add word under cursor to dictionary for current filetype only
`z=` - suggest spelling corrections for word under cursor

## Horizontal scrolling

Equivalents to zt and zb:

zs  " Place the cursor column at the left edge
ze  " Place the cursor column at the right edge

For fixed horizontal scrolling:

[count]zh  " Scroll left
[count]zl  " Scroll right
zH          " Scroll left by half a screen
zL          " Scroll right by half a screen

## Miscellaneous

CTRL-W f  - Split current window in two.  Edit file name under cursor.
CTRL-W F  - Split current window in two.  Edit file name under cursor at line
            following the file name under the cursor.

## kubectl

kubectl -n dev-opcua get pods
kubectl -n dev-opcua describe pod $pod

kubectl -n dev-opcua get cm
kubectl -n dev-opcua describe cm $cm

kubectl -n dev-opcua get secret
kubectl -n dev-opcua describe secret $secret
