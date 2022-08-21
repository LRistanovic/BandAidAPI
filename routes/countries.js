const prismaMod = require('@prisma/client');
const prisma = new prismaMod.PrismaClient();

const express = require('express');
const router = express.Router();

// List all countries with all cities in it
router.get('/', async (_, res) => {
    let countries = await prisma.country.findMany({
        select: {
            name: true,
            cities: {
                select: {
                    name: true
                }
            }
        }
    });

    for (country of countries) {
        country.cities = country.cities.map(c => c.name)
    }

    res.send(countries);
})

module.exports = router;