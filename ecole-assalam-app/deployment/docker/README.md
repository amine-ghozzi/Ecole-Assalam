# Déploiement avec Docker

Guide pour déployer l'application École Assalam avec Docker et Docker Compose.

## Prérequis

- Docker Desktop (Windows/Mac) ou Docker Engine (Linux)
- Docker Compose

### Installation de Docker

**Windows :**
1. Téléchargez [Docker Desktop](https://www.docker.com/products/docker-desktop)
2. Installez et redémarrez
3. Vérifiez : `docker --version`

**Linux :**
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
```

## Déploiement rapide

### 1. Configuration

Créez un fichier `.env` dans `deployment/docker/` :

```env
DB_PASSWORD=VotreMotDePasseSecurise123!
```

### 2. Lancer l'application

```bash
cd deployment/docker
docker-compose up -d
```

L'application sera accessible sur :
- **Frontend** : http://localhost:8080
- **Backend** : http://localhost:3000
- **PostgreSQL** : localhost:5432

### 3. Vérifier le statut

```bash
docker-compose ps
```

### 4. Voir les logs

```bash
# Tous les services
docker-compose logs -f

# Backend uniquement
docker-compose logs -f backend

# Frontend uniquement
docker-compose logs -f frontend
```

## Commandes utiles

### Arrêter l'application

```bash
docker-compose down
```

### Redémarrer

```bash
docker-compose restart
```

### Reconstruire les images

```bash
docker-compose up -d --build
```

### Nettoyer complètement

```bash
# Arrêter et supprimer les conteneurs et volumes
docker-compose down -v

# Supprimer les images
docker-compose down --rmi all
```

## Déploiement sur un serveur Linux

### 1. Préparer le serveur

```bash
# Se connecter au serveur
ssh user@votre-serveur.com

# Installer Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Installer Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### 2. Cloner le projet

```bash
git clone https://github.com/votre-username/ecole-assalam.git
cd ecole-assalam/deployment/docker
```

### 3. Configurer

```bash
# Créer le fichier .env
nano .env
```

Contenu :
```env
DB_PASSWORD=VotreMotDePasseSecurise123!
```

### 4. Lancer

```bash
docker-compose up -d
```

### 5. Configurer Nginx comme reverse proxy (optionnel)

```bash
sudo apt install nginx

# Créer la configuration
sudo nano /etc/nginx/sites-available/ecole-assalam
```

Contenu :
```nginx
server {
    listen 80;
    server_name votre-domaine.com;

    location / {
        proxy_pass http://localhost:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

    location /api/ {
        proxy_pass http://localhost:3000/api/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

Activer :
```bash
sudo ln -s /etc/nginx/sites-available/ecole-assalam /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

### 6. Configurer SSL avec Let's Encrypt

```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d votre-domaine.com
```

## Configuration avancée

### Variables d'environnement

Éditez `docker-compose.yml` pour ajouter des variables :

```yaml
backend:
  environment:
    - DATABASE_URL=...
    - PORT=3000
    - NODE_ENV=production
    - CUSTOM_VAR=valeur
```

### Volumes persistants

Les données PostgreSQL sont stockées dans un volume Docker nommé `postgres_data`.

Pour sauvegarder :
```bash
docker run --rm -v deployment_postgres_data:/data -v $(pwd):/backup alpine tar czf /backup/backup.tar.gz -C /data .
```

Pour restaurer :
```bash
docker run --rm -v deployment_postgres_data:/data -v $(pwd):/backup alpine tar xzf /backup/backup.tar.gz -C /data
```

### Scaling

Pour exécuter plusieurs instances du backend :

```bash
docker-compose up -d --scale backend=3
```

Ajoutez ensuite un load balancer (Nginx, Traefik, etc.)

## Monitoring

### Logs en temps réel

```bash
docker-compose logs -f --tail=100
```

### Utilisation des ressources

```bash
docker stats
```

### Health checks

Les services incluent des health checks. Vérifiez :

```bash
docker inspect deployment-backend-1 | grep -A 10 Health
```

## Déploiement en production

### Recommandations

1. **Utilisez des secrets** : Ne mettez jamais de mots de passe dans docker-compose.yml
2. **Limitez les ressources** :
```yaml
backend:
  deploy:
    resources:
      limits:
        cpus: '0.5'
        memory: 512M
```

3. **Utilisez un reverse proxy** : Nginx, Traefik, ou Caddy
4. **Configurez SSL** : Let's Encrypt via Certbot
5. **Sauvegardez régulièrement** : Automatisez les backups de la base de données
6. **Monitoring** : Ajoutez Prometheus + Grafana

### Exemple avec Traefik

```yaml
version: '3.8'

services:
  traefik:
    image: traefik:v2.10
    command:
      - "--api.insecure=true"
      - "--providers.docker=true"
      - "--entrypoints.web.address=:80"
      - "--entrypoints.websecure.address=:443"
      - "--certificatesresolvers.myresolver.acme.tlschallenge=true"
      - "--certificatesresolvers.myresolver.acme.email=votre@email.com"
      - "--certificatesresolvers.myresolver.acme.storage=/letsencrypt/acme.json"
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./letsencrypt:/letsencrypt
    networks:
      - ecole-network

  backend:
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.backend.rule=Host(`api.votre-domaine.com`)"
      - "traefik.http.routers.backend.entrypoints=websecure"
      - "traefik.http.routers.backend.tls.certresolver=myresolver"
```

## Dépannage

### Le backend ne se connecte pas à la base de données

Vérifiez les logs :
```bash
docker-compose logs postgres
docker-compose logs backend
```

Vérifiez la connectivité :
```bash
docker-compose exec backend ping postgres
```

### Le frontend ne peut pas joindre le backend

Vérifiez le réseau Docker :
```bash
docker network inspect deployment_ecole-network
```

### Espace disque insuffisant

Nettoyer Docker :
```bash
docker system prune -a
docker volume prune
```

### Rebuild complet

```bash
docker-compose down -v
docker-compose build --no-cache
docker-compose up -d
```

## Performance

### Optimiser les images

Les Dockerfiles fournis utilisent déjà :
- Multi-stage builds
- Alpine Linux
- Utilisateur non-root
- Layers optimisés

### Cache des dépendances

Les `package*.json` sont copiés avant le code source pour utiliser le cache Docker.

## Sécurité

### Bonnes pratiques appliquées

- ✅ Utilisateur non-root dans les conteneurs
- ✅ Health checks
- ✅ Variables d'environnement pour les secrets
- ✅ Réseau Docker isolé
- ✅ Images officielles minimales (Alpine)

### Améliorer la sécurité

1. Utilisez Docker secrets au lieu de variables d'environnement
2. Scannez les images : `docker scan ecole-assalam-backend`
3. Mettez à jour régulièrement les images de base
4. Limitez les ressources CPU/RAM
5. Utilisez un pare-feu (ufw, firewalld)

## CI/CD

Le fichier `.github/workflows/azure-deploy.yml` peut être adapté pour Docker :

```yaml
- name: Build and push Docker images
  run: |
    docker build -t your-registry/backend:${{ github.sha }} -f deployment/docker/Dockerfile.backend backend/
    docker push your-registry/backend:${{ github.sha }}
```

## Support

Pour toute question sur le déploiement Docker :
- [Documentation Docker](https://docs.docker.com/)
- [Documentation Docker Compose](https://docs.docker.com/compose/)
