import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import niveauRoutes from './routes/niveau.routes';
import groupeRoutes from './routes/groupe.routes';
import eleveRoutes from './routes/eleve.routes';
import horaireRoutes from './routes/horaire.routes';
import examenRoutes from './routes/examen.routes';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors({
  origin: process.env.ALLOWED_ORIGINS?.split(',') || '*'
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Routes
app.get('/', (req, res) => {
  res.json({
    message: 'API École Assalam',
    version: '1.0.0',
    endpoints: {
      niveaux: '/api/niveaux',
      groupes: '/api/groupes',
      eleves: '/api/eleves',
      horaires: '/api/horaires',
      examens: '/api/examens'
    }
  });
});

app.use('/api/niveaux', niveauRoutes);
app.use('/api/groupes', groupeRoutes);
app.use('/api/eleves', eleveRoutes);
app.use('/api/horaires', horaireRoutes);
app.use('/api/examens', examenRoutes);

// Gestion des erreurs globales
app.use((err: any, req: express.Request, res: express.Response, next: express.NextFunction) => {
  console.error(err.stack);
  res.status(500).json({
    error: 'Une erreur est survenue!',
    message: process.env.NODE_ENV === 'development' ? err.message : undefined
  });
});

app.listen(PORT, () => {
  console.log(`🚀 Serveur démarré sur le port ${PORT}`);
  console.log(`📚 API École Assalam disponible sur http://localhost:${PORT}`);
});
