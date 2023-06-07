# Configuration for xcasset/image

Please note that the top-level keys, namely `output` and `input`, are mandatory. These keys determine the values (`input`) to be used for generating a specific xcasset (`output`). Each output corresponds to the generation of an xcasset.

```yaml
xcassets: 
  images: 
    - output: Generated/Icons.xcassets
      input: Images/icons
      properties:
        preserves-vector-representation: true
        template-rendering-intent: template
```
```yaml
xcassets: 
  images: 
    - output: Generated/Illustrations.xcassets
      input: Images/illustrations
      properties:
        preserves-vector-representation: true
```
```yaml
xcassets: 
  images: 
    - output: Generated/PlainLogos.xcassets
      input: Images/logos-v2/plain
      properties:
        preserves-vector-representation: true
        template-rendering-intent: template
      process:
        addSuffix: Plain
```
```yaml
xcassets: 
  images: 
    - output: Generated/ColoredLogos.xcassets
      input: Images/logos-v2/colored
      properties:
        preserves-vector-representation: true
      process:
        addSuffix: Colored
```
```yaml
xcassets: 
  images: 
    - output: Generated/V1Logos.xcassets
      input: Images/logos-v1/any
      adaptive: 
          input: Images/logos-v1/dark
      properties:
        preserves-vector-representation: true
```

It is also possible to define multiple outputs simultaneously.

```yaml
xcassets: 
  images: 
  - output: ...
    input: ...
  - output: ...
    input: ...
```

## `output`

The `output` specifies the path and filename for the generated xcasset.

## `input`

The `input` specifies the path to the folder of images. Keep in mind that we currently only support single/universal images.

## `process`

- `process`: Additional processing options.
    - `addSuffix` (e.g., by `Suffix`): This will add the specified suffix to the name of the image. (`background` => `backgroundSuffix`)
    - `addPrefix` (e.g., by `prefix`): This will add the specified suffix to the name of the image. (`background` => `prefixBackground`)

## `adaptive`

- `adaptive`: You have the possibility to create a image set with a image for any and dark.
    - `input`: specifies the path to the folder of images. Keep in mind that they have to be named exactly the same as the `any` input above to be able to be matched together as adaptive image.

## `params`

- `params`: Additional parameters for the input. Certain templates may require specific values defined within this section. You can also include your custom static values here.

(`*` mandatory)

# Examples (WIP)