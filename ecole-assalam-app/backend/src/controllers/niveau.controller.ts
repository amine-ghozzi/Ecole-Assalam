import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export const getAllNiveaux = async (req: Request, res: Response) => {
  try {
    const niveaux = await prisma.niveau.findMany({
      orderBy: { ordre: 'asc' },
      include: {
        groupes: true,
        _count: {
          select: { groupes: true }
        }
      }
    });
    res.json(niveaux);
  } catch (error) {
    res.status(500).json({ error: 'Erreur lors de la récupération des niveaux' });
  }
};

export const getNiveauById = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const niveau = await prisma.niveau.findUnique({
      where: { id },
      include: {
        groupes: {
          include: {
            _count: {
              select: { eleves: true }
            }
          }
        }
      }
    });

    if (!niveau) {
      return res.status(404).json({ error: 'Niveau non trouvé' });
    }

    res.json(niveau);
  } catch (error) {
    res.status(500).json({ error: 'Erreur lors de la récupération du niveau' });
  }
};

export const createNiveau = async (req: Request, res: Response) => {
  try {
    const { nom, description, ordre } = req.body;

    const niveau = await prisma.niveau.create({
      data: { nom, description, ordre }
    });

    res.status(201).json(niveau);
  } catch (error: any) {
    if (error.code === 'P2002') {
      return res.status(400).json({ error: 'Ce niveau existe déjà' });
    }
    res.status(500).json({ error: 'Erreur lors de la création du niveau' });
  }
};

export const updateNiveau = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const { nom, description, ordre } = req.body;

    const niveau = await prisma.niveau.update({
      where: { id },
      data: { nom, description, ordre }
    });

    res.json(niveau);
  } catch (error: any) {
    if (error.code === 'P2025') {
      return res.status(404).json({ error: 'Niveau non trouvé' });
    }
    res.status(500).json({ error: 'Erreur lors de la mise à jour du niveau' });
  }
};

export const deleteNiveau = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;

    await prisma.niveau.delete({
      where: { id }
    });

    res.status(204).send();
  } catch (error: any) {
    if (error.code === 'P2025') {
      return res.status(404).json({ error: 'Niveau non trouvé' });
    }
    res.status(500).json({ error: 'Erreur lors de la suppression du niveau' });
  }
};
