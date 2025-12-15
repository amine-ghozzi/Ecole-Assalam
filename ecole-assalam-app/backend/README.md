# Backend - École Assalam API

API RESTful pour la gestion des classes d'une école.

## Technologies

- Node.js + Express
- TypeScript
- Prisma ORM
- PostgreSQL

## Installation

1. Installer les dépendances :
```bash
npm install
```

2. Configurer les variables d'environnement :
```bash
cp .env.example .env
```

Modifier le fichier `.env` avec vos paramètres de connexion à PostgreSQL.

3. Générer le client Prisma et créer la base de données :
```bash
npm run prisma:generate
npm run prisma:migrate
```

## Démarrage

### Mode développement
```bash
npm run dev
```

### Mode production
```bash
npm run build
npm start
```

## API Endpoints

### Niveaux
- `GET /api/niveaux` - Liste tous les niveaux
- `GET /api/niveaux/:id` - Récupère un niveau par ID
- `POST /api/niveaux` - Crée un nouveau niveau
- `PUT /api/niveaux/:id` - Met à jour un niveau
- `DELETE /api/niveaux/:id` - Supprime un niveau

### Groupes
- `GET /api/groupes` - Liste tous les groupes (query: ?anneeScolaire=2024-2025&niveauId=xxx)
- `GET /api/groupes/:id` - Récupère un groupe par ID
- `POST /api/groupes` - Crée un nouveau groupe
- `PUT /api/groupes/:id` - Met à jour un groupe
- `DELETE /api/groupes/:id` - Supprime un groupe

### Élèves
- `GET /api/eleves` - Liste tous les élèves (query: ?groupeId=xxx)
- `GET /api/eleves/:id` - Récupère un élève par ID
- `POST /api/eleves` - Crée un nouveau élève
- `PUT /api/eleves/:id` - Met à jour un élève
- `DELETE /api/eleves/:id` - Supprime un élève

### Horaires
- `GET /api/horaires` - Liste tous les horaires (query: ?groupeId=xxx)
- `GET /api/horaires/:id` - Récupère un horaire par ID
- `POST /api/horaires` - Crée un nouveau horaire
- `PUT /api/horaires/:id` - Met à jour un horaire
- `DELETE /api/horaires/:id` - Supprime un horaire

### Examens de Passage
- `GET /api/examens` - Liste tous les examens (query: ?statut=PLANIFIE&niveauSourceId=xxx)
- `GET /api/examens/:id` - Récupère un examen par ID
- `POST /api/examens` - Crée un nouveau examen
- `PUT /api/examens/:id` - Met à jour un examen
- `DELETE /api/examens/:id` - Supprime un examen

## Structure du projet

```
backend/
├── prisma/
│   └── schema.prisma      # Schéma de la base de données
├── src/
│   ├── controllers/       # Logique métier
│   ├── routes/           # Définition des routes
│   └── server.ts         # Point d'entrée
├── .env.example          # Variables d'environnement
├── package.json
└── tsconfig.json
```

## Commandes utiles

- `npm run prisma:studio` - Ouvrir l'interface Prisma Studio pour gérer les données
- `npm run build` - Compiler le TypeScript
