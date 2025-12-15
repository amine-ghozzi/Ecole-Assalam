import { Router } from 'express';
import * as niveauController from '../controllers/niveau.controller';

const router = Router();

router.get('/', niveauController.getAllNiveaux);
router.get('/:id', niveauController.getNiveauById);
router.post('/', niveauController.createNiveau);
router.put('/:id', niveauController.updateNiveau);
router.delete('/:id', niveauController.deleteNiveau);

export default router;
