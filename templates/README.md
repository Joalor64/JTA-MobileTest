# Template overrides

Files here replace Lime's own templates (enabled in `Project.xml` via `<template path="templates" />`).

- `ios/template/{{app.file}}/{{app.file}}-Info.plist` — copy of Lime's iOS Info.plist
  (from Lime 8.4) with `UIFileSharingEnabled` and `LSSupportsOpeningDocumentsInPlace` added,
  so the game's Documents folder (`mods/`, `logs/`) shows up in the iOS Files app.
  If you update Lime and its template changes, re-copy it and add those two keys again.
