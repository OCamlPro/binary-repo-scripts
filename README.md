Scripts pour faire le dépôt Debian 10.4 sur amd64
=================================================

Creer un fichier env.sh avec par exemple:

```
#!/bin/bash

OPAMBIN_SRCDIR=$HOME/GIT/opam-bin/
OPAMBIN_REPO=$HOME/GIT/opam-bin-repository

# These ones must be local
OPAM_REPO=$HOME/GIT/opam-repository
PATCHES_DIR=$HOME/GIT/relocation-patches

BASE_URL=https://www.origin-labs.com/opam-bin/debian10.4-amd64
REMOTE_URL=www.origin-labs.com:/home/www.origin-labs.com/www/opam-bin/debian10.4-amd64
```

où
* OPAMBIN_SRCDIR: un clone de git@github.com:ocamlpro/opam-bin
* OPAMBIN_REPO: un clone de git@github.com:ocamlpro/opam-bin-repository
* OPAM_REPO: un clone de git@github.com:ocaml/opam-repository
* PATCHES_DIR: un clone de git@github.com:ocamlpro/relocation-patches
* BASE_URL: l'URL finale du dépot publié
* REMOTE_URL: la cible pour rsync pour publier le dépot

Les scripts fonctionnent ainsi:
* on suppose qu'une copie du dépot complet se trouve dans `remote/` et
  qu'opam va travailler dans `root/`
* on fait `./update-binary-repo.sh` pour initialiser tout
* on fait `. ./set-opamroot.sh` pour initialiser OPAMROOT

Au jour le jour:
* on fait `opam bin pull` pour copier `remote/` dans
  `root/plugins/opam-bin/store`
* on lance `./continue-binary-repo.sh -XXX` où il existe un fichier
   `distribution-XXX.txt` avec des paquets versionnés. Ça compile ces paquets
   et ajoute les paquets binaires
* on lance `opam bin push` pour copier les paquets dans `remote/`
* on lance `./push-remote.sh` pour pousser `remote/` vers $REMOTE_URL

Avec des multi-dépots:
* les paquets sont toujours générés dans $OPAMROOT/plugins/opam-bin/store/repo,
  il faut donc parfois faire des modifs:
```
  cd  $OPAMROOT/plugins/opam-bin/store
  mv repo repo.backup
  mv 4.10.0 repo
```
* créer qques paquets pour 4.10.0
* Ensuite:
```
  cd  $OPAMROOT/plugins/opam-bin/store
  mv repo 4.10.0
  mv repo.backup repo
```

Il est possible de "tuner" les header/trailer des fichiers index.html
générés:
```
opam bin push --local-only
mkdir -p $OPAMROOT/plugins/opam-bin/store/repo/_site
cp $OPAMROOT/plugins/opam-bin/header.html.template $OPAMROOT/plugins/opam-bin/store/repo/_site/header.html
```
puis éditer le fichier `header.html`.
Il est ensuite utiliser à chaque `opam push`

Le script `create-maxi.sh` montre une heuristique pour créer la
distribution `distribution-maxi.txt` à partir de
`distribution-4.10.0.txt`. Il faut ensuite expurger certaines lignes
qui ne correspondent pas à des paquets en testant:

```
opam install $(cat distribution-maxi.txt) --show-actions
```
jusqu'à ce qu'il n'y ait plus d'erreur
