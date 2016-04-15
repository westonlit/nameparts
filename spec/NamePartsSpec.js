describe('NameParts.js', function() {
    var NameParts;

    beforeEach(function() {
        NameParts = require('../nameparts.js');
    });

    it('should load', function() {
        expect(NameParts).toBeDefined();
        expect(typeof NameParts).toBe('function');
    });

    it('should have all expected members', function() {
        expect(typeof NameParts.parse).toBe('function');
    });

    describe('parse()', function() {
        it('should parse a simple name', function() {
            var nameParts = NameParts.parse('Ben Jacob');

            // Parse results
            expect(nameParts.fullName).toBe('Ben Jacob');
            expect(nameParts.firstName).toBe('Ben');
            expect(nameParts.lastName).toBe('Jacob');

            // Members not used for this result
            expect(nameParts.salutation).toBeNull();
            expect(nameParts.middleName).toBeNull();
            expect(nameParts.generation).toBeNull();
            expect(nameParts.suffix).toBeNull();
            expect(nameParts.aliases).toBeNull();

            // Flags
            expect(nameParts.hasCorporateEntity).toBe(false);
            expect(nameParts.hasNonName).toBe(false);
            expect(nameParts.hasLnPrefix).toBe(false);
            expect(nameParts.hasSupplementalInfo).toBe(false);
        });

        it('should parse a simple name with a single middle name', function() {
            var nameParts = NameParts.parse('Neil Patrick Harris');

            // Parse results
            expect(nameParts.fullName).toBe('Neil Patrick Harris');
            expect(nameParts.firstName).toBe('Neil');
            expect(nameParts.middleName).toBe('Patrick');
            expect(nameParts.lastName).toBe('Harris');

            // Members not used for this result
            expect(nameParts.salutation).toBeNull();
            expect(nameParts.generation).toBeNull();
            expect(nameParts.suffix).toBeNull();
            expect(nameParts.aliases).toBeNull();

            // Flags
            expect(nameParts.hasCorporateEntity).toBe(false);
            expect(nameParts.hasNonName).toBe(false);
            expect(nameParts.hasLnPrefix).toBe(false);
            expect(nameParts.hasSupplementalInfo).toBe(false);
        });

        it('should parse a spaced surname', function() {
            var nameParts = NameParts.parse('Otto Von Bismark');

            // Parse results
            expect(nameParts.fullName).toBe('Otto Von Bismark');
            expect(nameParts.firstName).toBe('Otto');
            expect(nameParts.lastName).toBe('Von Bismark');
            expect(nameParts.hasLnPrefix).toBe(true);

            // Members not used for this result
            expect(nameParts.salutation).toBeNull();
            expect(nameParts.middleName).toBeNull();
            expect(nameParts.generation).toBeNull();
            expect(nameParts.suffix).toBeNull();
            expect(nameParts.aliases).toBeNull();

            // Flags
            expect(nameParts.hasCorporateEntity).toBe(false);
            expect(nameParts.hasNonName).toBe(false);
            expect(nameParts.hasSupplementalInfo).toBe(false);
        });

        it('should parse an apostrophe surname', function() {
            var nameParts = NameParts.parse('Scarlett O\'Hara');

            // Parse results
            expect(nameParts.fullName).toBe('Scarlett O\'Hara');
            expect(nameParts.firstName).toBe('Scarlett');
            expect(nameParts.lastName).toBe('O\'Hara');

            // Members not used for this result
            expect(nameParts.salutation).toBeNull();
            expect(nameParts.middleName).toBeNull();
            expect(nameParts.generation).toBeNull();
            expect(nameParts.suffix).toBeNull();
            expect(nameParts.aliases).toBeNull();

            // Flags
            expect(nameParts.hasCorporateEntity).toBe(false);
            expect(nameParts.hasNonName).toBe(false);
            expect(nameParts.hasLnPrefix).toBe(false);
            expect(nameParts.hasSupplementalInfo).toBe(false);
        });

        it('should parse a generation name', function() {
            var nameParts = NameParts.parse('Thurston Howell III');

            // Parse results
            expect(nameParts.fullName).toBe('Thurston Howell III');
            expect(nameParts.firstName).toBe('Thurston');
            expect(nameParts.lastName).toBe('Howell');
            expect(nameParts.generation).toBe('III');

            // Members not used for this result
            expect(nameParts.salutation).toBeNull();
            expect(nameParts.middleName).toBeNull();
            expect(nameParts.suffix).toBeNull();
            expect(nameParts.aliases).toBeNull();

            // Flags
            expect(nameParts.hasCorporateEntity).toBe(false);
            expect(nameParts.hasNonName).toBe(false);
            expect(nameParts.hasLnPrefix).toBe(false);
            expect(nameParts.hasSupplementalInfo).toBe(false);
        });

        it('should parse a generation name designated by the word "the"', function() {
            var nameParts = NameParts.parse('Thurston Howell the 3rd');

            // Parse results
            expect(nameParts.fullName).toBe('Thurston Howell the 3rd');
            expect(nameParts.firstName).toBe('Thurston');
            expect(nameParts.lastName).toBe('Howell');
            expect(nameParts.generation).toBe('3rd');

            // Members not used for this result
            expect(nameParts.salutation).toBeNull();
            expect(nameParts.middleName).toBeNull();
            expect(nameParts.suffix).toBeNull();
            expect(nameParts.aliases).toBeNull();

            // Flags
            expect(nameParts.hasCorporateEntity).toBe(false);
            expect(nameParts.hasNonName).toBe(false);
            expect(nameParts.hasLnPrefix).toBe(false);
            expect(nameParts.hasSupplementalInfo).toBe(false);
        });

        it('should parse a generation name designated by the spelled out word', function() {
            var nameParts = NameParts.parse('Thurston Howell Third');

            // Parse results
            expect(nameParts.fullName).toBe('Thurston Howell Third');
            expect(nameParts.firstName).toBe('Thurston');
            expect(nameParts.lastName).toBe('Howell');
            expect(nameParts.generation).toBe('Third');

            // Members not used for this result
            expect(nameParts.salutation).toBeNull();
            expect(nameParts.middleName).toBeNull();
            expect(nameParts.suffix).toBeNull();
            expect(nameParts.aliases).toBeNull();

            // Flags
            expect(nameParts.hasCorporateEntity).toBe(false);
            expect(nameParts.hasNonName).toBe(false);
            expect(nameParts.hasLnPrefix).toBe(false);
            expect(nameParts.hasSupplementalInfo).toBe(false);
        });

        it('should parse a generation name designated by the word "the" and the spelled out generation', function() {
            var nameParts = NameParts.parse('Thurston Howell the Third');

            // Parse results
            expect(nameParts.fullName).toBe('Thurston Howell the Third');
            expect(nameParts.firstName).toBe('Thurston');
            expect(nameParts.lastName).toBe('Howell');
            expect(nameParts.generation).toBe('Third');

            // Members not used for this result
            expect(nameParts.salutation).toBeNull();
            expect(nameParts.middleName).toBeNull();
            expect(nameParts.suffix).toBeNull();
            expect(nameParts.aliases).toBeNull();

            // Flags
            expect(nameParts.hasCorporateEntity).toBe(false);
            expect(nameParts.hasNonName).toBe(false);
            expect(nameParts.hasLnPrefix).toBe(false);
            expect(nameParts.hasSupplementalInfo).toBe(false);
        });

        it('should parse a single alias name', function() {
            var nameParts = NameParts.parse('Bruce Wayne a/k/a Batman');

            // Parse results
            expect(nameParts.fullName).toBe('Bruce Wayne a/k/a Batman');
            expect(nameParts.firstName).toBe('Bruce');
            expect(nameParts.lastName).toBe('Wayne');
            expect(nameParts.hasNonName).toBe(true);
            expect(nameParts.aliases[0]).toBe('Batman');

            // Members not used for this result
            expect(nameParts.salutation).toBeNull();
            expect(nameParts.middleName).toBeNull();
            expect(nameParts.generation).toBeNull();
            expect(nameParts.suffix).toBeNull();

            // Flags
            expect(nameParts.hasCorporateEntity).toBe(false);
            expect(nameParts.hasLnPrefix).toBe(false);
            expect(nameParts.hasSupplementalInfo).toBe(false);
        });

        it('should parse a nick name with one word', function() {
            var nameParts = NameParts.parse('"Stonecold" Steve Austin');

            // Parse results
            expect(nameParts.fullName).toBe('"Stonecold" Steve Austin');
            expect(nameParts.firstName).toBe('Steve');
            expect(nameParts.lastName).toBe('Austin');
            expect(nameParts.hasNonName).toBe(true);
            expect(nameParts.aliases[0]).toBe('Stonecold');

            // Members not used for this result
            expect(nameParts.salutation).toBeNull();
            expect(nameParts.middleName).toBeNull();
            expect(nameParts.generation).toBeNull();
            expect(nameParts.suffix).toBeNull();

            // Flags
            expect(nameParts.hasCorporateEntity).toBe(false);
            expect(nameParts.hasLnPrefix).toBe(false);
            expect(nameParts.hasSupplementalInfo).toBe(false);
        });

        it('should parse a nick name with two word', function() {
            var nameParts = NameParts.parse('Dwayne "The Rock" Johnson');

            // Parse results
            expect(nameParts.fullName).toBe('Dwayne "The Rock" Johnson');
            expect(nameParts.firstName).toBe('Dwayne');
            expect(nameParts.lastName).toBe('Johnson');
            expect(nameParts.hasNonName).toBe(true);
            expect(nameParts.aliases[0]).toBe('The Rock');

            // Members not used for this result
            expect(nameParts.salutation).toBeNull();
            expect(nameParts.middleName).toBeNull();
            expect(nameParts.generation).toBeNull();
            expect(nameParts.suffix).toBeNull();

            // Flags
            expect(nameParts.hasCorporateEntity).toBe(false);
            expect(nameParts.hasLnPrefix).toBe(false);
            expect(nameParts.hasSupplementalInfo).toBe(false);
        });

        it('should parse a nick name with many spaces', function() {
            var nameParts = NameParts.parse('"The Nature Boy" Ric Flair');

            // Parse results
            expect(nameParts.fullName).toBe('"The Nature Boy" Ric Flair');
            expect(nameParts.firstName).toBe('Ric');
            expect(nameParts.lastName).toBe('Flair');
            expect(nameParts.hasNonName).toBe(true);
            expect(nameParts.aliases[0]).toBe('The Nature Boy');

            // Members not used for this result
            expect(nameParts.salutation).toBeNull();
            expect(nameParts.middleName).toBeNull();
            expect(nameParts.generation).toBeNull();
            expect(nameParts.suffix).toBeNull();

            // Flags
            expect(nameParts.hasCorporateEntity).toBe(false);
            expect(nameParts.hasLnPrefix).toBe(false);
            expect(nameParts.hasSupplementalInfo).toBe(false);
        });

        it('should parse a multiple aliases', function() {
            var nameParts = NameParts.parse('"The People\'s Champion" Mohammed "Louisville Lip" Ali aka The Greatest');

            // Parse results
            expect(nameParts.fullName).toBe('"The People\'s Champion" Mohammed "Louisville Lip" Ali aka The Greatest');
            expect(nameParts.firstName).toBe('Mohammed');
            expect(nameParts.lastName).toBe('Ali');
            expect(nameParts.hasNonName).toBe(true);
            expect(nameParts.aliases[0]).toBe('The People\'s Champion');
            expect(nameParts.aliases[1]).toBe('Louisville Lip');
            expect(nameParts.aliases[2]).toBe('The Greatest');

            // Members not used for this result
            expect(nameParts.salutation).toBeNull();
            expect(nameParts.middleName).toBeNull();
            expect(nameParts.generation).toBeNull();
            expect(nameParts.suffix).toBeNull();

            // Flags
            expect(nameParts.hasCorporateEntity).toBe(false);
            expect(nameParts.hasLnPrefix).toBe(false);
            expect(nameParts.hasSupplementalInfo).toBe(false);
        });

        it('should parse supplemental information', function() {
            var nameParts = NameParts.parse('Philip Francis "The Scooter" Rizzuto, deceased');

            // Parse results
            expect(nameParts.fullName).toBe('Philip Francis "The Scooter" Rizzuto, deceased');
            expect(nameParts.firstName).toBe('Philip');
            expect(nameParts.middleName).toBe('Francis');
            expect(nameParts.lastName).toBe('Rizzuto');
            expect(nameParts.hasNonName).toBe(true);
            expect(nameParts.aliases[0]).toBe('The Scooter');
            expect(nameParts.hasSupplementalInfo).toBe(true);

            // Members not used for this result
            expect(nameParts.salutation).toBeNull();
            expect(nameParts.generation).toBeNull();
            expect(nameParts.suffix).toBeNull();

            // Flags
            expect(nameParts.hasCorporateEntity).toBe(false);
            expect(nameParts.hasLnPrefix).toBe(false);
        });

        it('should parse a name with multiple middle names', function() {
            var nameParts = NameParts.parse('George Herbert Walker Bush');
            expect(nameParts.firstName).toBe('George');
            expect(nameParts.middleName).toBe('Herbert Walker');
            expect(nameParts.lastName).toBe('Bush');
        });

        /*
        xit('should parse a name with extraneous information', function() {
            //John Doe fictitious husband of Jane Doe
        });
        */

        //Saleh ibn Tariq ibn Khalid al-Fulan
        // first = Saleh
        // last = everything-else
    });
});
