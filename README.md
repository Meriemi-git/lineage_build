# LineageOS jars builder

Ce dépôt sert à builder :
- framework.jar
- services.jar

pour les API :
- 33
- 34
- 35
- 36

en 2 variantes :
- vanilla
- patched

## Workflows
- build-jars-vanilla.yml
- build-jars-patched.yml

## Patchs
Les patchs sont rangés dans :
patches/sucre/apiXX/<repo>/*.patch

## Local manifests
Les manifests sont rangés dans :
local_manifests/sucre/apiXX/*.xml