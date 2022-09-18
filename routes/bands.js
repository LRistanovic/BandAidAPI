const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

const { Router } = require('express');
const router = Router();

// List all bands
router.get('/', async (req, res) => {
    let bands = await prisma.band.findMany();
    return bands;
});