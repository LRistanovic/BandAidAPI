-- CreateTable
CREATE TABLE "Country" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "City" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "countryId" INTEGER NOT NULL,
    CONSTRAINT "City_countryId_fkey" FOREIGN KEY ("countryId") REFERENCES "Country" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "User" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "email" TEXT NOT NULL,
    "firstName" TEXT NOT NULL,
    "lastName" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "description" TEXT,
    "gender" TEXT NOT NULL,
    "birthYear" INTEGER NOT NULL,
    "cityId" INTEGER NOT NULL,
    "profilePicture" TEXT,
    CONSTRAINT "User_cityId_fkey" FOREIGN KEY ("cityId") REFERENCES "City" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Instrument" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "UserPlaysInstrument" (
    "userId" INTEGER NOT NULL,
    "instrumentId" INTEGER NOT NULL,
    "howManyYears" REAL NOT NULL,
    "skillLevel" INTEGER NOT NULL,

    PRIMARY KEY ("userId", "instrumentId"),
    CONSTRAINT "UserPlaysInstrument_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "UserPlaysInstrument_instrumentId_fkey" FOREIGN KEY ("instrumentId") REFERENCES "Instrument" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Genre" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "Band" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "cityId" INTEGER NOT NULL,
    "profilePicture" TEXT,
    CONSTRAINT "Band_cityId_fkey" FOREIGN KEY ("cityId") REFERENCES "City" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "UserPlaysForBand" (
    "userId" INTEGER NOT NULL,
    "instrumentId" INTEGER NOT NULL,
    "bandId" INTEGER NOT NULL,

    PRIMARY KEY ("userId", "bandId"),
    CONSTRAINT "UserPlaysForBand_userId_instrumentId_fkey" FOREIGN KEY ("userId", "instrumentId") REFERENCES "UserPlaysInstrument" ("userId", "instrumentId") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "UserPlaysForBand_bandId_fkey" FOREIGN KEY ("bandId") REFERENCES "Band" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "_GenreToUser" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL,
    CONSTRAINT "_GenreToUser_A_fkey" FOREIGN KEY ("A") REFERENCES "Genre" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "_GenreToUser_B_fkey" FOREIGN KEY ("B") REFERENCES "User" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "_BandToGenre" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL,
    CONSTRAINT "_BandToGenre_A_fkey" FOREIGN KEY ("A") REFERENCES "Band" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "_BandToGenre_B_fkey" FOREIGN KEY ("B") REFERENCES "Genre" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "_BandToInstrument" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL,
    CONSTRAINT "_BandToInstrument_A_fkey" FOREIGN KEY ("A") REFERENCES "Band" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "_BandToInstrument_B_fkey" FOREIGN KEY ("B") REFERENCES "Instrument" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "_GenreToUser_AB_unique" ON "_GenreToUser"("A", "B");

-- CreateIndex
CREATE INDEX "_GenreToUser_B_index" ON "_GenreToUser"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_BandToGenre_AB_unique" ON "_BandToGenre"("A", "B");

-- CreateIndex
CREATE INDEX "_BandToGenre_B_index" ON "_BandToGenre"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_BandToInstrument_AB_unique" ON "_BandToInstrument"("A", "B");

-- CreateIndex
CREATE INDEX "_BandToInstrument_B_index" ON "_BandToInstrument"("B");
