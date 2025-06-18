# clang-tidy plugin csupport

clang-tidy plugin to perform additional checks on C source code.


## What checks `clang-tidy plugin csupport` do

- `csupport-return-value-null-check`
  
    For functions(malloc, realloc, calloc, fopen) that require the NULL check
   on the return value, 
    - check if an if statement for the Null check is written on the next line.
    - check if function's sentence is in the condition of if/while/do-while statement. (This is experiment. the specification is not finalized.)


## How to build

### OS Linux（Ubuntu）

1. Install packages
```bash
sudo apt-get install \
            make \
            cmake \
            clang \
            clang-tidy \
            libclang-dev
```

2. Compile plugin

```bash
git clone https://github.com/alma-emu/clang-tidy-plugin-csupport.git
cd clang-tidy-plugin-csupport
mkdir build
cd build
cmake ..
make
# => check if `build/lib/libclang-tidy-plugin-csupport.so` is created.
```

### OS Windows/Mac

... not yet confirmed ...


## How to check with `clang-tidy plugin csupport`

Please run clang-tidy with the following arguments.

```bash
clang-tidy \
  -checks="-*,csupport-*" \
  -load=/path/to/libclang-tidy-plugin-csupport.so \
  -p=/path/to/compile_commands.json \
  main.c
```

About the clang-tidy arguments

-  `-checks="-*,csupport-*"`

      specify check items as comma-separeted items. the "-" symbol before a check name disables it.
      wildcards can also be specified with an asterisk.
      - `-*`                   ... disable all checks.
      - `csupport-*`           ... enable only `clang-tidy plugin csupport` related checks

-  `-load=/path/to/libclang-tidy-plugin-csupport.so`

      path to plugin

-  `-p=/path/to/commpile_commands.json`

      path to compile_commands.json for your c project

-  `main.c`

      target c source file name

Other Memo

This is not enabled for the clangd server's LSP protocol.
The clang-tidy plugin does not support such usage. Please add
`clang-tidy plugin csupport` execution after compiling in your Makefile
or CMakeLists.txt.
