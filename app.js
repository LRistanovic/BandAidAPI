let express = require('express');
let path = require('path');
let cookieParser = require('cookie-parser');
let logger = require('morgan');

let usersRouter = require('./routes/users');
let countriesRouter = require('./routes/countries');
let citiesRouter = require('./routes/cities');

let dotenv = require('dotenv');
dotenv.config();

let app = express();

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

// routers
app.use('/countries', countriesRouter);
app.use('/cities', citiesRouter);
app.use('/users', usersRouter);

module.exports = app;
