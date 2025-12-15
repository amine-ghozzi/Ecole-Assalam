import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export const getAllEleves = async (req: Request, res: Response) => {
  try {
    const { groupeId } = req.query;

    const eleves = await prisma.eleve.findMany({
      where: {
        ...(groupeId && { groupeId: groupeId as string })
      },
      include: {
        groupe: {
          include: {
            niveau: true
          }
        }
      },
      orderBy: [
        { nom: 'asc' },
        { prenom: 'asc' }
      ]
    });

    res.json(eleves);
  } catch (error) {
    res.status(500).json({ error: 'Erreur lors de la récupération des élèves' });
  }
};

export const getEleveById = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const eleve = await prisma.eleve.findUnique({
      where: { id },
      include: {
        groupe: {
          include: {
            niveau: true,
            horaires: true
          }
        }
      }
    });

    if (!eleve) {
      return res.status(404).json({ error: 'Élève non trouvé' });
    }

    res.json(eleve);
  } catch (error) {
    res.status(500).json({ error: 'Erreur lors de la récupération de l\'élève' });
  }
};

export const createEleve = async (req: Request, res: Response) => {
  try {
    const { nom, prenom, dateNaissance, groupeId, photo, contactParent, adresse } = req.body;

    const eleve = await prisma.eleve.create({
      data: {
        nom,
        prenom,
        dateNaissance: new Date(dateNaissance),
        groupeId,
        photo,
        contactParent,
        adresse
      },
      include: {
        groupe: {
          include: { niveau: true }
        }
      }
    });

    res.status(201).json(eleve);
  } catch (error) {
    res.status(500).json({ error: 'Erreur lors de la création de l\'élève' });
  }
};

export const updateEleve = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const { nom, prenom, dateNaissance, groupeId, photo, contactParent, adresse } = req.body;

    const eleve = await prisma.eleve.update({
      where: { id },
      data: {
        nom,
        prenom,
        ...(dateNaissance && { dateNaissance: new Date(dateNaissance) }),
        groupeId,
        photo,
        contactParent,
        adresse
      },
      include: {
        groupe: {
          include: { niveau: true }
        }
      }
    });

    res.json(eleve);
  } catch (error: any) {
    if (error.code === 'P2025') {
      return res.status(404).json({ error: 'Élève non trouvé' });
    }
    res.status(500).json({ error: 'Erreur lors de la mise à jour de l\'élève' });
  }
};

export const deleteEleve = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;

    await prisma.eleve.delete({
      where: { id }
    });

    res.status(204).send();
  } catch (error: any) {
    if (error.code === 'P2025') {
      return res.status(404).json({ error: 'Élève non trouvé' });
    }
    res.status(500).json({ error: 'Erreur lors de la suppression de l\'élève' });
  }
};
