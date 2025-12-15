import { Router } from 'express';
import * as groupeController from '../controllers/groupe.controller';

const router = Router();

router.get('/', groupeController.getAllGroupes);
router.get('/:id', groupeController.getGroupeById);
router.post('/', groupeController.createGroupe);
router.put('/:id', groupeController.updateGroupe);
router.delete('/:id', groupeController.deleteGroupe);

export default router;
