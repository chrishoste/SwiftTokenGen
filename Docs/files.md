# Configuration for files

Please take note that the top-level keys, namely `output` and `inputs`, are mandatory. These keys determine the values (`inputs`) to be used for generating a specific file (`output`). Each `output` corresponds to the generation of a single file. `inputs` on the other hand is an array and therefor you can define multiple inputs for one output. 

```yaml
files: 
  - output:
      template: static-single-value
      output: Generated/DesignTokenBreakpoints.swift
      params:
        objectName: "DesignTokenBreakpoints"
    inputs: 
      - keys: [breakpoints]
        keysAsNamePrefix: true
        process:
          sortBy: value
        params:
          objectName: Breakpoints
```
```yaml
files: 
    - output:
      template: static-typography
      output: Generated/DesignTokenTypographys.swift
      params:
        objectName: "DTFontStyle"
    inputs: 
      - keys: [typography, interface]
        keysAsNamePrefix: true
        params:
          objectName: Interface
      - keys: [typography, tv]
        keysAsNamePrefix: true
        params:
          objectName: TV
```

It is also possible to define multiple outputs simultaneously. The `files` field accepts an array of outputs. 

```yaml
files: 
  - output: ...
    inputs: ...
  - output: ...
    inputs: ...
```

## `output`

The `output` section defines the output file settings.

- `template *` : Specifies the template to be used for generating the output. You can either utilize a pre-defined template as shown in the example configuration above or provide a relative path from your current working directory to your own custom template using [stencil](https://github.com/stencilproject/Stencil).
- `output *`: Specifies the path and filename for the generated output file.
- `params`: Additional parameters for the template. Certain templates may require specific values defined within this section. You can also include your custom static values here.

## `inputs`

The `inputs` section defines the input file settings.

- `keys`* : Specifies the key path (including nested keys) to be used as input. If `keysAsNamePrefix` is not required and you do not have nested values, you can simply use the top-level key.
- `keysAsNamePrefix`: If set to `true`, the nested keys are used as a name prefix after the defined input key.
- `process`: Additional processing options for the input.
  - `sortBy`: Specifies how the input should be sorted (e.g., by `value` or by the key of your value).
- `params`: Additional parameters for the input. Certain templates may require specific values defined within this section. You can also include your custom static values here.

(`*`) mandatory

# Examples (WIP)