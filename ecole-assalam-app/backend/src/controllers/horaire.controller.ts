import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export const getAllHoraires = async (req: Request, res: Response) => {
  try {
    const { groupeId } = req.query;

    const horaires = await prisma.horaire.findMany({
      where: {
        ...(groupeId && { groupeId: groupeId as string })
      },
      include: {
        groupe: {
          include: { niveau: true }
        }
      }
    });

    res.json(horaires);
  } catch (error) {
    res.status(500).json({ error: 'Erreur lors de la récupération des horaires' });
  }
};

export const getHoraireById = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const horaire = await prisma.horaire.findUnique({
      where: { id },
      include: {
        groupe: {
          include: { niveau: true }
        }
      }
    });

    if (!horaire) {
      return res.status(404).json({ error: 'Horaire non trouvé' });
    }

    res.json(horaire);
  } catch (error) {
    res.status(500).json({ error: 'Erreur lors de la récupération de l\'horaire' });
  }
};

export const createHoraire = async (req: Request, res: Response) => {
  try {
    const { groupeId, joursSemaine, heureEntree, heureSortie } = req.body;

    const horaire = await prisma.horaire.create({
      data: {
        groupeId,
        joursSemaine,
        heureEntree,
        heureSortie
      },
      include: {
        groupe: {
          include: { niveau: true }
        }
      }
    });

    res.status(201).json(horaire);
  } catch (error) {
    res.status(500).json({ error: 'Erreur lors de la création de l\'horaire' });
  }
};

export const updateHoraire = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const { groupeId, joursSemaine, heureEntree, heureSortie } = req.body;

    const horaire = await prisma.horaire.update({
      where: { id },
      data: {
        groupeId,
        joursSemaine,
        heureEntree,
        heureSortie
      },
      include: {
        groupe: {
          include: { niveau: true }
        }
      }
    });

    res.json(horaire);
  } catch (error: any) {
    if (error.code === 'P2025') {
      return res.status(404).json({ error: 'Horaire non trouvé' });
    }
    res.status(500).json({ error: 'Erreur lors de la mise à jour de l\'horaire' });
  }
};

export const deleteHoraire = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;

    await prisma.horaire.delete({
      where: { id }
    });

    res.status(204).send();
  } catch (error: any) {
    if (error.code === 'P2025') {
      return res.status(404).json({ error: 'Horaire non trouvé' });
    }
    res.status(500).json({ error: 'Erreur lors de la suppression de l\'horaire' });
  }
};
