#Report Programmeer Project

## iOS App "Nearby"

###Functionaliteit

Nearby is een iOS App die de gebruiker een notificatie stuurt als hij of zij in de buurt is van een opegegeven favoriete locatie. De gebruiker kan uit een lijst van een aantal populaire venues (e.g Starbuck, McDonalds etc) enkele favorieten aan favorieten lijst toevoegen. De app houd vervolgens bij of de gebruiker in een radius van 200m bij een locatie komt en krijgt vervolgens een notificatie als het zover is. 

###Technical Design

3 ViewControllers, Datamodel en Appdelegate

 *Tab 1* **VenueTableViewController**

- bevat alle venues 
- maakt een tableview van deze venues
- gebruiker kan met behulp van een add button aan favorieten (NSUserDefaults) toevoegen
- Checked of deze al bestaat in de favorieten lijst 

*tab 2* **FavoritesTableViewController**

- Verkrijgt data uit NSUserdefaults
- Maakt van de data een tableview
- als er op een cell getapped word, verspringt the view naar de mapview (NearbyViewController)

*tab 3* **NearbyViewController**

- bevat de mapkit

- *functie*: restartSearchAndMonitor() -> main functie met een notificatieCenter, stopped en herstart het maken van regions.
- *functie*: searchData() -> zoekt de favorietelijst data uit NSUserdefaults met een check of deze leeg is
- *functie*: performSearch() -> zoekt met MKLocalsearch de dichtsbijzijnde favoriete venues, stopt deze in een lijst en maakt MapAnnotations aan.
- *functie*: makeRegions() -> maakt van de gevonden dichtsbijzijnde favoriete locaties een CLregion en stopt deze in een lijst
- *functie*: startMonitoring() -> start het monitoren van de CLregion lijst
- *functie*: stopMonitoring() -> stopt het monitoren en maakt alle lijsten leeg

- *LocationManager delegate*: didUpdateLocations -> houd bij of de 1500m afstand is bereikt en ververst dan de locale searches

**AppDelegate**

- verwerkt de locale notificaties
- *functie*: handleRegionEvents -> stuurt notificaties als de gebruiker een region inkomt
- *LocationManager delegate*: didEnterRegion -> houd bij of the user een region entered

**Datamodel (Venues.swift)**

- data model met een init voor namen en photos van Venues.

### Challenges and Changes

- Searchbar eruit gelaten.
- De accurracy van GPS is niet zo goed als dat ik dacht, als je uit de metro komt of grote gebouwen heeft hij moeite. Hoop het te hebben opgelost door horizontal.accuracy < 20m in te stellen om altijd een goeie accuraatheid te hebben. Als hij dit niet heeft kan de gebruiker namelijk notificaties ontvangen die helemaal niet in de buurt zijn, omdat de GPS langs deze regions komt als hij de user current location zoekt.
- Asynchronous functies was ook een challenge maar opgelost met GCD (Grand Central Dispatch) om functies op de juiste moment uit te voeren
- MKLocalSearch werkt met een "Local" search die zover rijkt als de map is ingezoomed. wat resulteert dat als de map geopend word, hij moet wachten op het inzoomen van de userlocatie. opgelost met een Dispatch_after.
- Beginnen met de applicatie vanaf het launchen en het niet kunnen zien wat de MapKit en Localsearch doet zodra je in een andere view bent (dus ook de initial view). Leuke blackbox of magic. Maar het schijnt goed te gaan. 
- een nietzeggende wissel van tab gemaakt die van favorites naar map view gaat.


Searchbar was overbodig met het aantal venues en nam veel ruimte in. en werkte heel slecht samen met mijn data model. 
Testers deden heel intuitief klikken op de favorieten in de favorietenlijst, waar ik nu een segue van heb gemaakt dat de view word versprongen naar de map (waar de echte dingen gebeuren) dit heeft verder geen zin behalve dat de gebruiker niet hoeft te zoeken ernaar. Wat leuk had geweest is dat als de gebruiker op een bepaalde venue had gedrukt, zeg Starbucks, dat alle starbucks venues een andere kleur anotation kregen (dan het standaard rood). Maar dat ging niet in de opbouw van mijn code, leuk misschien voor later. 

- Hoe ik had bedacht dat de Apple Watch een extensie moest bieden op deze app, gaat geheel automatisch. wat ik wel dan nog mis, is een actie aan de notificatie.

