import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export const getAllGroupes = async (req: Request, res: Response) => {
  try {
    const { anneeScolaire, niveauId } = req.query;

    const groupes = await prisma.groupe.findMany({
      where: {
        ...(anneeScolaire && { anneeScolaire: anneeScolaire as string }),
        ...(niveauId && { niveauId: niveauId as string })
      },
      include: {
        niveau: true,
        _count: {
          select: { eleves: true }
        }
      },
      orderBy: { nom: 'asc' }
    });

    res.json(groupes);
  } catch (error) {
    res.status(500).json({ error: 'Erreur lors de la récupération des groupes' });
  }
};

export const getGroupeById = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const groupe = await prisma.groupe.findUnique({
      where: { id },
      include: {
        niveau: true,
        eleves: true,
        horaires: true
      }
    });

    if (!groupe) {
      return res.status(404).json({ error: 'Groupe non trouvé' });
    }

    res.json(groupe);
  } catch (error) {
    res.status(500).json({ error: 'Erreur lors de la récupération du groupe' });
  }
};

export const createGroupe = async (req: Request, res: Response) => {
  try {
    const { nom, niveauId, capaciteMax, anneeScolaire } = req.body;

    const groupe = await prisma.groupe.create({
      data: { nom, niveauId, capaciteMax, anneeScolaire },
      include: { niveau: true }
    });

    res.status(201).json(groupe);
  } catch (error: any) {
    if (error.code === 'P2002') {
      return res.status(400).json({ error: 'Ce groupe existe déjà pour cette année scolaire' });
    }
    res.status(500).json({ error: 'Erreur lors de la création du groupe' });
  }
};

export const updateGroupe = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const { nom, niveauId, capaciteMax, anneeScolaire } = req.body;

    const groupe = await prisma.groupe.update({
      where: { id },
      data: { nom, niveauId, capaciteMax, anneeScolaire },
      include: { niveau: true }
    });

    res.json(groupe);
  } catch (error: any) {
    if (error.code === 'P2025') {
      return res.status(404).json({ error: 'Groupe non trouvé' });
    }
    res.status(500).json({ error: 'Erreur lors de la mise à jour du groupe' });
  }
};

export const deleteGroupe = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;

    await prisma.groupe.delete({
      where: { id }
    });

    res.status(204).send();
  } catch (error: any) {
    if (error.code === 'P2025') {
      return res.status(404).json({ error: 'Groupe non trouvé' });
    }
    res.status(500).json({ error: 'Erreur lors de la suppression du groupe' });
  }
};
