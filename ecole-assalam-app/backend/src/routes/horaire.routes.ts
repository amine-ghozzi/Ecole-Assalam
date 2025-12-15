import { Router } from 'express';
import * as horaireController from '../controllers/horaire.controller';

const router = Router();

router.get('/', horaireController.getAllHoraires);
router.get('/:id', horaireController.getHoraireById);
router.post('/', horaireController.createHoraire);
router.put('/:id', horaireController.updateHoraire);
router.delete('/:id', horaireController.deleteHoraire);

export default router;
