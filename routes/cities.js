const prismaMod = require('@prisma/client')
const prisma = new prismaMod.PrismaClient()

const express = require('express');
const router = express.Router();

// List all cities with the country they're in
router.get('/', async (_, res) => {
    let cities = await prisma.city.findMany({
        select: {
            name: true,
            id: true,
            country: {
                select: {
                    name: true
                }
            }
        }
    });

    for (city of cities) {
        city.country = city.country.name
    }

    res.send(cities);
})

module.exports = router