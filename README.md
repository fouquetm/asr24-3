# ✅ Nginx configuration validation

Ce projet utilise un script Bash et un environnement isolé pour **valider la syntaxe de la configuration Nginx** (`nginx.conf`) avant tout merge sur la branche principale. Cette validation s’exécute automatiquement via GitHub Actions lors des *pull requests*.

---

## 📁 Structure attendue

```
.
├── nginx-conf/
│   ├── nginx.conf        # Fichier de configuration principal à valider
│   └── mime.types        # (Optionnel) fichier des types MIME
├── scripts/
│   └── setup-nginx-test-env.sh  # Script Bash de préparation
├── .github/
│   └── workflows/
│       └── validate-nginx.yaml  # Pipeline GitHub Actions
```

---

## 🔧 Objectif du script `nginx-linter.sh`

Ce script :

- Crée un environnement de test dans `./nginx-conf/` avec :
  - Un répertoire `logs/` (nécessaire pour `access.log` / `error.log`)
  - Un répertoire `html/` contenant un `index.html` minimal
  - Un fichier `mime.types` généré si absent
- Vérifie que `nginx.conf` est bien présent
- Permet de lancer la validation via :

```bash
sudo nginx -t -c nginx.conf -p $(realpath ./nginx-conf)
```

---

## 🐳 Validation avec Docker (optionnelle)

Si tu ne veux pas installer Nginx en local, tu peux utiliser Docker :

```bash
make docker-test
```

Ou directement :

```bash
docker run --rm \
  -v $(pwd)/nginx-conf:/etc/nginx \
  nginx:latest \
  nginx -t -c /etc/nginx/nginx.conf
```

---

## 🧪 Exécution en local

### 1. Préparer l’environnement :

```bash
bash scripts/nginx-linter.sh
```

### 2. Valider la configuration :

```bash
sudo nginx -t -c nginx.conf -p $(realpath ./nginx-conf)
```

---

## 🤖 Pipeline GitHub Actions

À chaque `pull request`, le fichier `nginx.conf` est validé automatiquement grâce au fichier :

```
.github/workflows/nginx-pr.yml
```

Si la configuration est invalide, la PR échoue.
