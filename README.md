![header](https://github.com/chrishoste/SwiftTokenGen/assets/22995847/2585cab5-07e8-4452-8646-e0efc5d591c8)

[![Swift](https://img.shields.io/badge/Swift-5.7_5.8-green)](https://img.shields.io/badge/Swift-5.7_5.8-Green)
[![Platforms](https://img.shields.io/badge/Platforms-macOS_iOS_tvOS_watchOS_Linux-green)](https://img.shields.io/badge/Platforms-macOS_iOS_tvOS_watchOS_Linux_Windows-Green)

# SwiftTokenGen
Effortlessly generate code from DesignTokens. Decode Figma exports or Amazon Style Dictionary JSON. Seamlessly populate stencil templates for enhanced development. Simplify development with SwiftTokenGen.

# ⚙️ Installation
To install the `swift-token-gen` tool for your open-source project, you have two options:

## Option 1: Download the Binary
1. Visit the GitHub page for the latest release or previous releases of `swift-token-gen`.
2. Locate the `swift-token-gen-x.y.z.zip` file associated with the desired release.
3. Download the ZIP file.
4. Extract the content of the ZIP file.

After extraction, you will have a somewhat following file path to the binary:

```sh
${PROJECT_DIR}/swift-token-gen-x.y.z/bin/swift-token-gen
```

Advantages of this method:
* You can commit the `swift-token-gen` binary with your project, ensuring that all project members use the same version.
* You can also invoke `swift-token-gen` within your build phases in xcode.

## Option 2: Clone or Download the Repository
1. Download or clone the repository for `swift-token-gen` to your local machine.
2. Open a terminal and navigate to the directory where you downloaded or cloned the repository.
3. Build the project using the following command:

```sh
swift build -c release
````

This command will compile the code and generate an optimized release build.

4. After the build process completes successfully, you can find the built executable in the `.build` folder within the project directory.

```sh
${PROJECT_DIR}/.build/release/swift-token-gen
```
Use this path to invoke the `swift-token-gen` tool.

Advantages of this method:
* You have direct access to the latest source code and can make modifications if needed.

## Option 3: Work in Progress: brew & mint
I am also exploring the use of `brew` and `mint` as package managers to make the installation of `swift-token-gen` even easier. However, I am currently facing an issue with the Resource Bundle. Once I resolve this issue, I will provide instructions for installing via brew and mint.


# 🚀 Usage
Once you have successfully installed `swift-token-gen`, you can use it to generate Swift code based on your configuration files and design token. `swift-token-gen` accepts YAML format configuration files and JSON format design tokens.

## Basic Usage
To use the tool for its main purpose, follow these steps:

**Prepare your configuration file(s) in YAML format. You can provide one or more configuration files to define your desired output.**

```sh
swift-token-gen -c config1.yml config2.yml
```

If you don't specify any configuration file(s), `swift-token-gen` will look for a `swift-token-gen.yml` file in the current working directory and use it as the configuration.

**Prepare your token file in JSON format. The token should be in either Amazon Style dictionary format or DesignToken Figma format.**

```sh
swift-token-gen -t token.json
```

If you don't specify a token file, `swift-token-gen` will look for a `token.json` file in the current working directory and use it as the token.

`swift-token-gen` will process the configuration file(s) and token to generate Swift code based on your specifications.

The generated Swift code will be saved to a specified location, depending on your configuration settings.

## Example Usage
Here's an example command that combines the usage of configuration and token files:

```sh
swift-token-gen -c config.yml -t token.json
```

This command uses the `config.yml` file as the configuration and the `token.json` file as the token. The tool will generate Swift code based on these files. 

Remember to adjust the filenames and paths according to your actual configuration and token file names. 

By default, the tool assumes that the configuration and token files are located in the current working directory. If you prefer to place the files in a different directory, specify the full path to the files in the command.

## Minimal Usage

```sh
swift-token-gen
```
The command above 👆 will default to the command below 👇.

```sh
swift-token-gen --config swift-token-gen.yml --token token.json
```

Enjoy using `swift-token-gen` to generate Swift code efficiently based on your configuration files and tokens!

# Configuration `swift-token-gen.yml` & examples
⚒️ WIP ⚒️
1. files
2. xcassets

# Design Token `token.json`
⚒️ WIP ⚒️