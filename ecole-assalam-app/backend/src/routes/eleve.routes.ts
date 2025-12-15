import { Router } from 'express';
import * as eleveController from '../controllers/eleve.controller';

const router = Router();

router.get('/', eleveController.getAllEleves);
router.get('/:id', eleveController.getEleveById);
router.post('/', eleveController.createEleve);
router.put('/:id', eleveController.updateEleve);
router.delete('/:id', eleveController.deleteEleve);

export default router;
