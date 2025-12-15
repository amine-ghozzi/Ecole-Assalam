import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export const getAllExamens = async (req: Request, res: Response) => {
  try {
    const { statut, niveauSourceId } = req.query;

    const examens = await prisma.examenPassage.findMany({
      where: {
        ...(statut && { statut: statut as any }),
        ...(niveauSourceId && { niveauSourceId: niveauSourceId as string })
      },
      include: {
        niveauSource: true,
        niveauDestination: true
      },
      orderBy: { dateExamen: 'asc' }
    });

    res.json(examens);
  } catch (error) {
    res.status(500).json({ error: 'Erreur lors de la récupération des examens' });
  }
};

export const getExamenById = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const examen = await prisma.examenPassage.findUnique({
      where: { id },
      include: {
        niveauSource: true,
        niveauDestination: true
      }
    });

    if (!examen) {
      return res.status(404).json({ error: 'Examen non trouvé' });
    }

    res.json(examen);
  } catch (error) {
    res.status(500).json({ error: 'Erreur lors de la récupération de l\'examen' });
  }
};

export const createExamen = async (req: Request, res: Response) => {
  try {
    const {
      niveauSourceId,
      niveauDestinationId,
      dateExamen,
      dateLimiteInscription,
      statut,
      description
    } = req.body;

    const examen = await prisma.examenPassage.create({
      data: {
        niveauSourceId,
        niveauDestinationId,
        dateExamen: new Date(dateExamen),
        dateLimiteInscription: new Date(dateLimiteInscription),
        statut,
        description
      },
      include: {
        niveauSource: true,
        niveauDestination: true
      }
    });

    res.status(201).json(examen);
  } catch (error) {
    res.status(500).json({ error: 'Erreur lors de la création de l\'examen' });
  }
};

export const updateExamen = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const {
      niveauSourceId,
      niveauDestinationId,
      dateExamen,
      dateLimiteInscription,
      statut,
      description
    } = req.body;

    const examen = await prisma.examenPassage.update({
      where: { id },
      data: {
        niveauSourceId,
        niveauDestinationId,
        ...(dateExamen && { dateExamen: new Date(dateExamen) }),
        ...(dateLimiteInscription && { dateLimiteInscription: new Date(dateLimiteInscription) }),
        statut,
        description
      },
      include: {
        niveauSource: true,
        niveauDestination: true
      }
    });

    res.json(examen);
  } catch (error: any) {
    if (error.code === 'P2025') {
      return res.status(404).json({ error: 'Examen non trouvé' });
    }
    res.status(500).json({ error: 'Erreur lors de la mise à jour de l\'examen' });
  }
};

export const deleteExamen = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;

    await prisma.examenPassage.delete({
      where: { id }
    });

    res.status(204).send();
  } catch (error: any) {
    if (error.code === 'P2025') {
      return res.status(404).json({ error: 'Examen non trouvé' });
    }
    res.status(500).json({ error: 'Erreur lors de la suppression de l\'examen' });
  }
};
