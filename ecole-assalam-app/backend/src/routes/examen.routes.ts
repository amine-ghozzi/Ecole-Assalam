import { Router } from 'express';
import * as examenController from '../controllers/examen.controller';

const router = Router();

router.get('/', examenController.getAllExamens);
router.get('/:id', examenController.getExamenById);
router.post('/', examenController.createExamen);
router.put('/:id', examenController.updateExamen);
router.delete('/:id', examenController.deleteExamen);

export default router;
