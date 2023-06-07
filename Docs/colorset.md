# Configuration for xcasset/colorset

Please note that the top-level keys, namely `output` and `input`, are mandatory. These keys determine the values (`input`) to be used for generating a specific xcasset (`output`). Each output corresponds to the generation of an xcasset.

```yaml
xcassets: 
  images: 
  colors:
    - output: Generated/Colors.xcassets
      input: 
        keys: [light, colors]
        keysAsNamePrefix: true
      adaptive: 
          keys: [dark, colors]
```
```yaml
xcassets: 
  images: 
    - output: Generated/ColorsDarkOnly.xcassets
      input: 
        keys: [dark, colors]
        keysAsNamePrefix: true
      process:
        addSuffix: DarkOnly
```

It is also possible to define multiple outputs simultaneously.

```yaml
xcassets: 
  colors: 
  - output: ...
    input: ...
  - output: ...
    input: ...
```

## `output`

The `output` specifies the path and filename for the generated xcasset.

## `input`

The `input` section defines the input settings.

- `keys`*: Specifies the key path (including nested keys) to be used as input. If `keysAsNamePrefix` is not required and you do not have nested values, you can simply use the top-level key.
- `keysAsNamePrefix`: If set to `true`, the nested keys are used as a name prefix after the defined input key.
- `process`: Additional processing options.
    - `addSuffix` (e.g., by `Suffix`): This will add the specified suffix to the name of the color. (`background` => `backgroundSuffix`)
    - `addPrefix` (e.g., by `prefix`): This will add the specified suffix to the name of the color. (`background` => `prefixBackground`)
- `adaptive`: You have the possibility to create a color set with a color for any and dark.
    - `keys`: Specifies the key path (including nested keys) to be used as input for adaptive color. Keep in mind that they have to be named exactly the same as the `any` input keys above to be able to be matched together as adaptive color.
- `params`: Additional parameters for the input. Certain templates may require specific values defined within this section. You can also include your custom static values here.
(`*` mandatory)

# Examples (WIP)