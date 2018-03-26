# Camino db

Outil pour convertir la base `titres_deb` au format postgres en fichier json compatible avec Camino-front.

* La base de donnée `titres_deb` doit être installlée au préalable.
* Le fichier `env.example` doit être complété avec les informations de connexion, puis renommé en `env`.

```bash
# installation
npm i

# export du fichier
npm run build

# export avec re-load lorsque le fichier `query.sql` est modifié
npm run watch
```
