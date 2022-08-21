const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

const { Router } = require('express');
const router = Router();

const jwt = require('jsonwebtoken');
const { expressjwt } = require('express-jwt');

const bcrypt = require('bcrypt')

let userSelect = {
  id: true,
  email: true,
  firstName: true,
  lastName: true,
  gender: true,
  birthYear: true,
  description: true,
  city: {
    select: {
      id: true,
      name: true,
      country: true
    }
  }
}

// List all users
// TODO: add filtering by category
router.get('/', async (req, res) => {
  let users = await prisma.user.findMany({ select: userSelect });

  res.send(users);
});

// Retrieve a single user
router.get('/users/:userId', async (req, res) => {
  let user = await prisma.user.findUnique({
    where: { id: req.params.userId },
    select: userSelect
  });

  if (!user) {
    return res.sendStatus(404);
  }

  res.send(user);
});

// Register a new account
router.post('/', async (req, res) => {
  let { email, password, firstName, lastName, gender, birthYear, description, cityId } = req.body;
  if (!email || !firstName || !lastName || !password || !gender || !birthYear || !cityId) {
    return res.status(400).send("Invalid data.");
  }

  if (!description) description = "";

  let saltRounds = 10;
  let hash = await bcrypt.hash(password, saltRounds);

  let newUser = await prisma.user.create({
    data: {
      email,
      firstName,
      lastName,
      gender,
      description,
      birthYear: parseInt(birthYear),
      cityId: parseInt(cityId),
      password: hash
    },
    select: userSelect
  });

  res.send(newUser);
});

// Login with an existing account
router.post('/login', async (req, res) => {
  let { email, password } = req.body;
  if (!email || !password) {
    return res.sendStatus(400);
  }

  let user = await prisma.user.findUnique({ where: { email } });
  if (!user) {
    res.status(400).send("This email is not registered.");
    return;
  }

  let result = await bcrypt.compare(password, user.password);
  if (!result) {
    return res.status(400).send('Wrong password');
  }

  let accessToken = jwt.sign({ data: user.id }, process.env.TOKEN_SECRET, { expiresIn: 1800 });
  res.send({ accessToken });
});

// Retrieve the logged in account
router.get(
  '/me',
  expressjwt({ secret: process.env.TOKEN_SECRET, algorithms: ["HS256"] }),
  async (req, res) => {
    let user = await prisma.user.findUnique({
      where: { id: req.auth.data },
      select: userSelect
    });

    res.send(user);
  }
);

// Update the logged in accout
router.put(
  '/me',
  expressjwt({ secret: process.env.TOKEN_SECRET, algorithms: ["HS256"] }),
  async (req, res) => {
    let { firstName, lastName, gender, description, birthYear, cityId, password } = req.body;

    let data = {}

    if (firstName) data.firstName = firstName;
    if (lastName) data.lastName = lastName;
    if (gender) data.gender = gender;
    if (description) data.description = description;
    if (birthYear) data.birthYear = parseInt(birthYear);
    if (cityId) data.cityId = parseInt(cityId);
    if (password) {
      let saltRounds = 10;
      data.password = await bcrypt.hash(password, saltRounds);
    }

    let updatedUser = await prisma.user.update({
      where: {
        id: req.auth.data,
      },
      data,
      select: userSelect
    });

    res.send(updatedUser);
  }
);

// Delete the logged in account
router.delete(
  '/me',
  expressjwt({ secret: process.env.TOKEN_SECRET, algorithms: ["HS256"] }),
  async (req, res) => {
    await prisma.user.delete({
      where: {
        id: req.auth.data
      }
    });

    res.sendStatus(204);
  }
);

module.exports = router;
