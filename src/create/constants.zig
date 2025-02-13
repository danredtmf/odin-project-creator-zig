pub const PROGRAM_HELP =
    \\---------------------------------------
    \\| ODIN Project Creator. Version 0.0.2 |
    \\---------------------------------------
    \\
    \\Usage:
    \\  program <project-name> [--ols] [--vscode]
    \\
    \\Parameters:
    \\  <project-name>  - project name (required);
    \\  [--ols]         - creates ols.json (optional);
    \\  [--vscode]      - creates .vscode folder with launch.json
    \\                    and tasks.json files (optional).
;
pub const MAIN_ODIN_DATA =
    \\package main
    \\
    \\import "core:fmt"
    \\
    \\main :: proc() {
    \\    fmt.println("Hello, World!")
    \\}
;
pub const OLS_JSON_CONTENT =
    \\{
    \\  "$schema": "https://raw.githubusercontent.com/DanielGavin/ols/master/misc/ols.schema.json",
    \\  "enable_document_symbols": true,
    \\  "enable_hover": true,
    \\  "enable_snippets": true
    \\}
;
pub const VSCODE_LAUNCH_CONTENT =
    \\{
    \\  "version": "0.2.0",
    \\  "configurations": [
    \\    {
    \\      "name": "Launch",
    \\      "type": "cppdbg",
    \\      "request": "launch",
    \\      "program": "${workspaceFolder}/${workspaceFolderBasename}",
    \\      "args": [],
    \\      "cwd": "${workspaceFolder}"
    \\    }
    \\  ]
    \\}
;
pub const VSCODE_TASKS_CONTENT =
    \\{
    \\  "version": "2.0.0",
    \\  "tasks": [
    \\    {
    \\      "label": "Build Release",
    \\      "type": "shell",
    \\      "command": "odin build .",
    \\      "group": {
    \\        "kind": "build",
    \\        "isDefault": false
    \\      }
    \\    },
    \\    {
    \\      "label": "Build Debug",
    \\      "type": "shell",
    \\      "command": "odin build . -debug",
    \\      "group": {
    \\        "kind": "build",
    \\        "isDefault": true
    \\      }
    \\    }
    \\  ]
    \\}
;