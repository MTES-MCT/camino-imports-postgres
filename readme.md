# Camino outils db

Outil pour convertir la base `titres_deb` (postgres) en fichier compatible avec Camino-front (json).

* La base de donnée `titres_deb` doit être installlée au préalable.
* Le fichier `env.example` doit être complété avec les informations de connexion, puis renommé en `env`.
* Les fichiers transformés sont accessibles dans le dossier `exports`.

```bash
# installation
npm i

# export du fichier
npm run build

# export avec re-load lorsque le fichier `query.sql` est modifié
npm run watch
```
