# About 
This work present homework number 3, part 1 and 2 for the school year 2016/2017 in [Digital Signal Processing](http://tnt.etf.rs/~oe3dos/) in the 3rd year, Department of Electronics, School of Electrical Engineering, University of Belgrade.

# About the homework number 3 in Serbian
Cilj trećeg domaćeg zadatka je da studenti samostalno probaju optimizacioni metod projektovanja FIR filtara, da projektovane filtre iskoriste za filtriranje EKG signala kao i da steknu osećaj za efekte koji nastaju usled realizacije funkcije prenosa u hardveru gde se sve računske operacije izvršavaju korišćenjem predstave brojeva sa fiksnom tačkom na konačnoj dužini reči.

Domaći zadatak se sastoji iz dva dela. Prvi deo domaćeg zadatka se sastoji od projektovanja dva FIR filtra koji služe za poboljšanje kvaliteta EKG signala. Drugi deo domaćeg zadatka je implementacija navedenih filtara korišćenjem direktne transponovane realizacije i upoređivanje rezultata ako je ta realizacija napravljena u hardveru.

# Text of the task in Serbian - part 1
Elektrokardiografija (skraćeno EKG, engl. Electrocardiography – ECG) je metod za snimanje električne aktivnosti srca u toku vremena korišćenjem elektroda postavljenih na ruke, noge i grudi pacijenta. Ove elektrode detektuju mala naelektrisanja na koži koja se menjaju pri svakom grčenju i opuštanju srčanog mišića. Snimanje se vrši uređajem koji se naziva elektrokardiograf, a grafik signala koji se dobija se naziva elektrokardiogram. Na slici 1 je prikazan karakterističan oblik jednog impulsa EKG signala (Pogledati primer sa 6. časa vežbi).

![1](https://user-images.githubusercontent.com/16638876/30591493-6486b112-9d43-11e7-83ff-1006440caa41.png)

Napajanje elektrokardiografa koji se napaja iz električne mreže nije savršeno i može dovesti do pojave šuma električne mreže. Ovaj šum je najvećim delom sinusoida učestanosti 50 Hz ili 60 Hz u zavisnosti od toga da li se uređaj nalazi na npr. Evropskom (gde je napon mreže efektivne vrednosti 230 V i učestanosti 50 Hz) ili Američkom tlu (gde je napon mreže efektivne vrednosti 120 V ili 240 V i učestanosti 60 Hz). Šum je aditivan i sabira se sa korisnim signalom. Time se dobija signal iz koga se ne mogu detektovati karakteristični oblici EKG signala (P, Q, R, S i T sa slike 1). Zbog toga je potrebno projektovati uskopojasni filtar nepropusnik opsega (notch filter) koji će isfiltrirati komponentu na 60 Hz, a propustiti koristan signal.

Takođe prilikom snimanja EKG signala moguće je da se, usled disanja pacijenta, srednja vrednost signala menja i u literaturi se ova pojava naziva baseline drift. Promena srednje vrednosti je spora, pa se visokofrekventnim filtriranjem gde je granična učestanost mala, reda 0,5 Hz, mogu očistiti ove promene srednje vrednosti. Na slici 2 je prikazan jedan primer zašumljenog EKG signala kod koga se i srednja vrednost menja.

![2](https://user-images.githubusercontent.com/16638876/30591569-974d99b2-9d43-11e7-9ba9-0e164b806098.png)

Učitati zašumljeni signal iz fajla ecg_corrupted.mat. Prikazati vremenski oblik signala. Vremenska osa treba da bude u sekundama. Učestanost odabiranja je fs = 360 Hz.

1. Napisati funkciju h = baseline_drift_filter(fs, fa, fp, Aa, Ap) kojom se projektuje FIR filtar propusnik visokih učestanosti optimizacionim metodom. Funkcija kao argumente prima učestanost odabiranja fs, graničnu učestanost nepropusnog opsega fa, graničnu učestanost nepropusnog opsega fp i odgovarajuća slabljenja u nepropusnom (αa) i propusnom (αp) opsegu. Kao povratnu vrednost, funkcija vraća impulsni odziv dobijenog filtra.

2. Napisati funkciju h = power_line_noise_filter(fs, fc, Aa, Ap) kojom se projektuje FIR filtar nepropusnik opsega učestanosti optimizacionim metodom. Funkcija kao argumente prima učestanost odabiranja fs, centralnu učestanost nepropusnog opsega fc i odgovarajuća slabljenja u nepropusnom (αa) i propusnom (αp) opsegu. Kao povratnu vrednost, funkcija vraća impulsni odziv dobijenog NO filtra. Navedeni filtar treba da zadovolji sledeće granične relativne učestanosti:

a. granične učestanosti propusnog opsega: Fp1 = (fc – 2 Hz)/fs i Fp2 = (fc + 2 Hz)/fs,

b. granične učestanosti nepropusnih opsega: Fa1 = (fc – 0,5 Hz)/fs i Fa2 = (fc + 0,5 Hz)/fs.

Ukoliko gabariti nisu zadovoljeni, funkcije treba da menjaju red filtra dok oni ne postanu zadovoljeni. Računati frekvencijske karakteristike u dovoljno velikom broju tačaka prilikom provere, npr. više od 10000.

3. Korišćenjem funkcije baseline_drift_filter projektovati filtar kod koga je fa = 0,4 Hz, fp = 1 Hz, αa = 30 dB i αp = 0,5 dB. Filtrirati učitani EKG signal. Nacrtati vremenski oblik izlaznog signala.

4. Korišćenjem funkcije power_line_noise_filter projektovati filtar kod koga je fc = 60 Hz, αa = 40 dB i αp = 0,5 dB. Filtrirati signal dobijen u prethodnoj tački. Nacrtati vremenski oblik izlaznog signala.

5. Nacrtati amplitudske i fazne karakteristike filtara iz tačaka 3 i 4 i crtanjem odgovarajućih linija za gabarite pokazati da filtri zadovoljavaju zadate specifikacije.

MATLAB skriptu nazvati ekg_godinaupisa_brojindeksa.m. U kodu komentarima jasno naznačiti koji deo koda se odnosi na koji deo zadatka.

Sve vremenske ose u ovoj tački treba da budu u sekundama. Neophodno je obeležiti sve ose odgovarajućim oznakama/tekstom.

# Text of the task in Serbian - part 2

1. Napisati funkciju y = FIR_direct_transpose(h, x) koja implementira direktnu transponovanu realizaciju FIR filtra čiji je implusni odziv ulazni argument h i filtrira signal x. Kao povratnu vrednost, funkcija vraća filtrirani signal y. Funkciju napisati korišćenjem vektora za rezultate i međurezultate i što manje petlji jer red filtra može biti veliki. Obezbediti da se izračunavanje vrši na način koji je određen tipom podatka ulaznih argumenata. Ako su ulazni argumenti objekti klase fi, tj. ako su predstavljeni kao brojevi sa fiksnom tačkom, sva izračunavanja treba da budu sa brojevima sa fiksnom tačkom. Takođe, svi međurezultati treba da imaju preciznost definisanu u opcijama ulaznih argumenata.

2. Predstaviti učitani EKG signal x kao vektor brojeva sa fiksnom tačkom čija je dužina 12 bita. Na osnovu vrednosti koje ima ulazni signal x odrediti koliko je bita potrebno za smeštanje celog, a koliko razlomljenog dela. Koeficijente filtara dobijenih u prvom delu predstaviti na 12 bita pri čemu se 10 bita koristi za razlomljeni deo.

3. Korišćenjem funkcije FIR_direct_transpose filtrirati originalni EKG signal x korišćenjem oba filtra projektovana u prvom delu, a zatim isti taj signal predstavljen korišćenjem predstave sa fiksnom tačkom filtrirati korišćenjem oba filtra čiji su koeficijenti predstavljeni na 12 bita (filtara iz tačke 2). Na jednoj slici ali na 4 podslike prikazati originalni ulazni signal, signal dobijen filtriranjem sadouble preciznošću, signal dobijen filtriranjem sa fixed-point preciznošću kao i signal koji predstavlja razliku dva izlazna signala. Ponoviti ovu tačku za tri različita formata međurezultata i uporediti greške.

4. Ponoviti tačku 3 za još dva različita načina zaokruživanja koeficijenata filtara pri čemu se broj bita dodatno smanjuje.

5. Nacrtati amplitudske karakteristike NO filtara korišćenih u tački 3 i 4 na jednom grafiku različitim bojama.

6. U komentarima ukratko objasniti dobijene rezultate za različita zaokruživanja, npr. kad je greška veća i zbog čega.

Obeležiti sve ose odgovarajućim oznakama/tekstom. U kodu komentarima jasno naznačiti koji deo koda se odnosi na koji deo zadatka.
