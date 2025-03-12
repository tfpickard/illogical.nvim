# illogical.nvim

**illogical.nvim** is a lightweight Neovim plugin written in Lua that toggles logical values and cycles through different case variations of the word "true". It comes with default keybindings so that you only need to load the plugin.

## Features

- **Toggle Logical Values:**  
  Automatically flips logical words. For example, `"true"` becomes `"false"`, `"yes"` becomes `"no"`, etc.
  
- **Cycle "true" Variants:**  
  Cycle the word `"true"` through the variants: `true` → `True` → `TRUE` → `true`.

- **Default Keybindings:**  
  - `<leader>\``: Toggles logical values.
  - `<leader>~`: Cycles through the `"true"` variants.

## Installation

### Using Lazy.nvim

Add the following to your Lazy configuration:

```lua
{
  "yourusername/illogical.nvim",
}

Using Other Plugin Managers

Clone this repository into your plugin directory or use your favorite plugin manager.
Usage

    Open a file in Neovim.
    Place your cursor over a logical word (e.g., true, yes).
    Press:
        `<leader>`` to toggle it to its logical opposite.
        <leader>~ to cycle the word "true" through its variants.

Customization

If you wish to override the default keybindings, you can set your own mappings in your configuration. Otherwise, the plugin works out-of-the-box.
